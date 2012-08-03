---
layout: post
title: "Cancan 實作角色權限設計的最佳實踐(1)"
date: 2012-07-30 02:12
comments: true
categories: Rubygem
---

權限存取設計是在開發 Application 中相當讓人棘手的一個題目。

在一個網站開始建設的初期，通常這樣的問題並不會浮現，畢竟一般人的需求大半只會有 user 和 admin 兩種角色。但是隨著網站長大，更多的生意需求浮現，第三種角色的出現，通常就會把原本乾淨的 code 弄得骯髒不堪。


## 多種角色的權限設計難題

當只有 user 和 admin 的情況下，你可以在 `view` 裡面單純的做出這樣的設計

``` erb

<% if user.is_admin ? %>
  <%= link_to("Admin Pannel", admin_panel_path ) %>
<% end %>

```

並且在 controller 裡面加上權限判斷

``` ruby

class Admin::ArticleController < ApplicationController
  before_filter :require_is_admin
end

```

但一段時間之後，User Story 被加進了這樣的需求: 

* 使用者可以被設定為「editor」
* 擁有「editor」角色的使用者，可以進入 admin 後台發表、編輯文章
* 擁有「edtior」角色的使用者，進入 admin 後台內的活動範圍僅限縮在文章後台內
* 擁有「edtior」角色的使用者，進入 admin 後台內，不可以看到其他後台選項。

身為開發者的你，要如何在現有後台內加入這樣的設計？

不用實際動手寫也知道，若如以往使用 if / else 的設計，Helper / Controller / View 鐵定變成一團血肉模糊。

抱怨不能解決問題，但世界上是否存在乾淨的解答？

## Rule-engine based authorization library: Cancan

答案就是：「Rule Engine」。

「針對多種條件執行多種動作」，此類的使用者需求，無論是使用 if / else，甚至是 case when，架構還是不免會一團混亂。與其承襲舊思路，不如啟用新想法「Rule Engine」實作：預先設計撰寫一套邏輯規則引擎，而後程式針對預設的規則進行邏輯判斷後執行。

而「角色權限」的設計需求上，正特別適合用 Rule Engine 這樣的觀念去建構。Rails 界知名的 authorization library [cancan](https://github.com/ryanb/cancan) 正是以此作為基礎。 

### Cancan 可以做到的：介面單純化

cancan 希望做到的是，把權限判定的處理部分從 Helper / Controller / View 裡面，全部移到 `app/models/ability.rb` 進行判定。也因此可以做到

* View 只需要判斷是否可以執行動作，而不必問是否有權限

``` erb
<% if can? :update, @article %>
  <%= link_to "Edit", edit_article_path(@article) %>
<% end %>
```

* Controller 不需要手動判斷是否具有權限

``` ruby
class ArticlesController < ApplicationController
  authorize_resource

  def show
    # @article is already authorized
  end
end
```

但驚人的是 ** view 的權限會是與 controller 的權限判定規則 ** 卻是一致的。（以往「自刻」權限判定，往往加了 view 卻會忘記 controller, 加了 controller 卻會忘記 view ）

### Cancan 希望做到的：權限中心化管理

而是否有權限存取，則全交給 `app/models/ability.rb` 去判斷處理。

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
    elsif user.has_role?(:member)
      
      can :create, Topic
      can :update, Topic do |topic|
        (topic.user_id == user.id)
      end
      
      can :destroy, Topic do |topic|
         (topic.user_id == user.id)
      end
      
      basic_read_only
    else
      # banned or unknown situation
      cannot :manage, :all
      basic_read_only
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

## 小結

[cancan](https://github.com/ryanb/cancan) 是一套相當 powerful 的權限管理系統，但是它的文件卻相當不好讀，第一次想使用 cacan的 developer 很難從文件上找到自己想要的範例以及 api，或者了解其原理構造。如果沒有先給一些基礎範例，往往會是寸步難行。

下一篇我會深入頗析 Cancan 更深的設計原理，讓大家更看得懂 cancan 的 API 到底想幹什麼....。

## 系列連結


* [Cancan 實作角色權限設計的最佳實踐(1)](http://blog.xdite.net/posts/2012/07/30/cancan-rule-engine-authorization-based-library-1/)
* [Cancan 實作角色權限設計的最佳實踐(2)](http://blog.xdite.net/posts/2012/07/30/cancan-rule-engine-authorization-based-library-2/)
* [Cancan 實作角色權限設計的最佳實踐(3)](http://blog.xdite.net/posts/2012/07/30/cancan-rule-engine-authorization-based-library-3/)


