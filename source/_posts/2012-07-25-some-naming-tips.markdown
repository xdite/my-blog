---
layout: post
title: "一些 Ruby 命名的技巧"
date: 2012-07-25 01:17
comments: true
categories: Ruby Tips
---

命名是 CS 中兩大[難題](http://martinfowler.com/bliki/TwoHardThings.html)，（ref: 在 DK 週一 [Passion Bean 的 Talk 上聽到的](http://blog.gslin.org/archives/2012/07/24/2931/%e5%9c%a8-passion-bean-%e5%88%86%e4%ba%ab%ef%bc%9asystem-operations-for-startup/) ）。

今天在公司批票，剛好稍微教了一下同事如何設計寫出好讀的 Ruby method 名稱，覺得蠻有價值的，就隨手整理了一下貼上來。

#### 場景

手機需要驗證，需要寫一個 Class 包裝一個手機驗證碼的寄送與儲存。原始的寫法是使用 「auth_gsm」欄位儲存。

### 視狀況使用「能表達情境」的名詞設計欄位 : gsm_authcode

* auth_gsm 的缺點在於讓人看不出來這個字的主題是 gsm 還是 auth。是 gsm 嗎？看起來也不是，只能從字面知道這是跟 gsm 相關的 auth 行為。

* auth_gsm 但這個 auth 到底是驗證的「狀態」，還是被驗證的「內容」？從名詞上看不出來。

* 如果 User Story 是指這是應該傳送給使用者的驗證碼內容。應該被更具體的用名詞設計。

### 使用過去分詞 + "at" 或者是 "is" + 形容詞設計欄位

* 被驗證的時間不應該使用 activated_time 而應該使用 activated_at。因為 time 是表示時間（時間是指什麼時候還是花多久時間？），不是「什麼時候被驗證」。

* 是否已被驗證可以使用「is_activated」配合 boolean （true / false）。

### 使用 ? 表示這個 method 預期會傳回來的值只會是 true/false。

* ruby 允許 method 名稱有 `?`，若 method 名字內有 `?`，開發者會預期回傳值是 true/ false
* `if post.is_hidden?` 比 `if post.is_hidden` 直觀
* `if user.is_activated?` 比 `is_activated` 直觀
* 加上 `?` 更強調了狀態，而非只是驗證欄位是否 true / false
* Array 也有類似用法  array_a.include?(element_a)

通常會在 class 內再對作欄位作一層包裝


```
class Post < AR
   def is_hidden?
     is_hidden
   end
end
```

### 使用動詞與名詞如 generate_gsm_authcode 表示要做的事情

* 不要在 controller 裡面直接使用

```
  user.gsm_authcode == "123456"
  user.save
```

* 應該在 User model 內設計一個可以敘述要作什麼事的 method 包裝起來

```
class User < AR
  def genetate_gsm_authcode
    update_attribute(:gsm_authocode, rand(10))
  end
```

* generate_gsm_authcode （動詞 + 名詞）只做事


### 名詞只是名詞

* 如果 method 只是名詞，不要偷偷動作，而且預期傳回來的要是純量如 String, Array, Hash, Set, Object 

```
class User < AR
  def full_gsm_number
    "#{area_code}-#{gsm_number}"
  end
end
```

### 使用 ! 表示這個 method會改變原先自身的狀態

* String 的 gsub! 與 gsub 是不同的結果與作用。
* 在 Ruby 中如果 method 加上! 通常會預期這個 method 會改變該 object 本身的狀態
* ActiveRecord 的 save 與 save! 會發生的事其實是不同的。
* save 遇到 validation 不過會儲存失敗，但不會 throw excecption。但是 save! 遇到 validation 會 throw exception。
* dalayed_job 還是哪一套 background job 的 gem。method 後面若被加上 ! 表示立即執行不進 queue。

``` 
class User < AR
  def regenerate_authcode!
    # blah
  end
```

### Library 的名稱應儘量為中性，並且貼近實際的責任。

如果這一支程式是拿來傳簡訊的函式，命名應考慮到這支程式應該要作什麼。

* TWSMS (twsms.rb) 是比較好的。原因是這隻程式負責把 API 呼叫「包裝」了起來。

* TWSMSWrapper (twsms_wrapper.rb) 是不好的。因為這隻程式並沒有實際「包裝」了什麼東西。它只是提供了一個介面讓其他人可以呼叫。

* TWSMSSender (twsms_sender.rb) 是不好的。因為這隻程式並沒有實際自己去「呼叫」了外部程式。如果有 twsms_sender.rb 這支程式，裡面應該是一支負責實際去「呼叫」的 services wrapper。就跟 Mailer 的作用一樣。

``` 
module SMSsedner
  def send_to_customer
    # blah
  end
  
  def send_to_vendor
    # blah
  end
end
```

### 動作應該是中性的動詞，但不應該是保留字

這是安全的字

* request
* assign
* ….

這是不安全的字

* send
* save
* ….


### worker 這個字被視為 background worker 。而不是作事的 dispathcher。

worker 通常會負責被視為是去 background job queue 裡面取出來的人。而非 job dispatcher。


## Summary

這是我目前整理出來的一些比較大的方向。如果照著這樣的原則走去寫程式碼，大致上都會蠻乾淨好懂的…

