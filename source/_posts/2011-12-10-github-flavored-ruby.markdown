---
layout: post
title: "Github Flavored Ruby - by Tom Preston-Werner (1)"
date: 2011-12-10 11:23
comments: true
categories: Ruby Tips
---

這是我近期裡面看到算比較有趣的演講，是 Github CTO Tom Preston-Werner 給的 talk

影片在這裡： 
<http://confreaks.net/videos/712-rubyconf2011-github-flavored-ruby>

投影片在這裡： 
<http://speakerdeck.com/u/mojombo/p/github-flavored-ruby>

本來先貼在社群內 <http://ruby-taiwan.org/topics/69>。現在來補充貼我自己的筆記…

裡面提到非常多有趣的東西。

提到五個 Github 的開發哲學：

* Relentless Modularization
* Readme Driven Development
* Rake Gem
* TomDoc
* Semantic Version

雖然這個 talk 長度不到一個小時，但是從中不少學到知識。


## Relentless Modularization

當專案越來越大，身處其中的開發者就會越來越感覺到 codebase 帶來的壓力， code 會變得越來越 messay 和 tightly coupled。牽一髮而動全身。

把一些元件 modularize 應該會是好的解法。但我們總會困惑，那什麼東西應該是應該被 modularize ？

TOM 給出的答案：**EVERYTHING**。

Github 是這樣做的，當它們在建造 <http://github.com> 時，因為 Github 是個 git services。
於是他們造了

* grit <https://github.com/mojombo/grit>

接著他們為了要 scale up，造了

* smoke，讓 frontend 可以直接跟 backend 溝通。

`We then replace Grit::Git with a stub that makes RPC calls to our Smoke service. Smoke has direct disk access to the repositories and essentially presents Grit::Git as a service. It’s called Smoke because Smoke is just Grit in the cloud. Get it?`

<https://github.com/blog/530-how-we-made-github-fast>
<http://www.slideshare.net/rubymeetup/inside-github-with-chris-wanstrath>

而 smoke 又用了 bertrpc

* bertrpc <https://github.com/mojombo/bertrpc>

`For our data serialization and RPC protocol we are using BERT and BERT-RPC. `

和 

* proxymachine <https://github.com/mojombo/proxymachine>

保持連線平穩

`ProxyMachine is my content aware (layer 7) TCP routing proxy that lets us write the routing logic in Ruby.`

`Each frontend runs four ProxyMachine instances behind HAProxy that act as routing proxies for Smoke calls. `

再使用 chimney 控制 route

* chimney

`Chimney finds the route by making a call to Redis. Redis runs on the database servers. We use Redis as a persistent key/value store for the routing information and a variety of other data.`

而每台 Fileserver 上面跑了兩組 Ernie Server。Erine 是 BERT-RPC server implementation that uses an Erlang server to accept incoming connections。

* ernine <http://github.com/mojombo/ernie>

`Every file server runs two Ernie RPC servers behind HAProxy. Each Ernie spawns 15 Ruby workers. These workers take the RPC call and reconstitute and perform the Grit call. The response is sent back through the Smoke proxy to the Rails app where the Grit stub returns the expected Grit response.`

當事情出錯了，用 Failbot 去掌握災情..

* failbot <https://gist.github.com/1162437>

===

* gerve

用 Gerve 去管控 identity

`GitHub user and this information is sent along with the original command and arguments to our proprietary script called Gerve (Git sERVE). Think of Gerve as a super smart version of git-shell.`

`Gerve verifies that your user has access to the repository specified in the arguments. If you are the owner of the repository, no database lookups need to be performed, otherwise several SQL queries are made to determine permissions`


* resque <https://github.com/defunkt/resque>

用 resque 實作 job queue

`Resque (pronounced like "rescue") is a Redis-backed library for creating background jobs, placing those jobs on multiple queues, and processing them later.`

* rock-queue <https://github.com/grzegorzkazulak/rock-queue>

RockQueue 是用來把東西丟進 resque

`Rock Queue is a simple, yet powerful unified interface for various messaging queues. In other words it allows you to swap your queuing back-end without making any modification to your application except changing the configuration parameters.`

* jekyll <https://github.com/mojombo/jekyll>

jekyll 用來生靜態檔案

`Jekyll is a simple, blog aware, static site generator. It takes a template directory (representing the raw form of a website), runs it through Textile or Markdown and Liquid converters, and spits out a complete, static website suitable for serving with Apache or your favorite web server. `

* nodeload <https://github.com/blog/678-meet-nodeload-the-new-download-server>

nodeload 是拿來 handling download files


* albino <https://github.com/github/albino>

albino 拿來處理 pygments 上色


`Albino: a ruby wrapper for pygmentize`

* markup <https://github.com/github/markup>

markup 用來處理不同 format 文檔的 rendering

`We use this library on GitHub when rendering your README or any other rich text file.`

* camo <https://github.com/atmos/camo>

camo 用來作 SSL proxy

`Camo is all about making insecure assets look secure. This is an SSL image proxy to prevent mixed content warnings on secure pages served from GitHub.`

* gollum <https://github.com/github/gollum>

gollum 作 wiki-backend 

`Gollum wikis are simply Git repositories that adhere to a specific format. Gollum pages may be written in a variety of formats and can be edited in a number of ways depending on your needs. You can edit your wiki locally`

* stratocaster <https://github.com/technoweenie/allofthestars/tree/master/vendor/stratocaster>

stratocaster 拿來作 event timeline

`Stratocaster is a system for storing and retrieving messages on feeds. A message can contain any arbitrary payload. A feed is a filtered stream of messages. Complex querying is replaced in favor of creating multiple feeds as filters for the messages. Stratocaster uses abstract adapters to persist the data, instead of being bound to any one type of data store.`

* amen

amen is for graphing ( 我找不到資料 )

* heaven 用來作 deploy

<http://bloggitation.appspot.com/entry/rubykaigi-2001-notes-day-1>
<https://github.com/holman/feedback/issues/38>

`Heaven - wrapper around capistrano for easy branch deployments:

heaven -a github -e production -h fe -b my_branch`

* haystack 拿來收集 Failbot 傳回來的 Exception log

<http://www.slideshare.net/rubymeetup/inside-github-with-chris-wanstrath> # 173

`We use in-house app called Haystack to monitor abitrary information treacked as JSON`

* hubot 

就是…bot XD

<http://hubot.github.com/>

* github-services

<https://github.com/github/github-services>

`Official GitHub Services Integration - You can set these up in your repo admin screen under Service Hooks`


* help.github.com

<https://github.com/github/help.github.com>

`opensource GitHub help guides`

這一段只有七分鐘，但蒐集到的資料太多了…

開下一篇等等再接著寫。

## 其他

在翻一些相關資料時，還找到不少好東西

* <https://github.com/blog/530-how-we-made-github-fast>
* <http://www.slideshare.net/rubymeetup/inside-github-with-chris-wanstrath>

這兩篇也給了蠻多其他的 detail 的...