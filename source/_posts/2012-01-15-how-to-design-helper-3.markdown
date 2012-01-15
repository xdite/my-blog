---
layout: post
title: "如何運用 / 設計 Rails Helper (3)"
date: 2012-01-15 16:08
comments: true
categories: 
---

本系列其他文章：

* [如何運用 / 設計 Rails Helper (1)](http://blog.xdite.net/posts/2011/12/08/how-to-design-helpers/)
* [如何運用 / 設計 Rails Helper (2)](http://blog.xdite.net/posts/2011/12/09/how-to-design-helpers-2/)

===


## Helper AntiPatterns

Helper （輔助方法）的存在目的是用來輔助整理 View 中內嵌的複雜 Ruby 程式碼。設計得當的 Helper 可以加速專案的開發，以及增進程式的可讀性。然而設計不好的 Helper 卻可能造成嚴重的反效果。

以下列舉常見的幾種糟糕的 Helper 設計模式：

### 1. 矯往過正：用 Helper 作 partial 該做的事

有些開發者以為 partial 效率是低下的，刻意不使用 partial，而使用 Helper 完成所有的動作。就將需要重複使用的 HTML 通通寫成了 Ruby code，串接成 HTML：

``` ruby

def show_index_block(block_name, post, is_show_game)
  
  block_title = content_tag(:h3, block_name)
  section_header = content_tag(:div, block_title, :class => "section-header")
  
  game_name = is_show_game ? "【 #{post.games.first.name} 】" : ""
  title = content_tag(:h4, link_to("#{game_name} #{post.title}", post_path(post)))
  image = content_tag(:div, render_post_image(post), :class => "thumbnail")
  content = content_tag(:p, truncate( post.content, :length => 100))
  section_content = content_tag(:div, "#{title}#{image}#{content}", :class => "section-content")
  
  section_footer = content_tag(:div, link_to("閱讀全文", post_path(post)), :class => "section-footer")
  
  return content_tag(:div, "#{section_header}#{section_content}#{section_footer}" , :class => "article-teaser")
end

```

Helper 的作用只是協助整理 HTML 中的邏輯程式碼，若有大片 HTML 需要重複使用，應該需要利用 partial 機制進行 HTML 的重複利用。這樣的寫法，非但效率低下（可以用 HTML 產生，卻使用 Ruby 呼叫 Tag Helper，且製造大量 Ruby Object），而且更降低程式的可讀性，其他維護者將難以對這樣的 DOM 進行後續的維護翻修。

### 2. 容易混淆：在 Helper 裡面穿插 HTML tag

這也是另外一個矯枉過正的例子，不過剛好相反，因為覺得使用 Ruby code 產生 HTML tag 可能浪費效能，而直接插入 HTML 在 Helper 裡面與 Ruby Code 混雜。結果造成維護上的困難。因為 Ruby 中的字串是使用雙引號`"`，而 HTML 也是使用雙引號`"`，，所以就必須特別加入 `\"` 跳脫，否則就可能造成 syntax error。

#### 錯誤 

``` ruby
def post_tags_tag(post, opts = {})
  # ....
   raw tags.collect { |tag|  "<a href=\"#{posts_path(:tag => tag)}\" class=\"tag\">#{tag}</a>" }.join(", ")
end
```

大量的 `"` 混雜在程式碼裡面，嚴重造成程式的可閱讀性，而且發生 syntax error 時難以 debug。

#### 錯誤 
``` ruby
def post_tags_tag(post, opts = {})
  # ....
  raw tags.collect { |tag| "<a href='#{posts_path(:tag => tag)}' class='tag'>#{tag}</a>" }.join(", ")
end
```
即便換成 `'` 單引號，狀況並沒有好上多少。


#### 正確

``` ruby
def post_tags_tag(post, opts = {})
# ...
  raw tags.collect { |tag| link_to(tag,posts_path(:tag => tag)) }.join(", ")
end
```
正確的作法應該是妥善使用 Rails 內建的 Helper，使 Helper 裡面維持著都是 Ruby code 的狀態，並且具有高可讀性。

### 3. 強耦合：把 CSS 應該做的事綁在 Ruby Helper 上。

#### 錯誤 

``` ruby
def red_alert(message)
  return content_tag(:span,message, :style => "font-color: red;")
end

def green_notice(message)
  return content_tag(:span,message, :style => "font-color: green;")
end
```
有一些開發者不熟悉 unobtrusive 的設計，直接就把 design 就綁上了 Ruby Helper。造成將來有例外時，難以變更設計或擴充。

#### 正確

``` ruby 
def stickies(message, message_type)
  content_tag(:span,message, :class => message_type.to_sym)
end

<span class="alert"> Please Login!! </span>
```
樣式應該由 CSS 決定，使用 HTML class 控制，而非強行綁在 Helper 上。
    

### 4. 重複發明輪子

Rails 已內建許多實用 Helper，開發者卻以較糟的方式重造輪子。在此舉幾個比較經典的案例：

* [cycle](http://apidock.com/rails/ActionView/Helpers/TextHelper/cycle)

如何設計 table 的雙色效果？

#### 劣 
``` ruby 
<% count = 0 >
<table>
<% @items.each do |item| %>
  <% if count % 2 == 0 %>
    <% css_class = "even "%>
  <% else %>
    <% css_class = "odd" %>
  <% end %>
  <tr class="<%= css_class %>">
    <td>item</td>
  </tr>
  <% count += 1%>
<% end %>
</table>
```
一般的想法會是使用兩種 class : event 與 odd 上不同的顏色。


#### 劣 
``` ruby 
<table>
<% @items.each_with_index do |item, count| %>
  <% if count % 2 == 0 %>
    <% css_class = "even "%>
  <% else %>
    <% css_class = "odd" %>
  <% end %>
  <tr class="<%= css_class %>">
    <td>item</td>
  </tr>
  <% count += 1%>
<% end %>
</table>
```
這是一般 Ruby / Rails 初心者會犯的錯誤。實際上 Ruby 中有 `each_with_index`，不需要另外需要宣告一個 count。

#### 優

``` ruby
<table>
<% @items.each do |item| %>
  <tr class="<%= cycle("odd", "even") %>">
    <td>item</td>
  </tr>
<% end %>
</table>
```
但 Rails 其實內建了 `cycle` 這個 Helper。實際上只要這樣寫就好了...

#### 常用你可能不知道的 Helper

限於篇幅，直接介紹幾個因為使用機率高，所以很容易被重造輪子的 Helper。開發者會寫出的相關 AntiPattern 部分就跳過了。

* [truncate](http://apidock.com/rails/ActionView/Helpers/TextHelper/truncate)
* [auto_link](http://apidock.com/rails/ActionView/Helpers/TextHelper/auto_link)
* [div_for](http://apidock.com/rails/ActionView/Helpers/RecordTagHelper/div_for) & [dom_id](http://apidock.com/rails/ActionController/RecordIdentifier/dom_id)
* [simple_format](http://apidock.com/rails/ActionView/Helpers/TextHelper/simple_format)

## 5. Ask, Not Tell

這也是在 View 中會常出現的問題，直接違反了 Law of Demeter 原則，而造成了效能問題。十之八九某個 View 緩慢無比，最後抓出來背後幾乎是這樣的原因。

不少開發者會設計出這樣的 helper：

#### 劣 

``` ruby
def post_tags_tag(post, opts = {})
  tags = post.tags
  tags.collect { |tag| link_to(tag,posts_path(:tag => tag)) }.join(", ")
end
```

``` ruby
<% @posts.each do |post| %>
  <%= post_tags_tag(post) %>
<% end %>
```

這種寫法會造成在 View 中，執行迴圈時，造成不必要的大量 query (n+1)，以及在 View 中製造不確定數量的大量物件。View 不僅效率低落也無法被 optimized。

#### 優

``` ruby
def post_tags_tag(post, tags, opts = {})
  tags.collect { |tag| link_to(tag,posts_path(:tag => tag)) }.join(", ")
end
```

``` ruby
<% @posts.each do |post| %>
  <%= post_tags_tag(post) %>
<% end %>
```

``` ruby
  def index
    @posts = Post.recent.includes(:tags)
  end
```

正確的方法是使用 [Tell, dont ask](http://pragprog.com/articles/tell-dont-ask) 原則，主動告知會使用的物件，而非讓 Helper 去猜。並配合 ActiveRecord 的 includes 減少不必要的 query（ includes 可以製造 join query ，一次把需要的 posts 和 tags 撈出來）。

且在 controller query 有 object cache 效果，在 view 中則無。

## 小結



Helper 是 Rails Developer 時常在接觸的工具。但可惜的是，多數開發者卻無法將此利器使得稱手，反而造成了更多問題。在我所曾經參與的幾十個 Rails 專案中，很多設計和效能問題幾乎都是因為寫的不好的 View / Helper 中的 slow query 或大量物件造成的 memory bloat 所導致的。但參與專案的開發者並沒有那麼多的經驗，能夠抓出確切的病因，卻將矛頭直接是 Rails 的效能問題，或者是沒打上 Cache 的關係。這樣的說法只是把問題掩蓋起來治標，而非治本。

下次若有遇到 performance issue，請先往 View 中瞧看看是不是裡面出現了問題。也許你很快就可以找到解答。

===

接下來兩章我將會介紹：

自用 Helper 的設計整理原則、如何將常用 Helper 抽取出來可以複用。

本篇文章將會收錄在 [Essential Rails Pattern](http://rails-101.logdown.com/books/3-essential-rails-pattern)，目前已有部分章節已可[預覽](http://erp-book.heroku.com)，歡迎[預購](http://rails-101.logdown.com/books/3-essential-rails-pattern)支持我的寫作，謝謝！

