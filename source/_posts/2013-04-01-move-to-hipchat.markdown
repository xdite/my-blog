---
layout: post
title: "把公司 Log 搬到 Hipchat..."
date: 2013-04-01 22:19
comments: true
categories: 
---

一直以來（ 5-6 年前幾..)，我都是用 IRC 在管團隊的 Log 和通知。

這個習慣最早以來是跟前輩學習來的。這在比較強悍的技術團隊內部，幾乎是行之有年的標準 Convention。

（ 可見 Flickr 著名的 [10+ Deploys Per Day: Dev and Ops Cooperation at Flickr
](http://www.slideshare.net/jallspaw/10-deploys-per-day-dev-and-ops-cooperation-at-flickr) 投影片 (P.52)，不過他們大概 2006 年就開始這樣做了，這篇只是後來比較漂亮的整理...）。

當年 [在 T 客邦](http://t17.techbang.com/topics/7181-t-off-state-technical-departments-magic-work-processes-open-to-the-public)，也是用 redmine + IRC bot 自己搞了一套。

把 Log 都打到 IRC 有很多好處。團隊成員去開會、或者暫時離開。回到電腦前，還是可以很快速的掌握剛剛發生了什麼事。再加上 issue tracking 或者是 system alert 其實是很洗信箱讓人容易分神的東西，所以我們把這些幾乎都搬到 IRC 上，建立出一個可以非同步但又高效率的合作開發模式。

![img](http://www.techbang.com.tw/system/images/56563/original/f619713e13061413515e24406f7fbe02.png?1312367582)

![img](http://www.techbang.com.tw/system/images/56564/original/a2c052c70ec3bfc1023c2660bfbf54b9.png?1312367582)

不過這個模式還是有一些極限，所以最近在 survey 過後，最近我決定把 [公司](http://rocodev.com) 整套 solution 搬到 [Hipchat](http://hipchat.com) 上。


## 主要搬家原因

1. 發現每個同事一進來都要教怎麼用 [irssi](http://www.irssi.org/) + 工作站掛 irc，學習成本很高
2. 公司聊天室是 skype, log 在 irc 上，開兩窗有點麻煩。加上 skype-bot 不是不能作，只是我覺得 skype-bot 很吵…
3. 人員離職很麻煩，因為要把 irc room 的 key 和 info 整套換掉，無法作權限控管
4. demo 給別人看 irc solution 時也很麻煩，因為對方一定看得到我們的 key ....
5. 對 irc 訊息上色要試很久，對一般的 developer 門檻有點高
6. irc log 多半要切到桌機才能看，沒有 mobile solution。

所以最後就整套就搬到 [Hipchat](http://hipchat.com) 了。看起來大家現在是用的蠻習慣的。

![img](https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-snc6/221729_10151576143483552_1020905528_n.jpg)

## Hipchat integration

我們目前是把目前的幾種 Log 都打到 hipchat 上

1. Github (github 的 hook 支援 hipchat, pull request, push , merge 都會通知...)
2. Capistrano Deploy <http://blog.hipchat.com/tag/capistrano/>
3. Airbrake ( server error 通知系統, airbrake 支援 hipchat )
4. Redmine (官方的 hipchat/redmine_hipchat 不好用，所以我自己改了一隻 [rocodev/redmine_hipchat](https://github.com/rocodev/redmine_hipchat) 出來)

之後還會掛更多東西上去…

