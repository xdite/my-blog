---
layout: post
title: "升級 Rails 4.0.0 停看聽"
date: 2013-06-27 01:22
comments: true
categories: 
---

TL; DR: Rails 4.0.0 有地雷，建議修完所有 depcrapted warning 再從 rc1, rc2 升級，不然會有大災難。

上個禮拜跟同事做了個 Markdown Blog Service Provider : [Logdown](http://blog.logdown.com)。介紹請看[這裡](http://logdown.com/pages/about)。Logdown 是用 Rails 3.2.13 寫的。適逢昨日 [Rails 4.0.0 釋出](http://weblog.rubyonrails.org/2013/6/25/Rails-4-0-final/)，於是手癢癢就想幫 Logdown 升級…


上個月我曾經寫過兩篇文章：

* [Upgrade 到 Rails4 的一些感想](http://blog.xdite.net/posts/2013/05/04/upgrade-to-rails4/)
* [Rails 4: New Feature, Better Syntax](http://blog.xdite.net/posts/2013/05/04/rails4-new-feature/)

該踩的雷我都中過了，也知道怎麼 patch 常見的地雷，閃過去….

不過我膝蓋還是中了一箭了…orz

### 地雷一：強制 raise error

Rails 4 改變最大的有幾個重點：

1. 拿掉 attr_protected，改用 strong parameters
2. scope 改用 -> {}
3. routes 建議大家棄用 match ，而用更精確的 get , post


well, 在 4.0.0 版，如果你還在用 match 的話，Rails 除了 warning message 還會直接 raise error。網站會直接跑不起來，而不是像 beta 的向下相容。而且一些行為也會強制禁掉，如 Logdown 其實有兩個 `root :to`，其中一個跑 contraint 偵測是否有 user 而導到後台。

Rails 4 是直接禁掉這樣的 syntax 讓你跑不起來。


不過這個還算好的警告手段。直接爛掉雖然有點 annoying，但是你知道 patch 掉就沒有後遺症了....


### 地雷二：改變行為

這件事我真的覺得最扯....。但也可以預見未來可能有一些災難發生。

Rails 4 beta 建議大家 scope 改用 -> {}。並且有警告 Message 通知你必須改變，但撈出來的 query 還是向下相容，也就是執行結果是正確的。

Rails 4.0.0 版 建議大家 scope 改用 -> {}。並且有警告 Message 通知你必須改變，`但撈出來的 query 行為改變，也就是執行結果是錯誤的。`

這件事讓到底有多嚴重，我的 `post.rb` 是這樣設計的：


``` ruby
class Post < AR
  scope :recent, order("id DESC")
end
```

而在 Logdown 的 Dashboard 裡面，我的後台 index action 是這樣設計的

``` ruby
class Account::PostController < AC
  def index
    @posts = current_users.posts.recent
  end
end
```  

正常的行為，生出來的 query 是這樣的（撈出我本人的所有文章）：


```
Post Load (11.3ms)  SELECT `posts`.* FROM `posts` WHERE `posts`.`user_id` = 3 ORDER BY id DESC LIMIT 50 OFFSET 0
```

到這邊都沒什麼問題。

本來我改好程式，在 local 測一測看起來沒什麼問題，（ Rails 4 最大的改動通常是 update_attributes 會需要修，query 通常不太需要修）…也沒 raise error。還好我今晚是先 deploy 到 staging 去測。deploy 上去差一點噴茶....

我個人的 Dashboard 竟然出現了（全站文章） ……orz…..WTF…

在 local 重新測試才發現：

如果你沒把 scope 改成


``` ruby
class Post < AR
  scope :recent, -> { order("id DESC") }
end
```

那麼…在後台

``` ruby
class Account::PostController < AC
  def index
    @posts = current_users.posts.recent
  end
end
```  

生出來的 query 會長這樣 


```
Post Load (1.2ms)  SELECT `posts`.* FROM `posts` ORDER BY id DESC LIMIT 50 OFFSET 0
```

齁齁，所有條件失效，**撈全站文章**給你。簡單的 query 都這樣，複雜的 query 我不敢想像。（ -> { } 的新預設寫法席卷了一大堆設計，而且一堆 plugin 還在用 舊 query … ）我已經可以預見這會產生多大的災難了....

重點是，你還不能回報這是 bug，畢竟人家都已經叫你換成 `-> {} `，誰叫你不換勒？


### 地雷三：管太多…

我在 deploy 的時候，遇到 Asset compile 不過的狀況。sprockets 一直報錯：

```
Asset logical path has no extension: README
```

WTF，我從沒在之前的版本看過這個。在網路上搜尋了一下發現是這個 issue..:

<https://github.com/sstephenson/sprockets/issues/347>

意思就是 sprockets 連你的 README 有沒有加 .txt 都要管啦 -_-。然後維護者不想修，叫大家自己去找 workround…

所以如果你的 `app/assets/javascripts` `app/assets/stylesheets` 下如果有沒有副檔名的檔案，compile 就不會過。你會想說 not big deal，自己改成多加 .txt 或 .md 就好了…

沒這麼簡單。一堆 3rd party 的 css / js ..不僅有 …..README…還有 LICENSE…還有 CHANGELOG….XDD

齁齁齁，感覺很精彩了吧。沒關係，這都可以加 .txt。頂多是 CSS / JS 界的 repo 這陣子會被 Rails developer 群騷擾而已。更精彩的是 Makefile….這到底是要怎麼閃 XD

( 剛剛網路上找 solution 看到一堆慘案 …)

Bower 已經身亡，這裡是[解法](https://gist.github.com/afeld/5704079)


### Summary

如果你是從 Rails 4.0.0beta1 或者是 Rails 4.0.0rc1 升級，務必停看聽…

Rails 4.0.0 跟你想得很不一樣 …orz

