---
layout: post
title: "Rails 4: New Feature, Better Syntax"
date: 2013-05-04 15:28
comments: true
categories: 
---

TL;DR : Rails 4 是一個溫和加強版的 Rails3，而且贈送了很多酷炫 feature，適合進場


上個月花了一點時間直接衝了 Rails 4.0beta1，利用 upgrade project 去熟悉整個 Rails4 新的架構。

若要我形容對於 Rails4 這次升級的感想的話，我會總結為兩句話 `New Feature, Better Syntax`。

相較於 Rails 2 -> Rails 3 幾乎是個毀天滅地的重新大改寫（i.e. 不管是 Rails 本身，還是使用 Rails 開發的 project），Rails 3 -> Rails 4 的升級及變更內容顯得溫和許多。

## Better Syntax

Rails 4 這次的改進，許多都是吵了多年以來的折衷方案、或者是許多開發者對如何設計，始終各自有 strong opinion 的主題，都找到 best practices 而被一槌定音了。或者是一些一直以來大家覺得老是被逼著這樣寫，非常智障的設計，也都被改掉了…

### Routing

* 讓 Routing 更安全：新增了以 http verb 為 syntax 的寫法，如 get/post
* 支援 Rouring concern: 如果要幫不同的 resources 加上如同 :comments 這樣的 nested_resources 就不用一直再重複貼上

### ActiveRecord

* 強迫 scope 的寫法要全面改成 proc / lambda：避免 eager-evaluated 出現的問題。
* Relation#not：以往要寫出 not 的查詢條件，寫法讓人哭笑不得。
* Relation#none：以往撈不出集合，是 nil，要回傳 [] 空集合要自己作..
* Relation#pluck：可以輕鬆只摘出某些欄位，以及要自己手下 select…
* Relation#unscope：避免 default_scope + order 產生的排序問題。（因為下 except 無法閃過去）
* `update` & `update_columns`：update 會觸發 callbacks, update_column 不會，但是 update_column 無法送多個 params，於是必須只好用 sneaky-save 這個 solution 繞過。現在 4 直接支援 update_columns

### ActionController

* before_filter 更名為 before_action：就是正名...
* `respond_to do |format|` 拿掉 xml 以 json 取代：2013 年了，沒人再拿 xml 當 default API... 

### Security

* 拿掉 attr_accessible，改用 strong_paraments：去年 [Github 被打下](http://blog.xdite.net/posts/2012/03/05/github-hacked-rails-security/)的事情鬧很大，Rails 的安全策略重新被檢討，於是最後社群討論出採用 strong_parameters 得這個 best practices。

### Other 

* 砍掉 `public/index.html` : 砍掉愚蠢的 publc/index.html，以往教 Rails 初學者第一課就是記得砍掉這個預設檔案，不然寫的東西都會看不到
* add_flash_type ：以往警告訊息只有 [:notice , :alert, :error ] 三種類型，但是自從有 [bootstrap](http://twitter.github.io/bootstrap/) 之後。大家習慣使用的是 [:notice , :warning, :error]。要套版時要一直手加 ` , :flash => { :warning => "Oh no!" }` 是很智障的事，Rails4 開放自定義 flash types。(P.S. 這是我提的...)
* mem_cache_store 換成 dalli：自從 1.9 出了之後，原先的 :mem_cache_store （memcache-client）會撞到 utf8 問題，於是大家都改用 dalli 作為 backend cache，Rails 4 的 :mem_cache_store 預設將改為 dalli。


## New Feature

* Model Concern / Controller Cern: 重複用到的 method使用 Concern 複用
* [Turboklinks](https://speakerdeck.com/xdite/turbolinks) : 無痛自動 pjax。pjax 不難，只要你用 Rails4 …
* [Cache Digest](http://blog.xdite.net/posts/2012/09/02/cache-digest-new-strategy/): 採用 Russian Doll Cache Strategy，智能 cache 設計，以前多層 partial cache 的問題讓大家實在很頭大。
* HTML5 input form helpers: 現在是 HTML5 的時代，開發時自然會使用很多 js plugin，如calendar plugin，但用傳統的 form object 去產生這些 field 實在很痛苦。Rails4 內建了 HTML5 input form helpers。
* 採用 jbuilder 產生 json : 生 json 可以採用類似生 rss 的方式寫 builder，真是驚訝這個 feature 現在才出現 …. 

## 結論

學 Rails4 最快的方式不是看書，因為總體而言，這次的升級並不是什麼大破壞。改良的 syntax 和好用的新 feature。反而應該會減少不少平常開發上的負擔。而學習 Rails4 最好的方式就是用勇敢在現有的 project 上，大方的開一個 rails4 branch 下去練習升。

不用花很多時間你就能感受到 Rails4 新 feature 帶來給你的好處…

// 警告：以上建議只針對 Senior Rails Developer。目前還有一些 gem 沒有 Rails4 版本。所以 project 升級有時候會遇到必須要自己 fork gem「手動升級/Hack」的狀況，不熟包 gem 者勿輕易嘗試。

這次內建的一些 feature，其實都還蠻有意思的，也許將來還會挑幾篇特別再寫幾篇文章...

## 資源

* <http://www.upgradingtorails4.com/>
* <http://blog.wyeworks.com/2012/11/13/rails-4-compilation-links/>
* <http://blog.remarkablelabs.com/2012/11/rails-4-countdown-to-2013>
* <http://www.edgerails.info/>