---
layout: post
title: "Migrate to Octopress"
date: 2011-10-07 18:19
comments: true
categories: 
---

[Wordpress](http://wordpress.org/) 用到今年，也第五年了。發現越來越不敷我的需求。

決定轉戰 [Octopress](http://octopress.org/)。

原本是打算 host 在 Github 上，這樣比較炫（？）

後來考慮到要支援舊 blog 上的文章。所以最後還是放在 [Heroku](http://heroku.com) 上，用 [rack-rewrite](https://github.com/jtrupiano/rack-rewrite) 對所有舊文章轉址。

舊文章會通通放在 <http://wp.xdite.net>。這邊的文章我就不繼續再更新了。feed 應該不受影響，本來就放在 feedburner 上。

至於迴響也會轉放在 disqus 上。

大概就這樣...

---

本來曾經考慮要連內容都轉過來，連中文亂碼都搞定了，不過排版要重弄就有點懶了。

再來是 compile 的速度，我在舊站寫了大概約 850 篇文章。轉過來每 compile 一次對我來說就是一次折磨。

算了 :Q

