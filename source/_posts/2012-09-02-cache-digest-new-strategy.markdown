---
layout: post
title: "cache_digests 最大化緩存策略"
date: 2012-09-02 20:06
comments: true
categories: 
---

<a href="http://www.flickr.com/photos/ferguson666/3605271302/" title="Russian Dolls 097 by Louise...6661, on Flickr"><img src="http://farm3.staticflickr.com/2473/3605271302_0532598c8f.jpg" width="500" height="333" alt="Russian Dolls 097"></a>

大概半個月之前（2012/ 8/13 前後），[@dhh](http://twitter.com/dhh) 釋出了一個有關於 cache 的 gem，叫做 [cache_digests](https://github.com/rails/cache_digests)，並宣布此 gem 會成為 Rails 4 中的一部分。

既然會是主體的一部分，想必這個 gem 解決的問題非常重要。但無奈 README 也非常簡略，看不出重要性在哪。還花了我一點時間在網路上找資料，把 DHH 想要表達的哲學拼出來....

### 從 new Basecamp 改版談起

@dhh 的公司 [37signals](http://37signals.com) 旗下最有名的產品 [Basecamp](http://basecamp.com) 大概半年前改版了。與其說是改版，不如說是整個大重寫了。撇開使用性不談（好用度大幅提高），Website Performance 整體也大幅提升。

37signals 在大概二月發表了一篇文章，談了這次的版本為什麼效能變得這麼好：

#### 1. Turn to JavaScript Applicaton

眾所皆知（?）的這次的改寫重點是在 JavaScript 上，整個 codebase 中CoffeScript 與 Ruby 的比例到達了 1:1 之譜。也就是 new Basecamp 實質上是個「JavaScript Application」。另外再利用 Stacker (advanced puhState-based engine for sheets) 大幅降低 HTTP requests。

#### 2. Cache TO THE MAX: Russian Doll cache stratgy

雖然 new Basecamp 已經是個 「JavaScript Application」。但有個問題還是存在，身為 backend 的 Rails App 在 render Basecamp 的邏輯時，速度還是不夠快。於是他們採用「Russian Doll」的 Cache Strategy 把能 Cache 的部分擴展到上限…

### Russian Doll cache strategy

如名所示，Russian Doll strategy，就是使用層層 cache 嵌套的策略。

![image](http://s3.amazonaws.com/37assets/svn/777-russian-doll-caching-1.png)

這一張圖片的背後 code 會是這樣的寫法：

``` ruby
<% cache @project do %>
  aaa
  <% cache @todo do %>
    bbb
    <% cache @todolist do %>
      ccc
    <% end %>
  <% end %>
<% end %>
```

再利用 Rails 內建 cache helper 使用 `"#{cache_key}/#{id}-#{timestamp}"` ([出處](http://apidock.com/rails/ActiveRecord/Base/cache_key)) 的方式去實作 cache invalidation。如此一來，只要 object 被變更，cache 就會被刷新。

但這招即使如此直觀，還是會遇到 invalidation 上的幾個問題。

#### 1. 更新了 todolist，但是上層 class: todo 卻不知道…

todlist 更新了，所以 updated_at 會被更新。不過 todo 卻不知道 todolist 的更新，所以整塊並不會被更新。

##### 解法：

不過解法容易。可以透過 `belongs_to :todo, :touch => true`，`belongs_to :product, :touch => true`。從最底部的 todolist，層層連鎖更新到最上層。

#### 2. 更新了 code block，但 object 內容卻因為沒更新而不會 expire。

當我把 ccc 改成 zzz 時且打算 deploy 時，問題來了...。整套 cache 機制是基於 object 更新，而不是 code 更新。所以 cache 並不會 invalid….

``` ruby
<% cache @project do %>
  aaa
  <% cache @todo do %>
    bbb
    <% cache @todolist do %>
      zzz
    <% end %>
  <% end %>
<% end %>
```
##### 解法：

這邊有另外一個寫法可以閃過這個地雷，就是為這整段 code 加上版本號：


``` ruby
<% cache [v15,@project] do %>
  aaa
  <% cache [v10,@todo] do %>
    bbb
    <% cache [v45,@todolist] do %>
      zzz
    <% end %>
  <% end %>
<% end %>
```

如果我要將 todolist block 那塊更新，要強制 invalid，我可以把 `v45` 改成 `v46`。這樣就更新了。

不過如果這一塊 view 上面還有外層 cache 嵌套，`v10` 要跟著變成 `v11`，`v15` 要跟著變成 `v16`。

有點麻煩了…

但這還不是最糟糕的…

#### 3. cache 的部分散落在 partial 裡面，版本號更新不易

改版本號麻煩但還算可以接受。但這只限於都在同一張 view 裡面的狀況。

若是 cache 被放在 partial 裡面，被多個 view 引用呼叫，那就麻煩了…

`_todolist.html.erb`

``` ruby
    <% cache [v45,@todolist] do %>
      zzz
    <% end %>
```

改版本號的手續就變成地獄了…。因為你永遠都會有忘記清掉的 view…

解法：

暫無。認命的改吧（？）

### 4. 逐漸冗長的 syntax 問題..

而使用版本號閃避 cache 還會造成，原本直觀的

``` ruby
  <% cache @todolist do %>
    zzz
  <% end %>
```

為了要 invalid cache 的問題，被迫使用 trick 去 bypass。

``` ruby
  <% cache [v45,@todolist] do %>
    zzz
  <% end %>
```

可不可以單純一點，我們寫 code 還是回到直觀的 `cache @object`，然後以上談到的這些問題都會自動解決？


### cache_digests 就是這一切的答案：md5_of_this_view

[cache_digests](https://github.com/rails/cache_digests) 就是 DHH 解決這一切惱人問題的手段。

而且解決策略也非常簡單，既然大家都在版本號上面 GGYY，那麼其實最快的方式就是 **md5_of_this_view** ！！！

[cache_digests](https://github.com/rails/cache_digests) 允許開發者繼續使用這樣的 code:

``` ruby
  <% cache @todolist do %>
    zzz
  <% end %>
```

但！cache_digests 自動幫忙計算此 block 裡面的 code 產出的內容的 md5，以此 md5 作為 cache key，從而達到自動 invalid 的效果。

同時，這個 gem 也會自動解決層層嵌套的 dependency 問題…

### 小結

這一個 gem 前前後後不到 150 行。卻解決了一個非常重要的 cache 問題，也難怪會變成 Rails 4 之後內建的功能。

gem 雖然直觀。不過翻出這些前因後果還真是不簡單，在寫這篇文章的確也花了我花了一點時間去蒐集資料。從 37signals 釋出的一些小片段去把內容組出來。

相關連結：

* [How Basecamp Next got to be so damn fast without using much client-side UI](http://37signals.com/svn/posts/3112-how-basecamp-next-got-to-be-so-damn-fast-without-using-much-client-side-ui)
* [How key-based cache expiration works](http://37signals.com/svn/posts/3113-how-key-based-cache-expiration-works)
* [Evening on Backbone.js/Views w/ Q&A with David Heinemeier Hansson](http://www.youtube.com/watch?v=FkLVl3gpJP4#t=33m30s)
* [Advanced Caching: Part 2 - Using Caching Strategies](http://www.broadcastingadam.com/2012/07/advanced_caching_part_2-using_strategies/)