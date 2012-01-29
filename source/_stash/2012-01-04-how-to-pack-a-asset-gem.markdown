---
layout: post
title: "[Ruby][教學] 如何打包一個 Asset Gem "
date: 2012-01-04 09:10
comments: true
categories: 
---

## What is Asset Gem

[Asset Pipeline](http://upgrade2rails31.heroku.com/asset-pipeline/)的概念興起，不只是推動了 SASS 與 CoffeeScript 的廣泛流行。其實造成更重大的影響是 assets ( CSS / JavaScript / Images ) 不再被視為專案中難以「整理」與「管理」的頭痛元件。透過 Asset Pipeline 的架構，我們可以把 assets 包裝成一個 gem ，在其他專案中重複使用。

在以往，如果想使用 [bootstrap](http://twitter.github.com/bootstrap/) 這個 CSS / JS Framework，我們必須將所有靜態檔案 COPY 一份到專案的靜態目錄中。當專案使用到大量 3rd party vendor assets，整個靜態目錄就會被這種拷貝行為弄得髒亂不堪，難以整理。

而透過 Asset Pipeline 的架構，開發者就可以停止這種草率但不得不為之的動作。要引用 3rd party vendor assets，只要在 application.css 或者 application.js 進行 require 就可以輕鬆使用了。


```
//= require jquery
//= require bootstrap

``` 

引用 asset gem 很簡單，但不少人想知道的是：`如何把手上想整理的 asset 包裝成一個 gem 進行使用`。


## Asset Pipeline 的 mount 位置

談到這裡，就要稍微提一下 Asset Pipeline 對於 assets 位置的定義。by default，你可以把 assets 放在以下三個資料夾內：

* app/assets
* lib/assets
* vendor/assets

理論上，你把 assets 丟在這三個資料夾內，在 application.cs|js 內 require 都可以動。

### 如何整理目前專案中的 assets

這其實是另外一個主題，不過我在這裡也順便整理出來。


如何整理歸類現在手頭上的 assets 呢？

* app/assets

在 Rails 3.1.x 之後的版本，rails g controler posts，會自動在 assets/styelsheets/ 和 assets/javascripts/ 中產生對應的 scss 與 coffeescript 檔案。

所以 app/assets 是讓開發者放「自己為專案手寫的 assets」的地方。

* lib/assets

lib 是 library 的簡寫，這裡是放 LIBRARY 的地方。所以如果你為專案手寫的 assets 漸漸形成了 library 規模，比如說 mixin 或者是自己為專案整理了簡單的 bootstrap，應該放在 lib/ 下。

* vendor/assets

verdor 是「供應商」的意思，也就是 「別人寫的」assets 都應該放在這裡。比如說:

* jquery.*.js 
* fanfanfan icons
* tinymce / ckeditor

等等…

## 透過 Rails Engine 機制實作

為什麼剛剛要扯這麼大一圈去解釋如何整理手頭的 assets 呢？

因為 asset gem 其實就是透過 Rails Engine 的機制去實作出來的。

拿一個前幾個月幫 [@evenwu](http://twitter.com/evenwu) 寫的 asset gem 作為示範好了。

<https://github.com/xdite/compass-ggs-framework/tree/rails-engine>

作法是將你整理好的 lib/assets 扔到 vendor/assets 裡(你寫的給別人用，你就變成 vendor 了)，再宣告一個「空的」Rails Engine Class 讓 Rails 可以將這個 gem 視為網站的一部分「掛起來」裡面的 vendor/assets。

沒錯，就是這麼簡單。

而宣告自己是一個 Rails Engine 的方式也很簡單：只要把 Rails Engine 塞進自定義的 module 就好了。
（還是看不懂的可以看我的 code…）


``` ruby
module Ggs
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end
```

剩下來的流程就跟[一般包 Gem 的流程](http://blog.xdite.net/posts/2012/01/04/how-to-pack-a-gem/)差不多了。

=====

現在我每週都固定有在回答一些問題，發現不少朋友對 Ruby / Rails 的一些疑惑，都大同小異。這些問題有一些我有寫過文件但沒有公開披露，有一些沒有寫過文件但有答案。所以順手把這些回答過的答案整理到 blog 上讓大家參考。

如果你在 Ruby / Rails 在使用有任何問題，都歡迎貼到 <http://ruby-taiwan.org>。