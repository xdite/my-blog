---
layout: post
title: 'Logdown Beta Plan 與 新功能 : Custom Doman, File Upload, Latex Support ...'
date: 2013-07-01 01:45
comments: true
categories: 
---

真是一個刺激的 Hack 週末。自從 [Logdown](http://logdown.com) 在[兩週前推出](http://dev-xdworks.dev/posts/2013/06/17/logdown-blogging-things-markdown/)，得到了不少好評，這股動力讓我們寫起 Feature 更加的賣力。

這個週末（是的。你現在看到這些功能，幾乎都是我們在週末寫的....）， [Logdown](http://logdown.com) 推出了更多功能以及 Beta Plan：

首先是

## Custom Domain ( Beta / Preinum required )

大家期待已久的功能 Custom Domain 功能

![custom_domain.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/xPnFPKoRoCAUfiVCLsHN_custom_domain.png)

## Octopres Import ( Beta required )

可以把 原先的 Octopress 文章壓縮打包成 zip 後，無痛匯入 Logdown 裡面。我們預計在接下來的幾個禮拜測試 Wordpress 與 Movable Type 的匯入

![octopress_import.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/wbO96xUlQQa0zHydnTKH_octopress_import.png)

## Custom Handle & Custom URL

支援原先的 Octopress URL

綜合 Custom Domain / Octopres Import  / Custom Handle & Custom URL 這三項。基本上把 Octopress 搬過來應該沒什麼問題了...

![custom_handle.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/vZwutL0lRhaBG4EjNJVU_custom_handle.png)

## File Uploader ( Beta / Preinum required )

很多朋友一直在問的 File 上傳功能，我們在週末也完成了。目前 Logdown 支援 File drag & drop upload, Flickr, Instagram, Facebook Photo, Picasa, Dropbox Upload!!!! （其實還有更多...）

![file_uploader.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/2W7wmLLKSMurz9uVNFLF_file_uploader.png)

目前暫定 Beta 是 `100 mb`，Prenium Plan 會是 `10GB`。

## 單篇 Markdown 下載

如果只喜歡我們的 Editor 也沒關係，我們支援在 [Logdown](http://logdown.com) 寫完再下載回家貼到 Octopress，但是如果你可以考慮 `搬家` 那就更好了。

![markdown_export.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/lCabxuufTrGGuZ8rAMnt_markdown_export.png)

## 匯出功能

如果哪一天你不喜歡 Logdown 想搬回 Octopress 了，我們也提供了全站打包下載功能，會把所有的文章打包匯出，郵寄到你的 email 裡面。

目前的打包功能只有 Octopres Zip 匯出。我們預計在接下來的幾個禮拜測試與開發 Movable Type 的匯出。

![blog_export.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/y9qqzblpTQSxORrKdsRZ_blog_export.png)

## 更多 syntax ( Especially for Hacker and Scienist ) 


### Octopress Style Code Block ...

是的，我們支援了 Octopress 特有的 code block 寫法，會有 Caption...

{% codeblock %}

  ``` css common.css.scss
    @import "reset";

  ```
{% endcodeblock %}

![octopress_code.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/4Vy0B9xTmO9c5yipC3bs_octopress_code.png)

### Octopress old syntax

我們目前 porting 了 `codeblock` 與 `img` ，預計還會再支援下一個更重要的 `gist` 功能，敬請期待

### Latex Support 

是的，我們喪心病狂的支援了 Latex 語法。你可以透過加入 `mathjax` 來顯示 Latex 語法。而且直接可以在預覽裡面看到結果！！！

![latex_support.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/oPSZt3J2RGCPzteMwaP6_latex_support.png)

![latex_support2.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/yKncEngfSbKHrPe86QVK_latex_support2.png)

## 後續計畫：Beta & Preinum Plan

這兩週我們收到不少朋友的鼓勵與支持，所以我們很認真嚴肅的決定將繼續維護這個產品，而不只是一個 Hackathon 的 pet project。我本人的 blog 部落格也會在近期之內就搬到 Logdown 上。

[Logdown](http://logdown.com) 之後將會有 Preinum 收費的計畫。我們預計的收費計畫將會是 49 USD / year。為了感謝這段期間參與測試的朋友，在八月底前升級 Beta Membership 在轉換為 Preinum 時，我們將只會收取 24.95 USD 的費用。

![beta.png](https://s3.amazonaws.com/logdown-production/user/1/blog/1/post/1815/HfPyJ5Q3RcGe4OOmT4br_beta.png)

以上宣布的這些 Advanced Feature，你可以在後台中找到[升級頁面](http://logdown.com/account/settings/plan)，Upgrade 成 Beta 後進行使用。

## 追蹤我們

你可以透過這兩個管道取得 Logdown 的最新消息。我們也會在重大 Feature 推出時，寫信通知大家。

* [Logdown 官方部落格](http://logdown.com)
* [Twitter:@logdowninc](http://twitter.com/logdowninc)
* Support Email <logdown@rocodev.com>




