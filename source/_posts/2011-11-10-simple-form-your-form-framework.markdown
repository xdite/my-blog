---
layout: post
title: "Simple Form - 你的 Form Framework"
date: 2011-11-10 02:20
comments: true
categories: Rubygem

---

今天在 RGBA 跟 [DK](http://blog.gslin.org) 嘴砲聊 Twitter 釋出的 [BootStrap](http://twitter.github.com/bootstrap) 這套 CSS Framework，才雄雄想起來我前幾週寫了一個小玩具，忘記拿出來講。

我曾經在 [Asset Pipeline 的重大意義：Version Control Your Asset Package](/posts/2011/10/18/asset-pipeline-version-control-assets/) 提過 [bootstrap-rails](https://github.com/anjlab/bootstrap-rails) 這個 gem。

Rails 社群這群狂徒當然不會放棄把 Bootstrap 扔進 Gem 做 Asset Pipeline 的機會。事實上，Bootstrap 還是大家練習包 Asset Gem 的絕佳練習對象。你可以在網路上 Google 到一堆 bootstrap-rails 的 gem，幾乎都是在做同樣的事 XD

不過 Asset Gem 包好了，剩下來的問題就是… Helper。Bootstrap 是提供了樣式，但是這些被指定了 class 的 HTML呢？

有麵包屑、列表、警告訊息、表單，別跟我說你還是想要手寫啊？

Rails Developer 要有骨氣一點，要繼續秉持著懶的寫 HTML 的精神繼續寫 Ruby XD

所以我的練習作業跟人家不一樣，我是跑去寫 Rails Helper，我把原先的 Asset Gem fork 出來 [一份](https://github.com/xdite/bootstrap-rails)，然後寫了幾乎所有可以拿來練的 HTML Helper …XD

寫一般 HTML Helper 還算簡單，基本上也是拿 [前輩寫過的 Helper](https://github.com/techbang/handicraft_helper) 改一改 DOM 結構扔進去包成 Gem。

但是寫 Form Helper 就很麻煩了。因為表單元件除了 text_field 與 text_area 這兩個選項外的，實在千奇百怪，什麼鬼 case 都有。本來之前也想秉著硬幹魂硬幹到底，折騰兩個小時以後就決定砍掉放棄了。

本來想說跑去看看其他 Form Gem 如何設計，自己也來寫一套 Form Helper。結果看完第一套 Gem [simple_form](https://github.com/plataformatec/simple_form) 我就投降了。simple_form 考慮得**很周全，幾乎什麼 case 都考慮到了**。

要重造一台精密坦克，即便是只有 clone 履帶也可能超過我能力。

我馬上放棄自己寫 Form Helper 的念頭。方向換成鑽研如何使用 simple_form 自動產生出來的表單，改成可以直接 bootstrap 樣式的 HTML。

本來最初的想法也是直接 override helper method，這樣最快。因為 simple form 自己產生出來的表單欄位，外面還是會產生出來一堆包覆用的 styling div。

後來看完 source 繞了一大圈才發現，README 上面就有說明，simple_form 提供直接「抽換」template 的選項。

也就是可以透過 override `def input` 這個 method，可以達到改變 styling div 的目的。

所以我做的事就變成[重寫 form builder](https://github.com/xdite/bootstrap-rails/blob/master/lib/bootstrap-rails/helper.rb) 

``` ruby
module Bootstrap
  
  class CustomFormBuilder < SimpleForm::FormBuilder
    def input(attribute_name, options = {}, &block)
       "<div class='clearfix'>#{super}</div>".html_safe
    end

    def button(type, *args, &block)
      options = args.extract_options!
      options[:class] = "btn primary"
      args << options
      "<div class='actions'>
        #{super}
      </div>".html_safe
    end
  end
end
```
和 [override input helper](https://github.com/xdite/bootstrap-rails/blob/master/lib/bootstrap-rails/form_inputs/collection_input.rb) 再包進自己的 Helper Gem 內。

``` ruby
class CollectionInput < SimpleForm::Inputs::CollectionInput
  def input
    "<div class='input'>#{super}</div>".html_safe
  end
end
```

寫表單再也不需要辛苦的手包 div 調整 style。

可以維持用原先 simple_form 的這種標準寫法，卻產生出符合 bootstrap style 的 form。

``` ruby
<%= bootstrap_form_for :post, :url => posts_path do |f| %>
  <%= f.input :username, :disabled => true, :hint => "You cannot change your username." %>
  <%= f.button :submit %>
<% end %>
```

如此一來，以後我 bootstrap 任何 project 就可以直接引入自己寫的 [xdite-bootstrap-rails](https://github.com/xdite/bootstrap-rails) 這個 gem，一次搞定 Form , HTML , CSS , JavaScript 的問題。

繼續懶惰下去。甚至可能乾脆寫成 rails template，因為也許 template 可能才 3 行而已？

寫完這個 gem，我突然間理解為什麼 simple_form 打遍天下無敵手，因為它本身就是一套 Form Framework。其他人實在沒有再造一套輪子的必要，透過 override template，你幾乎可以造出各式各樣的表單欄位....

