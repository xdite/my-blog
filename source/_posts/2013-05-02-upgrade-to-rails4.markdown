---
layout: post
title: "Upgrade 到 Rails4 的一些感想"
date: 2013-05-04 13:27
comments: true
categories: 
---


![img](http://www.upgradingtorails4.com/ipad_sized.jpg)

Rails4 在前天的 [RailsConf 2013](http://www.railsconf.com/) 釋出 [Rails 4.0 RC1](http://weblog.rubyonrails.org/2013/5/1/Rails-4-0-release-candidate-1/) 了，這也表示大家應該可以進場了。

上個月在 Rails 4.0 beta1 時為了練手感，把手上的一個中小 production 專案，也上了 rails4 branch。

大概有幾個感想：

* [Upgrading to Rails4](http://www.upgradingtorails4.com/) 這本書強烈建議要買，才 $15 USD，可以節省你不少 debug 時間。

* 升 Rails4 建議不只開 branch，也用 rvm 開一個 gemset 出來作，因為 gem dependency 變更蠻多的。

* [rails4_upgrade](https://github.com/alindeman/rails4_upgrade) 要裝。這個 gem 蠻好用的..可以幫你掃 dependency 問題。事實上 Rails3 升 Rails4 最討厭的是 gem dependency tree，因為 Rails 3 已經出太久了（幾乎快兩年了吧)，很多 Gemfile 都強綁定 3 ，所以升 Gemfile 時會出現很多問題...

* major gem，如 simple_form, devise, 幾乎都有 beta1 版，裝了就保證可以動。小的 gem 也幾乎都有 rails4 branch 可以 hotfix。(起碼我在 beta1 進場時遇到的問題就幾乎都有解，所以在 rc1 的狀況應該會更好)

* 這次 Rails4 的改動，我個人的感想會是 Rails3 的 New Feature, Better syntax Version。如果平常 code 都寫的蠻漂亮（接口和封裝乾淨）的話，升級應該是沒有太痛才對。唯一讓人很煩的就是 gem dependency 解不完，還有牽扯到 scope 與 query 的部份幾乎都要重寫..:/ （目前是都還跳 warning 而已，但真要清 warning，如果 model 裡面 condition 很多，真的會清到手快斷...）

* 有關於 New Feature 與 Better syntax 這個議題，我應該週末會寫一篇出來..


* Rails project 的本體內容物是沒有改動太大，但大家拿來 build gem 的 internal API 改不少，這也難怪 Jose Valim 這一兩天也同步釋出了 [Crafting Rails Applications (2nd edition): Expert Practices for Everyday Rails Development](http://pragprog.com/book/jvrails2/crafting-rails-applications) 第二版的 beta。我這幾天改 gem 要升 Rails4 也是中了一堆 api 變更的地雷…

* 會逼大家都改 gem 的原因是因為是，連 migration api 都改了，所以只要提供產生 migration 的 gem 通通會逼要升 Rails4，真是個好招 -_- （連我只有兩個 commit 的 AutoFacebook gem 也不能倖免。解法在[這裡](https://github.com/xdite/auto-facebook/commit/2e21a3fd1884c6eec7856b849d811b1d9b168502) ）

*  Obie Fernandez 前天也宣布了 Rails 聖經 [The Rails 4 Way](https://leanpub.com/tr4w)開始 beta。值得注意的是他這次是使用 [Leanpub](leanpub.com) 釋出書籍的 beta，而非走 [Informit](http://www.informit.com/) 的 RoughCut 版本。

* 為什麼我有時間測這些東西？好問題，我也不知道…明明最近就忙到快死了...orz




