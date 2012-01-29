---
layout: post
title: "OmniAuth - 實作多方認證的最佳實踐 (4)"
date: 2011-12-05 21:40
comments: true
categories: 
---




兩週前談到 OmniAuth，還剩下最後一篇欠稿：實作篇。來還債了...

* [OmniAuth - 實作多方認證的最佳實踐 (1)](http://blog.xdite.net/posts/2011/11/19/omniauth-clean-auth-provider-1/)
* [OmniAuth - 實作多方認證的最佳實踐 (2)](http://blog.xdite.net/posts/2011/11/19/omniauth-clean-auth-provider-2/)
* [OmniAuth - 實作多方認證的最佳實踐 (3)](http://blog.xdite.net/posts/2011/11/19/omniauth-clean-auth-provider-3/)

本來還在煩惱怎樣給出一個 demo app。剛好最近幫忙翻修 <http://ruby-taiwan.org>。網站的 0.3 => 1.0 的升級就是出於筆者之手。

乾脆拿這個網站直接來講...

若最後還是看不懂示範的可以直接 [clone 專案](git://github.com/rubytaiwan/ruby-taiwan.git)下來直接 copy。

## Install Devise

1. 安裝 Devise
2. `rails g devise User` 產生 User model
3. `rails g model Authorization provider:string user_id:integer uid:string` 產生 Authorization Model

User **has_many** Authorizations

``` ruby

class User < ActiveRecord::Base
  has_many :authorizations

```

``` ruby

class Authorization < ActiveRecord::Base
  belongs_to :user

```

## Install OmniAuth 

* 安裝 OmniAuth 1.0 
* 安裝 omniauth-github 與 omniauth-twitter

``` ruby Gemfile
 gem 'devise', :git => 'https://github.com/plataformatec/devise.git'
 gem "omniauth"
 gem "omniauth-github"
 gem "omniauth-twitter"
```

* 定義 :omniauthable

在 User model 內加入 `:omniauthable`

```ruby 

 devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable, :omniauthable
```

* extend OmniauthCallbacks

在 `User` model extend OmniauthCallbacks

``` ruby app/model/user.rb

class User < ActiveRecord::Base
  extend OmniauthCallbacks

````

* 新增 `app/model/users/omniauth_callbacks.rb`

具體內容請看這裡 <https://github.com/rubytaiwan/ruby-taiwan/blob/master/app/models/user/omniauth_callbacks.rb>

主要是拿 callbacks 回來的東西 new_from_provider_data 塞進去。先找有沒有，有找到回傳 user。沒找到從 data 裡塞資料進去，同時建立 provider 與 uid 關係。


## 設定 route 與 controller

`config/routes.rb`

``` ruby

  devise_for :users, :controllers => { 
    :registrations => "registrations",
    :omniauth_callbacks => "users/omniauth_callbacks" 
  } do
    get "logout" => "devise/sessions#destroy"
  end
```

`app/controllers/users/omniauth_callbacks_controller.rb`

具體內容看這裡 <https://github.com/rubytaiwan/ruby-taiwan/blob/master/app/controllers/users/omniauth_callbacks_controller.rb>


光用  `app/model/users/omniauth_callbacks.rb` 與 `app/controllers/users/omniauth_callbacks_controller.rb` 這兩招就可以把 callback 和 provider 切得很漂亮了。


## 申請 OAuth 

各大網站都有審請 OAuth 的機制：

* Twitter: <https://dev.twitter.com/apps/new>
* Github: <https://github.com/account/applications>

如果你是使用 ruby-taiwan 這個 project 的話

* 網址填 http://ruby-taiwan.dev/
* Call 網址填 http://ruby-taiwan.dev/account/auth/github/callback

** 一定得這樣填，亂改炸掉別怪我.. **

## 設定 token

key 設定都放在這裡 `config/initializers/devise.rb`

<https://github.com/rubytaiwan/ruby-taiwan/blob/master/config/initializers/devise.rb>


``` ruby config/initializers/devise.rb
  config.omniauth :github, Setting.github_token, Setting.github_secret
  config.omniauth :twitter, Setting.twitter_token, Setting.twitter_secret
  config.omniauth :douban, Setting.douban_token, Setting.douban_secret
  config.omniauth :open_id, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id', :require => 'omniauth-openid'

```

## Link Helper

可看 <https://github.com/rubytaiwan/ruby-taiwan/blob/master/app/views/devise/sessions/new.html.erb>

``` html

          <li><%= link_to "Twitter", user_omniauth_authorize_path(:twitter) %> </li>
          <li><%= link_to "Google", user_omniauth_authorize_path(:google) %> </li>
          <li><%= link_to "Github", user_omniauth_authorize_path(:github) %> </li>
          <li><%= link_to "Douban", user_omniauth_authorize_path(:douban) %> </li>
```

## 小結

這樣就設完了，非常乾淨。如果有任何問題歡迎上 <http://ruby-taiwan.org> 討論。
