---
layout: post
title: "Rails 3.2 新的 Route recognition 引擎 ： Jounery"
date: 2012-01-25 20:55
comments: true
categories: Rails
---

Rails 3.2 四天前 [Release](http://edgeguides.rubyonrails.org/3_2_release_notes.html) 了。這次主要的改進幾乎都在效能部分。

最大的改版應該屬於 Route recognition 這部分。原本這部分是由 [rack-mount](http://rubygems.org/gems/rack-mount) 擔綱，Aaron Patterson (a.k.a. [@tenderlove](http://twitter.com/tenderlove)) 將之抽換成他自己寫的 Gem : [jounery](https://github.com/rails/journey)。速度快了非常多倍。


但相關的原理並沒有 [jounery](https://github.com/rails/journey) 的 About 頁面並沒有被詳加敘述，

> SYNOPSIS: Too complex right now. :(

不過根據有限的線索，我還是從 @tenderlove 的 slideshare 上挖出來了。

jounery 的原理是用 FSM ( [Fininte State Machine](http://en.wikipedia.org/wiki/Finite-state_machine) ) 實做的。有興趣的可以從投影片裡面繼續挖。

<div style="width:425px" id="__ss_10090654"> <strong style="display:block;margin:12px 0 4px"><a href="http://www.slideshare.net/tenderlove/rubyconf-argentina-2011" title="RubyConf Argentina 2011" target="_blank">RubyConf Argentina 2011</a></strong> <iframe src="http://www.slideshare.net/slideshow/embed_code/10090654" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> <div style="padding:5px 0 12px"> View more <a href="http://www.slideshare.net/" target="_blank">presentations</a> from <a href="http://www.slideshare.net/tenderlove" target="_blank">Aaron Patterson</a> </div> </div>


### 其他豆知識：

ActiveRecord 背後的 SQL 生成引擎 [Arel](https://github.com/rails/arel) 背後原理是用 [Relational Algerbra](http://en.wikipedia.org/wiki/Relational_algebra) 生成的，可以生成非常複雜的 SQL Query 但又兼顧到效能問題。

