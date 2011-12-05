---
layout: post
title: "對於使用 Render Partial 的一些誤解"
date: 2011-12-04 11:30
comments: true
categories: 
---


<http://ruby-taiwan.org> 是從 [ruby-china](https://github.com/huacnlee/ruby-china) 這個專案 fork 出來改的。

====

本文章經過 [ruby-china](https://github.com/huacnlee/ruby-china) 作者 [huacnlee](http://twitter.com/huacnlee) 同意後進行寫作。

===

坦白說，最初會開始把玩這個專案，是因為覺得想法和介面上做的不錯，想 clone 下來玩玩看。不過這個 project 當時的狀態可以說是「unmaintainable」。

造成 unmaintainable 的因素主要有兩個：

* 使用不好的寫法 implement 連結。

``` ruby
	<a href="<%= posts_path %>"> ALL POST </a>

```

* view 裡面充滿 LOGIC。

這是當時的 [app/views/topics/index.html.erb](https://github.com/huacnlee/ruby-china/blob/1e3359a26dd71ece872c5f4adfcabc054f5b9c83/app/views/topics/index.html.erb) 和 [app/views/topics/_sidebar.html.erb](https://github.com/huacnlee/ruby-china/blob/1e3359a26dd71ece872c5f4adfcabc054f5b9c83/app/views/topics/_sidebar.html.erb)


在我 join 這個專案之後，第一件事就是清 code，把 project 翻修到大家都改的動....

## 對於 render :partial 的誤解

會產生這樣的 code，是有原因的。主要是因為作者

* 想要複用 index 與 sidebar
* 不想使用人人都「覺得」慢的 render :partial，所以才用 LOGIC 判斷，要吐哪一些內容出來。

而「被覺得慢的 partial」，也是促使我想寫這篇文章的主要原因。

### 聰明反被聰明誤

造成這個 project unmaintainable 的兩大主要原因，背後的想法是

1. 「覺得」使用 Ruby 去產生 link 會產生 extra function call，拖累效能。所以乾脆只取用 path_helper
2. 「覺得」使用 partial 會變慢，所以刻意使用 LOGIC in View 去控制顯示的內容。

而第一點造成了 連結 unmaintainable，第二點造成 View 不僅 unmaintainable，還 ULTRA SLOW。

而這也不怪作者，幾乎我認識的一些 Rails Developer，都帶著這樣的偏見。

(我自己以前對 partial 也是能閃就閃，只是我還是為了 code 乾淨度維護問題，繼續使用，然後再對緩慢的 partial 上 cache。)

### Partial 真正緩慢的原因 ：eval

Partial 真正緩慢的原因是這樣：ERB 裡面能夠「跑」 code 的原因，是因為用 eval 去執行裡面 code 的內容。而一旦牽扯到「eval」，view 巨慢無比就是很正常的事。

你可以動手作個小實驗，render 一個 partial。裡面分別放入這樣的內容：

``` ruby
12345 Hello World 
```

``` ruby
<%= @post.id %>
```

``` ruby
<% Post.first %>
```

也在這個 case 裡，如果直接拆成 partial，分塊呼叫的話，其實效率是非常高的，而且在維護上也非常直觀。而`原本為了避免採用 partial 造成效率低落所作的 LOGIC in View，反而是把這一頁效能完全拖垮的最大兇手`。

### Follow MVC : Never LOGIC in View

不只是別在 Partial 裡面寫 LOGIC，更進一步的，其實你也應該儘量避免在 View 裡面寫任何 LOGIC。

follow MVC 在 Rails 的意義，不僅是因為遵循 MVC pattern 精神而已。更重要的是，`在 view 中 LOGIC 會直接帶來嚴重的效能低落`。

### How to organize code?

接下來衍生出來一個常常被問到的問題：「如何區別使用 Helper 與 Partial 的時機？」

#### Helper

我建議的判斷準則是這樣的。如果只有三行 HTML 以內的 View，而這一段 code 常常會被使用到。應該將他翻修成 Helper。

``` html
    <h1 class="title"> <a hre="/posts/1"> POST TITLE </a> </h1>
```
翻修成

``` ruby
    def render_post_title(post)
      content_tag(:h1, link_to(post.title, post_path(post)), :class => "title")
    end

    <%= render_post_title(post) %>
```

或者是這樣的情形

``` rhtml
  <% if current_user && (post.user == current_user || current.user.is_forum_admin? || current.user_is_admin? ) %>
	<%= link_to("Edit", edit_post_path(post) ) %>
  <% end %>
```
翻修成

``` rhtml
  <% if editable?(post) %>
     <%= link_to("Edit", edit_post_path(post) ) %>
  <% end %>
``` html

#### Partial

而使用 Partial 適當的時機是「大塊的 HTML 需要被複用」，所謂的大塊，是指 3 行以上的 HTML。千萬不要逞強使用 Helper 硬幹。用 Helper 包裹複雜的 HTML DOM 也會讓程式碼變得無法維護。

以前就曾經改到一段 code：Developer 根本不知道有 partial 可用，只知道有 helper。他覺得 helper 很棒，因此就拿來包一段 20 多行的 HTML。

結果美術的版不是 final，DOM 要大改重調位置，結果現場包含他自己，根本沒人看得懂 / 改的動這一段 code。

我自己個人蠻常使用的技巧則是` helper 與 partial `混用，比如說

``` html
  <% if editable?(post) %>
     <%= render :tool_bar %>
  <% end %>
```

### 被迫得在 View 中 LOGIC 或 Query 怎麼辦？

但有的時候，我們還是會被迫在 View 中寫程式，比如說跑迴圈 query…

```
  <% sites.each do |site| %>
    <% site.categories.each do |category| %>
      <% category.popular_posts.each do |post| %>
         <%= post.title %>
         <%= post.content %>
      <% end %>
    <% end %>
  <% end %>
```
常見的想法是，整片 `打 cache`。

但打 cache 其實沒有真正解決問題，當 cache expire 時，還是要有一個倒楣鬼，去負責 heat cache。就看哪個 user 倒楣囉。

這時候我會推薦你使用一套 gem : [Cells - Components For Rails](http://cells.rubyforge.org/)。去取代 partial 的架構。

Cells 的架構，有些不一樣。它提出的概念是 `mini-controller` & `partial`。也就是如果在 View 中 query 是昂貴的，你可以使用 Cells 提供的 mini-controller 把 query 拆上去。多層也沒問題，因為可以一直 render_cell 上去。

而 Cells 也是 cachable 的架構。


## Don't use MVP & Drapper

近年比較熱的包裝手法是 MVP 和 Drapper，很不巧的都剛好是同一個作者 Jeff Casimir。

Rails 的 MVP 是他在 [Fat Models Aren't Euough](http://blip.tv/rubynation/jeff-casimir-fat-models-aren-t-enough-5562605) 倡導的。

MVP 其實並沒有解決 View 的問題，而更糟的是，把片段的邏輯拆出去變成一層 Presentor，讓 code 變得其實更難維護了。

而 [Drapper](http://railscasts.com/episodes/286-draper) 更糟，玩的是 Decorater 手法。本來 Controller 與 View 混在一起就已經很糟了。而 Drapper 實作的手法，反而把整件事情帶往又更糟的方向…`Model 與 View 混在一起`。

更別提它的效能問題了…

-_-|||

難道只有我覺得他是害人精嗎？

## Conculsion

怎麼寫出好的 Code? 其實一般人對於我的感覺是：看我談這麼多 Rails 寫作技巧，我一定對同事很要求。

很多人都有一個很大誤解：好的 Code 等於寫法漂亮的 Code，效能很高的 Code。所以一開始就給自己很大的壓力，第一次就要寫到漂亮，第一次就要寫到效能很棒，第一次就要用上很多技巧。

這是錯誤的想法。其實寫 Code 只有兩件事需要注意：

1. 別寫蠢 Code。有一些禁忌是絕對不能犯的。比如說 
	* SLOW SQL (QUERY|REQUEST) in View。
	* wrap everything, 20 行的 HTML Helper
2. 寫出乾淨易懂的 code。
	* 笨拙但直觀的 code 別人多半是可以勉強接受的。
    * 直觀好維護的 code 才可以讓人看出你的意圖，從而改善。
    * 一段好 code 也通常是經過這樣幾次的 refactor，才到達最後的水準…

我也只有執行這兩個原則而已。

一般實作功能，真正的效能瓶解往往不在於那多出來的幾個 function call。多半會在於你意想不到的地方，或者反而是你以為 optimize (效能/寫法)的地方。

好好運用內建的機制，不要嘗試用 Cache 硬隱藏原有的問題，其實這樣就夠了…