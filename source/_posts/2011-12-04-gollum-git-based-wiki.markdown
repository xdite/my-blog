---
layout: post
title: "gollum : Git-backend Wiki"
date: 2011-12-04 01:02
comments: true
categories: 
---

這週繼續在實作 <http://ruby-taiwan.org> 上的 features。

既然要打造一個讓程式設計師很願意發表的社區，介面就要對 developer content 非常 friendly。

如何友善法？除了發文介面要做的棒，讓人很容易發表文章、寫回應之外，還要容易貼 code！社區不能貼 code 還叫程式社區嗎？


## Topic 與 Reply 支援多種語法、程式碼高亮

所以這週的主要進度是：Topic 支援程式高亮了。(by [@yorkxin](http://twitter.com/yorkxin) )，詳細的內容在這篇公告：[新增多種語法支援：粗體、斜體、底線、程式碼高亮](http://ruby-taiwan.org/topics/31)。

## Wiki

Wiki 是當初第二個看不順眼的東西。

在程式社區中 Wiki 也算是很重要的角色，但是一個爛的介面和動線也會讓人不怎麼想要貢獻內容。

而 <http://ruby-taiwan.org> 的 Wiki 其實還是只具備非常初階的功能，底層是用 DB 實作，而表單也是簡單的用 Bootstrap 套，雖然支援 Markdown 語法，但 Wiki 內連結什麼都還是要自己 hard link。貼程式碼也容易貼的歪七扭八…

理想的程式社區 Wiki 我覺得要具備幾個要素

1. 內容可以實現 [[ XXX ]] 站內超連結
2. Markdown 或 Markdown extra 以上功能
3. 貼任何程式碼都支援高亮
4. Version Control ( 基本 )
5. 可 Diff
6. 權限控管
6. 容易「預覽」的介面…

不過這些願望就算是自己用 Rails 實作，也很苦手。因為有一大堆底層苦工需要先作…

我是個很討厭重造輪子的人，馬上就想起以前曾經用過的一套 Wiki : [gollum](https://github.com/github/gollum)。

以前曾經寫過一篇文章介紹過這套 wiki : [用 Pow 架起 Gollum](http://wp.xdite.net/?p=2182)。

Github 官方部落格上面的介紹：[Making GitHub More Open: Git-backed Wikis](https://github.com/blog/699-making-github-more-open-git-backed-wikis)


### gollum 的基本想法

gollum 的想法是將 Wiki 的每一頁都視為一個檔案，塞進 Git 版本控制。這與傳統的 Wiki 作法不同，多數的 Wiki 實作是將每一頁視為一筆 DB record，而且還要另外拉一個表紀錄版本變遷（有的 Wiki 甚至沒有這樣功能）。

而用 Git 實作的好處，是檔案儲存、變更、版本控制、搜尋，就可以走 Git 本身的機制，不必再重造一套輪子了。所以當初看到 gollum 釋出的時候，受到很大的震撼，沒想過原來可以這樣惡搞閃掉重造輪子。

### gollum 的基本功能

gollum 提供了一套 API，可以存取，版本控制，搜尋，自動將特定格式內容轉換。（支援 Markdown、RST, ASCIIDoc…等等）

而且 gollum 還提供一套用 Sinatra 刻的介面，可以讓人輕鬆的寫 Wiki…

### 還是要重造輪子

寫到這裡，可能會讓人以為我的作法可能是會將 gollum 當作一個 rack app 掛在 <http://ruby-taiwan.org> 就收工?

gollum 的介面頂多是勉強堪「自用」，所以在我自己的 Mac 上，我的確是用 gollum + Pow 架起來寫私人程式筆記的。但是 gollum 的 wiki 介面，我自己覺得連易用都摸不上邊...（更別提 1.3.x , web preview 介面是爛的 …）


再來是 gollum 並沒有權限與使用者概念，如果是用 web interface 發表，走的都是 local git config 的 user name…

## 終極 solution

以前自己寫過一個小專案，用 Rails 刻一套介面去接整套 gollum API，自己把 UI 改的 friedly 些。讓寫筆記的速度可以加快，直到 [Mou](http://mouapp.com/) 出來之前，我一直都是這樣寫東西的…

要達到剛剛所說的六個重點，於是最後實作的解法就是…

## 寫 Rails 去接 Gollum API…

### Model

<https://github.com/rubytaiwan/ruby-taiwan/blob/production/app/models/wiki.rb>

* 檔案存取 / 版本控制：把整個 db 抽換掉，換成 gollum 
* 與 bootstrap form 結合：因為 <http://ruby-taiwan.org> 是用 simple_form 實作表單，所以 Wiki 的部分是寫了一個 class 去 include ActiveModel 的一些 API 去接上 form

### Controller 

<https://github.com/rubytaiwan/ruby-taiwan/blob/production/app/controllers/gikis_controller.rb>

* CRU 接了 gollum API 去實作。
* 寫入 commit log 則取站上認證的 current_user 去塞

### 權限控制

<https://github.com/rubytaiwan/ruby-taiwan/blob/production/app/models/ability.rb>

* 用 [CanCan](https://github.com/ryanb/cancan) 去管基本的存取。若以後要上黑名單，細緻權限，鎖定，都可以從 CanCan 這端寫 rule block 掉。

### Markdown Support & Syntax Highlight

<https://github.com/github/gollum/blob/master/lib/gollum/markup.rb>

* gollum 本身就是使用 [Redcarpet](https://github.com/tanoku/redcarpet) 去實作 Markdown 的 renderer，所以吐回來的 formatted_data 已經會是支援 Markdown Extra 以上的格式了。更棒的是也自動結合了[pygments.rb](http://rubygems.org/gems/pygments.rb)。

### Preview

<https://github.com/github/gollum/blob/master/lib/gollum/wiki.rb>
<https://github.com/rubytaiwan/ruby-taiwan/blob/master/app/assets/javascripts/topics.coffee>

* 本來在煩惱 Page Preview 要怎麼實作…真不想自己寫 renderer 硬幹。後來發現 gollum 也提供了 preview_page，提供 in-memory preview。而 [@yorkxin](http://twitter.com/yorkxin) 這兩天才為 Topic & Reply 寫一個 ajax preview。就用同樣的一套 interface 也接上去…

### Backup

* 用 Git 實作 Wiki 最大的好處，是可以把內容都塞進一個資料夾內。再定期跑 crobtab 丟上 github …（這是其他 wiki 很難做到的地方）

## 踩到的一些雷

其實事情也不是大家想像中的順利。主要還有遇到兩個地雷。

<https://github.com/xdite/gollum/commit/7924e8c9a90a772d90da5f7c6a3366bfc5010fbb>

* Redcarpet 的介面改變。原先 Redcarpet 1.0.x 是走 `Redcarpet.new(data, *flags).to_html` 這種介面。而 Redcarpet 2.0.x 是走 `markdown = Redcarpet::Markdown.new(html_renderer)`、`data = markdown.render(data)`。gollum 沒有鎖 redcarpet 版本，然後就大爆炸了。目前官方沒有 release 新 gem 的打算，只好自己 hot fix 然後拉 pull request 回去。

<https://github.com/mojombo/grit/commit/696761d>

* Ruby 1.9.2 在塞中文內容進檔案時會爆炸。主要是 [Git](https://github.com/mojombo/grit) 這套拿來存取 Git 的 Ruby Library，會遇上 UTF8 string 長度問題。同樣的，官方目前沒有 release 新 gem 的打算，不過 patch 已經進 master ..

## 小結

所以為了作這個 Wiki 功能，用了..

* ActiveModel
* [simple_form](https://github.com/plataformatec/simple_form)
* [CanCan](https://github.com/ryanb/cancan)
* [bootstrap + simple_form wrapper](https://github.com/rafaelfranca/simple_form-bootstrap/blob/master/config/initializers/simple_form.rb)
* [RedCarpet](https://github.com/tanoku/redcarpet)
* [pygments.rb](http://rubygems.org/gems/pygments.rb)
* [css3buttons_rails_helpers](https://github.com/thetron/css3buttons_rails_helpers)
* [CoffeeScript](http://jashkenas.github.com/coffee-script/)

非常神經病的列表…

不過出來的架構和最後呈現算是令人滿意...:D