---
layout: post
title: "Bootstrappers 一鍵產生 Rails App with Bootstrap theme"
date: 2012-10-12 00:17
comments: true
categories: 
---

<img src="http://farm9.staticflickr.com/8045/8077515365_44bccfc5c5.jpg" width="500" height="334" alt="Bootstrappers Demo">

這是我本週剛釋出的一個 Gem: [Bootstrappers](http://github.com/xdite/bootstrappers)。是一個 Rails 專案產生器，特色是內建馬上套好的 [Bootstrap](http://twitter.github.com/bootstrap/) theme 和 其他好東西。



## Bootstrappers 的開發緣由

身為一個職業開發者，我開啟一個新專案的機會實在太高了。但是，你知道的。每次要開發一個專案，無非就是 `rails new project_name`。然後打開 Gemfile，添加一些常用 Gem，再修改 `application.html.erb`，塞塞設定，填填 CSS，修修 HTML。

[Bootstrap](http://twitter.github.com/bootstrap/) 以及其他 rubygems 是很方便，但是把他們組起來還是非常花時間。次數多了，我就覺得這樣的初始化動作實在很煩。

於是，我第一次的嘗試，就是作一個空專案，把我平常的 best practices 和 templates 都丟進去。如果有開新專案的需求，再 copy 過去。

但是，隨著時間更迭，我又發現更煩的事了。就是我還是得花上一堆時間改 namespace 與 setting。而且，裡面內建的 rubygems 會過期，等於還要花時間 ugprade 這些 template。而最煩的還是：Rails 本身自己也會過期！而要升級的小版本，自己可能還要補一堆 config，而這些變動真的很難追蹤。


於是，最後我下定決心要來研究 App Generator 到底要怎麼寫。我實在受夠了每次的 c/p + modify 了。

（之後我也許會寫一篇如何製作 App 產生器的文章 ）

最後 [Bootstrappers](http://github.com/xdite/bootstrappers) 就這樣誕生了。

### 內建好康


這個專案裡面目前內建了以下這些 Gem 以及相關 Template :

* [Bootstrap SCSS](https://github.com/anjlab/bootstrap-rails)
* [Bootstrap Helper](https://github.com/xdite/bootstrap-helper)
* [SimpleForm](https://github.com/plataformatec/simple_form)
* [WillPaginate](https://github.com/mislav/will_paginate/)
* [Compass](http://compass-style.org/)
* [SeoHelper](https://github.com/techbang/seo_helper)
* [Capistrano](https://github.com/capistrano/capistrano)
* [Cape](https://github.com/njonsson/cape)
* [Magic encoding](https://github.com/m-ryan/magic_encoding)
* [Settingslogic](https://github.com/binarylogic/settingslogic)
* [Airbrake](https://github.com/airbrake/airbrake)
* [NewRelic RPM](https://github.com/newrelic/rpm)
* [Turbo Sprockets for Rails 3.2.x](https://github.com/ndbroadbent/turbo-sprockets-rails3) Speeds up your Rails 3 rake assets:precompile by only recompiling changed assets

### Powerful Features

特點如下

* 現成套好的 Bootstrap Theme (application.html.erb)
* 搭配的 Bootstrap Helper，快速兜出表單、選單、按鈕、Dropmenu、ajax modal、alert、breadcrumb 等等…
* 套好的 WillPaginate (with bootstrap style)
* 套好的 SimpleForm (with bootstrap style)
* 內建 Devise 會員系統
* Bootstrap useful hacks (比如 `body { padding-top:60px }`、dropmenu 自動展開等等)
* [Boostrap override best-practices](http://blog.xdite.net/posts/2012/08/03/how-to-use-bootstrap-in-clean-way/)
* MagicEncoding : Ruby 1.9 自動添加 utf-8 宣告
* 自動掛上 Compass
* SeoHelper : 自動幫你的網站產生 page description / page keywords
* Open Graph : 自動幫你的網站產生 og description / og_image
* Facebook JS、Google Analytics
* Capistrano / Cape
* Asset Pipeline 加速器
* ….etc.


一些我平常開發專案時，累積出來的 best practices。

有了這個武器，你現在可以使用 `bootstrappers project_name` 這個指令，一鍵瞬間就產生出一個不錯的 app，而不用擔心套版問題以及一些基本的網站優化問題。

歡迎 [現在就試看看](http://github.com/xdite/bootstrappers) ！

## Bug / Pull Request

<https://github.com/xdite/bootstrappers/issues>

歡迎各位回報錯誤，或者提交 Pull Request。當然，如果能夠直接提交 Pull Request，是最感謝的。

我還會繼續把一些還沒丟進去的 best practices 繼續整合進去。如果各位有興趣幫忙的話，歡迎查看 TODO.md。

<https://github.com/xdite/bootstrappers/blob/master/TODO.md>