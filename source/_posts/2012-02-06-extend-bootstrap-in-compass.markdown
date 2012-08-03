---
layout: post
title: "使用 SCSS 的 extend 重複利用 Bootstrap 的 style"
date: 2012-02-06 02:20
comments: true
categories: WebDesign SCSS Bootstrap
---

Twitter 的 [Bootstrap](http://twitter.github.com/bootstrap/) 是一套很好用的 CSS Framework。可以讓開發者加上工具類 CSS 如 `.btn`，就設計出一個按鈕。

但有時候這東西也像 **inline style** 一樣討厭，比如說我要設計一排「按鈕] link，就非得每行都加個 `class = "btn"`。


``` ruby
<div class="job-options">
  <span class="option-title"> 工作類別： </span>
  <%= link_to("網站設計師", jobs_path+"?m_type=1", :class=>"btn ") %>
  <%= link_to("美術設計師", jobs_path+"?m_type=2", :class=>"btn ") %>
  <%= link_to("手機APP開發", jobs_path+"?m_type=3", :class=>"btn ") %>
  <%= link_to("市場行銷", jobs_path+"?m_type=4", :class=>"btn ") %>
  <%= link_to("社群管理", jobs_path+"?m_type=5", :class=>"btn ") %>
  <%= link_to("其他", jobs_path+"?m_type=0", :class=>"btn ") %>
</div>
```

我在開發時並不是使用 Twitter 自己提供的 LESS 版本，而是採用人家拆好的 SCSS 版本 [anjlab/bootstrap-rails](https://github.com/anjlab/bootstrap-rails)。

如何翻修這樣的 code 呢？我使用了 SCSS 的 @extend。

``` scss
.job-options{
   padding-bottom: 10px;
   a{
      @extend .btn;
   }
}
```

``` ruby
<div class="job-options">
  <span class="option-title"> 工作類別： </span>
  <%= link_to("網站設計師", jobs_path+"?m_type=1") %>
  <%= link_to("美術設計師", jobs_path+"?m_type=2") %>
  <%= link_to("手機APP開發", jobs_path+"?m_type=3") %>
  <%= link_to("市場行銷", jobs_path+"?m_type=4") %>
  <%= link_to("社群管理", jobs_path+"?m_type=5") %>
  <%= link_to("其他", jobs_path+"?m_type=0") %>
</div>
```

這樣就可以把 .btn 從 HTML 裡面拿掉了。

### 其他

其實表格也可以比較辦理...

``` scss
#feeds-list{
   @extend .zebra-striped;
}
```
====

不過不能 span2 這種定位的 class 不能 @extend。@extend bootstrap 這招只能用在與「位置」無關的 style 上。
