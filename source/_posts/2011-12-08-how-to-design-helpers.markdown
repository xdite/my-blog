---
layout: post
title: "如何運用 / 設計 Rails Helper (1)"
date: 2011-12-08 21:40
comments: true
categories: 
---

Helper 與 Partial 一直是初學者比較容易迷路的主題之一。迷路的原因有幾個：

1. 不知道有 Rails 提供了許多好用的 Helper 可以用
2. 不知道 Helper 與 Partial 他們各自的使用時機。
3. 擔心使用 Helper 會造成效能下降。
4. 以不好的方式使用 Helper 反而使維護性降低。

因此，一直以來這也是我比較想寫的一個主題…

## Helper 與 Partial

### Partial

Partial 指的是局部樣板。而 Helper 指的卻是在樣板中的一些幫助方法（Ruby Method）。這兩種都是整理又臭又長的 HTML 版面時的好工具。

一般而言，我們會使用 Partial 去處理大段且重複的程式碼。或者是經常使用到的局部程式碼。

* 大段程式碼：（如 new / edit 會複用到的表單）

``` ruby
<%= form_for @post do |f| %>
    <%= render :partial => "form", :locals => { :f => f} %>
<% end %>
```

* 經常使用到的局部程式碼：（如 sidebar 內的區塊）

``` html
<div id="sidebar">
  <%= render :partial => "recent_posts" %>
  <%= render :partial => "recent_comments" %>
</div>
```

…etc.

#### Partial 的優點

* Don't repeat yourself（DRY）程式碼不重複
* 程式修改會比較清楚
* Partial 樣板比較容易被重複使用

### Helper

Partial 的定位多半是被用來處理「大片 HTML 」的工具，而 Helper 卻是比較屬於需要邏輯性輸出 HTML 時用的整理工具。

一般我們學 Rails 常見的

* stylsheet_link_tag
* link_to
* image_tag
* form_for 中的 f.text_field…etc

都屬於 Helper 的範疇。

## 為什麼在專案中我們要使用內建 Helper 開發？

### 其一：為了省力

Rails 最令其他 Ruby Web Framework 羨慕的，就是內建的很多方便 Helper。

舉幾個其實很方便，但大家其實不太知道它們存在的 Helper 好了。

* [simple_format](http://apidock.com/rails/ActionView/Helpers/TextHelper/simple_format) : 可以處理使用者的內容中 \r\n 自動轉 br 和 p 的工作
* [auto_link](http://apidock.com/rails/ActionView/Helpers/TextHelper/auto_link) :可以處理使用者的內容中，若有連結，就自動 link 的工作。
* [truncate](http://apidock.com/rails/ActionView/Helpers/TextHelper/truncate): 使用者輸入的內容，若過長，可以指定多少字後就自動砍掉，並加入 "…."
* [html_escape](http://apidock.com/rails/ERB/Util/html_escape/class): 使用者輸入的內容，若有 html tag，為了怕使用者輸入惡意 tag 進行 hack。自動過濾。（以前要手動加 h 過濾，現在 Rails 預設 escape，不想被 escape 才手動指定 raw 閃掉 escape）

這些東西若自己寫 parser 處理，不知道要花費多少精力，還不一定濾的徹底。卻都是 Rails 預設內建 Helper。

### 其二：為了跟 Rails 內建的其他更棒的基礎建設整合

* stylesheet_link_tag 與 image_tag

有些人也覺得，這東西還要用 Helper 嗎？直接貼 HTML 不是也一樣會動嗎？有什麼差別。差別可大了。

``` ruby
 <%= stylesheet_link_tag "abc", "def", :cache => true %>
```

這一行，可以在 production 環境時，自動幫你將兩支 CSS 自動壓縮成一支 all.css 。直接實現了 Yahoo [Best Practices for Speeding Up Your Web Site]（http://developer.yahoo.com/performance/rules.html）中，minify HTTP reqesut 的建議。而在 Rails 3.1 之後，甚至還會自動幫你 trim 與 gzip。

完全不需要去在 deploy process 中 hook 另外的 compressor 就可以達到。

至於 image_tag 有什麼特別的地方？

``` ruby
 <%= image_tag("xxx.jpg") %>
```

Rails 可以幫你的 asset 自動在後面上 query string，如：xxx.jpg?12345

這樣在網站若有整合 CDN 架構時，可以自動處理 invalid cache 的問題。

而 Rails 也有選項可以實作 asset parallel download 的機制，一旦打開，站上的 asset 也會配合你的設定，亂數吐不同來源的 asset host 實做平行下載。

輕鬆就可以把網站 Scale 上去。

* form_for

這也是 Rails 相當為人稱讚的一個利器。Rails 的表單欄位是綁 model (db 欄位的)，除了開發方便（ `Post.new(params[:post])` 直接收參數做 mapping）之外，也內建了防 CSRF (`protect_from_forgery`)的防禦措施。

===

可以在一眨眼的工夫，實作出業界（performace /security）最佳實踐。而你卻不需要是架構大師。

