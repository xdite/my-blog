---
layout: post
title: "OmniAuth - 實作多方認證的最佳實踐 (1)"
date: 2011-11-19 02:16
comments: true
categories: 

---

這幾天在寫一個小玩具，因為要用到 Github 認證，於是採取了 [OmniAuth](https://github.com/intridea/omniauth)  + [Devise](https://github.com/plataformatec/devise) 這組作法。因為適逢 OmniAuth 在十月底一舉從 v0.3 大改版，直衝到 v1.0。版號大躍進，整個架構與 API 也幾乎全都不一樣了，網路上的教學幾乎等於作廢，加上 Github 原本實作的 OAuth 2.0 本來就不太標準，吃了幾個小時苦頭，終於才把認證搞定。不過也拜這一晚的折騰，讓我把 OmniAuth 架構摸個更加透徹。

## 多方認證的需求

現在作網站，使用者的要求比以往的高。在過往，幾乎都是站方的姿態較高，使用者要試用一個網站前，無不是必須填一堆資料，勾完一堆囉哩八縮的選項，才能加入這個網站。

但隨著時代的改變，Facebook Connect 的普及，現在網路生態卻跟以前完全相反，如果你的網站不提供傳統帳號密碼以外的方案（諸如 Facebook Connect、Google ID …etc.）使用者二話不說，絕對馬上就閃人。反正網站那麼多，不差哪一個…

於是提供傳統帳號密碼以外的註冊方案，對一個新創網站就顯得格外重要。

## 實作上的困難

話雖如此，但是實作上是真的有很大的困難的。就拿 Rails 生態圈好了，[傳統帳號密碼方案](https://www.ruby-toolbox.com/categories/rails_authentication) 有非常多套：Devise、Authlogic、Restful-authenication 等等。而實作第三方認證的功能也是相當多元的，你可以拿 Facebook API 的 gem 或者是 Google OAuth 的 gem 直接硬幹整合這些方案，也是做的出來。

理想的境界應該是一個網站最好只要提供一個 3rd Party 的認證，而且認證 Library 與 API 存取機制，不能要有太大的變化。

但這真的只是理想而已，現實上你會遇到三類大挑戰：

### 1. PM 亂開規格

PM 不會管你死活，硬是要你同時既提供 Facebook / OpenID / Yahoo Auth / Google OpenID。天知道這些網站認證和存取 API 的規格完全都不一樣。

硬是把這些方案一起塞到一個 controller 和同一個 model，瞬間就會無法維護。不…很可能是 code 亂到讓自己狂跌倒，直接作不出來

### 2. OAuth 版本規格間的問題

理想的境界應該是大家都走 [OAuth](http://zh.wikipedia.org/wiki/OAuth) 就能夠解決問題，但是 OAuth 1.0 推出時，鬧了一個大笑話：被發現有 security issue。於是 OAuth 推出了 1.0a 的修補方案，但這又衍生出另外一個問題：每一家解決 security issue 機制完全不一樣。

因為 service provider 的機制完全不一樣，就造成了已經上路使用 OAuth 的網站大囧。因為 1.0a 那步要變成客製。其實大家做的調整都差不多，但當時有一家是來亂的：Yahoo ….

因為 Yahoo 實在太特例，還造成當時 OAuth 這個 rubygem 的作者，拒絕支援 Yahoo（因為要做的修改不只是「小」修改而已）。

這件事實在是太囧了，於是 OAuth 在不久後，又提供了一個解決方案：直接提出 OAuth 2.0! 

鬧劇到這裡就結束了嗎？

沒有。

因為 OAuth 2.0 不相容 1.0a 及 1.0 …

好吧，那算了，大家還是繼續裝死使用 1.0x …

還沒有結束喔！

原本完全不鳥 OAuth 的 Facebook 這時候宣布即將放棄自己的 Facebook Connect 架構，宣布未來直接擁抱 OAuth 2.0。

崩潰。一個專案上跑 n 種 OAuth library 是什麼鬼....

[** 如果你是沒什麼信念的 Web Developer，看到這裡我建議你可以轉行 **]

### 3. 大網站本身直接的 API 改版以及認證機制的改變

一個網站只要還沒倒，就不可能一直停滯不前。更尤有甚者如 Facebook，它的 API 更是三天一小改，五天一大改。而 FB 的 認證架構 和 API 一改，相對的 library wrapper 就一定會跟著改。

這就苦到那一些直接使用 library 接認證的開發者。

而 FB 改版就已經夠令人苦惱，其他網站不可能也像一攤死水，Google 也改很大....。從之前只是 
OpenID + API 存取，改成直接走 OAuth ...

你也許會問，為何要使用 library 直接接認證呢？那是不用獨立 library 接認證有時候也不太行得通，因為每一家提供使用者資訊的「方式」和「資料格式」幾乎不一樣。有時候還要分好幾步才能拿到令人滿意的結果

## 理想的解決方案

當 Web Developer 實在太苦了，賣雞排真的比較輕鬆 :/

理想中 Developer 們需要的解決方案應該是這樣的：

1. 開發者不需管最底層的傳統認證方案是哪一套 solution，甚至是不只局限於 Rails 這個框架
2. 開發者不需管提供認證方使用的是哪一套協定
3. 開發者拿到的使用者資料格式應該是接近一致的

這套方案存在嗎？

存在，它就是 [OmniAuth](https://github.com/intridea/omniauth) 。

## 小結

前言歷史寫太長了，決定拆成幾篇寫完。下集待續。

