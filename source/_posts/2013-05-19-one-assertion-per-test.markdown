---
layout: post
title: "One assertion per test & DAMP not DRY"
date: 2013-05-19 22:57
comments: true
categories: 
---

TL; DR : 寫測試兩個鐵律：一次只測一件事情、不要自作聰明幫測試碼 DRY。

最近跟著朋友 [Kevin Wang](http://twitter.com/knwang)，現 [Tealeaf](http://teahleaf.com) (Ruby on Rails 線上教學公司) 教師，前 [Hashrocket](http://hashrocket.com) 工程師，學習寫正統的測試。

找老師直接學下來，果然比自己抄一抄外面的 code ，寫出湊合測試，果然神速許多。

以往寫測試時最讓人迷惑的就是，如何才能測到恰到好處，一段程式碼幾十行，中間有的動作根本不知道要怎麼測，或者是寫了一大堆測試，還是會在某個執行點壞掉，結果測試碼寫到跟程式碼打架。或者是 case 很多，測了 一 在 二 爆炸，測了二，在三爆炸…寫測試寫到火大。

最近才開始領悟到要同時把「程式碼」和「測試代碼」寫好，其實真的很簡單。只是以前沒有機會「好好學」。

其實總歸來說：寫測試只要抓住兩個原則：

* 「One assertion per test」
* 「DAMP not DRY」

就可以解決 80% 的問題。

只是我以前從來就不知道這兩條原則不是寫好玩的（指選擇性遵守），而是寫測試的「鐵律」。

只要你嚴格守住第一條線「One assertion per test」，你的程式碼就會變得非常乾淨。守住第二條線「DAMP not DRY」，你的測試碼就會變得非常好維護。

這兩條用得很熟，你寫測試就再也不會迷惑，到底應該怎樣寫才算「測得對」。

## One assertion per test

One assertion per test 講的其實是：一個測試必須只驗證一件事。這是什麼意思呢？

這是指就算是你的程式碼只有下面幾行的話

``` ruby
def show
  @post = Post.find(params[:id])
  @comments = @post.comments 
end
```

你也必須這樣拆開測

``` ruby
describle "GET show" do 
  let(:post) { Fabricate(:post)} 
  let(:comment) { Fabricate(:comment, :post => post) } 
  
  it "assgin @post variable" do 
    get :show, :id => post
    assigns(:post).should == post
  end
  
  it "assigns @comments to @post.comments"  do 
    get :show, :id => post
    assigns(:comments).should == [comment]
  end
  
  it "render show's view" do 
    get :show, :id => post
    response.should render_tempate :show
  end
  
end
```

而不是擠在一起。如同下面這個測試。

``` ruby
describle "GET show" do 
  let(:post) { Fabricate(:post)} 
  let(:comment) { Fabricate(:comment, :post => post) } 
  
  it "assgin @post variable and assigns @comments to @post.comments and render show's view " do 
    get :show, :id => post
    assigns(:post).should == post
    assigns(:comments).should == [comment]
    response.should render_tempate :show
  end
  
end
```

為什麼守著這個原則這麼重要呢？因為當你在寫類似以下程式碼時

``` ruby
def create

  @post = Post.new(params[:post])
  
  if @post.save
    urls = URI.extract(@post.content)
    urls = urls.uniq 
    urls.each do |url|
      link = @post.links.build(:url => url)
      link.save
    end
    redirect_to posts_path
  else
    render :new
  end
      
end
```

就會下意識的改寫成

``` ruby
def create

  @post = Post.new(params[:post])
  
  if @post.save
    @post.extract_links!
    redirect_to posts_path
  else
    render :new
  end
      
end
```

針對 @post.extrat_links! 再寫一個 unit test，然後在 controller test 中 mock 掉。

一旦不這樣拆，你就會發現「非常難遵守」「One assertion per test」這條定律，更不用說也很難測。當一旦習慣寫 code 拆 method 時，你就會發現程式碼其實會一天一天更乾淨....

而且你會猛然發現，以前那些「很難寫測試的code」，都是那些不喜歡拆 method 拆 class 的 code …


## 「DAMP not DRY」

[DAMP not DRY](http://stackoverflow.com/questions/6453235/what-does-damp-not-dry-mean-when-talking-about-unit-tests)

* DAMP 是指 Descriptive And Meaningful Phrases
* DRY 是指 Don't Repeat Yourself

這是什麼意思呢？

我發現大部分的測試很難改是因為，程式設計師寫 code 寫的最後的一個壞習慣 DRY。

等等？DRY 不是一個好原則嗎？

DRY 在寫程式時是一個很重要的好原則沒錯，它的作用是讓程式儘量好讀好（給人）維護。所以程式師設計在經過良好的寫程式訓練之後，下意識習慣性的在寫任何 code 時都給他 DRY 一下。

很可能就會寫出這樣的測試碼：

``` ruby
describe Post do 
  before do 
    let(:alice) { Fabricate(:user) } 
    let(:bob) {  Fabricate(:user) } 
    let(:post) { Fabricate(:post, :user => alice ) }    
  end

  it "#xxx" do 
    ...
  end
  
  it "#yyy" do 
    ...
  end
  
  it "#zzz" do 
    ...
  end

end
```

這，就，慘，了。

為什麼呢？在剛開始第一次寫這些 test case 的時候，你可能覺得這沒什麼問題，測試都會通過…不過當一個月之後，你的老闆叫你改一些功能的時候，比如說改 `#xxx` 好了，你可能要換掉 alice 這個 sample。這就慘了，一改下去 `#xxx` 是綠燈了，`#yyy` 與 `#zzz` 卻紅燈了。

這時候你就會很幹....要去修一下 `#yyy` 與 `#zzz` 裡的變數，但是改著改著你卻發現要讓 `#yyy` 與 `#zzz`綠燈，其實有時候可能要連原先 `#yyy` 與 `#zzz` 的測試碼也要重寫…

然後你就會相當抓狂：改兩行，然後卻要修 60 行，越寫覺得寫程式碼和寫測試碼的邊界到底在哪裡？好像只有多做工....

DAMP 的原則是要你，在寫測試時 CASE 寫的越清楚越好，甚至「多行重複」也沒有關係。也就是以上的程式碼我們應該改成：


``` ruby
describe Post do 
  it "#xxx" do 
    alice = Fabricate(:user) 
    bob = Fabricate(:user) 
    post =  Fabricate(:post, :user => alice )


    ...

  end
  
  it "#yyy" do 
    alice = Fabricate(:user) 
    bob = Fabricate(:user) 
    post =  Fabricate(:post, :user => alice )
    ...
  end
  
  it "#zzz" do 
    alice = Fabricate(:user) 
    bob = Fabricate(:user) 
    post =  Fabricate(:post, :user => alice ) 
    ...
  end

end
```

它的原則是：開發者要儘量讓寫的每一個測試「環境獨立」。不要被其他測試環境變數的改變，也被影響到。

而且用 before，容易隱藏一些該被測試的 host，不容易 debug。這也是另外一個需要小心的地方...


<hr>

只要這兩條線你守得非常嚴，程式碼和測試碼就會越來越有水準。

至於防守警鐘在哪裡？

* 只要你在 it "xxxx …. and yyyy" 裡面提到 `and` 這個字，基本上就表示你在一個 test 裡測兩件事。你應該開個 context 拆開繼續做成兩個 test，或者再拆一個 it 出來再寫一個 test。

* 只要你想要在 describe 裡面寫 `before`，可能就要小心你又在不小心 DRY 過頭破壞測試的獨立環境了。









