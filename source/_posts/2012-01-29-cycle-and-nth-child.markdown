---
layout: post
title: "Rails 的 cycle helper 以及 CSS 中的 nth-child"
date: 2012-01-29 00:03
comments: true
categories: 
---

在設計需要顏色循環的表格時你會怎麼作？

<a href="http://www.flickr.com/photos/xdite/6776490237/" title="table by xdite, on Flickr"><img src="http://farm8.staticflickr.com/7157/6776490237_b2418f359b.jpg" width="500" height="146" alt="table"></a>


## Rails 

### 初入門者

#### 使用兩種不同 HTML class : even 與 odd，上不同的顏色

``` ruby
<% count = 0 %>
<table>
<% @items.each do |item| %>
  <% if count % 2 == 0 %>
    <% css_class = "even "%>
  <% else %>
    <% css_class = "odd" %>
  <% end %>
  <tr class="<%= css_class %>">
    <td>item</td>
  </tr>
  <% count += 1%>
<% end %>
</table>

<% end %>
```

### 懂一點 Ruby 

#### Ruby 裡面有 each_with_index，不需要在外部宣告 count

```
<table>
<% @items.each_with_index do |item, index| %>
  <% if index % 2 == 0 %>
    <% css_class = "even "%>
  <% else %>
    <% css_class = "odd" %>
  <% end %>
  <tr class="<%= css_class %>">
    <td>item</td>
  </tr>
<% end %>
</table>
```

### 熟 Rails Helper

#### Rails 有 [cycle](http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html#method-i-cycle) 這個 helper，可以做出循環效果

``` ruby
<table>
<% @items.each do |item| %>
  <tr class="<%= cycle("odd", "even") %>">
    <td>item</td>
  </tr>
<% end %>
</table>
```

### 熟 CSS

#### 使用 pseudo class 中的 [nth-child](http://reference.sitepoint.com/css/pseudoclass-nthchild)

``` ruby
<table>
<% @items.each do |item| %>
  <tr>
    <td>item</td>
  </tr>
<% end %>
</table>
```

用法：`:nth-child(an+b)`

``` css
tr:nth-child(2n+1) {
  color: #ccc;
}
tr:nth-child(2n) {
  color: #000;
}
```

## 小結

快改用 nth-child，不要繼續在 class 裡面寫 even, odd, one, two, three 了 XD
