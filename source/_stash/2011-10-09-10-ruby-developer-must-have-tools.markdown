---
layout: post
title: "十個 Ruby Web Developer 應該熟悉的工具"
date: 2011-10-09 05:30
comments: true
categories: 
---

原本是承諾讀者要整理一篇我常用的工具集，後來想想其實應該要改成來寫一篇：「十個 Ruby Web Developer 應該熟悉的工具」。


### 1. Git

[Git](http://git-scm.com/) 是進入 Ruby 這個生態圈首先最應該學會的工具。幾乎所有以 Ruby 開發出來的套件都放在 [Github](http://github.com) 上。也就是不管你要下載或修改協作都需要透過 Git。

### 2. RVM

Ruby 有很多種 implementation，比較多人在使用的有

* 標準的 MRI Ruby 1.8.7
* 標準的 MRI Ruby 1.9.2
* [REE](http://www.rubyenterpriseedition.com/) ( Ruby Enterprise Edition)
* JRuby 等等

其實你用哪一種版本開發都無所謂，不過目前有一些 project 只能在 Ruby 1.9.2 上執行。切換 Ruby 環境跑實驗 project 在之前的時代是一件很痛苦的事。

所以有人發明了 [RVM](http://beginrescueend.com/)，讓開發者可以無痛的可以切換各種 Ruby 環境，甚至透過 RVM 製造出獨立的 Gemset 環境，無負擔的盡情實驗新工具。

### 3. Mac

不可否認的開發 Ruby 程式，[Mac](http://www.apple.com/tw/mac/) 是第一首選環境。

最初的原因是撰寫 Ruby / Rails 的利器: [TextMate](http://macromates.com) ，是 Mac 上的軟體。而後來使用 Mac 開發 Ruby 程式的開發者越來越多，更加深這種情況，
造成一些實戰 best practices 以及友善的開發工具，幾乎都以 Mac 為優先或唯一平台發佈，如：Pow 與 Homebrew。


### 4. Homebrew

原先在 Mac 上，套件管理幾乎是 Macports 與 Fink 的天下。但這兩者因為 dependency 處理不佳，加上需要 sudo 執行。某些時候會造成套件管理上的災難。
在 OSX 10.6 之後的時代，就逐漸被後起之秀 Homebrew 取代。

Homebrew 有兩大極優秀之點：

1. by user，不需 sudo 就可以安裝套件。不會把檔案權限搞得一團髒。
2. 更新迅速以及乾淨。Homebrew 是 git-based 的 fomula sets，透過預設的 fomula 安裝程式。

安裝時如果發現有錯誤，可以自行修改，並透過 Github 的功能發 pull request 要求管理者 patch。用 Homebrew 建置出來的 Rails 開發環境通常極為乾淨且無惱人的套件 bug。


（ Rails developer 最常會撞雷的兩大套件：MySQL 與 ImageMagick 在 brew 上裝，幾乎沒什麼問題...）[註1]

### 5. Pow

這是由 [37signals](http://37signals.com) 所開發出來的網頁伺服器，可以跑任何 Rack Based 的網頁程式。特點是，你可以把某個開發中的 project，如：wiki，symlink 到自己的家目錄底下的 .pow/ 資料夾。

```bash
$ cd ~/.pow
$ ln -s ~/projects/wiki

```

再打開瀏覽器上的 http://wiki.dev/，就可以把 projects 掛起來了。

(原理是攔截對 port 80 上的 request 導回 Pow)

在從前，如果你要掛上 projects，通常得自己改 local 的 apache conf 和 /etc/hosts 加上設定。掛起、移除、重開都非常麻煩。

而 [Pow](http://pow.cx) 的誕生，讓常常追許多新玩意的開發者，實驗的成本變得極度低廉。

### 6. Rack

[Rack](https://github.com/rack/rack/wiki/List-of-Middleware) 是一個 Ruby 套件，也同時是 Ruby 界的網頁程式標準 interface。背後的想法與原理可以參考我以前寫的一篇舊文 [Rack 與 Rack middleware](http://wp.xdite.net/?p=1557)。

現在只要看以 Ruby 開發的網站程式，幾乎都支援 Rack。不會再有以前哪一套框架，推薦獨家使用哪一套 web server 跑的亂象。

而因為有了 Pow，掛起 Rack-based 的網站實驗程式成本也很低廉。

同時因為採用 Rack 架構開發的緣故，開發者可以透過 Rack middleware 外掛實作一些框架或程式沒有的功能。

比如說：

* [rack-now-www](https://github.com/logicaltext/rack-no-www) 硬是幹掉網址的 www
* [rack-rewrite](https://github.com/jtrupiano/rack-rewrite) 在不支援 .htaccess 的環境下，直接使用 rack 硬 rewrite routing 

也很自然而然的會知道：

* 想惡搞，改 config.ru 
* 想重開，touch tmp/restart.txt 

這些潛規則。

### 7. Bundler

[Bundler](http://gembundler.com/) 原先是 Rails3 架構師 Yehuda Katz 開發出來解決 Rails 中 package dependency 的工具（ 在開發 Merb 這個 framework 時，Katz 就開始嘗試實作了）。

package dependency 一直是相當麻煩的問題。解不開，就無法將程式 boot 起來。

原先大家也只有拿 Bundler 搭配 Rails 使用。

而後來 Bundler 也逐漸變成一般 Ruby 程式中預設的套件 dependency 管理程式。

Bundler 中的 Gemfile 設計，不只能讓開發者能夠輕易的解決套件相依問題，並且可以直接引入「開發中」套件，解決 3rd gem 版本更新過慢，卡住自己開發進度的問題。

```ruby Gemfile
gem 'nokogiri', :git => 'git://github.com/tenderlove/nokogiri.git'
gem 'nokogiri', :git => 'git://github.com/tenderlove/nokogiri.git',:branch => 'stable-2'
gem 'nokogiri', :git => 'git://github.com/tenderlove/nokogiri.git',:tag => 'tag-2'
gem 'nokogiri', :git => 'git://github.com/tenderlove/nokogiri.git',:ref => '23456'
```

### 8. Guard

在開發網頁程式時，開發者很常重複這樣的動作：寫一寫 -> run test -> refresh web browser -> 繼續修改 -> run test -> refresh browser

這些都是很機械式的行為，非常煩人。

有沒有辦法只要「檔案變更，就自動作事」呢？

[Guard](https://github.com/guard/guard) 就是這樣的一套工具。

有趣的是，Guard 剛推出時，其實也只單純是一套監視檔案工具變動的工具，你可以透過寫 Guardfile，去自由監視需要監視的資料夾，再 do something。而因為 Guard 架構算設計的不錯，後來許多開發者更基於 Guard
做出更多其他的 rubygems。

[guard-livereload](https://github.com/guard/guard-livereload) 就是一個例子。

### 9. LiveReload

修改網頁 => refresh browser 是剛剛所提到的煩人事之一。

[LiveReload](http://github.com/mockko/livereload) 提供了監視檔案變動，並通知 browser reload 的功能。

開發者如果螢幕夠大的話，可以同時開著文字編輯器與 browser，修改的任何變動馬上即時顯示在 browser 上。

值得一提的是，LiveReload 在 10.7 以後是 broken 的。因此後來有人利用 guard 實作出了 guard-livereload 作為替代品。

以前寫過舊文一篇：[LiveReload：你的套版好幫手！](http://wp.xdite.net/?p=1791)

### 10. Sass / SCSS / Compass

自從 Rails 3.1 引入 [SCSS](http://sass-lang.com/) 作為 [Asset Pipeline](http://upgrade2rails31.com/asset-pipeline) 當中的選項之後，這套本來沒多少開發者知道的 CSS framework 就開始瘋狂走紅。

SCSS 的原理是透過寫編寫「巢狀」的 style，取代原本需要寫 CSS 時需要一直複製 DOM 結構名稱的動作。並且支援變數、數學、繼承、mixin 等功能...

如：

```scss SCSS
   $border-color: #3bbfce;
   $link-color: #3bbfcf;
   .content
      { border-color: $border-color;
        a{color: $link-color}
   }
```

可以生成

```css CSS
  .content{ border-color: #3bbfce; }
  .content a{color: #3bbfcf; }
```

而 [Comass](http://compass-style.org/) 是基於 SCSS 的 Framework。提供了更進一步的許多暴力 feature。

有些人可能會搞不清楚 SASS / SCSS / Compass 的關係。如果你有興趣的話，可以參考我在 [Upgrade2Rails31](http://upgrade2rails31.com) 這個 project 中寫的兩篇文章：[Sass/SCSS](http://upgrade2rails31.com/sass-scss) 以及 [Compass](http://upgrade2rails31.com/compass)。