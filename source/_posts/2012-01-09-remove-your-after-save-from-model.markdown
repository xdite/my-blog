---
layout: post
title: "[進階]使用 Facade Pattern 取代 Model callbacks"
date: 2012-01-09 18:56
comments: true
categories: 
---

## What is "callbacks"?

Rails 的 ActiveRecord 提供了相當方便的 callbacks，能讓開發者在寫 Controller 時，能夠寫出更加 DRY 的程式碼：

* before_crearte
* before_save
* after_create
* after_save
* …

在從前，在 Controller 裡面想要再 object 儲存之後 do_something，直觀的思路會是這樣：

``` ruby
class PostController
  def create
    @post = Post.new(params[:post])
    @post.save
    @post.do_something
    redirect_to posts_path
  end
end
```

當時的最佳模式：通常是建議開發者改用 callbacks 或者是 Observer 模式實作。避免 controller 的髒亂。

* callbacks : after_create

``` ruby
class PostController < ApplicationController
  def create
    @post = Post.new(params[:post])
    @post.save
    redirect_to posts_path
  end
end

class Post < ActiveRecord::Base
  after_create :do_something

  protected
  
  def do_something
  end
end
```

或者是使用 Observer

* Observer
``` ruby

class PostController < ApplicationController
  def create
    @post = Post.new(params[:post])
    @post.save
    redirect_to posts_path
  end
end

class PostObserver < ActiveRecord::Observer

  def after_create(post)
    post.do_something
  end

end

class Post < ActiveRecord::Base

  protected
  
  def do_something
  end
end
```

## 使用 callbacks 所產生的問題

callbacks 雖然很方便，但也產生一些其他的問題。若這個 do_something 是很輕量的 db update，那這個問題還好。但如果是很 heavy 的 hit_3rd_party_api 呢？

在幾個情形下，開發者會遇到不小的麻煩。

* Model 測試：每次在測試時都會被這個 3rd_party_api 整到，因為外部通訊很慢。
* do_something_api 是很 heavy 的操作：每次寫測試還是會被很慢的 db query 整到。
* do_something_api 是很輕微的 update：但是綁定 after_save 操作，在要掃描資料庫，做大規模的某欄位修改時，會不小心觸發到不希望引發的 callbacks，造成不必要的效能問題。

當然，開發者還是可以用其他招數去閃開：

比如說若綁定 after_save 。

可以在 do_somehting 內加入對 dirty object 的偵測，避免被觸發：

``` ruby
def do_somthing
  # 資料存在，且變動的欄位包括 content
  if presisited? && changed.include?("content")
     the_real_thing  
  end
end
```

但這一招並不算理想，原因有幾：

1. 每次儲存還是需要被掃描一次，可能有效能問題。
2. 寫測試時還是會呼叫到可能不需要引發的 do_somehting。
3. if xxx ＆＆ yyy 這個 condiction chain 可能會無限延伸下去。

## Facade Pattern

那麼要怎樣才能解決這個問題呢？其實我們應該用 Facade Pattern 解決這個問題。

設計模式裡面有一招 Facade Pattern，這一招其實是沒有被寫進 [Design Pattern in Ruby](http://designpatternsinruby.com/) 中的。Russ Olson 有寫了[一篇文章](http://designpatternsinruby.com/section02/facade.html)解釋沒有收錄的原因：因為在 Ruby 中，這一招太簡單太直觀，所以不想收錄 XDDD。但他還是在網站上提供當時寫的草稿，供人參考。


### What is Facade Pattern?

Facade Pattern 的目的是「將複雜的介面簡化，將複雜與瑣碎的步驟封裝起來，對外開放簡單的介面，讓客戶端能夠藉由呼叫簡單的介面而完成原本複雜的程式演算。」（[來源](http://www.dotblogs.com.tw/jameswu/archive/2008/06/26/4382.aspx)）

延伸閱讀: [(原創) 我的Design Pattern之旅[5]：Facade Pattern (OO) (Design Pattern) (C/C++)](http://www.cnblogs.com/oomusou/archive/2007/04/24/725714.html)

### 實際舉例：

在上述的例子中，其實 do_something 有可能只會在 PostController 用到，而非所有的 model 操作都「需要」用到。所以我們 **不應該將 do_somehting 丟進 callbacks（等於全域觸發），再一一寫 case 去閃避執行**

與其寫在 callbacks 裡。我們更應該寫的是一個 Service Class 將這一系列複雜昂貴的行為包裝起來，以簡單的介面執行。

``` ruby

class PostController < ApplicationController
  def create
    CreatePostService(params[:post])
    redirect_to posts_path
  end
end

class CreatePostService
  def self.create(params)
    post = Post.new(params[:post])
    post.save
    post.do_something_a
    post.do_something_b
    post.do_something_c
  end
end

```

而在寫測試，只需要對 PostCreateService 這個商業邏輯 class 寫測試即可。而 PostController 和 Post Model 就不會被殃及到。

## 小結

不少開發者討厭測試的原因，不只是「因為」寫測試很麻煩的原因，「跑一輪測試超級久」也是讓大家很不爽的主因之一。

其實不是這些測試框架寫的爛造成「寫測試很麻煩」、「執行測試超級久」。而是另有其他因素。

許多資深開發者逐漸意識到，真正的主因是在於目前 Rails 的 model 的設計，耦合度太高了。只要沾到 db 就慢，偏偏 db 是世界的中心。

ActiveRecord 的問題在於，讓開發者太誤以為 ORM = model。其實開發者真正要寫的測試應該是對商業邏輯的測試，不是對 db 進行測試。

所以才會出現了用 Facade Pattern 取代 callbacks 的手法。

## 其他

MVC 其實有其不足的部份。坦白說，Rails 也不是真正的 MVC，而是 [Model2](http://andrzejonsoftware.blogspot.com/2011/09/rails-is-not-mvc.html)

目前 MVC 其實是不足的，演化下來，開發者會發現 User class 裡面會開始出現這些東西：

* current_user.buy_book(book)
* current_user.add_creadit_point(point)

這屬於 User 裡面應該放的 method 嗎？well，你也可以說適合，也可以說不適合。

適合的原因是：其實你也不知道應該放哪裡，這好像是 User 執行的事，跟他有關，那就放這裡好了！不然也不知道要擺哪裡。

不適合的原因是：這是一個「商業購買行為」。不是所有人都會購物啊。這應該是一個商業購買邏輯。但是....也不知道要放在哪啊。

一直到最近，James Copelin 提出了：[DCI](http://en.wikipedia.org/wiki/Data,_Context,_and_Interaction) 去補充了現有的 MVC 的不足，才算勉強解決了目前浮現的這些問題。

有關於 DCI ( Data, Context, Interaction ) 的文章，我會在之後發表。我同時也推薦各位去看這方面的主題。這個方向應該會是 Rails 專案設計上未來演化的方向之一。

