---
layout: post
title: "Bootstrap Helper 與 Bootstrappers 開始支援 Rails 4"
date: 2013-05-04 13:24
comments: true
categories: 
---


我寫的兩隻 gem [bootstrap-helper](github.com/xdite/bootstrap-helper) 與 [boostrappers](https://github.com/xdite/bootstrappers) 目前都釋出 Rails4 版本了。

* gem install bootstrap_helper -v 4.2.2.1
* gem install bootstrappers -v 4.0.rc1

有任何問題，請回報到 Github 上的 issues 上。

Boostrappers 是針對我在 2013/03 月底測試 Rails 4.0.beta1 測出來的 solution 更換掉 gemset 的。目前應該是沒什麼大問題...

不過這次值得注意的是，Rails4 底層又換了不少 API，包括 generator 的 action 和 migration，所以為了 bnootstrappers 的升級，我被迫 release 了三隻 gem。

包括我之前寫的 [AutoFacebook](https://github.com/xdite/auto-facebook)，也被迫出了一個 Rails4 版本。

* gem install auto-facebook -v 0.1.rails4

