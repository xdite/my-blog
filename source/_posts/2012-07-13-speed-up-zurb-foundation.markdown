---
layout: post
title: "Asset Pipeline 加速：以 Zurb Foundation 為例"
date: 2012-07-13 03:28
comments: true
categories: AssetPipeline Tips
---

前幾天貼了這一篇 [3 招實用 Asset Pipeline 加速術](http://blog.xdite.net/posts/2012/07/09/3-way-to-speedup-asset-pipeline/)。

順便去 [sass-rails](https://github.com/rails/sass-rails/issues/67#issuecomment-6854291) 上面這個靠北 sass-rails 的 issue 回了一下 [zurb/foundation](https://github.com/zurb/foundation) 主要的問題…

我觀察 foundation 原先慢的原因是：幾乎所有的 library 都 `@import "base";`，然後 base 又 `@import "compass";`。所以導致只要 compile foundation 就無敵慢…

不過不知道解掉這個問題可以實際上快多少。今天正打算抓下來 benchmark 時，就發現這篇靠么 zurb 的人應該收到了。他們 [patch 掉](https://github.com/zurb/foundation/commit/b9c8d1d5ca29ceb89111084dfd530b68bfd65484)了，版本從 3.0.4 升到 3.0.5 。

主要變更就是把原先 `@import "compass";` 改成 `@import "compass/css3";`。然後把所有的 `@import "base";` 拿掉。


## Benchmark

我就開了一個空的 Rails。實際用手上的機器去測 compile 時間。

#### iMac i5 2010 mid 款 8GB ram

* Compiled application.css  (9516ms)  (pid 41169) # 3.0.4
* Compiled application.css  (2300ms)  (pid 41483) # 3.0.5

#### Linode 4096

* Compiled application.css  (12518ms)  (pid 12585) # 3.0.4
* Compiled application.css  (3201ms)  (pid 12853) # 3.0.5

平均來說速度快了四倍...


## 結論

* … 拜託不要偷懶直接用 `@import "compass";` 啊 XD
* 太慢有時候可能是 SCSS Framework 的問題



