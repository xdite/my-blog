---
layout: post
title: "Strong Parameter: Mass Assignment 機制的防彈衣"
date: 2012-08-12 02:16
comments: true

---

還記得年初才發生的 [Github 被入侵事件](http://blog.xdite.net/posts/2012/03/05/github-hacked-rails-security/) 嗎？

事件的起因是因為 Rails 內建的 mass assignment 機制，很容易被有心人利用這個漏洞入侵。

原本的 attr_accessible / attr_protected 的設計並不足夠實務使用。在該事件發生後，Rails 核心團隊在 3.2.3 之後的版本，預設都開啟了 `config.whitelist_attributes = true` 的選項。

也就是專案自動會對所有的 model 都自動開啟白名單模式，你必須手動對每一個 model 都加上 attr_accessible。這樣表單送值才會有辦法運作。

這樣的舉動好處是：「夠安全」，能強迫開發者在設計表單時記得審核 model 該欄位是否適用於 mass-assign。

但這樣的機制也引發開發者「不實用」「找麻煩」的議論。

### 問題 1: 新手容易踩中地雷

首先最麻煩的當然是，新手會被這一行設定整到。新手不知道此機制為何而來，出了問題也不知道如何關掉這個設定。更麻煩的是撰寫新手教學的人，必須又花上一大篇幅（就如同倒楣的我，想要幫 Rails 101 改版，結果內容無限追加）解釋 mass-assignment 的設計機制，為何重要，為何新手需要重視…etc.

### 問題 2: 不實用

手動一個一個加上 attr_accessible 真的很煩人，因為這也表示，若新增一個欄位，開發者也要手動去加上 attr_accessible，否則很可能在某些表單直接出現異常現象。

而最麻煩的還是，其實 attr_accessible 不敷使用，因為一個系統通常存在不只一種角色，普通使用與 Admin 需要的 mass-assignment 範圍絕對不盡相同。

雖然 Rails 在 3.1 加入了 [scoped mass assignment](http://enlightsolutions.com/articles/whats-new-in-edge-scoped-mass-assignment-in-rails-3-1)。但這也只能算是 model 方面的解決手法。

一旦系統內有更多其他流程需求，scoped mass assignment 的設計頓時就不夠解決問題了…

### 癥結點：欄位核准與否應該由 controller 管理，而非 model

大家戰了一陣子，終於收斂出一個結論。原來一切的癥結點在於之前的想法都錯了，欄位核准與否應該由 controller 決定。因為「流程需求」本來就應該作在 controller 裡面。wycats 當時也起草了一份[解法的 proposal](https://gist.github.com/1974187)。日後打算以 plugin 方式釋出。

### plugin：strong_parameter

現在 plugin 出來了。（其實出來很久了，只是我一直沒寫文章...) 就是 [strong_parameters](https://github.com/rails/strong_parameters/) 。strong_parameters 的想法與 DHH [當時扔出來的想法](https://gist.github.com/1975644) 相近。

DHH 當時的作法

{% gist 1975644 %}

是使用 slice 去把真正需要的部分切出來，所以就算 hacker 打算送其他 parameter 也會被過濾掉(不會有 exception)。

而 strong_parameters 的作法是必須過一段 permit，允許欄位。如果送不允許的欄位進來，會 throw exception。

``` ruby
class PeopleController < ActionController::Base
  def update
    person.update_attributes!(person_params)
    redirect_to :back
  end

  private
    def person_params
      params.require(:person).permit(:name, :age)
    end
end
```

安全多了，擴充性也比較大...

### 進階用法

當然，每一段 controller 都要來上這麼一段，有時候也挺煩人的。Railscast 也整理了一些[進階招數](http://railscasts.com/episodes/371-strong-parameters)：

* Nested Attributes
* Orgngized to Class

大家可以研究看看…

