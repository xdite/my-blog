---
layout: post
title: "OmniAuth - 實作多方認證的最佳實踐 (3)"
date: 2011-11-19 12:43
comments: true
categories: 

---

OmniAuth 是在 2011/11/2 正式釋出 v1.0 版的，其實也就是不久之前而已…

這個大改版也讓我吃足苦頭，因為 0.3 與 1.0 的架構差太多，網路上 Google 到的文件反而會打爆我的 application，除錯了很久。

不過也因為這件事情，逼我在幾個小時之內認真看了不少關於認證的想法與文件，才從而理解這些架構，寫出這些文章...。

## 0.3 與 1.0 的差異

0.3 與 1.0 的差異，在於 1.0 的架構更直覺、更乾淨。主要改變有二：

* Strategy as Gem
* 標準的資料介面

### Strategy as Gem

在 0.3 版，如果開發者想在 Rails project 內使用 Twitter 的認證。除了必須在 Gemfile 內宣告使用 OmniAuth

``` ruby Gemfile
gem "omniauth"
```

還必須使用一個 initializer 去 claim 他要使用 Twitter 認證

``` ruby config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end
```

而在 1.0 中

開發者只需要這樣作，在 Gemfile 裡面宣稱他要使用 OmniAuth 和 OmniAuth-Twitter

``` ruby Gemfile
gem "omniauth"
gem "omniauth-twitter"
```

#### 注意事項

其實也是這個細微的差異，害我誤入歧途，我按照網路上找到的方案，也在 1.0 版乖乖多寫了一個 initializer 去宣告使用，反而造成 invalid credential。

#### OAuth 惡夢

當然將 Strategy 抽出來當成 Gem 是一件好事，這樣就不用因為某一個認證方 API 改版，就必須 fork 整個 OmniAuth 出來使用。

不過促使 OmniAuth 改版最痛的問題可能是 OAuth 的問題。

我也是因為實作 Github 的認證才發現到這個令人憤怒的 issue。

[BTW: **講個不好笑的笑話，開發與 Github 結合的產品真的很令人困擾，因為你無法使用 "xxx github" 這樣的關鍵字在搜尋引擎找答案，因為結果一定會出現 xxx 在 Github 上的 repo。翻桌！=_=||| **]

這是 OmniAuth 0.3 版當時的 [oa-oauth](https://github.com/intridea/omniauth/tree/3aff8a3d71a5c968f558172750a2a20165d77bc5/oa-oauth/lib/omniauth/strategies) 目錄夾。你可以各家看到關於 OAuth 的認證實作多麼的混亂，逼得開發者只好寫出超多不同的 solution 去應對！

而 Github 雖然號稱已經[支援 OAuth 2.0](https://github.com/blog/656-github-oauth2-support) (賀!?)，但令人崩潰的是，它也不是標準的。[Rails in Action](http://www.manning.com/katz/) 作者 Ryan Bigg 在寫作此本書範例程式的認證部分時，曾經憤怒的發現這一個事實，並把故事始末紀錄在這篇文章「[Whodunit: Devise, OmniAuth, OAuth or GitHub?
](http://ryanbigg.com/2011/04/whodunit-devise-omniauth-oauth-or-github/)」

**OAuth 2.0 的規格說，token param 必須命名為 oauth_token，而 Github 的卻叫作 access_token。**

而且 Github 不打算修這個問題…

所以如果在 0.3 版的 OmniAuth，你必須要 hack OAuth2 這個 gem 才能支援 Github...。而如果你同時要想支援 Facebook 認證，那就哭哭了 T_T

#### 小結

而既然大家都這麼亂搞，不如把 Strategy 通通抽出來讓開發者在自己的黑箱內惡搞，可能還是比較快的一個方式....


### 標準的資料介面

在 OmniAuth 拿資料的方式是存取 `env["omniauth.auth"]` 這個變數，裡面會回傳認證需要的參數與資訊。

[這個目錄](https://github.com/intridea/omniauth/tree/3aff8a3d71a5c968f558172750a2a20165d77bc5/oa-oauth/lib/omniauth/strategies/oauth) 含蓋了所有目前 OmniAuth 0.3 支援的 Strategy，可以看到大家的 auth_hash 通通都寫的不一樣，也是各自為政。

所以在 1.0 版，OmniAuth 將強迫大家走同樣的規格回來，這些使用者資訊將會切成四種 DSL methods : `info`, `uid`, `extra`, 和 `credentials`。

這個部分在[上一篇](http://dev-xdworks.dev/posts/2011/11/19/omniauth-clean-auth-provider-2/)談架構時已經寫過，就不再重寫一遍了。

## 小結

經過這一番折騰，最後我還是成功用 OmniAuth 1.0 實作了 Github 認證。我將在下一節中示範如何整合。

但如果你還是想要用 0.3 實作 OmniAuth + Github 。我推薦你可以參考這篇 Stackoverflow 上的 [GitHub OAuth using Devise + OmniAuth](http://stackoverflow.com/questions/5611023/github-oauth-using-devise-omniauth) 討論。

* Ryan Bigg 有個 [ticketee](http://github.com/rails3book/ticketee) 的 project 可以參考。（我不保證它能動）

* Markus Proske 也有個 [omniauth_pure](http://github.com/markusproske/omniauth_pure) 的 project 可以看。

Good Luck!


