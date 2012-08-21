---
layout: post
title: "Rails-with-massive-data"
date: 2012-08-22 00:20
comments: true
categories: 
---

這是我今天在 Ruby Tuesday #21 所寫的投影片。以下文章是寫投影片前已經擬好的草稿。可以配著服用

<script async class="speakerdeck-embed" data-id="5030bd74edfca8000202c365" data-ratio="1.299492385786802" src="//speakerdeck.com/assets/embed.js"></script>

Rails Developer 在使用內建工具開發網站時，若是由小做起，通常不會踩到這些雷。但是若一開始開站資料就預計會有 10 萬筆、甚至 100 萬筆資料。執行 db 的 rake task 通常往往會令人痛苦不堪。

在這篇文章內，我整理了一些處理巨量資料必須注意的細節，應該可以有效解決大家常遇到的問題：


### 1. 盡量避免使用 ActiveRecord Object

ActiveRecord 當初的設計目的是為了框架內「商業使用」。它的工作是將純資料化為具有商業邏輯的 Ruby Object，並且配合框架，設計了多層 callbacks。

簡單來說，它並不是為了「處理 raw data」而設計。如果開發者只是要作一些簡單的資料操作，建議的方式請直接下 SQL，不要沾到任何 ActiveRecord。

（但大多數開發者直覺都是會開 ActiveRecord 下了條件就直接跑迴圈，忘記 MySQL 是可以直接拿來下指令的）

當然，沒有 ActiveRecord 這麼抽象化的工具，下純指令也是蠻痛苦的一件事，我推薦可以換用 [sequel](http://sequel.rubyforge.org/) 這套工具試看看。

再者，在實務操作上我也建議避免使用 ActiveRecord + 內建的 rake task 操作巨量資料。原因是，開發者會順帶會把整套的 Rails 環境都載進來跑，其慢無比是正常的…

### 2. 有 update_all 可以用，少用 for / each。

通常會出問題的 code 是長這樣的：

``` ruby
posts = Post.where(:board_id => 5)

post.each do |post|
  post.board_id = 1
  post.save
end
```

這段 code 非常直觀，但會造成許多的問題。如果符合的條件有 10 萬筆，大概放著跑一天都跑不完....

先提供快速解法。Rails 提供了 [update_all](http://apidock.com/rails/ActiveRecord/Base/update_all/class) 可以下。可以改成這樣

``` ruby
Post.update_all({:board_id => 1}, {:board_id => 5})
```

基本上就是等於直接幫你下 update 的 SQL 啦。同樣資料量跑下去大概只要 10 秒秒以下左右吧。

### 3. 不要傻傻的直接 Post.all.each，可以用 find_in_batches

直接叫出所有符合的資料（Array) 是一件危險的事。如果符合條件的資料是 10 萬筆，全拉出來有高達 10G 的大小，嗯…我想機器沒個 10 G 以上的記憶體，指令下去機器直接跑到死掉有極大的可能性…

Rails 提供了 find_in_batches 

``` ruby
Post.find_in_batches(:conditions => "board_id = 5", :batch_size => 1000) do |posts|
  posts.each do |post|
    post.board_id = 1
    post.save
  end
end
```

如果沒下 batch_size 預設一次是拉 2000 筆。可以一次指定小一點的數目，如一次 500 筆去跑。

### 4. 使用 transaction 跳過每次都要 BEGIN COMMIT 的過程，一次做完 1000 筆，然後再 COMMIT。

打開 Rails 的 development.log，這樣的 LOG 應該對你不陌生。

```
   (0.3ms)  BEGIN
   (0.5ms)  COMMIT
```

Rails 開發時，為了確保每比資料正確性，儲存的時候都會過一次 transaction，於是即使已經照 `3` 這樣的解法，還是要過 10 萬次 COMMIT BEGIN。很浪費時間。

``` ruby
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

### 5. 使用 update_column / sneacky-save 而非原生 save

用原生 `save` 會有什麼問題呢？原生的 `save` 在資料儲存時，會經過一堆 `validator` 和 `callbacks`，即使你只是要簡單 update 一個欄位，會觸發到一狗票東西（假設 10 道 hook），那 10 萬筆就是過 100 萬道 hook 了啊。天啊 /_\，機器死掉不意外。

如果你想要閃掉 hook 的話，可以使用 update_column，

``` ruby
    posts.each do |post|
      post.update_column(:board, 1)
      post.save
    end
```    

但 update_column 的缺點是一次只能 update 一個欄位，如果你有 update 多個欄位的需求，可以用[sneacky-save](https://github.com/partyearth/sneaky-save) 這套 gem。

如其名，sneacky-save 偷偷儲存不會勾動任何天雷地火。

### 6. 可以的話使用 Post.select("column 1, colum2").where

很多人會忽略一件事，`Post.where("id < 10")`，其實是把這 10 個 object 拉出 database。Post 裡面有什麼呢？會有幾千字的 `content` 啊。所以當你下了這道 comment 後，拉出來的是這些內容

```
Post Load (18.8ms)  SELECT `posts`.* FROM `posts` WHERE (id < 10)
```

拉出 10 萬筆會發生什麼事呢？(炸)

所以這也是我建議如果你沒有複雜操作（相依高度 model 邏輯）需要的話，千萬別碰 ActiveRecord，因為你不會知道會按下哪一顆核彈按鈕。

### 7. 使用 delegate 把大資料搬出去

ActiveRecord 裡面有 delegate 這個 API。如果你嫌要 `Post.select("column 1, colum2").where` 這樣東閃西閃很麻煩，還是希望使用 `SELECT post.*`。那麼不妨可以換一個思路，把肥的 column 丟到另外一個 table，再用 delegate 接起來。

``` ruby
class Post < ActiveRecord::Base
  has_one :meta
   
  after_create :create_meta
  
  deleage :content, :to => :meta
end
```



### 8. 操作資料前，別忘記打 INDEX

舉凡操作資料，多半是至少會先下個 condition。再看是直接用 SQL 處理掉還是跑迴圈。不過一般開發者最會中地雷的部分就是

* 忘記打 index

忘記打 index 下 condition ，就會引發 table scan，這當然會很慢啊 /_\

* 對 varchar(255) 直接打 index

使用 Rails 產生的 varchar，多半是 varchar(255)，很少有人會直接去改長度的。而且使用 Rails 直接打的 index，也就是全長的 index 打下去了。效率爛到炸掉。

可以用這招 [index 可以指定只取前面 n chars](http://blog.gslin.org/archives/2012/07/17/2911/%e5%b0%8d-mysql-%e7%9a%84-varchar-%e6%ac%84%e4%bd%8d%e4%bd%bf%e7%94%a8-index-%e6%99%82%e5%8f%af%e4%bb%a5%e5%a2%9e%e5%8a%a0%e6%95%88%e7%8e%87%e7%9a%84%e6%96%b9%e6%b3%95/) 的方式增進效率

```
ALTER TABLE post DROP INDEX PTitle, ADD INDEX(PTitle(13));
```

Percona 前幾天也有一個 talk 是 [MySQL Indexing Best Practices](http://www.percona.tv/percona-webinars/mysql-indexing-best-practices)，值得參考。

### 9.  delete / destroy，刪除很昂貴。確保你知道自己在幹什麼。

首先第一件事要分清楚 delete 和 destroy 有什麼不同。

* destroy 刪除資料並 go through callbacks
* delete 刪除資料，不過任何 callbacks

所以要刪除資料前，請確認你用的是何種「刪除」。

destroy_all 和 delete_all 也是類似的原則。

* [destroy_all](http://apidock.com/rails/ActiveRecord/Base/destroy_all/class) 

找到符合特徵的紀錄，然後呼叫 destroy method。在這個動作中會引發 `callbacks` ….orz

* [deletea_all](http://apidock.com/rails/ActiveRecord/Base/delete_all/class)

找到符合特徵的紀錄，刪掉，但不觸發 `callbacks`。

不過如果你真的要「清空 DB」。不要用 delete_all，MySQL 提供了：TRUNCATE 給你用。請用這個...

* TRUNCATE TABLE

``` ruby
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name}")
```

雖然 delete 不觸發 callbacks，但是「刪除」DELETE 真的很慢，因為 
DELETE 涉及到會 update index，所以會…很慢。<http://stackoverflow.com/questions/4020240/in-mysql-is-it-faster-to-delete-and-then-insert-or-is-it-faster-to-update-exist>

如果你的資料要作大量的刪除動作，有兩種思路可以繞。


一個是使用軟性刪除 soft_delete，也就是加上標記標示已刪除，但實質上不從資料庫刪除資料，只 update 會比 delete 快一點。有 [acts_as_archive](https://github.com/winton/acts_as_archive) 可以用。

另外一個想法是：與其用刪的 (DELETE) 不如用 塞的 (INSERT)

開一個新的 Table，用倒的，把 match 的 record 塞到新的 DB 去。INSERT 比 DELETE 快太多了。

### 10. 無法避免的昂貴操作丟到 background job 去操作。

使用 `posts.each` 是一個昂貴的線性操作。這個 process 會無限的膨脹及 block 資源。

所以可以改用一個作法，使用 background job 如

* [delayed_job](https://github.com/collectiveidea/delayed_job) (不推薦)
* [resque](https://github.com/defunkt/resque/) 
* [sidekiq](http://mperham.github.com/sidekiq/)

把昂貴的操作包成獨立事件。塞進 queue 裡面，丟到背景跑，然後開 10 支 worker，十箭其發，速度可以快不少。

之所以把 delayed_job 列出來又不推薦的原因是因為 delayed_job 清 queue 的方式是用 DELETE，在第九點我們談過了，在有大量資料的情況下，「刪除」這件事會非常昂貴。使用 delayed_job 無異是拿汽油澆火。

## 結論

十點列下來。我的建議是，如果你手上的資料量大到一個程度，能儘量回歸基本(SQL command)就回歸基本。因為使用 ActiveRecord ，開發者永遠不知道自己什麼時候會按下核爆彈的按鈕啊…


#### 其他

目前我們固定在禮拜二，都會在 松江路的田中園 上舉辦 [Taipei Rails Meetup](http://www.meetup.com/taipei-rails-meetup/)。我自己本身也會固定在這裡免費幫大家解答 Rails 與 Web Operation 相關的問題。而坦白說，最近一些比較經典的 Post 也是從聚會裡的問答集裡面萃取出來的。

如果你對 Rails 有濃厚的興趣又住在台北，歡迎每週加入我們，謝謝！
