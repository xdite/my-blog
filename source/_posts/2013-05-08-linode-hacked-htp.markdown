---
layout: post
title: "Linode 被 Hack 事件始末"
date: 2013-05-08 00:49
comments: true
categories: 
---

TL; DR 版本：Linode 是躺著中槍的路人


上個月，Linode 被打下來，洩漏了一堆資訊。逼得很多人不得不換卡和換密碼。幾個小時前，在 HackerNews 的一篇文章揭露 Linode 其實是路邊的那個倒楣鬼，人家不是要揍他，而是揍他的客戶...

以下內容是基於 [HN 上的一篇懶人包](https://news.ycombinator.com/item?id=5667027)翻譯，然後加上[HTP 雜誌原文](http://straylig.ht/zines/HTP5/0x02_Linode.txt)裡的資訊。

故事是這樣的：

有個駭客組織叫 HTP，最近有個匿名組織假冒成另一個組織 "ac1db1tch3z" 想要挖他們的底（去挖 HTP 的 botnet）。HTP 非常不爽想要報復，後來他們查到這個匿名組織在用 SwiftIRC 這個 IRC 服務在聯絡。而 SwiftIRC 的 nameserver 放在 Linode..。

所以 HTP 想要把 Linode 打下來，hack 進 SwitftIRC 放後門，然後報復回去。

他們一開始直接打 Linode，結果 1day exploit 被 Linode 防下來了。但是，Linode 的域名註冊商 name.com 被打下來了。所以他們的計畫改成弄一個 transparent proxy，打算從中間攔下 Linode 的帳號密碼...。 

=== 題外話 ===

不只 name.com 被打下來了。 Xinnet, MelbourneIT, and Moniker 也被打下來了。在去年 11 月，他們從 Symantec 放了一隻 Huawei 後門，Symantec 的註冊商？就是 Xinnet…

這一波總共有 550 萬的 domain 被打下來..no kidding

=== 題外話結束 ===

本來計畫是這樣的，但是他們發現了一個更棒的洞，直接打下了 Linode ...

這當然很 high 啦。他們當然直接拿下 SwiftIRC 開始種後門。更精彩的是，因為不少站台也放在 Linode，中獎的名單還有： Nmap, Nagios, SQLite, OSTicket,      
Phusion Passenger (modrails), Mono Project, Prey Project, Pastie, Sucuri, Hak5, Pwnie Express, Puppet, and oauth. 

（都是一些超重要的站...）

但是，HTP 不知道的是，HTP 內部被 FBI 滲透了..因為 nmap.org 是個非常重要的站台（security scanner）。於是 Linode 很快就被 FBI 警告了 nmap.org 被打下來了。

於是，Linode 上其他站被 HTP 打下來的事，很快的也被知道了。這讓 HTP 的報復計畫來不及實現...於是 HTP 決定警告 Linode 至少在 5/1 不准講出去，否則 HTP 就會散佈這些他們拿到的這些敏感資訊（包括客戶資料以及信用卡資料）。如果 Linode 安靜的話，HTP 就會遵守約定刪掉拿到的這些東西。

=== 題外話 ===

敏感資訊包括 : 159000 + 信用卡資料，使用這名稱, $5 (我不知道是多少數量) 筆加密過的密碼，LiSH 使用者名稱，LiSH 密碼 「明碼版」 。還有 Linode 雇員 Login 帳號。

=== 題外話結束 ===

因為 HTP 打 Linode 本來就不是為了拿這些資料，而是想要打仇家。所以他們認為開給 Linode 的 Offer 已經算不錯了。如果他們不聲張，基本上就等於什麼事都沒發生。

但是！！Linode 還是公開了被打下的這件事（因為他們也被 FBI 逼著要公開，FBI 很明顯的不信任 HTP 會守約）。HTP 知道 Linode 其實被逼到一個很難自處的位置，於是也跟 Linode 達成了另一個協議，只要 Linode 在公告上說，經過分析之後發現打下他們的是 HTP。HTP 就會同意刪除當初拿到的這些資料....（很多 Hacker 其實只是想留名）

HTP 被這樣偷搞很不爽，於是他們就在查到底誰是 FBI 的內鬼。最近終於找到了，他們打進了這個內鬼的電腦，並且打開了 webcam。正好清楚拍到了 FBI 正在對某個 HTP 成員背後下指導棋，然後這個人就被踢出了組織...

這是到目前的故事。不過這是 HTP 單方面的故事，信不信就隨你了…

