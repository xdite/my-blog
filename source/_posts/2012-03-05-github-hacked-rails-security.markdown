---
layout: post
title: "從 Github 被 hack，談 Rails 的安全性（ mass-assignment ）"
date: 2012-03-05 10:51
comments: true
categories: 
---

關於 Github 被入侵這件事，目前在國外開發圈傳的沸沸揚揚。看來中文圈還沒有消息，我來報導一下到底發生了什麼事好了。順便宣導一下開發 Rails 程式碼需要注意的其中一個觀念..

## 到底發生了什麼事

[Rails](https://github.com/rails/rails) 的 master 被某個 hacker 塞上這一段 [commit](https://github.com/rails/rails/commit/b83965785db1eec019edf1fc272b1aa393e6dc57)。以證明 Github 是可以被入侵的。

## 為什麼會發生這件事（糾紛起源）

有個俄羅斯 Hacker : [homakov](homakov) 到 Rails 的 Github issue 頁，report 了一個 [issue](https://github.com/rails/rails/issues/5228)。

聲稱他發現很多「中等程度以下的」Rails 開發者開發任何網站，都沒有在 model 內作上任何  [attr_accesible] 的防護，這樣會引起很多安全性的問題。

Rails 官方應該設計一個機制強迫大家一定得「使用」[attr_accesible]。

因為寫 code 要塞 attr_accesible 被多數開發者認為是根本是一個「常識」。所以這個 issue 很快就被 Rails core team 關掉了。他的意見是這不是 Rails 的問題，而是開發者的問題。（正常人都會做出這樣的反應）

這個 Hacker 覺得他好心來報告，但是卻被忽視，感到很生氣。

於是！他 Hack 了 Github 證明這件事情是真的。

他不僅利用這個漏洞在 rails/rails 中塞了 [commit](https://github.com/rails/rails/commit/b83965785db1eec019edf1fc272b1aa393e6dc57) ，連當初被關掉的 [issue](https://github.com/rails/rails/issues/5228) ，也用同樣方法打開了。

所以這下就鬧到舉世震驚了！…XDDDDD

## 為什麼會發生這件事（剖析 Rails ）

### 從 Rails 表單機制談起

Rails 秉持著 Don't Repeat Yourself 的精神，將 Form 表單 Helper 直接與 Model 欄位直接結合，節省不少開發者撰寫表單的時間，是一個很聰明的作法。

``` ruby
<%= form_for @post do |f| %>
  <%= f.text_field :title %>
  <%= f.text_area :content %>
  <%= f.sumbit "Submit" %>
<% end %>
```
當表單送出後，會被壓縮成一個 params[:post] 這樣的 Hash。controller 裡面透過 massive-assignment 的技巧直接 mapping 進 Model 裡。

``` ruby
class PostController < ApplicationController
  def create
     @post = current_user.posts.build(params[:post])
     if @post.save
       # do something
     else
       # do another thing
     end
  end
end
```
這是一個自 Rails 誕生以來就有的機制了，十分便手。

有些不了解的 Rails 的其他 Developer 批評這是一個不安全設計，並因此拒絕使用 Rails。欄位暴露在外被人知道，讓他們感到非常不自在。

萬一被人猜到 user 權限是用 user.is_admin 作為 boolean 值，這樣豈不是很危險嗎？在修改個人資訊頁時，假造 DOM 就不是可以把自己提升為 admin 了嗎？

### Rails 內建的安全防禦措施

Rails 也不是沒有針對這件事設計出防禦措施，有兩組 model API ：[attr_accesible](http://api.rubyonrails.org/classes/ActiveModel/MassAssignmentSecurity/ClassMethods.html#method-i-attr_accessible) 與 [attr_protected](http://api.rubyonrails.org/classes/ActiveModel/MassAssignmentSecurity/ClassMethods.html#method-i-attr_protected)。其實也就是 白名單、黑名單設計。

把 [attr_accesible](http://api.rubyonrails.org/classes/ActiveModel/MassAssignmentSecurity/ClassMethods.html#method-i-attr_accessible) 加在 model 裡，可以擋掉所有 massive assignement 傳進來的值，只開放你想讓使用填寫的欄位。

``` ruby
class Post < ActiveRecord::Base
  attr_accesible :title, :content
end
```
而 [attr_protected](http://api.rubyonrails.org/classes/ActiveModel/MassAssignmentSecurity/ClassMethods.html#method-i-attr_protected) 是完全相反地機制。

### 知名認證 Plugin 皆內建 attr_accesible

也因為 user.is_admin 幾乎是所有懶惰開發者會寫出來的 code。因此長久的歷史演變下來，許多知名認證 plugin，如 [devise] ，restful-authentication 等等…，在 User model 裡都會加上 attr_accesible（你可能沒有察覺到，因為可能是透過 include Module 塞進來的功能）。

因為是隱藏的內建防禦，很多不夠經驗的開發者，反而會被這道自動防禦整到，在設計修改使用者資訊這個功能時，常常標單明明沒問題，但就是修改不了除了密碼和 email 以外的欄位 XDDD

### User model 自動防禦，那其他 model 呢？

好問題！這就是這次 Github 發生的問題。嚴格來說，根本不是 rais/rails 的錯，**而是 Github 內某個被罵 mid/junior level 的 developer 的錯**。他根本沒有對其他 model 作上保護，才被 hacker 有機可稱。

Hacker 也是想要證明連 Github 都會犯這種錯，才會鬧出這種事件

## 看到 Github 的事件，我該做什麼？

請回家讀這兩組 model API ：[attr_accesible](http://api.rubyonrails.org/classes/ActiveModel/MassAssignmentSecurity/ClassMethods.html#method-i-attr_accessible) 與 [attr_protected](http://api.rubyonrails.org/classes/ActiveModel/MassAssignmentSecurity/ClassMethods.html#method-i-attr_protected) 的作用。

並檢查你的 project 內是否有類似問題：一般來說，容易被攻擊的點都跟 relation 比較有關係。也就是 xxxxx_id 的部分都要清查。

### Scoped Mass Assignment 

這是 Rails 3.1 加入的新 feature : scoped mass assignment，
<http://enlightsolutions.com/articles/whats-new-in-edge-scoped-mass-assignment-in-rails-3-1>。

我也建議你閱讀。

## Rails core team 目前的解法

大師 Yahuda Katz (wycats) 目前起草了一份新的 [proposal](https://gist.github.com/1974187)，並且丟在 [Hacker News](http://news.ycombinator.com/item?id=3664334) 讓鄉民討論。應該可能近期就會近 Rails core 或以 plugin 的方式釋出。

## 我個人的感想

其實昨晚睡前看到一堆人說 Github 被 Hacked 掉，然後追了幾篇討論串之後，覺得真的是沒什麼，因為就我來說，的確應該就是這個 hacker 覺得有必要提醒大家，但這對多數的 Rails Developer 來說，根本是超小的小事，不值得這麼大驚小怪。

結果憤怒的 Hacker 攻擊了 Github，Github 真的還因為某個 developer 犯了低級錯誤中招。但我還是覺得沒什麼…

## XSS V.S. Massive Assignment

後來睡醒以後才發現不對，其實這東西應該要被拿來跟 auto escape 相比：XSS 是一般設計 Web Application 最容易中招的攻擊。

XSS 的原因肇因是讓開發者開放讓使用者自行輸入內容，然後無保護的讀出來，Hacker 會利用這種漏洞，寫進有害的 JavaScript 讓使用者中招。正確的方式應該是，讀出來之後，都要利用 html_escape 濾掉。

問題是，html_escape 濾不勝濾，沒有開發者能夠那麼神，寫任何一段 code 都會自律的加上 h(content)。最後 Rails core 痛定思痛，在 Rails 3.0 後效法 Django 的設計，在讀出 content 時，一律先 escape。除非有必要，才另行設定不需 escape。

我想這次的 massive assignment 問題應該也要比照辦理才對…

## 延伸閱讀：

國外鄉民懶人包：[GitHub and Rails: You have let us all down.](http://chrisacky.posterous.com/github-you-have-let-us-all-down)

