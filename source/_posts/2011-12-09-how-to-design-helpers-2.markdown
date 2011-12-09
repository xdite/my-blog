---
layout: post
title: "How-to-design-helpers-2"
date: 2011-12-09 16:36
comments: true
categories: 
---

本系列第一篇：

[如何運用 / 設計 Rails Helper (1)](http://blog.xdite.net/posts/2011/12/08/how-to-design-helpers/)

===

## 為什麼在專案中我們要撰寫「自用」 Helper？

### 其一：在 View 裡面實作 LOGIC 是不好的。

#### 造成效能低落

在 [對於使用 Render Partial 的一些誤解](http://blog.xdite.net/posts/2011/12/04/misunderstanding-about-render/) 一文中。我有解釋過一部分的原因：「效能低落」。原因是 ERB 是用 eval 實作 執行 Ruby code 的。在 View 裡面穿插大量的 LOGIC 會造成 render 的效率低落。

#### 造成程式碼混亂難讀

View 在 MVC 的模式中，原本就是只為了做 UI 輸出的功用的。如果有程式邏輯，或者是資料查詢，應該挪到 Controller 或 Model 去做。

這通常在 PHP 出身轉過來的 Programmer，比較能找到這樣的問題。原因是在 PHP 寫作，這樣是很天經地義的作法。但眾所週知的，PHP 的 project 也特別容易藏汙納垢。

如果你拿到一個 Project，View 一打開來都 7-8 頁以上，別懷疑，肯定都是 LOGIC in View 造成的。而根據經驗，有長 View 問題的 project，往往比長 controller 的 project 還要難纏。

一個 view 若有著很多 if / else / elsif , query_some_data。又有著 if / else / elsif , change some css class ?

人的大腦不是 Ruby Interperator，很難腦內想像這麼複雜的 code 會長什麼樣子，沒多久就會當機的....

### 其二：讓 View 更加直觀好維護。

``` html
  <% if current_user && (post.user == current_user || current.user.is_forum_admin? || current.user_is_admin? ) %>
	<%= link_to("Edit", edit_post_path(post) ) %>
  <% end %>
```

看的懂這段 code 的意圖嗎？

這段還算簡單，我想你應該猜的到。不過如果這一段 code 再經過兩三輪的維護，我想應該就面目全非了。

其實應該要這樣做，把邏輯拆出來，放在 Helper 裡。就像這樣：

``` html
  <% if can_edit?(post) %>
     <%= link_to("Edit", edit_post_path(post) ) %>
  <% end %>
```

後續維護者就知道，這一段程式碼就是在表示：**如果當前使用者有權限編輯，就應該顯示編輯頁面的連結。**


### 其三：給 Code 取名字，容易尋找並複用成果。

上面一段 Code 其實還不算好，這一段 code 只說了：**如果當前使用者有權限編輯，就應該顯示編輯頁面的連結。**。它還是沒有自己的意思。但其實這一塊原始碼的意圖是，若有編輯權限，這裡應該應顯示一塊 Toolbar。

``` html
<%= render_tool_bar %>
```
包裝成 Toolbar 後，這一塊程式碼就變得有名字了，下次你在某個頁面要寫到類似的功能時，就只要呼叫 render_too_bar 就可以了。

而最重要的，是你以後再維護這一塊程式碼時，完全不必再猜測程式意圖，也很容易找當初亂丟在哪裡了。


### 其四： 不會被以前寫的 Code 害死。

像這種 code 在網站初期建設時沒有什麼不好。

``` html
  <% if current_user && (post.user == current_user || current.user.is_forum_admin? || current.user_is_admin? ) %>
	<%= link_to("Edit", edit_post_path(post) ) %>
  <% end %>
```

但是一旦接近完工就要儘快 refactor 掉它。這種 code 一旦越來越多，網站就會更難維護。

像是我的 Team 或專案都有一個慣例，一旦專案開發快到尾聲。我一定會開始整理 code，把重複的 code 包成有名字的 Helper。

有什麼好處呢？

1. 網站以後要進行結構重整時，只要調整已定義好的 Helper 內部架構就好了。如果還是東一個西一個到處亂放，同樣的東西重複貼 10 個地方，將來想要調整就要改 10 遍。相信我，你不喜歡在「改版時期」改 code 改 10 遍。就算 git grep 還是會改漏掉…

2. painless 升級 Rails 版本。有很多人好奇我手上的每個專案，為何可以一路從 2.3.x 一路升升升到3.1.x 去。卻還是輕鬆愉快？

中間不是有令人抓狂的 html_escape API 問題？asset_pipeline 架構調整？這些都是很 painful 的過程。不少人都在升版過程中放棄了。為什麼我們還是寫意的辦到了。

這不是有沒有寫 test 的關係，是在於有沒有定期整理 code 的習慣。

不管是 helper / partial / controller / model ，只要是重複的 code ，定期都會進行封裝整理。就算有東西爆炸，也只要調整一下 helper 或者是 model 的輸出，就辦到了。

所以就算 Rails 要升版，精力也都是集中在處理幾個 decrapteed method 或 imcompatiable API 的調整。就算 view 爆掉，也只要改一個地方，10 個地方都會生效。自然寫意無比。


### 其五：容易複用並開創專案打下來的 best practices

在進行專案過程中，也會漸漸的養出自己的一套 HTML 架構 與 CSS (SCSS)。很多元件在不同專案中都是共通的，比如說自己用來 bootstrap （非 twitter）專案的 view 和 helper。

navgation_bar, user_bar, breadcrumb, menu list, table, button,gravator 這些都是專案必備。

這是前東家 [Handlino](http://handlino.com) 設計的一套 helper
<https://github.com/handlino/handicraft_helper>

可以很方便就寫出 menu, table, body class with browser type, breadcrumb…etc.

而我作網站還會多上幾套自己養出來的標準 Helper 

* SEO 最佳化實踐
* Social Media Share-Friendly
* Content Site 常用功能最佳實踐 

專案越寫越多，後期越來越輕鬆，但不管之後再寫什麼新網站，依舊是幾乎都預設含有以前維護舊網站時打下的 Best Practices.


// 最近的目標換在整理 SCSS …

===

接下來幾章將會介紹：

什麼是不好的 Helper Pattern 應儘量避免、自用 Helper 的設計整理原則、如何將常用 Helper 抽取出來可以複用。

