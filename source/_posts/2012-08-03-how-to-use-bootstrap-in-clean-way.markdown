---
layout: post
title: "如何乾淨的 使用 / 修改 Bootstrap Fraemwork"
date: 2012-08-03 20:41
comments: true
categories: Bootstrap SCSS Rubygem
---

[Bootstrap](http://twitter.github.com/bootstrap/) 是 Twitter 推出的一套 CSS Framework。相當受歡迎的原因是因為讓原本對設計苦手的程式設計師在開發產品早期原型時可以有個可以看的門面先擋著。

又因為 Bootstrap 在 2.0 版以後加入了 configuable 以及 responsive 的設計。所以有些開發團隊，不僅只在 development 階段當臨時門面，在 production 階段，也作為骨架使用。

不過作為 production 使用，就出現了一個不容忽視的課題：如何在一套已經有現成的 styling 的 CSS Framework 上「客製發揮」。

「客製」往往意味著「大幅修改」。不過既然也要「乾淨」，這也表示一個附加條件：「不能破壞 bootstrap 原始架構」。

How can it be possible? 

以下是我平常使用 bootstrap 的方式：

### 利用 Bundler 掛上 Bootstrap 的 rubygems

Bootstrap 的原始版本是使用 LESS 撰寫，不過也有開發者修改成 SCSS 版本。我本身是使用 anjlab 的 [bootstrap-rails](https://github.com/anjlab/bootstrap-rails)。

透過 Gemfile 把 Bootstrap 掛上來，不直接放進 Rails project 裡面。

``` ruby Gemfile
gem "bootstra-rails"
```

### 利用 Asset Pipeline 以及 SCSS 機制，客製、覆寫

#### application.css 內容

``` css
//= require base
```

#### base.scss 內容

``` scss
@import "bootstrap-config";
@import "bootstrap";
@import "bootstrap-customized";
@import "responsive";
@import "responsive-customized"
```

#### 解說

* bootstrap-config.scss 是用來修改「Bootstrap 預設的變數」

``` scss
$navbarHeight: 50px;
$navbarBackgroundHighlight: white;
$navbarBackground: #F7F7F7;
$navbarSearchBackground: #EAECEF;
$navbarSearchBorder: #EAECEF;
$navbarSearchPlaceholderColor: #565E65;
```
* bootstrap 則是 Gemfile 裡面掛上的預設 bootstrap 包。（不修改）

* bootstrap-customized.scss 則是無法透過修改變數的效果，通通放這裡用 override 的方式覆蓋。

``` scss
.navbar {
  .navbar-inner {
    background: url(/assets/bg_header.png);
  }
}
```    

* responsive 是 bootstrap 用來作 responsive 的 css
* responsive-customized 是你想要針對 bootstrap 的 resposnive 版本做的客製。

### 小結

這樣你的 application 「理論上」就可以跟著 bootstrap 的小升級而升級，而不會被纏到這個纏那個...