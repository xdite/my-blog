---
layout: post
title: "網站程式上線前需要準備的事 （四）"
date: 2012-03-18 16:12
comments: true
categories: 
---

## 第 4 件事：架設一套 issue tracking system

你用什麼工具來管理軟體專案的進度呢？我曾經一度認為使用 issue tracking 管理專案進度，是一件天經地義的事。大家都是這麼做的，所以這個題目沒什麼好談的。
後來，我才發現這個印象大錯特錯...

** 絕大多數的人真的只用「mail」和「cc」來管專案，that's all。(註1) **

P.S. issue 真的太多的話，他們會改用 ...`Excel`！！

ZOMG...

### What is issue tracking system ?

Issue Tracking system ，顧名思義就是`紀錄`、`追蹤` 問題的系統。[BugZilla](http://www.bugzilla.org/)、[Trac](trac.edgewall.org)、[Redmine](http://www.redmine.org/)、[JIRA](http://www.atlassian.com/software/jira/overview)、[lighthoustapp](http://lighthouseapp.com/)、[Basecamp](http://basecamp.com/) ...等等這幾套軟體，都是知名的 Issue Tracking system。

一套合格的 Issue Tracking system 的 Issue 至少要可以紀錄這些內容：

* Issue 的主題
* Issue 的內容
* Issue 現在的狀態 (新建立、已指派、已解決、已回應、已結束、已擱置...etc)
* Issue 優先權 (正常、重要、緊急、輕微、會擋路...etc.)
* Issue 發生日期
* Issue 希望解決日期
* Issue 實際解決日期
* Issue 被分派給誰
* Issue 的附件
* Isuue 的觀察者有誰

### 為什麼 email 不管用？

常人使用的 email 管理法其實會有幾個很大的缺點：

#### 喪失時間感、無確切完成日期

專案中最珍貴的資源無非是「時間」。僅使用 email 往來，會造成一個嚴重的假象：大家都一直有信件往來，所以整件事其實是有進度的。但其實，專案進行的速度卻是牛步...

後面的原因其實是因為：「回信」是一個「順序」執行動作，當一方回了，下一方才能決定要做什麼、要回什麼。「什麼時候」再回（有空回，做完回？）其實沒有人知道。通常一個來回就要搞掉一個上午，甚至是一個整天。但其實整件事沒什麼進展。

這麼浪費效率，逼得某些 PM 還得自己用 TODO list + email tracking label 才可以勉強控制這種局面。

####  無確切執行人

有的 email，cc 者一大堆：A 先指派了 B 作這個工作，但 B 做到一半覺得需要 C 的火力支援，於是把 C 加入這個討論串裡面。C 做到一半覺得不妥，請示長官 D 要如何配合這個專案。往往一整個 mail 牽扯了一大堆人進去，大家討論來討論去，好不熱烈。

但是呢...誰需要去執行，哪些事需要被執行，什麼時候這些事需要被執行完畢？在這一整個串裡面完全被模糊掉了。

#### 洩密

cc 者一大堆。怎麼分得清楚誰有權知道、誰無權知道這一串信裡面提到的執行事項？

#### 優先權的分配

一個專案可能同時間有幾十上百條待處理事項需要被執行。請問哪一條需要先被執行？它們的優先權又是用什麼標準決定的呢？

#### 處理事項目前的執行狀態

一個較具規模的專案，可能不只一個人參與（多個 RD 和多個美術）。到底誰正在執行什麼項目，會不會相撞（項目、執行者）？什麼項目其實已經完工了，需要被 archieve 起來？資訊有沒有 outdate 問題？

Email + Excel 其實很不夠用...

### What you need : Project Management Tool

其實由這一連串的問題整理下來，可以清楚的發現，一個專案需要的是什麼？這也是 Project Management Tool 可以提供給你的東西。

與其說 [Redmine](http://www.redmine.org/)、[JIRA](http://www.atlassian.com/software/jira/overview)、[Basecamp](http://basecamp.com/) 是 Issue Tracking System，更精確的來說，它們應該被稱為「專案管理工具」。

要能夠的讓專案項目有計畫且順利的被執行，需要：

* 一個地方可以透明的列出所有需要被執行的項目 (Issue List)
* 一個地方可以列出階段內需要被執行的項目 ( Issue Milestone )
* 一個可以記載 內容，狀態、優先權、日期、分派者、觀察者，且具有「permalink」、「權限控管」，且讓大家可以討論執行項目細節的地方。(Issue Ticket)
* 可以 cross reference 或具有子票功能
* 一個地方可以整理統合專案現在所有的相關資訊。( Wiki 功能)
* 一個地方可以看到自己今天需要 Focus 進行哪些項目（Issue Personal Dashboard)
* 一個地方能讓 Manager 可以看到自己的 Employee 正在進行哪些項目，這些項目目前的狀態是什麼。（Issue Query)

至於我個人一直以來偏好的系統，就是 [Redmine](http://www.redmine.org/)。尤其是近一兩年的版本，Issue Query 的加強和 子票 / 相關票的功能被開發出來， 讓我在專案管理上更加的得心應手(註2)。

#### 簡單歸納

專案往往會搞到失火，或是時間不夠用。問題往往出在整個專案之間的「不透明」。

* 搞不清楚總共有多少事需要完成
* 搞不清楚目前這件事的進行狀態
* 搞不清楚今天要進行哪些事
* 搞不清楚現在正在做的事，是否跟「目前」的全局有強大的正關聯
* 搞不清楚哪些事必須在何時就需要「確切」的被完成，否則就會產生重大風險

要讓專案順利上線，一套好的 issue tracking system 是不能少的啊。


* 註 1: 我一直以為裝個 issue tracking system 是常識。為什麼會寫這種「常識」等級的東西？因為我後來發現這完全不是「常識」，特別對 「PM」 來說不是「常識」（顛覆了我的認知...orz）！之前在某社服務時，就發現他們竟然沒有這種東西，提議要部門內架設還被當作是異類。接著所有高階主管討論了超過一個月才勉強決定要裝 issue tracking。接著又花了兩個月的時間討論要裝哪一套 issue tracking，再花了一個月才把決定好的 issue tracking 架起來。真是嘆為觀止！...實在受不了種種的低效率，最後早早 say bye。


* 註 2: 切票示範 (已取得授權)
  - Nested Ticket Sample : <http://www.flickr.com/photos/xdite/6469521821/sizes/o/in/photostream/>
  - Milestone Sample: <http://www.flickr.com/photos/xdite/6469526205/sizes/o/in/photostream/>
