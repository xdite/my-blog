---
layout: post
title: "如何閱讀 Rails 原始碼"
date: 2012-11-25 00:28
comments: true
categories: 
---

開始有計畫整理一些在 [RubyConf China](http://rubyconfchina.org) 大家線下問我的問題的答案。

挑選出來暫定的第一篇是大會期間詢問度最高的：「如何閱讀 Rails 原始碼」。

想要「閱讀 Rails 原始碼」的原因很多，不過多半的出發點都是想要能夠設計出更好的 Plugin (Gem)、或者是希望能在程式碼出錯時，能夠更快在 Rails 原始碼快速找到答案。

但擺在眼前的事實是， Rails 的原始碼已經成長大到成幾萬行的怪獸，如何「看懂」或者是有效率的找到答案，已經變成是一個很大的難題。

以下是我根據這幾年的經驗，能夠給各位的建議：

## 1. 從單純的部分切入，例如 Helper

最令大家頭疼的地方是，這麼多程式碼，要從哪部分開始讀起。

如果你是初心者，想要跳進這個池子裡，想找點簡單的東西讀，我會建議你先從「Helper」的部分開始讀。「Helper」是整個 Rails 程式碼裡面最獨立的部分（不牽扯到 request 呼叫），而且結構相對單純。


## 2. 從 request 開始，到 rack，到 routing，到 controller，最後再到 model

我真正開始有系統的讀懂 Rails code，是從一門線上 [Owning Rails](http://owningrails.com)開始的。這門課的宗旨是，就是教你有效掌握搞懂 Rails 的核心與結構。相當有趣的是，他並不是教你讀任何 Rails 代碼，而是實際一步步帶你造出一個「mini Rails」。而造完這個 「mini Rails」之後，學員也能夠開始神奇的開始擁有快速找 code 的能力。

我在去年曾經寫過一篇 [Owning Rails masterclass](http://wp.xdite.net/?p=2407) 介紹過這個課程。

#### 第一天：造出自己的 mini Rails

帶你如何寫出精簡版 ActiveRecord、寫 rack app、用 rack app 改出精簡版 ActionController、自己 implement 出 before_, after_, around_ filter、自己 implement 出 view。然後最後再用你自己刻出來的這套 mini Rails 寫 web application。


#### 第二天的課程

Refactor 昨天寫的 mini Rails，教你如何 trace Rails core。利用 Rails internal API 客製化出你想要的特殊 function、library。作業有 custom validator、custom finder、create responder、create form builder、使用 Railtie 客制 Engine、造 plugin。


宥於這是付費課程的關係，我也無法公開提供你更進一步的教材內容。但是我能夠告訴你這們課程為什麼會這樣設計，讓你可以也依循著這個軌道去自我進修。


### rack

一個 request 進來，首先通過的是層層的 rack middleware。所以你要先理解什麼是 rack，rack 的運作原理是什麼。可以試著自己先寫一個 rack app 玩看看。

如果你想知道 Rails 裡面的 request 流程會經過哪些 middleware，被加過哪些工。可以在 Rails 專案裡面打 rake middleware，再去把 class 一個一個叫出來讀。

### routing

request 通過 rack 層進來後，首先面對的是 dispatch 問題，Rails 透過 routes.rb 進行 dispatch。而如何 dispatch 到正確的 controller，中間靠的就是 regexp。

### controller

開發者在 controller 會牽涉到兩個常用的相關機制：Filter 與 View Rendering。Filter 時怎麼運作的。method 應該是回傳「值」，怎麼做到自動回傳的是 render 出來的view。

### model

ActiveRecord 的上一層就是一套 ActiveModel API。其實 Rails 不一定要靠 ActiveRecord，也可以透過實作一個 Class 加上部分機制做出自己的 ORM。其中 validation, finder 都是這方面的課題。

## 3. 搞懂 Rails 的啟動流程

[RailsCast China](http://railscast-china.com) 曾經 release 過一個很好的影片：[The Rails Initialization Process By kenshin54](http://railscasts-china.com/episodes/the-rails-initialization-process-by-kenshin54)

講解了整個 Rails 啟動流程。你也可以讀由 Ruby on Rails 官方釋出的這篇[官方教學啟動流程](http://guides.rubyonrails.org/initialization.html)去更加了解啟動過程中究竟會經過哪些檔案，如果要寫 plugin 可以 hook 在哪一些部分。

## 4. 實際簡單寫一個 Rails Plugin

最好的學習方法就是動手實作。在看過以上這一些資料之後，我建議你可以實際透過開發一個 Gem 去更加了解整個 Rails 內部的結構。

目前 Rails Plugin 幾乎都是以 Engine Gem 的形式釋出。所以透過撰寫一個 Gem，可以了解到：

* 如何將自己的 Library 與現有 API 整合
* 如何將自己的 Library / 不掛進啟動 process 中。
* Engine 與 Railtie 的結構
* 如果有相依檔案，如何撰寫 generator，把檔案放進去 project 裡面。
* 如果有檔案操作和客製選項，如何透過 thor 這個工具去達到檔案修改的目的。

算是一個相當好的鍛鍊。

## 5. 讀別人（熱門）的 Rails Plugin

有時候，想要實作某一些功能不得其法。最好的方式就是去讀有類似功能的 Gem，去看看其他作者怎麼做的。有時候會翻到他們用了不少你根本不知道的 Rails API。

順著他們用這些 Rails API 的方法，可以更快的在 Rails 原始碼找到你要的答案…


## 小結

希望以上的方法能夠協助各位更快的上手讀通 Rails 的原始碼。有任何問題歡迎留言在底下討論。

