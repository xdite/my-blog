---
layout: post
title: "Pry ：新一代 Debug 利器"
date: 2012-08-12 18:37
comments: true
categories: Rubygem
---

提起 [Pry](https://github.com/pry/pry)，一般 Ruby 開發者幾乎對這套 Gem 沒有很深的印象。比較有在追社群新聞的人，會知道這是一套新的 IRB 取代方案，但僅此於如此。事實上在近一年前，[Pry 被 Ruby5 報導的原因](http://ruby5.envylabs.com/episodes/173-episode-170-april-26-2011/stories/1526-pry-a-powerful-alternative-to-the-standard-irb-shell-for-ruby) 也是因為很炫的 console。

比如說 Pry 允許開發者在 console 這樣幹：

``` 
pry(main)> cd Article
pry(#<Class:0x1022f60e0>):1> self
=> Article(id: integer, name: string, content: text, created_at: datetime, updated_at: datetime, published_at: datetime)
```

`Article.first`

```
pry(#<Class:0x1022f60e0>):1> first
=> #<Article id: 1, name: "What is Music", content: "Music is an art form in which the medium is sound o...", created_at: "2011-08-24 20:35:29", updated_at: "2011-08-24 20:37:22", published_at: "2011-05-13 23:00:00">
```

`cd name`

```
pry(#<Article:0x102300c98>):2> cd name
pry("What is Music"):3> upcase
=> "WHAT IS MUSIC"
```

允許了開發者利用 console 進行程式的進階探索。當然這樣的 feature 是很炫。但是不算很大幅解決了開發者的問題，所以只被當作是一套還不錯的 shell。就這麼被大家靜悄悄的撇在身後了…

### killer feature: binding.pry

但是大家比較沒有注意到的是，Pry 真正強大的地方不在於它的 console，而是在後面接著演化出的 `binding.pry`。

`binding.pry` 做的是 Runtime invocation。也就是可以在執行時攔截呼叫。這樣講你可能沒有感覺。

真正厲害的用途是：	例如搭配 Rails 使用，在程式碼裡面插入 binding.pry。打開 `rails s`

``` ruby
class CourseController < ApplcationController
  def show
    @course = Course.find(params[:id])
    binding.pry
  end
```

當 browser 打開 <http://localhost:3000/courses/30>，pry 會自動攔下 request，跳出 console 供開發者 debug 。

```
From: /Users/xdite/Dropbox/projects/mentorhub/app/controllers/courses_controller.rb @ line 20 CoursesController#show:

    20: def show
    21:   @course = Course.find(params[:id])
 => 22:   binding.pry
    23: end
```

開發者可以在 console 直接就拉出 @course 這個 object 出來看

```
[1] pry(#<CoursesController>)> @course
=> #<Course id: 30, name: "voluptas", user_id: 1, course_topic_id: 2, plan: "Laboriosam labore soluta debitis excepturi consequa...", hourly_rate: 822, location: "Taipei", course_type: nil, created_at: "2012-08-12 09:41:21", updated_at: "2012-08-12 09:41:21", video_link: nil, video_link_html: nil>
```

也可以繼續追下去看裡面的東西

```
[2] pry(#<CoursesController>)> cd @course
[3] pry(#<Course>):1> plan
=> "Laboriosam labore soluta debitis excepturi consequatur et eos et et praesentium doloremque. qui debitis ab est rerum aut velit fuga ut nemo omnis eum praesentium voluptatem ut. eum fugit rerum fuga error architecto quod nesciunt assumenda in. dicta "
```

`binding.pry` 可以 Runtime 攔截呼叫物件，這讓開發者在寫一些複雜 Library 或者是 API 交涉資訊時，頓時就變得如虎添翼。因為每次在解決這類需求時，狀況都很像被綁黑布蒙著眼開發，最討厭的就是每次還要不斷的執行「印出」 debug，效率低落的驚人。

### pry-nav

也因為 `binding.pry` 太好用。社群也基於 Pry 繼續做了其他的 pry 的 plugin。最 killling 的就是 [pry-nav](https://github.com/nixme/pry-nav)。

pry-nav 做的就是可以讓你在 `binding.pry` 的攔節點前後，作 `next`、`step`。直接一行一行的逐一 debug。

相信我，如果你在寫通訊交涉的 Library，或者是正在改複雜的 Rails View。用到 pry + pry-nav 鐵定會感動到哭出來 XD

### pry-remote

Pry 搭配 Rails，在往常的作法只有 `rails s` 可以叫出 debug console 而已。但很多人實際上是使用 [Pow](http://pow.cx) 作為開發用 HTTP Server。

這樣的需求可以用 [pry-remote](https://github.com/Mon-Ouie/pry-remote) 解決。pry-remote 的作法是把原本的 `bindig.pry` 改成 `binding.remote_pry`。

而 `binding.remote_pry` 會開一支 DRb 起來，開發者再用 `pry-remote` 連到 debug console。

## 小結

Pry 在短短一年間，已經默默的演化出一個龐大的生態圈，只是這當中的過程並沒有大張旗鼓，所以很多開發者並沒有發現 Pry 其實已經默默從 console shell 進化到超強 Debugger 了。

[Pry 的 wiki](https://github.com/pry/pry/wiki) 上有著相當大的相關資源，相當值得各位繼續探索下去…

### 同場加映

[rack-webconsole](https://github.com/mrbrdo/rack-webconsole) 一樣是 pry 的應用，可以在 webpage 裡面直接開 console 改東西…超酷的


