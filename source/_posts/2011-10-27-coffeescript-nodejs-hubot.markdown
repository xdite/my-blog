---
layout: post
title: "CoffeeScript 還可以用來做什麼？ -- Hubot"
date: 2011-10-27 16:44
comments: true
categories: 

---

[Github](http://github.com) 內部自用的機器人 Hubot 一直是個神秘的產品，常常看到內部員工在[投影片](http://speakerdeck.com/u/holman/p/how-github-uses-github-to-build-github)內炫耀 Hubot 多麼的屌：

<a href="http://www.flickr.com/photos/xdite/6285733326/" title="Hubot1 by xdite, on Flickr"><img src="http://farm7.static.flickr.com/6031/6285733326_5754b16968.jpg" width="500" height="375" alt="Hubot1"></a>

<a href="http://www.flickr.com/photos/xdite/6285212725/" title="Hubot2 by xdite, on Flickr"><img src="http://farm7.static.flickr.com/6110/6285212725_7255bbcabc.jpg" width="500" height="374" alt="Hubot2"></a>

但往往只是聞其聲，不見其蹤。

不過要是按照 Github 內部慣例，常常在員工投影片出現的東西，往往就是下一個 release 的標的。因此大家也都是迫不及待在等 Hubot 的釋出。按照大家的假想，Hubot 應該是某種 Perl 或 Ruby 的 client，而且 Ruby 的機率可能還大的多。

但 Github 官方 blog 貼的這篇[公告文](https://github.com/blog/968-say-hello-to-hubot)章讓大家下巴掉下來：[Hubot](http://hubot.github.com/) 是 [CoffeeScript](http://jashkenas.github.com/coffee-script/) 寫的.......XDDDDD

(註：以防你不知道什麼是 [CoffeeScript](http://jashkenas.github.com/coffee-script/)，或者是它能帶來的好處，我曾經寫過這麼一篇[文章](http://upgrade2rails31.com/coffee-script) 解釋原理以及用途 )

### CoffeeScript meets NodeJS

更精確的來說，Hubot 是用 [NodeJS](http://nodejs.org/) 架構作出來的一套機器人框架，而 Github 並非直接撰寫 JavaScript，他們是直接使用 CoffeeScript。整個專案的原始碼都只有 .coffee 而已。

### Support Campfire 與 IRC

目前 Hubot 支援兩種 chatroom，預設是 [37signals](http://37signals.com) 的產品 [Campfire](http://campfirenow.com)，也有提供 [IRC](http://en.wikipedia.org/wiki/Internet_Relay_Chat) 的 adapter。

### Provide tons of hubot-scripts example

為了避免大家不知道怎樣擴展 Hubot 的功能，Github 在專案內提供了大概十支左右的 example，也另開了一個專案 [hubot-scripts](https://github.com/github/hubot-scripts)，讓大家交流和 contribute。

### Hosted on Heroku

你會覺得，要跑起這樣一隻 bot，也許又要找一台機器把 bot 跑起來？

Well，這次你錯了… 

Hubot 的架構被設計為可以透過 [Heroku](http://heroku.com) 的 [Procfile 架構](http://devcenter.heroku.com/articles/node-js)掛起來，也就是可以把這一隻 Bot 養在雲端 XD （ Hubot 的文件有教你怎麼作 ） 

## 小結

昨天晚上在 Twitter 上看到幾個 Rails core team member 在講 hubot-scripts 時，才突然發現 Hubot 竟然已經釋出了。早上認真想玩時，發現整個架構竟然是 CoffeeScript + NodeJS 時，內心其實有小震撼…

目前看到的幾個是 feature project 的 network program 都是以這樣的方式誕生，如 [Pow](http://pow.cx)、Hubot。看來 network program 應該會越來越往 NodeJS 方向傾斜過去。

BTW，今天在玩 Hubot 時，有發現幾個比較值得注意的地方。

1. 請使用 trunk 版。雖然官方請你直接下載有版本號的打包檔，不過大概是剛釋出，bug 有一點點多，但社群都積極的在修補，這些修補檔目前都還在 master branch 上，還沒被 tag 成 release 版本。所以跑 master 通常會比較沒問題。

2. 扔上 Heroku 時，要記得寫 Procfile，不然是不會動的。Procfile 的 sample 在 src/templates 下。記得一定要寫，然後再開 `heroku ps:scale app=1`。完整 Heroku 教學放在 `src/templates/README.md` 下。

Good Luck!

