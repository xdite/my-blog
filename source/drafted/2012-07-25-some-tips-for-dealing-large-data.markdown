---
layout: post
title: "一些在 Rails 上處理大量資料的技巧"
date: 2012-07-25 23:56
comments: true
categories: 
---

這個主題也是我最近常被問到的答案集合包。

Rails Developer 在使用內建工具開發網站時，若是由小做起，通常不會踩到這些雷。但是若一開始開站資料就預計會有 10 萬筆、甚至 100 萬筆資料。執行 db 的 rake task 通常往往會令人痛苦不堪。

在這篇文章內，我整理了一些處理巨量資料必須注意的細節，應該可以有效解決大家常遇到的問題：

另外不要再說 10 萬筆資料是巨量資料了啊 -_-|||。這個數字講巨量會被人家偷笑幼幼班啊 orz


### 1. 盡量避免使用 ActiveRecord Object

ActiveRecord 有點肥，如果你只是要作一些簡單的資料操作，請直接下 SQL，不要沾到任何 ActiveRecord。

（但大多數開發者直覺都是會開 ActiveRecord 下了條件就直接跑迴圈，忘記 MySQL 是可以直接拿來下指令的）

如果你覺得沒有抽象一點的工具可以用，直接下指令很痛苦，有 [sequel](http://sequel.rubyforge.org/) 這套工具可以用。

避免用 ActiveRecord + 內建的 rake task 原因是，你會把整套的 Rails 環境都載進來跑，其慢無比是正常的…

### 2. 有 update_all 可以用，少用 for / each。

通常有問題的 code 都是長這樣：

```
posts = Post.where(:board_id => 5)

post.each do |post|
  post.board_id = 1
  post.save
end
```

這段 code 非常直觀，但會造成的問題超級多。如果符合的條件有 10 萬筆，大概你跑一天都跑不完....

先提供快速解法。Rails 提供了 [update_all](http://apidock.com/rails/ActiveRecord/Base/update_all/class) 可以下。可以改成這樣

```
Post.update_all({:board_id => 1}, {:board_id => 5})
```

基本上就是等於直接幫你下 update 的 SQL 啦。同樣資料量跑下去大概只要 10 秒秒以下左右吧。

### 3. 不要傻傻的直接 Post.all.each，可以用 find_in_batches

直接叫出所有符合的資料（Array) 是一件危險的事。如果符合條件的資料是 10 萬筆，全拉出來有高達 10G 的大小，嗯…我想你的機器應該沒裝 10 G 的記憶體，指令下去機器直接跑到死掉有極大的可能性…

Rails 提供了 find_in_batches 

```
Post.find_in_batches(:conditions => "board_id = 5", :batch_size => 1000) do |posts|
  posts.each do |post|
    post.board_id = 1
    post.save
  end
end
```

如果沒下 batch_size 預設一次是拉 2000 筆。你可以一次指定小一點的數目，如一次 500 筆去跑。

### 4. 使用 transaction 跳過每次都要 BEGIN COMMIT 的過程，一次做完 1000 筆，然後再 COMMIT。

如果你打開 Rails 的 development.log，這樣的 LOG 你應該不陌生。

```
   (0.3ms)  BEGIN
   (0.5ms)  COMMIT
```

Rails 開發時，為了確保每比資料正確性，儲存的時候都會過一次 transaction，於是即使已經照 `3` 這樣的解法，還是要過 10 萬次 COMMIT BEGIN。很浪費時間。

```
Post.find_in_batches(:conditions => "board_id = 5", :batch_size => 1000) do |posts|
  Post.transaction do 
    posts.each do |post|
      post.board_id = 1
      post.save
    end
  end 
end
```

如果你只是要 update 少量欄位，而且資料處於離線狀態，可以使用 [Transactions](http://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html) 搭配 find_in_batches，做完兩千筆再一次 commit，而不是每次做完就 commit 一次，在資料量很大的狀況下也可以節省不少時間。

### 5. 使用 sneacky-save 而非原生 save

用原生 `save` 會有什麼問題呢？原生的 `save` 在資料儲存時，會經過一堆 `validator` 和 `callbacks`，即使你只是要簡單 update 一個欄位，會觸發到一狗票東西（假設 10 道 hook），那 10 萬筆就是過 100 萬道 hook 了啊。天啊 /_\，機器死掉不意外。

如果你想要閃掉 hook 的話，可以使用 [sneacky-save](https://github.com/partyearth/sneaky-save) 這套 gem。如其名，就是偷偷儲存不會勾動任何天雷地火。

### 6. 可以的話使用 Post.select("column 1, colum2").where

很多人會忽略一件事，`Post.where("id < 10")`，其實是把這 10 個 object 拉出 database。Post 裡面有什麼呢？會有幾千字的 `content` 啊。所以當你下了這道 comment 後，拉出來的是這些內容

```
Post Load (18.8ms)  SELECT `posts`.* FROM `posts` WHERE (id < 10)
```

拉出 10 萬筆會發生什麼事呢？(炸)

所以這也是我建議如果你不是要作複雜操作（高度 model 邏輯）的話，千萬別碰 ActiveRecord，因為你不會知道哪按下哪一顆核蛋按鈕。


### 7. 無法避免的昂貴操作丟到 background job 去操作。

使用 `posts.each` 是一個昂貴的線性操作。這個 process 會無限的膨脹及 block 資源。

所以可以改用一個作法，使用 [delayed_job](https://github.com/collectiveidea/delayed_job) 或者是 [resque](https://github.com/defunkt/resque/) 把昂貴的操作包成獨立事件。塞進 queue 裡面，丟到背景跑，然後開 10 支 worker，十箭其發，速度可以快不少。

### 8. 使用 truncate 而非 destroy_all 與 delete_all

* [destroy_all](http://apidock.com/rails/ActiveRecord/Base/destroy_all/class)

找到符合特徵的紀錄，然後呼叫 destroy method。在這個動作中會引發 `callbacks` ….orz

* [deletea_all](http://apidock.com/rails/ActiveRecord/Base/delete_all/class)

找到符合特徵的紀錄，刪掉，但不觸發 `callbacks`。

* TRUNCATE TABLE

不過 `DELETE` 在 MySQL 裡面還是慢的，如果你要清整個 db，直接下 `TRUNCATE` 的 SQL command 吧…

```
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name}")
```

### 9. 與其用刪的 (DELETE) 不如用 塞的 (INSERT)

DELETE 真的很慢，如果你的資料要作大量的刪除動作，不如開一個新的 TABLE 用塞的...。

DELETE 涉及到會 update index，所以會…很慢。<http://stackoverflow.com/questions/4020240/in-mysql-is-it-faster-to-delete-and-then-insert-or-is-it-faster-to-update-exist>


### 10. 操作資料前，別忘記打 INDEX

舉凡操作資料，多半是至少會先下個 condition。再看是直接用 SQL 處理掉還是跑迴圈。不過一般開發者最會中地雷的部分就是

* 忘記打 index

忘記打 index 下 condition 當然會很慢啊 /_\

* 對 varchar(255) 直接打 index

使用 Rails 產生的 varchar，多半是 varchar(255)，很少有人會直接去改長度的。而且使用 Rails 直接打的 index，也就是全長的 index 打下去了。效率爛到炸掉。

可以用 [index 可以指定只取前面 n chars](http://blog.gslin.org/archives/2012/07/17/2911/%e5%b0%8d-mysql-%e7%9a%84-varchar-%e6%ac%84%e4%bd%8d%e4%bd%bf%e7%94%a8-index-%e6%99%82%e5%8f%af%e4%bb%a5%e5%a2%9e%e5%8a%a0%e6%95%88%e7%8e%87%e7%9a%84%e6%96%b9%e6%b3%95/) 的方式增進效率

```
ALTER TABLE post DROP INDEX PTitle, ADD INDEX(PTitle(13));
```

## 結論

如果你手上的資料量大到一個程度，能儘量回歸基本(SQL command)就回歸基本。你不知道你什麼時候會按下核爆彈的按鈕啊…