---
layout: post
title: "[電子出版] Rails 101 的兩年來的一些數據"
date: 2013-06-02 23:00
comments: true
categories: 
---

[Rails-101](https://leanpub.com/rails-101) 是我兩年前寫的一本 Rails 教學書，前身是我的 Developer 訓練教材 / 解答本。

不少想出書的朋友這兩年來問過我一些大大小小的相關問題，想一想乾脆趁改版作一次解答。


Q: 這一本書兩年來賣了多少本？

A: 接近 2000 本。

Q: 賺了多少錢？

A: 其實沒有仔細算過。因為這本書有時候賣 9.99，有時候特殊節慶我會特價幾天打對折。但總體來說，乘以最佳銷售狀況的 0.6 應該是個合理的數字吧....

Q: 好像比紙本書好賺？

A: 看你怎麼想？出版社大概都是一刷 2000 本，預付版稅大概 5-7 萬元。技術書一刷也不會賣超過這個數量。看起來收入比給出版社出版高不少。但是你可能要考慮

1. 書是我自己排版輸出的
2. 客服信是我自己回的
3. 購物車系統...（呃，還好不是自己做的，不過月費 9 USD）
4. 書的網站是我自己做的…

這本書要付 RD xdite, 客服 xdite, 編輯 xdite, blogger xdite 不少錢....所以 Author xdite 應該沒什麼賺。

Q: 自費出版的優缺點你覺得是什麼？

A: 

#### 優點：小眾市場的書也能賣

小眾市場導向的書也能賣。通常這種書出版社不願意出。但是卻有讀者願意要買，運氣好挑對主題就其實蠻賺的。我看 Leanpub 上有人寫 Larvel 的書就賣了 6000 多本…

#### 優點：技術書籍載體適合電子發行

而且技術書籍的載體蠻適合電子發行，因為內容有時效性。

#### 缺點：排版技術門檻很高

缺點就是排版系統不好搞。寫一本電子書，幾乎 90% 的時間不是在寫書，而是在搞定「該死」的排版系統（下一段會講到...）。而且當你的書裡面有很多程式碼時，就準備排到死吧 -_-

#### 缺點：書籍內容容易過期

我這本書剛寫成時是 Rails 3.0.3。到下架時 Rails 版本是 3.2.13。

當中 Rails stack 有很多技術架構上的轉變，這些讓我在更新書籍時遇到很多麻煩，因為讀者都會想要我支援最新架構，但是有一些 stack 是很難寫進去的....

（比如 rails 在 10.6, 10.7, 10.8 的安裝方法不一樣..orz）

但是其實更新書籍，排版很容易爆炸，所以我不是沒有寫好需要更新的內容，而是每次排版排到生氣我就想放棄了…orz

#### 缺點：書籍讀者認為「更新」是應當的。

一般紙版的書籍，書一旦印出來了，內容就算過期，讀者會摸摸鼻子就算了。但是在電子書上，讀者會認為作者有需要更新內容的義務....

而且應當是免費的 /_\

#### 缺點：讀者認為作者提供 pdf, epub, mobi 三種版本是理所當然的

嗯....雖然我買書時也希望別人都提供，但實際上，排版實在會搞死人啊 XD


Q: 你曾經用哪一些技術進行排版？

A:

(1) 最初我是用 Mac 的 Pages 寫作，但只能轉成 PDF，而且貼 code 很痛苦。

(2). 第二版我就改用 [reStructuredText](http://docutils.sourceforge.net/rst.html) 重新改寫。貼 code 變得很漂亮了，也有辦法寫一些註解，但是裡面的文字編排反而讓人很頭大…邊寫邊排是一個大挑戰

轉 pdf 需要自己 hack 一些 latex 的支援，因為 reStructuredText 當時並沒有考慮到 UTF-8 排版的問題，所以我花了不少時間在解中文內容輸出問題。

這一個版本我有順利同時轉了一個 epub 出來

(3) 在這中間我有試過幾套軟體（不一定是在 101 這本書上）

* a. [Progit](https://github.com/progit/progit) 的排版軟體
* b. [review](https://github.com/kmuto/review) 達人出版會的排版軟體
* c. [Working with tcp-sockets](http://www.jstorimer.com/products/working-with-tcp-sockets) 用的排版軟體 [kitabu](https://github.com/fnando/kitabu)
* d. [Ruby Science](https://learn.thoughtbot.com/products/13-ruby-science) 用的排版軟體 (thoughtbot 自己拼出來的)
* e. [Scrivener](http://www.literatureandlatte.com/scrivener.php) 劇本寫作軟體

個人覺得有用的是 c,d,e 

在這當中踢到的鐵板多數是：

* 軟體喜歡自己發明格式的問題。所以每換一個平台，內容等於要通通重排...
* 解決 latex 中文與相依性套件問題（轉 pdf 所需要的套件）
* 讀者靠北為何沒有贈送 .mobi 的問題
* 為何贈送了 .mobi 卻不支援七吋 kindle 排版的問題....

（我覺得自己真是毅力驚人，要是我不懂寫程式，可能老早就放棄了.....）

Q: 為何這次會選 Leanpub 發行？幹嘛兩年之內搞得這麼累，早用 Leanpub 不就好了...

A:

其實 Leanpub 一出來就想用了。只是兩年前 Leanpub 的問題是，(1) 不支援中文 (2) 不支援排 code (3) 不支援 coding tips。只能排排文學小書，所以很快就被 rule out 了。

這次會進場是因為最近有幾檔強檔 Ruby 新書，特別是 Rails 界聖經 [The Rails4 Way](http://blog.obiefernandez.com/content/2013/04/the-rails-4-way-beta.html) 宣布在 leanpub 上發行…

要知道這本書可是 6-700 頁以上的超級程式巨作，如果他們排的動，那就表示應該沒什麼問題了....

這次進場寫作，也發現意外的順手，所以就打算把早前寫完但放棄排版的書稿，開始搬上去了…

撰寫輸入格式接近 markdown，輸出格式則有 pdf, epub, mobi。能夠滿足讀者需求。

一本書賣 10 元，Leanpub 抽我 1 元。我覺得算是個蠻合理的數字。


Q: 你之前用什麼平台收錢？

A :
[Digital Delivery](http://www.digitaldeliveryapp.com/) + Paypal。這個平台本身不抽交易，但每月使用費 9 USD。所以我的獲利會是每一本書被 paypal 抽的交易稅 + 每個月的使用費。其實算下來跟 Leanpub 其實差不多....

Q: 你不怕電子書被盜版嗎？如何處理買書退費問題？

A: 

寫書「真的」就是一半在作功德的事。其實在作者的立場，其實是希望書能被越多人看到越好。收入有個合理回報就好。

我也遇過跟人「借看」的讀者，最後覺得寫得不錯，寫信過來說自己重新補買的。這次雖然改版我送大家 100% 折價卷，但是也有讀者覺得全新內容很不錯，自己重新付錢補買的…誰知道呢？

至於退費問題，在網路上退費的原則通常是 45-60 天內無條件退費原則。不過其實在賣電子書的各位作者，其實都願意讓大家無限時間退費，只是超過了這個時間，paypal 刷退非常麻煩。所以最後大概都限制 45-60 天。

退錢也不會囉唆。反正不合期待大家都能理解。

不過大陸讀者申請退費數量是台灣的 10 倍這我必須在這裡講一下 XDDD



Q: 有沒有下載 PDF, EPUB, MBI 的數據？

A: 第一版沒有。但第二版有，Leanpub 有提供這個功能。直至剛剛，我這本書總已經發出大約 600 本。

數據如下：


```

Metrics
Book formats downloaded at least once per purchase
97.9% of your readers downloaded PDF format.
60.7% of your readers downloaded EPUB format.
37.6% of your readers downloaded MOBI format.
These numbers won't add up to 100%, as purchases include all formats.

Book formats download profile
34.9% of your readers downloaded PDF only.
1.0% of your readers downloaded EPUB only.
0.5% of your readers downloaded MOBI only.
26.5% of your readers downloaded PDF and EPUB only.
3.9% of your readers downloaded PDF and MOBI only.
0.5% of your readers downloaded EPUB and MOBI only.
32.6% of your readers downloaded all three formats.

```

我目前能整理出常見的內容和問題大概就是這些。對電子出版有興趣的朋友歡迎留言交流....








