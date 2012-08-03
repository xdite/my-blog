---
layout: post
title: "Responsive Web Design 的一些技巧和想法"
date: 2012-02-16 13:16
comments: true
categories: WebDesign
---

昨天在 [Happy Designer 5](http://registrano.com/events/hdm5) 上，有聊起了做 Responsive Web Design (特別是 mobile 版)的一些狀況。在這裡我提供一些自己的經驗和技巧：

1. Mobile First：如果你要做 Desktop / Mobile 雙版本的網站。先設計 Mobile 版的，而且要從最小的尺寸開始做。

2. 盡量讓 Mobile 的版本：大部分功能保持唯讀狀態。因為在 Mobile 上要將「輸入」這件事做得好，是很困難的，而且不少的寫入會牽涉到動線及頁面的跳轉，會大幅降低 user experience。雖然某些功能和元素幹掉很可惜，但要懂得「取捨」。

3. 不要過於迷信 Media Query: media query 只能解決 CSS 的問題。但是 mobile client 上需要解決的問題不只是這些：

   * 內圖的尺寸與傳輸速度：圖可能是用 Desktop version 的圖硬縮的。
   * 3rd party social plugin：3rd party social plugin 多半沒有考慮 mobile 版本的問題。所以在 mobile 版面上，幾乎都會有尺寸問題。而這些 social plugin 的 js 因為都是由放置在外國的原站提供，在 mobile 版上 loading 更加的緩慢。

   所以我會採取「偵測 agent 」與 media query 混合使用的招數進行開發。如果這個 agent 確定是手機，則直接移除掉 social 功能（直接從 server side 幹掉 DOM，而不是用 CSS 隱藏），並且吐尺寸較小的圖片。

4. 我個人還是認為 Responsive 的用途比較適合用在 Tablet 的 Portrait / Landscape 的用途上。畢竟 Responsive Web Design 的想法，是讓 Desktop / Mobile 擠在同一個版面上，用同一份 code。再 conditional override 或者 remove。在需要「持續維護」的產品上，容易搞死 Developer…

P.S. 如果你對 Responsive Web Design 好奇，可以用手機打開 [T 客邦](http://www.techbang.com.tw) 以及 [Digiphoto](http://digiphoto.techbang.com.tw) ，這個站都是用此技巧設計的…

＝＝＝

廣告：二月份 [xdite 家桌遊團](http://registrano.com/events/xdbg-1202) 又開放了，限八人，請儘速報名。
