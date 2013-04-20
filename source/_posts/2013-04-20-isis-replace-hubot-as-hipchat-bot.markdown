---
layout: post
title: "使用 isis 作為 hipchat bot 取代 hubot"
date: 2013-04-20 12:25
comments: true
categories: 
---

最近公司頻道從 [IRC 換到 Hipchat](http://blog.xdite.net/posts/2013/04/01/move-to-hipchat/) 上面，本來也想要把 [Hubot](http://hubot.github.com/) 也一起搬過去的。

但是 Hubot 的安裝真是惡夢，光是 node.js 版本和 npm 之間的 dependencies 就可以搞死人。我們公司現在又沒有專職的 SA，工具蠻多都是我自己下海寫的....

最後想了一下，決定找一套在 ruby 下也很好開發的 hipchat bot framework。

最後找到這套 [isis](https://github.com/whitehat101/isis)。因為[敝公司](http://rocodev.com) 是 100% 靠 Ruby 吃飯的，所以瞬間就把寫 bot 的門檻拉到很低...

### 掛上 hipchat bot 的方式

因為 bot 是常駐在聊天室的，所以你必須要幫 bot 申請一個 hipchat 專用帳號。

``` yaml
hipchat:
  jid: DDDD_XXXXX@chat.hipchat.com
  name: Full Name
  password: <password>
  history: 3 # num of history fields to request
  rooms:
    - DDDD_room_name@conf.hipchat.com
    # - DDDD_second_room_name@conf.hipchat.com
```

Bot 走 Jabber 通訊協定。Jid 和 Romm 的資訊在 <https://rocodev.hipchat.com/account/xmpp> 

jid 格式 `DDDD_XXXXX@chat.hipchat.com`，room 格式 `DDDD_room_name@conf.hipchat.com`

### 開發 / 掛上 Plugin 方式

isis 的 plugin 撰寫很簡單。基本上只要到 `lib/isis/plugins` 多開一個 `class` 繼承 `Isis::Plugin::Base`，然後掛進 config.yml。
這樣就做好了...

### Local 測試

`bin/isis run` 就可以把 bot 跑起來了。而若要背景常駐要跑 `bin/isis start`  

### Deployment

開發完畢推上 git 之後，要讓 bot 重開還要跑到 server 上跑 `bin/isis restart`。懶人如我當然覺得這很麻煩，所以我用 [gitploy](https://github.com/brentd/gitploy) 和 Rake 檔寫了 autodeploy，跑 `rake deploy` 就會動了。

順便還參考 [hipchat/hipchat-rb](https://github.com/hipchat/hipchat-rb/blob/master/lib/hipchat/capistrano.rb) 的 deploy 檔，做了 deploy hook 掛在 bot 的 deploy rake 上，這樣起碼有人 deploy bot 時大家會知道，以免 bot 被搞爛了沒人發現...。

`config/gitploy.rb` <https://gist.github.com/xdite/5424771>


`Rakefile` <https://gist.github.com/xdite/5424780>

### 後記

昨天後續還寫了幾隻常用 bot，比如說「午餐吃什麼 bot」、「redmine #issue_number bot」、「網頁自動抓標題 bot」。

不過這不是重點，重點是 bot framework 架好之後，禮拜五晚上同事們竟然不睡覺，一直在惡搞這隻 bot 瘋狂加功能....XD

看起來 bot 的確可以玩出不少花樣啊...

