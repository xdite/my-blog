---
layout: post
title: "Why Octopress?"
date: 2011-10-07 19:05
comments: true
categories: 
---

[OctoPress](http://octopress.org/) 是一套Blog Framework。也是我這個 blog 正在用的系統。


{% img http://octopress.org/images/logo.png %}

用了這麼久（5 年）的 Wordpress，突然放棄，你一定會好奇背後真正轉換的原因。

[Wordpress](http://wordpress.org) 是一個很方便的 Blog 系統。

但很可惜的，一直以來它一直是一個給文字書寫者用的部落格系統。

怎麼說呢？若你是一個專門談論技術的 blogger，用 Wordpress 寫一篇技術文帶給你的感覺通常是無比…麻煩。

## 樣樣麻煩

* **貼圖很麻煩**。（我們有潔癖，不喜歡直接傳圖直接上 Wordpres，通常會傳上 flickr 再 embd script)

* **程式排版很麻煩**。如果不裝一些 plugin，幾乎無法貼程式語法。但是通常 plugin 也需要你寫特殊語法排這些程式碼。生出來的東西也很差強人意。

* **Hosting 很麻煩**。安裝 Wordpress 需要租一個 [LAMP](http://zh.wikipedia.org/zh-hant/LAMP) 的 stack 去停泊，沒事你還要害怕機器炸掉，沒有備份。上班摸一整天機器了，下班根本不想再弄…

* **版本控制 很麻煩**。以前的 blog 系統沒有自動備份，視窗一炸掉，文章 99% 就是不見了。而雖然現在 Wordpress 還有一些其他 BSP 有自動儲存功能。但你我心知肚明那只是醫手殘。你只有辦法撈上最近幾個版本，去把文章存回來。若要看自己上次 **因為什麼理由，修訂了這篇文章的草稿** 根本辦不到。

* **改 theme 很麻煩**。如果需要自己訂一些 tips 等方塊，要自己另寫 CSS，但是改 wp-theme 再生效實在是很麻煩的一件事。而且可不可以讓我直接寫 [SCSS](http://sass-lang.com)就好？

* **寫作 很麻煩**。雖然這一點寫出來算有點雞蛋挑骨頭。但是使用 [Markdown](http://markdown.tw) 書寫文章，實在遠比用黏膩膩的 HTML 語法快多了。

樣樣都煩啊！想到就懶！！

## Developer Blogger 的需求

其實我們的需求也不多。若是可以：

* 輕鬆的撰寫 Markdown
* 輕鬆的貼圖
* 輕鬆的貼程式碼
* 改 CSS 超容易
* 不用煩惱佈署問題
* 檢視草稿變化，甚至是站台更動變化。

這樣就很開心了！

## Octopress 

而 Octopress 就是這樣一套會讓人開心的 Blog Framework。

* 輕鬆佈署

Octopress 背後是一套叫 Jekyll 的靜態網站產生引擎，可以輕鬆產生 static-file based 的網站，佈署出去。

你可以選擇放到自己的機器，[Heroku](http://heroku.com)，甚至是 Github Page 上。

佈署簡單到只要一個指令 rake deploy 就出去了！

* 輕鬆撰寫文章

Octopress 支援 Markdown，直接解決了寫作和貼圖的問題。

而程式碼的排版更不用煩惱，可以直接使用 Markdown 原先的 block 貼程式碼，只要註記語言種類，就會自動排版上色。（格式也與 Markdown 語法完全相容）

更令人讚嘆的是可以內嵌 [Gist](http://gist.github.com)。這不知道有多酷啊…

* 使用 Git 版本控制

Octopress 本身不需使用任何 database，架構本身靠的是文字檔案以及版本控制系統。可以透過使用 Git 觀看站體與文章的修改變化。

而我現在寫文章還常使用進階的招數：開 Git branch 把 TODO 扔進 TODO branch，這樣就算我還有文章沒有寫好，或者是日後需要補充，都不需要另外管理以及害怕被人看見。

* 更改網站配置更方便

Octopress 雖然基於 Jekyll，但用起來比 Jekyll 更方便，不少功能都是內建模組化，比如：社群功能（Twitter / Google plus）、留言功能（[DISQUS](http://disqus.com/)）、統計功能（Google Analytics），這些都簡單到只要改 _config.yml 就可以改一改，馬上就可以有一個 Blog 上線了。


* 對 Ruby Developer very very very friendly

Octopress 是 Ruby-based 的。自然許多 feature 是取用 Ruby Ecosystem 熱門架構與套件打造的。

熟悉 Ruby 的開發者，可以透過：

* Rack
* Rake
* SCSS
* Guard
* LiveReload 
* Heroku 

就玩出更多花樣。

寫出 Octopress plugin 更不是什麼難事。

## 小結

Wordpress 爛歸爛，但如果不挑的話，還算是可以用。一直以來，我都認為自己寫文章的速度，若不被平台和工具綁住的話，其實寫作速度還可以更快，寫作興致還可以更高昂。

想歸想，但實際上找不出解法去解決問題。

這件事，一直到了我漸漸接觸到了 Markdown 、 [iAWriter](www.iawriter.com) / [Mou](http://mouapp.com) 、 [Jekyll](https://github.com/mojombo/jekyll) / Octopress，慢慢被改變了。

後來實際用了 Octopress 認真架了一個關於 「[Upgred2Rails31](http://upgrade2rails31.com/)」 的教學網站，放置升級到 Rails 3.1 的教學筆記。

寫著寫著，更加深了我這樣的信念。我寫作的速度，文章的長度，還有文章的有趣度，無一不被提高了！

加上我本身的職業就是 Ruby Developer，要 **Hack** 這個系統根本不是什麼難事。這個職業反而有加分作用。

最後，就是你看到的：我終於鼓起勇氣把用了五年的 Wordpress 扔掉了 XD

 




