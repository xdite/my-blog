---
layout: post
title: "[進階] Make ActiveRecord includable"
date: 2012-01-04 16:58
comments: true
categories: 
---

[警告] 這一篇是進階的文章，如果你看不懂可以跳過。

前幾天在 Twitter 看到一條值得慶賀的消息（印象已模糊，忘記誰慶賀，也不知慶賀的原因），是關於 Rails core 上的一串 commit，大意是 ActiveRecord::Base 已經從傳統的繼承使用，變成了可以用 include 的 ActvieRecord::Model。

<https://github.com/rails/rails/compare/58f69ba...00318e9#diff-0>

也就是從開始有 Rails 以來，傳統的使用方式

``` ruby
class Post < ActiveRecord::Base
end
```

以後將變成 

```ruby
class Post 
  include ActiveRecord::Model
end
```

坦白說，我看不懂這一串的意義是什麼。而 commit 下面的留言也有人說他看不懂....XDDDD

所以我就把這則收入記憶倉庫了。直到今天聽 podcast 時不小心觸發…

## Ruby Rogues Podcast

[Ruby Rogues](http://rubyrogues.com/) 是這幾個月才興起的一個新的 Ruby Podcast，與較知名的 [Ruby 5](http://ruby5.envylabs.com/) 或 [The Ruby Show](http://rubyshow.com) 這兩個 podcast，性質很不同。後兩者著重於介紹本週有什麼 Ruby / Rails 的新消息，或者亮點 gem。Ruby Rouges 的則是每周邀請五個 Ruby 大師，上來針對一個特定主題，無盡的喇賽亂鬥 XD

當然這些大師也不是在講廢話，從他們的喇賽中可以學到不少觀念，甚至是有的時候你還可以聽到有的大師現場被其他人電：「什麼，你不知道可以這樣用？」「什麼，你一直用錯誤的觀念寫 code？」….XD

到目前為止一共有 35 集，每集大概 1 小時。這麼多....所以當然我…沒有聽完 XDDDD

今天找資料時，翻到第 20 集 [RR Object Oriented Programming in Rails with Jim Weirich](http://rubyrogues.com/object-oriented-programming-in-rails-with-jim-weirich/)

為了要找其中的一段資料，就耐心的下載了這集，開始聽。結果原先的資料沒找到，倒是意外聽到一段重要的寫 code 觀念，讓我理解 Make ActiveRecord includable 的意義。

## Rails 誤導大家的觀念 : Model = DB

這一段觀念可以從 [podcast](http://rubyrogues.com/object-oriented-programming-in-rails-with-jim-weirich/) 中的大約 30:00 左右開始聽。

Rails 誕生以來，model 的設計就是長這樣，從 ActiveRecord::Base 繼承。

``` ruby 
class Post < ActiveRecord::Base

  has_many :comments
  belongs_to :user

  scope :recent , order("id DESC")


end
```

當專案長大了，開發者免不了會往裡面塞一些 Business Logic，所以會變成這樣。

``` ruby 
class Post < ActiveRecord::Base

  has_many :comments
  belongs_to :user

  scope :recent , order("id DESC")

  
  def aaa
  end

  def bbb
  end

  def ccc
  end
end

```

但是 class 再繼續長大之後，大家可能就會受不了了。developer 開始把一些 method ( 所謂的 bussiness logic 抽出去)，用 include 的方式去做，然後把這些 logic 放在 lib/ 下。

變成

``` ruby 
class Post < ActiveRecord::Base

  has_many :comments
  belongs_to :user

  scope :recent , order("id DESC")

  include AAA
  include BBB
  include CCC  

end

```

儘量讓這個 model class 只保持著 db 的 association，logic 抽出去保持整潔。

寫到這裡看起來都沒問題？

## 繼承自 ActiveRecord::Base 帶來的問題

錯了，問題可大了。

這樣的設計導致了一個現象：因為繼承自 ActivRecord::Base，無可避免的寫測試一定要扯到 DB，於是就帶來了其他頭痛的問題

1. 寫測試變成在測試 query 和 ORM。寫測試的重點是在測 Business  Logic，其實應該要與 DB 資料與 DB 連線無關，結果測試都在測這個…

2. 因為一定要過 DB，於是 model 測試很慢。

## ORM 是配角，被誤以為主角，反客為主！！！

在 MVC 裡面，Model 的定義－主要負責應用程式中的商業邏輯(Business Logic)。

看看這個範例，你覺得這個 model 寫法是正確的嗎！？

``` ruby 
class Post < ActiveRecord::Base

  has_many :comments
  belongs_to :user

  scope :recent , order("id DESC")

  include AAA
  include BBB
  include CCC  

end

```

這是一個 ORM 行為為主的 model，不是 Bussiness Logic 為主的 Model 啊 XD。真正的主角好像被趕走了，被趕到 lib/ 去。

podcast 中 30:00 - 33:00 主要討論的議題就是：

===
你將 Bussiness Logic 放在哪裡？你稱 Bussiness Model 為 Model 還是 SuperModel。然後 James Edward Gray 在這裡回答他放在 lib 下，就被電了 XDDDDD
===

事實上正確的寫法應該通通都是要放在 `app/models` 下。

而設計手法應該是

class Post 本身就放自己的 bussiness logic，然後去 claim 自己有用 ORM。至於過多複雜的邏輯就整理起來放在 Module 裡。

```ruby
class Post 
  include ActiveRecord::Model

  include AAA
  include BBB
  include CCC  
end
```

而寫測試應該就是測 model 本身的商業邏輯而不是測 DB !!

## 小結


Rails 原生的機制讓開發者非常容易以為 Model 與 ORM 是一對一的關係。並且在此架構中，要將 code 整理得乾淨，就會無可避免的演變到反客為主的寫法。

這個 commit 其實只是剛起步，還沒有能夠完全避免一定要測到 DB 的問題。不過至少邁開了一大步。

聽完了這集 podcast，讓我完全看懂這個 commit 和下面的留言，還順便澄清了一個錯誤觀念…

（不過對現狀沒什麼幫助，因為這是 4.0 feature，所以目前還是不能用的 XD，開發者還是只能按照舊的寫法繼續當鴕鳥）

有空還是要多聽大師喇賽才能進步啊...