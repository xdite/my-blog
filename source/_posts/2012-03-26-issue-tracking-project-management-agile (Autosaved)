---
layout: post
title: "為什麼必須使用 Issue Tracking System 管理專案？"
date: 2012-03-26 03:14
comments: true
categories: 
---
我在 [網站程式上線前需要準備的事 （四）](http://blog.xdite.net/posts/2012/03/18/website-online-todo-4/) 提到了為了順利進行專案，一個好的專案管理系統絕對是必備的。

專案管理系統背後運作的邏輯何在，就是這篇文章主要的重點。

## What is issue tracking (project management) system ?

Issue Tracking system ，顧名思義就是`紀錄`、`追蹤` 問題的系統。[BugZilla](http://www.bugzilla.org/)、[Trac](trac.edgewall.org)、[Redmine](http://www.redmine.org/)、[JIRA](http://www.atlassian.com/software/jira/overview)、[lighthoustapp](http://lighthouseapp.com/)、[Basecamp](http://basecamp.com/) ...等等這幾套軟體，都是知名的 Issue Tracking system。

一套合格的 Issue Tracking system 的 Issue 至少要可以紀錄這些內容：

* Issue 的主題
* Issue 的內容
* Issue 現在的狀態 (新建立、已指派、已解決、已回應、已結束、已擱置…etc)
* Issue 優先權 (正常、重要、緊急、輕微、會擋路…etc.)
* Issue 發生日期
* Issue 希望解決日期
* Issue 實際解決日期
* Issue 被分派給誰
* Issue 的附件
* Isuue 的觀察者有誰

### Project Management Tool

其中 [Redmine](http://www.redmine.org/)、[JIRA](http://www.atlassian.com/software/jira/overview)、[Basecamp](http://basecamp.com/)  並不僅止是 Issue Tracking System，更精確的來說，它們應該被稱為「專案管理工具」。

它們多半能夠提供以下作用：

* 一個地方可以透明的列出所有需要被執行的項目 (Issue List)
* 一個地方可以列出階段內需要被執行的項目 ( Issue Milestone )
* 一個可以記載 內容，狀態、優先權、日期、分派者、觀察者，且具有「permalink」、「權限控管」，且讓大家可以討論執行項目細節的地方。(Issue Ticket)
* 可以 cross reference 或具有子票功能
* 一個地方可以整理統合專案現在所有的相關資訊。( Wiki 功能)
* 一個地方可以看到自己今天需要 Focus 進行哪些項目（Issue Personal Dashboard)
* 一個地方能讓 Manager 可以看到自己的 Member 正在進行哪些項目，這些項目目前的狀態是什麼。（Issue Query)

## 背後運作的原理

[網站程式上線前需要準備的事 （四）](http://blog.xdite.net/posts/2012/03/18/website-online-todo-4/) 這篇文章刊出後，得到不少的迴響。其中我看到的絕大多數的回應多是多半抱怨 PM 根本不稱職不盡責，只顧著畫規格，然後只按照自己寫出來的無法執行ㄉ的天才（？）規格的催進度。所謂的 M 不是 Management，而是 Magic。即使成員賣了命的加班，專案還是得不到好的結果：超時，品質粗糙，成本
過高，scope 過大無法完成。

在我進行開發軟體專案時，也發現所謂的其實絕對多數的 PM，其實職稱與進行的事務完全不合。它們的工作內容往往只有 Project Planning，應該被稱作是 Planner，而不是 Project Manager。

一個軟體開發專案，最重要的變數有四：成本、品質、時間和規模。真正的 Project Management，是能夠準確 Manage 這四項變因，在可以接受的與變動差異下，完成整個專案，產出預期的成果。

### 規模管理

專案會無限膨脹，主要多半是因為規模的掌控不佳。而規模掌控不佳，時間和成本就會隨之膨脹。

規模之所以膨脹，有幾個原因：

* 沒有人知道，到底「總共」有多少事情需要完成。
* 離目前的時間表，「還有」多少事情需要完成，還有多少時間可以用。這些事情裡面有沒有可以被「調整縮減」的餘地。

所以，專案需要一個工具能提供以下功能：

* 一個地方可以透明的列出所有需要被執行的項目 (Issue List)
* 一個地方可以列出階段內需要被執行的項目 ( Issue Milestone )
* 一個可以記載 內容，狀態、分派者、執行者，且讓大家可以討論執行項目細節的地方。(Issue Ticket)

### 時間管理

一個專案中，最寶貴的資源是「時間」。什麼東西都可以用「錢」買到，唯獨時間不能。
在專案中時間最容易被浪費的地方在：

* 使用信件往來，交涉的互相等待時間。
* 沒有被壓定「完成日期」，「詳細需求品質」的工作細項。（陷入不必要的完美，或者是悠哉的怠惰）
* 不符合期待，修改的來回時間。（沒有達到良好溝通，導致方向錯誤）
* 類似的事情，重複消耗資源。（沒有 SOP，每次都要花費一定以上的資源去解決）

所以，專案需要一個工具能提供以下功能：

* 一個可以記載 內容，狀態、優先權、預計完成日期、分派者、執行者，且讓大家可以討論執行項目細節的地方。(Issue Ticket) 
  - 可以平行討論，而不是信件順序往來
  - 明確的完成時間
* 一個地方可以整理統合專案現在所有的相關資訊。( Wiki 功能)
  - 提供專案相關的資訊以及 SOP

同時，專案最好能夠搭配舉行每日的 Standup Meeting，確保每個人正在進行的方向是正確的，以及確保專案資源沒有被浪費的跡象。

### 團隊工作管理

一個專案，成員至少會有兩人以上。兩個人以上，就會有溝通與工作協調安排的問題。專案的工作項目往往是有 related 的，少有獨支。
比如說 Planner 沒有把規格寫完，RD 和 Art 就不太容易先動工。沒有把 Database schema 規劃好，後續就很難繼續開發程式。

這也是專案當中最傷資源的狀況：優先權等級為：「block」票。因為 A 方沒有交付，導致 B 方不能交付，連帶導致 C 不能開始。

而專案當中也有很多工作項目分別是「對最終專案目標很重要，但當下不重要」、「對當下 milestone 很重要，對最終目標沒那麼重要」，「只對合作同事很重要」...etc

如果工作項目不能夠按照當下狀況調整正確的優先等級分派給團隊成員。就很容易會造成所有的人雖然很努力，整體工作效益卻非常低的情形。

當然，不只是 Project Manager 知道全部的人今天要做什麼。而被分派到工作項目的工作，也需要能夠知道當天所需要執行的項目依序是哪些，按照優先狀況完成。如果優先狀況有錯誤，可以及早告知資源協調者 (Manager) 。

所以，專案需要一個工具能提供以下功能：

* 一個地方可以列出階段內需要被執行的項目 ( Issue Milestone )
* 一個可以記載 內容，狀態、優先權、日期、分派者、觀察者，且讓大家可以討論執行項目細節的地方。(Issue Ticket)
* 可以 cross reference 或具有子票功能
* 一個地方可以看到自己今天需要 Focus 進行哪些項目（Issue Personal Dashboard)
* 一個地方能讓 Manager 可以看到自己的 Member 正在進行哪些項目，這些項目目前的狀態是什麼。（Issue Query)

### 資源調配管理

Project Management，並不是在專案的一開始設下「完成時間」，切出所有「工作項目」，列出「完成目標」這麼簡單。隨著專案的進行，開始會有很多變因出現，造成資源不足，需求改變，規模追加，人力減少...等等的挑戰障礙出現。

都在考驗著專案經理對於資源調配的管理能力。能不能在預定的時間、預定的預算、預定的人力資源內，如期完成當初設立的目標以及交付達到品質要求的產品。

如果不能，當下必須作出取捨、做出決定，而非死板的捍衛規則與命令。

所以，專案需要一個工具能提供以下功能：

* 一個地方可以列出階段內需要被執行的項目，並可以移動改變階段項目。 ( Issue Milestone )
* 一個可以記載 內容，狀態、優先權、日期、分派者、觀察者，且讓大家可以討論執行項目細節的地方。(Issue Ticket)

## Agile Method

若讀者對於專案管理有興趣的話，研究過一些「敏捷開發」的 method，不管是 XP、Scrum、Kanban...，你會發現到這些工作方法都在傳達幾件類似的事：

* 專案必須透明，進行局勢一目了然
* 專案要能拆分成可執行的階段
* 溝通、溝通再溝通
* 不斷的消除浪費
* 不斷的 deliver 

而一個好的 Project Management Tool 能夠輔助專案具備以上的特徵。

## 小結

還是老話一句：真正的 Project Management，是要能夠準確管理，成本、品質、時間和規模這四項變因，在可以接受的與變動差異下，完成整個專案，產出預期的成果。

「Project Manager」必須要做到的事，也就是要在動態的環境下，利用種種手段盡力讓這件事發生。

所謂的「Project Management」其實可以用很科學的手段達成，因為事實上這本身就是一門科學。

一般所謂的 PM 很常誤以為 Project Management 就是用 mail+excel、口頭分配任務，得到專案成員的口頭回覆，接著只要坐著回去發呆或無時無刻的跑到座位上催專案成員作事，整件事情就會發生。
如果你真的一直這樣想，我想可能最後程式設計師可能做的事：就是直接用 shell script 換掉你。

no kidding。

### Thinkgeek : Go away or I will replace you with a very small shell script

<a href="http://www.thinkgeek.com/tshirts-apparel/unisex/frustrations/374d/"><img src="http://www.thinkgeek.com/images/products/frontsquare/lg-go-away-tshirt.jpg" alt="Go away or I will replace you with a very small shell script"></a>


## 推薦書單

<a href="http://www.flickr.com/photos/xdite/7014948309/" title="Untitled by xdite, on Flickr"><img src="http://farm7.staticflickr.com/6091/7014948309_52e099ec27.jpg" width="375" height="500" alt=""></a>

