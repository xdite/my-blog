---
layout: post
title: "Cancan 實作角色權限設計的最佳實踐(2)"
date: 2012-07-30 12:07
comments: true
categories: 
---

## 使用Cancan 的限制：RESTful controller （resource）

一般新進開發者會被  cancan 這兩個 API 搞得七葷八素：`load_and_authorize_resource`、`authorize_resource`。

這是因為 cancan 並沒有明顯的在 README 上做出說明：**cancan 在使用上是有架構的限制**：

#### * 必須為 RESTful resource
（cancan 直接假設了你一定使用 RESTful，畢竟這年頭誰還在寫 non-RESTful …?）

#### * resource 必須與 Controller 同名 
（@article 與 ArticlesController）

使用過 cancan 的人，大概都「猜到」規則好像是這樣？

其實不必猜，[source code](https://github.com/ryanb/cancan/blob/master/lib/cancan/controller_resource.rb) 裡面就寫的很清楚。

### load_and_authorize_resource

load_and_authorized_resource 做了兩件事：

``` ruby
   def load_and_authorize_resource
      load_resource
      authorize_resource
    end
```    

* load_resource
* authorize_resource

load_resource 作什麼呢？: loard_resource => load_resource_instance 

``` ruby
    def load_resource_instance
      if !parent? && new_actions.include?(@params[:action].to_sym)
        build_resource
      elsif id_param || @options[:singleton]
        find_resource
      end
    end
```

okay，這段的作用等於如果你在 Controller 裡面下了 load_resource，cancan 會**自作聰明**的幫你 **自動** 在每一個 action 塞一個 instance 下去

``` ruby
lass ArticlesController < ApplicationController
  load_resource
  
  def new
  end
  
  def show
    # @article is already loaded
  end
end
``` 

如果是 new 這個 action，效果會等於

```
   def new
     @article = Article.new
   end  
```

如果是 show 這個 action，效果會等於

``` 
   def show
     @article = Article.find(params[:id])   
   end
```

有好處也有壞處，好處是…你不需要自己打一行 code，壞處就是不熟 cancan 的人，找不到 @article 在哪裡會驚慌失措…


### authorize_resource

authorize_resource 就是對 resource 判斷權限（根據 CanCan::Ability 裡的權限表）。

而這個 resource 必定是與同名的 instance。

如果是 ArticlesController 對應的必然是 @article。

但是你會想說這樣慘了？萬一我在 ArticlesController 裡面要用 @post 怎麼辦呢？

你可以在 controller 裡面指定 resource instance 的 name 要用什麼名字: `authorize_resource :post`

``` ruby
lass ArticlesController < ApplicationController
  authorize_resource :post
  
  def new
    @post = Article.new
  end
  
  def show
    @post = Article.find(params[:id])
  end
end
``` 

Ability 裡面要這樣下

```
  can :read, Post
  can :create, Post
  can :update, Post
```      

### resource 規則小結

所以 cancan 裡面的 resource 第一個會去吃 controller 的名稱當成 resource name，如果是 `ArticlesController`，instance 就會是 `@article`，而在 ability 裡面就會是 `can :read, Article`。這是在假設你已經使用同名設計 resource & controller 的情況下。

如果非同名。你可以做出指定：`authorize_resource :post`，雖然是 ArticlesController，但是這一組的 resource 名稱為 `post`，所以 instance 就會是 `@post`，而在 ability 裡面就會是 `can :read, Post`。

一般開發者常會誤會的是

* ability 會綁到 model，實際上不是
* controller 名稱要與 @instance 名稱相同，實際上不一定
* @instance 要與 model 同名，實際上不用
* ability 吃的應該是 controller name，實際上不一定（吃的是 resource name，且可以被指定）。

Cancan 吃的是 resource，而且自作聰明的假設了大家「應該」都同名，而且 README example 也是使用「同名」，才會造成了這麼多的誤解…

如果你有更多疑問，可以直接看 source code 裡面的 這一支[controller_resource.rb](https://github.com/ryanb/cancan/blob/master/lib/cancan/controller_resource.rb)，相信會讓你對整個架構更加的清楚...

## 小結

這一節解釋了開發者認為最難懂的 `load_and_authorize_resource`、`authorize_resource`。下一節我們要來講 ability 要如何設計…