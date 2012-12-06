---
layout: post
title: "如何閱讀 Rails 源代碼"
date: 2012-11-20 21:21
comments: true
categories: 
---

開始有計畫整理一些在 RubyConf China 大家線下問我的問題的答案。目前挑選的第一篇就是大會期間詢問度最高的「如何閱讀 Rails 源代碼」。

相信大家都有一個共識，要設計出好的 Plugin (Gem)，多讀 Rails sourcode 是沒有錯的。但是，如今 Ruby on Rails 的 source code 已經成長大到成幾萬行的怪獸，一口氣跳進去無非是直接跌入深不見底的池子，直接溺水。

是不是有沒有什麼建議指南，可以讓一個開發者快速抓到方向，開始讀通的呢？

### 1. 從單純的部分切入，例如 Helper

Rails 裡面的很多元件其實彼此互相呼叫來呼叫去。比較單純自成一個系統，而且結構相對單純的，是 Helper。一般如果想要直接先找「看得懂」的 Rails code，我會建議從 Helper 開始。

### 2. 從 request 開始，到 rack，到 routing，到 controller，最後再到 model

我真正開始有系統的讀懂 Rails code，是從一門線上「Owning Rails」開始的。這門課的宗旨是，教你有效掌握搞懂 Rails。相當有趣的是，他並不是教你讀任何 Rails 代碼，而是實際一步步帶你造出一個「mini Rails」。而造完這個 「mini Rails」之後，你也神奇的能夠開始自己讀會

