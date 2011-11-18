---
layout: post
title: "OmniAuth - 實作多方認證的最佳實踐 (2)"
date: 2011-11-19 03:33
comments: true
categories: 

---

[OmniAuth](https://github.com/intridea/omniauth)  本身並不是一套被限於特定框架、特定認註冊系統上的認證方案，而是一個基於 Rack 的「認證策略提供者」。


## 主要架構

### Provider

OmniAuth 將所有的提供認證方，通通視為不同的 Provider，每一種 Provider 有一個 Strategy。不管你是 Facebook、還是 LDAP，通通擁有各自的 Strategy。

### Strategy

每一個 Strategy 分為兩個 Phase：

* request phase
* callback phase

而 Omniauth 提供了兩個主要的 url

* /auth/:provider
* /auth/:provider/callback

當使用者 visit /auth/github 時，OmniAuth 會將你導到 Github 去作認證。而認證成功之後，會 redirect 到 callback 網址。通常我們會在 callback 網址作 session create 動作（透過拿回來的資料 find_or_create user）

#### 使用 Strategy 的好處

使用 Strategy 的好處很多。最明顯的我覺得有幾點：

##### 1.能夠將 routhing 切得很乾淨。

這點顯而易見。

##### 2.能夠在網路不通下繼續實作認證。

有時候開發中，可能正用本機網址，無法實作 callback。有時候是網路不通。OmniAuth 可以讓我們使用一套 developer strategy 去 "fake"。

所以在開發過程中，即便網路不通，我們還是可以透過寫 developer strategy 的方式，拿到同格式的假資料，完成假認證、假 callback。

``` ruby lib/developer_straegy.rb

require 'omniauth/core'
module OmniAuth
  module Straegies
    class Developer
      include OmniAuth::Strategy
      
      def initialize(app, *args)
        supper(app, :developer, *args)
      end
      
      def request_phase
        OmniAuth::Form.build url:callback_url, title: "Hello developer" do
          text_field "Name", "name"
          text_field "Email", "email"
          text_field "Nickname", "nickname"
        end.to_response
      end
      
      def auth_hash
        {
          'provider' => 'twitter'
          'uid' => request['email'],
          'user_info' => 
          {
            'name' => request['name'],
            'email' => request['email'],
            'nickname' => request['nickname']
          }
        }
      end
    end
  end
end

```

（ 這是 0.3 範例，出處為 [OmniAuth, 昨天今天明天](http://cn.intridea.com/2011/07/omniauth-intro/)）

而新的 1.0 Strategy Guide 已經 [釋出](https://github.com/intridea/omniauth/wiki/Strategy-Contribution-Guide)，一個 Strategy 需要完成的部分大致上有這三個：

1. request phase 如何完成
2. callback phase 如何完成
3. 定義回傳需拿到的資料：如 provider name、uid、email、以及 extra info


### User Info

在 0.3 版的範例裡面，可以看到回傳的資訊是使用 auth_hash 去包。這也導致了另一個混亂的局面，各種不同的 Strategy 寫了不同的 auth_hash，把 auth_hash 拉回來時，create User 的介面相當混亂與醜陋。

而自 1.0 版起，這些使用者資訊將會切成四種 DSL methos : `info`, `uid`, `extra`, 和 `credentials`。

``` ruby
class OmniAuth::Strategies::MyStrategy < OmniAuth::Strategies::OAuth
  uid { access_token.params['user_id'] }

  info do
    {
      :first_name => raw_info['firstName'],
      :last_name => raw_info['lastName'],
      :email => raw_info['email']
    }
  end

  extra do
    {'raw_info' => raw_info}
  end

  def raw_info
    access_token.get('/info')
  end
end

```

把基本資訊的存取切分的更清楚。

讓我把各家新版的 Strategy 翻出來介紹給大家吧：

看完這些 example，相信你可以更了解這些資訊架構後面的想法是什麼。

* [omniauth-twitter](https://github.com/arunagw/omniauth-twitter/blob/master/lib/omniauth/strategies/twitter.rb)
* [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook/blob/master/lib/omniauth/strategies/facebook.rb)
* [omniauth-githuib](https://github.com/intridea/omniauth-github/blob/master/lib/omniauth/strategies/github.rb)

## 小結

而因為 OmniAuth 是 rack-middleware，且介面單純的緣故（ 兩組統一 url），因此可以接在各種任何支援 Rack 的任何 Ruby Web Framework 上，在這一層之上就完成握手交換資訊的互動。**於是整個認證過程就可以「框架」和「框架上的傳統認證方案」完全切割分離**，開發者可以透過這兩組介面完成傳送與接收資訊的動作，而不需像傳統實作，必須大幅客製 controller 與 routing 遷就 provider。

下一節我將繼續介紹，為何 OmniAuth 要自 0.3 大幅改版至 1.0 。


