---
layout: post
title: "Cancan 實作角色權限設計的最佳實踐(3)"
date: 2012-07-30 23:03
comments: true
categories: Rubygem
---

### 角色判斷 current_ability

這是一段普通的 `ability.rb` 權限範例 code。

``` ruby
class Ability
  include CanCan::Ability

  def initialize(user)

    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
    elsif user.has_role?(:admin)
      # admin
      can :manage, :all
    end

  end

  protected

  def basic_read_only
    can :read,    Topic
    can :list,    Topic
    can :search,  Topic
  end
end
```

一般開發者最有疑問的是 `def initialize(user)` 這一段程式碼中的 user 到底是怎麼來的？怎麼會沒頭沒尾的天外飛來一個 user，然後對這個 user 進行角色判斷就可以動了？

這一段要追溯到...[lib/controller_additions.rb](https://github.com/ryanb/cancan/blob/master/lib/cancan/controller_additions.rb) 中的這一段 current_ability。

cancan 裡面去判斷是否有權限的一直是 `current_abibilty`，而 `current_abibilty` initialize 的方式就是塞 current_user 進去。

``` ruby
    def current_ability
      @current_ability ||= ::Ability.new(current_user)
    end
```    

所以 `initialize(user)` 裡的 `if user.blank?` 其實就等於 `if current_user.blank?`（若沒登入）。

這樣去解讀程式碼，看起來就好理解很多了…

### 權限類別解說 :manage, :all, ..etc.

cancan 裡面用了一堆自定義縮寫，如 `:manage`、`:read`、`:update`、`:all`，讓人不是很了解在做什麼。

* :manage: 是指這個 controller 內所有的 action
* :read : 指 :index 和 :show
* :update: 指 :edit 和 :update
* :destroy: 指 :destroy
* :create: 指 :new 和 :crate

而 :all 是指所有 object (resource)

當然，不只是 CRUD 的 method 才可以被列上去，如果你有其他非 RESTful 的 method 如 :search，也是可以寫上去..，只是要一條一條列上去，有點麻煩就是了。

#### 組合技：alias_action

cancan 還提供了組合技，要是嫌原先的 :update, :read 這種組合包不夠用。還可以用 `alias_action` 自己另外再組。例如把 :update 和 :destroy 組成 :modify。

``` ruby
   alias_action :update, :destroy, :to => :modify
   can :modify, Comment
```
#### 組合技: 自訂 method

要是你嫌每個角色都要一條一條把權限列上去，超麻煩。可以把一些共通的權限包成 method。用疊加 method 上去的方式列舉。比如把基礎權限都包成 `basic_read_only`、`account_manager_only`, etc…

``` ruby
  def basic_read_only
    can :read,    Topic
    can :list,    Topic
    can :search,  Topic
  end
```  

### 針對物件狀態控管

在 User story 中，使用者固然 `can :update, Topic`，但還是讓人覺得覺得哪裡有點怪怪的？

是的。使用者應該只能編輯和修改屬於自己的文章，`can :update, Topic` 只有說使用者可以「修改文章」啊（等於可以修改所有文章） XD

所以 `ability.rb` 就要這樣設計了

``` ruby
      can :update, Topic do |topic|
        (topic.user_id == user.id)
      end
      
      can :destroy, Topic do |topic|
         (topic.user_id == user.id)
      end
```

可以玩的更加進階：

``` ruby
    can :publish, Post do |post|
      ( post.draft? || post.submitted? ) && !post.published?
    end
```          

## 其他

cancan 還有其他進階主題可以繼續探討，讀者可以自行研究：

* [Nested Resources](https://github.com/ryanb/cancan/wiki/Nested-Resources)
* [Exception Handling](https://github.com/ryanb/cancan/wiki/Exception-Handling)
* [Ensure Authorization](https://github.com/ryanb/cancan/wiki/Ensure-Authorization)

不過關於「難懂」和「難用」的部分，我想我應該講的差不多了…

## 小結

在寫這一系列文章時，我發現 cancan 的作者，其實把大部分的文件與範例，都寫在 lib/ 下的 RDOC 裡面了，光看 code comment 其實就可以瞭解大半流程。

不過我覺得 cancan 讓人覺得難讀的最大原因，可能還是官方缺乏一個 example `ability.rb`，對於被隱藏的自動完成部分也缺乏解釋，所以才造成大家覺得 cancan 是個難用的 magic library。事實上如果你開始搞懂 cancan 怎麼撰寫的話，它是可以幫你把網站的權限 code 處理的非常漂亮又易懂的。

這系列就寫到這邊，如果你對 cancan 還有什麼使用上的問題，歡迎到 [Rails Tuesday](http://www.meetup.com/Ruby-Taiwan-Group/) 來找我討論。

## 系列連結


* [Cancan 實作角色權限設計的最佳實踐(1)](http://blog.xdite.net/posts/2012/07/30/cancan-rule-engine-authorization-based-library-1/)
* [Cancan 實作角色權限設計的最佳實踐(2)](http://blog.xdite.net/posts/2012/07/30/cancan-rule-engine-authorization-based-library-2/)
* [Cancan 實作角色權限設計的最佳實踐(3)](http://blog.xdite.net/posts/2012/07/30/cancan-rule-engine-authorization-based-library-3/)

