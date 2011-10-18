---
layout: post
title: "Asset Pipeline 的重大意義：Version Control Your Asset Package"
date: 2011-10-18 23:51
comments: true
categories: 

---

Asset Pipeline 是 Rails 3.1 引入的重大 feature。

之前我曾經為文撰寫過背後設計的意義以及哲學。若你有興趣的話可以觀看這一系列的文章：

* [Asset Pipeline](http://upgrade2rails31.com/asset-pipeline)
* [Sass / SCSS](http://upgrade2rails31.com/sass-scss)
* [Compass](http://upgrade2rails31.com/compass)
* [CoffeeScript](http://upgrade2rails31.com/coffee-script)

## Asset as rubygem

其實這個設計在 Rails 3.1 的蠻早期就有了，而且就藏在官方範例中。只是我初看時完全沒意識到這個設計背後的原理、哲學以及它的重大意義。而多數的鎂光燈也集中在 Asset Pipeline 可大幅獲益於 Compass 與 CoffeeScript 中，沒多少人提起這件事。

Rails 的 application.js 裡面有著這麼一段：

``` javascript application.js

//= require jquery
//= require jquery_ujs

```

而這是由 Gemfile 中的這個 gem : [jquery-rails](/todo) 所提供的

``` ruby Gemfile
gem "jquery-rails"
```

看得出來奧妙嗎？

### 結合 Rails Engine 提供 asset 掛載

yes。現在你可以透過結合 Rails Engine 把 gem 中的 asset 掛起來。所以 application.js 中

``` javascript application.js

//= require jquery
//= require jquery_ujs

```

的 jquery 以及 jquery_ujs 都是 jquery-rails 這個 gem 中的 javascript。

### Boost you project

還看不出來意義嗎？讓我再給你一個例子吧：[bootstrap-rails](https://github.com/anjlab/bootstrap-rails)

[Bootstrap](http://twitter.github.com/bootstrap/) 是 Twitter 近期所推出的一個 CSS Framework opensource project，它能夠讓程式設計師，在做 project 的初期（設計師還沒把畫面設計好時），或者是在做小 project （不需要複雜 Style）時，很快的就把一些簡單的版面元素搞定，簡單大方。

但是在 Rails project 中 setup 還是小麻煩，因為你必須手動把 asset 搬到指定位址才行。

若是我跟你說，如果用這個 gem，你只要在 Gemfile 裡 require

``` ruby Gemfile
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails'
```
然後再到 application.css 中

```css application.css
//= require bootstrap
```

接著即刻就可以寫 HTML，Bootstrap 馬上就生效了呢？

另一個程式設計師最愛的 [web-app-theme](https://github.com/pilu/web-app-theme)，在 Rails 3.1 後的版本，也可以用同樣的方法，把 CSS 直接掛起來，馬上寫！

而不是像之前的作法，掛上 gem 之後，還得用 generator 把當時版本的 asset copy （算是半自動）到目錄資料夾裡！

夠**震撼**你的心靈了吧？

## 「萃取」 / 「打包」 / 「版本控制」core asset 的好處

在從前，若我們同時維護多個系列 project，都會有 asset 其實都長得差不多，但是會有只要一份發現要更新，其他份沒有同步更新，就會相當麻煩的痛處。但是作這些更新，都必須要手動去調整。而且 asset 的 version control log 會與專案程式的 version control log 混在一起。若沒有馬上一併處理更新，時日一久，當你要更新其他 project 時，就會忘記自己需要改哪裡。

使用 SCSS 並沒有改變: 「你還是要 copy 好幾份 SCSS 到多個 project 」的事實。

但是如果你的 core SCSS / core JavaScript plugin 是一份 Gem 呢？

** 維護的方式可以變成只需要維護 Gemfile 中的版本號，複雜度幾乎趨近於 0。**

``` ruby Gemfile
gem "some-css-plugin", "0.0.2"
gem "some-js-plugin", "0.5.7"
```

你不需要再對「一包」檔案作版本控制，而是對「一個數字」作版本控制。

### 使用 git submodule 不行嗎？

當然你也會問，使用 git submodule 管理 asset 不行嗎？ 這當然也是一種作法。但問題在於

* git submodule 不管修改、刪除、更新都要特殊的步驟，否則就會弄爛你的 project
* git submodule 是依 commit id
* git submodule 沒有處理 dependency 問題

而且當你想把 asset revert 到某一版本時，可能就會讓你的耐性爆炸 ….


## 小結

因為今天在練習寫 Generator 還有 Rails Engine。寫著寫著就有鬼點子，不知道 Rails 3.1 之後，Rails Engine 支不支援掛 asset。當然也沒有一股就栽下去，當然先去找找有沒人已經作過這件事，想想 Bootstrap 最近很紅，應該會變成大家練習的對象。沒想到真的就有人寫出來....而且還有一堆。

看了別人有實作出來，就隨便找了一套 CSS 當練習包 Gem 的對象，熟悉一下結構。沒想到門檻也沒有說很高。既然 CSS 成功了，就開始繼續亂想 JavaScript 可不可以惡搞，這一想，才意識到 Rails 範例的

``` javascript application.js

//= require jquery
//= require jquery_ujs

```

就是在講這件事啊 XDDDDDD。

為什麼我這麼豬頭，都沒想到過啊…繼續往下想，就 blow my mind 了。

因為既然這樣可以 work，那就表示以後只要是 asset，就可以打包。CSS framework 和 jQuery plugin 到處都是，那就表示將來一定會出現更多更變態的玩法。不禁讓人越來越期待接下來的發展了。

身為一個 Rails Developer 真是相當幸福快樂的事啊！


