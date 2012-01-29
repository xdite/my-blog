---
layout: post
title: "如何從 Wordpress Migrate 到 Octopress"
date: 2011-10-09 18:09
comments: true
categories: 
---

### 文章轉換

如果你不 Care 你的舊連結能不能動，只在乎內容和 Comment 能不能搬而已。

* 使用 Jekyll Convertor

我改了一支 [convertor](https://gist.github.com/1273518)，可以從 Wordpress XML 匯入文章，並解決中文問題。

（是的，老外才不管 UTF8 死活。）
（有問題我不負責保固，請自行修理）

### 留言轉換

* 把 Comment 倒進 DISQUS

DISQUS 與 Wordpress 與 Octopress 都有良好的整合。你可以把 Woordpress XML 先 import 進 DISQUS 引擎，處理完後可以對應回剛剛轉的 markdown（裡面會有記 wordpress\_id）。

### 圖片轉換

我個人習慣很好，平日貼圖都貼在 Flickr 上，沒有這樣的問題。

（有這樣問題的人，請自行解決。）

### RSS Feed

我個人習慣很好，幾年前就將 feed 代管在 [feedburner](http://feedburner.com/) 之上。

（有這樣問題的人，請自行解決。）

### Facebook Likes 數

你瘋了嗎？

### 使用舊有網址

* 如果你之前的 網址是使用 ?p=XXX 作為永久網址，目前此題無解。
* 如果你是之前有已經定義好的 permalinks，你可以使用修改 Jekyll Convertor，將 permalink 加入轉換選項裡

<https://github.com/mojombo/jekyll/wiki/YAML-Front-Matter>

## 大絕招

如果你是像我一樣，覺得轉換成本代價過高，只是想另起爐灶而已。就不要管之前的 Blog 怎樣了，改個網址做 301 重新導向就好。


### 301 轉址

這招只適合使用在自己 hosting 或 heroku 之上。因為 Github pages 不支援 .htacess 設定，只能放置靜態檔案。
我是放在 Heroku 上，使用 [rack-rewrite ](https://github.com/jtrupiano/rack-rewrite) 做到對過去的網址 301 轉址。

```ruby Gemfile
gem "rack-rewrite"
```

```ruby config.ru
require 'rack/rewrite'

use Rack::Rewrite do
 
 r301 %r{/\?p=(.*)?},  "http://wp.xdite.net/?p=$1" 
 r301 %r{/\?s=(.*)?},  "http://wp.xdite.net/?s=$1" 
 r301 %r{/\?feed=(.*)?}, "http://feeds.feedburner.com/xxddite"  
 
end
```

這簡單三行我可是琢磨了好幾個小時啊 :/