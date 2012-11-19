---
layout: post
title: "RubyConf China 2012 演講：最佳實踐如何變成了最慢實踐"
date: 2012-11-20 03:24
comments: true
categories: 
---

<script async class="speakerdeck-embed" data-id="60e4fb4013c5013077d112313d1a82a3" data-ratio="1.2994923857868" src="//speakerdeck.com/assets/embed.js"></script>

這是我今年參加 [RubyConf China 2012] 所給的演講。

不過這個投影片裡面的不少內容，是在現場直接解說掉的，所以只看投影片的話，可能不會知道這樣的設計慢在哪裡。這陣子比較忙，如果有空的話，過一陣子我再寫一個全文版的。

這個演講的主旨是，在以往，我們設計 Rails Application 時，為了想要寫出一些漂亮的架構，會參考一些 Best Practices，或者是參照官方 Rails 官方指南的 Convention 建議，進行設計。

但是這一些 Convention 或依照直覺的軟體設計，很大的成分其實會造成你的 Application Performance 下降。這些問題即使你裝了 New Relic 還是絕對抓不出來。而這些設計可能也不太能算是 Rails 或者是相關套件的錯，甚至是 nobody's fault。這個 talk 會帶你找出這些問題，解釋原因，並且給出修正方案。

