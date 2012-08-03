---
layout: post
title: "Stickies Gem"
date: 2011-10-19 14:38
comments: true
categories: Rubygem
---

stickies 這個 plugin 是我在開發中常用的一個 plugin。用來實作注意/警告訊息的。

{%img http://farm7.static.flickr.com/6114/6259519683_ae8e1d15b6.jpg %}

stickies 是一個非常古早的 plugin，在 2008 年前左右就問世了，當時的特效還是使用 rjs 。後來 [ihower](http://ihower.tw) 在 [和多](http://handlino.com) 時把這個 plugin 翻成 jQuery 版本。

這套 plugin 我自己還蠻喜歡用的。T 客邦內部也用了很多，不過因為內部有 Gem （認證系統）預設訊息就綁 stickies，每次開新專案裝完認證，就要手動 copy plugin 到 vendor/ 和手動 copy assets 到 public/，有夠麻煩...

今天進公司大概跟同事聊了一下昨天寫的用 [Asset Pipeline 掛 Asset](http://blog.xdite.net/posts/2011/10/18/asset-pipeline-version-control-assets/) 的概念。

[vincent](http://twitter.com/v1nc3ntlaw) 就覺得 stickies 應該要首先被拔出去，每次 copy asset 實在太麻煩了，將來最好還可以放在認證系統的 Gemfile dependency 上。於是剛剛我就接下來作了。

本來以為只是掛 asset 而已，小事一樁。不巧的我發現它還是 Rails 2.x 時代的 Rails Plugin。於是剛剛索性將架構作了一番重構。

（重寫 generator，用 Railtie / Engine 作 gem )

目前 stickies 已經被我包裝成 rubygems，並支援 Rails 3.0 / 3.1。
而且 3.1 版本可以直接用 asset pipeline 掛 assets。不需要再跑 copy tasks )

code 放在這裡：<https://github.com/techbang/stickies>
