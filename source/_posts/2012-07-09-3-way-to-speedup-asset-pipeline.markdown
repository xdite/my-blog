---
layout: post
title: "3 招實用 Asset Pipeline 加速術"
date: 2012-07-09 02:49
comments: true
categories: 
---

Asset Pipeline 最讓人詬病的就是 deploy 時花費速度過久。在[社群聚會](http://www.meetup.com/Ruby-Taiwan-Group/)時發現大家都對這個主題非常不熟。所以把最近累積了的這方面技巧整理出來分享給大家。

## 1. Capistrano deployment speedup

### 使用 capistrano 內建 task 執行 assets:precompie

capistrano 內建了 `'deploy/assets'` 這個 task。只要在 `Capfile` 裡面

``` ruby Capfile
load 'deploy/assets'
```

deploy 就會自動執行 assets precompile 的動作。由 [原始檔](https://github.com/capistrano/capistrano/blob/master/lib/capistrano/recipes/deploy/assets.rb) 可以看到這個 task 實際執行的是

`"cd /home/apps/APP_NAME/releases/20120708184757 && bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile"`

而執行的時機是

`after 'deploy:update_code', 'deploy:assets:precompile'`

許多開發者不知道有這一個 task 可以用。手動寫 task 去 compile，造成了兩個問題:

1. 時機執行錯誤。Compile 時機錯誤會造成站上出現空白 css。
2. 執行 compile 機器負擔太重。如果是手寫的 task 通常會是 load 整個 production 的環境去 compile。與只 load assets 這個 group 所吃的系統資源「有可能」差得非常多。


### 如果沒有變更到 assets 時，就不 compile

請把這裡面的內容貼到你的 deploy.rb 檔裡面

{% gist 3072362 deploy/asset.rb %}

這是在 Railsconf 2012 的 [Stack Smashing](https://speakerdeck.com/u/czarneckid/p/railsconf-2012-stack-smashing-cornflower-blue) 上學到的一招。

如果你的 assets 檔案沒有變動的話，只要執行 copy 上一版本的 assets 就好了。這段 task 會偵測

* app/assets
* lib/assets
* vendor/assets
* Gemfile.lock
* confir/routes.rb

是否有變動。基本上已經含了所有可能 assets 會變動的可能性。有變動才會重新 compile。

整體上會加速 **非常非常的多**。

## 2. use @import carefully

### 避免使用 @import "compass"; 這種寫法

[compass](http://compass-style.org/) 是大家很愛用的 SCSS framework。大家寫 gradiant 或者 css spriate 很常直接開下去。

但是你知道

``` scss
@import "compass";
```

和 

``` scss
@import "compass/typography/links/link-colors";
```

這兩種寫法。

前者 compile 的速度可能比後者慢到 9 倍以上嗎？

會這麼慢的原因，是因為 compass 本身即是[懶人包](https://github.com/chriseppstein/compass/blob/stable/frameworks/compass/stylesheets/_compass.scss)，`@import "compass";` 會把

* "compass/utilities";
* "compass/typography";
* "compass/css3";

下面的東西 **通通** 都掛起來（還跑 directory recursive）。

所以自然慢到爆炸。如果要用什麼 helper，請直接掛它單支的 CSS 就好了，不要整包都掛上來。

全掛其慢無比是正常的。


### 避免使用 partial 

我知道 partial 是 SCSS 整理術的大絕招。但是若非必要，也儘量避免一直單檔一路 @import 到底。

``` scss common.css.scss
@import "reset";
@import "base";
@import "product";
```

``` scss common.css.scss
//= require "reset"
//= require "base"
//= require "product"
```

這兩個結果是一樣的。但後者會比前者快。

如果真的需要用到非得使用 partial 的技巧再使用即可，因為只要一牽涉到directory recursive compile 就會慢…

## 3. don't require .scss & .coffee for no reason

### 避免使用 require_tree

使用 generator 產生 controller 時，rails 會自動幫忙產生

* product.css.scss
* product.js.coffee

然後 application.css 與 application.js 會利用

``` css application.css
//= require_tree
```

這種技巧來把這些檔案掛上去。

但是你知道嗎？就算這些檔案裡面只寫了這幾行注解：

``` coffeescript
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

```

而且實際執行結果也等於空輸出。compile 一支大概也要 250ms。你可以想想，多 compile 10 支，就是 2.5 秒了。難怪超耗時。

### 可以使用 .js 或 .css 解決的不要用 .scss 與 .coffee 當結尾

``` plain
Compiled jquery-ui-1.8.16.custom.css (0ms) (pid 19108)
Compiled jquery.ui.1.8.16.ie.css (0ms) (pid 19108)
Compiled jquery.js (5ms) (pid 19108)
Compiled jquery_ujs.js (0ms) (pid 19108)
Compiled custom.css (14ms) (pid 19108)
```
其中 custom.css 的檔名是 custom.css.scss

這樣應該知道為什麼不要亂用 scss 當檔名了吧？

## 小結

為了方便大家調整，我把具體加速 assets precompile 過程的步驟羅列在下面。

#### 1. 換掉 deploy.rb 的 assets precompile tasks
#### 2. 觀察 logs/product.log。

1. 找出慢的 assets。
2. 拿掉直接使用 import "comppass"; 的 SCSS，改用功能針對性寫法。
3. 不需要使用 @import 寫法的改用 require
4. 拿掉 require_tree，改用 //=require 一行一行掛上去
5. 刪掉空的 scss 與 coffeescript
6. 單純只是 CSS 的不要自作聰明幫忙加上 .scss 檔名。

====

如果有什麼問題，歡迎各位在底下留言討論。

也歡迎大家有空來 [Rails Tuesday](http://www.meetup.com/Ruby-Taiwan-Group/) 坐坐。我很樂意幫大家解答問題。

P.S. 如果你是要問 [Rails 101](http://rails-101.logdown.com) 書上的問題，請找小蟹。

