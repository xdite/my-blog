---
layout: post
title: "Yahoo News 的 SEO 網址所帶來的問題"
date: 2011-10-25 17:08
comments: true
categories: 
---

我不知道設計這個 feature 的是哪位。只是簡單講一下我覺得這個 feature **畫虎不成反類犬**了。

在為網站實作 SEO 改善工程時，我們通常會使用一個技巧：**在 permalink 裡面塞關鍵字**。

這樣的設計你可以在 [T 客邦](htt://www.techbang.com.tw) 看到，也可以在 [PIXNET](http://www.pixnet.net) 看到。

* T 客邦的設計是 /1234-seo-in-url
* PIXNET 的設計是 /5678-SEO藏在網址裡

中文是否適合塞在網址裡面，還是個見仁見智的問題，畢竟每一家處理 URL ENCODE 的方法不一樣。但

但 Yahoo 的網址是這樣的： /SEO藏在網址裡-7890.html。

看的出設計者應該覺得這是個 **獨樹一格** **別出心裁** 的設計。因為全世界幾乎沒有人這樣幹啊 =_=|||

<a href="http://www.flickr.com/photos/xdite/6279632106/" title="螢幕快照 2011-10-25 下午5.25.23 by xdite, on Flickr"><img src="http://farm7.static.flickr.com/6215/6279632106_86d70297c7.jpg" width="324" height="130" alt="螢幕快照 2011-10-25 下午5.25.23"></a>

<a href="http://www.flickr.com/photos/xdite/6279633244/" title="螢幕快照 2011-10-25 下午5.26.29 by xdite, on Flickr"><img src="http://farm7.static.flickr.com/6054/6279633244_4951092121_z.jpg" width="530" height="71" alt="螢幕快照 2011-10-25 下午5.26.29"></a>

這樣你應該看出問題了吧。

各家縮網址和 auto-link 的 library 不認得中文字。因此 

* /1234-seo-in-url => 不會有問題
* /5678-SEO藏在網址裡 => 會被 parse 成 /5678 ，但因為是動態網頁，所以還是沒問題

* /SEO藏在網址裡-7890.html => 被 parse 成 / ，就算輸入 /7890.html 還是連不到。

「將中文放在 URL 裡且是在數字之前」的設計，會造成在某些網站社群穿透力為 0，因為貼的連結會被自動 parse 成為根本不能動的連結。

不知道為什麼這個問題沒被測到，這應該在 beta 測試就要被檢驗出來了...

