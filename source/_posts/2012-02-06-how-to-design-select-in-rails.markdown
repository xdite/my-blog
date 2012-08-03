---
layout: post
title: "在 Rails 中如何設計 Select"
date: 2012-02-06 00:27
comments: true
categories: Rails Tips
---

在 Rails 開發中，有時候我們會遇到要在表單中設計 select 的選項。select 吃的 collection 是個 Array 。通常我們會往往第一直覺的想法是將之塞到 model 的 CONSTANT 裡，再寫一個 class method 包裝起來，再寫自己的 collection Helper 叫出來。

``` ruby
<%
def my_collection_select(title, target_id, default_val, objs)
  html = '<div class="clearfix"><label for="normalSelect">'+title+'</label><div class="input">'
  html += '<select name="'+target_id+'" id="normalSelect">'
  objs.each do |obj|
    selected = (default_val.to_s == obj[:downcase].to_s) ? 'selected="selected"' : ''
    html += '<option '+selected+'value="'+obj[:downcase].to_s+'">'+obj[:titleize]+'</option>'
  end 
  html += '</select></div></div>'
  return raw(html)
end

%>

<%= my_collection_select("職務類別", "job[job_category]", @job.job_category, Job.categories) %>
```

``` ruby
class Job < ActiveRecord::Base
#職務類別

CAT_OTHER                   = 0   #其他
CAT_WEB_DEVLOPER            = 1   #網站設計師
CAT_DESIGNER                = 2   #美術設計師
CAT_PHONE_APP_DEVLOPER      = 3   #手機APP開發
CAT_MARKETING_SALES         = 4   #市場規劃 & 業務
CAT_WEB_SOCIAL_MANAGER      = 5   #社群管理

def self.categories
  [
      {:downcase=>CAT_OTHER, :titleize=>'其他職缺'},
      {:downcase=>CAT_WEB_DEVLOPER, :titleize=>'網站設計師'},
      {:downcase=>CAT_DESIGNER, :titleize=>'美術設計師'},
      {:downcase=>CAT_PHONE_APP_DEVLOPER, :titleize=>'手機APP開發'},
      {:downcase=>CAT_MARKETING_SALES, :titleize=>'行銷&業務'},
      {:downcase=>CAT_WEB_SOCIAL_MANAGER, :titleize=>'社群管理'}
  ]
end

def category_str
   Job.categories.each { |item| 
     return item[:titleize] if item[:downcase] == self.job_category 
   }
end

```

會這樣設計的原因是：通常程式設計師會想要對一個值 assign 一個數字，又想要用一個英文字包裝它，以方便取用。

這樣設計的手法很常見，但其實這樣的設計一聞下來就有「壞味道」。我自己也是思考了這個問題好幾年，換了非常多寫法，直到最近終於想出一個比較好的方式去設計 select。

## 翻修

我設計出一個比較漂亮的方式去改寫這樣的 code。當中用到了 [settings_logic](https://github.com/binarylogic/settingslogic) 與 [simple_form](https://github.com/plataformatec/simple_form) 這兩個 gem。

### Simple Form

``` ruby
<%= f.input :job_category, :label => "職務類別" do %>
    <%= f.select :job_category, Job.categories %>
<% end %>
```

### SettingsLogic

``` ruby app/models/job_data.rb
class JobData < Settingslogic
  source "#{Rails.root}/config/job_data.yml"
  namespace Rails.env
end
```

把數值塞到 settings

``` ruby config/job_data.yml
defaults: &defaults
   job_categories:
      other : 0
      web_developer: 1
      designer: 2
      app_developer: 3
      marketing_sales: 4
      web_social_manager: 5
development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
```

### Rails 內建的 I18n

``` ruby config/locals/job.zh-TW.yml
"zh-TW":
   job_categories:
      other : "其他職缺"
      web_developer: "網站設計師"
      designer: "美術設計師"
      app_developer: "手機APP開發"
      marketing_sales: "行銷&業務"
      web_social_manager: "社群管理"
```
### Model : Job

JobData.job_categories 拉出來會是這樣的內容：

`{"other"=>0, "web_developer"=>1, "designer"=>2, "app_developer"=>3, "marketing_sales"=>4, "web_social_manager"=>5} `

但 select 要吃的是： `[["其他職缺", 0],["網站設計師",1]]` 這樣的 Array。所以我們再用 map 去對 I18n 求值包裝。

``` ruby app/modesl/job.rb
class Job < ActiveRecord::Base

  def self.categories
    JobData.job_categories.map{ |k,v| [I18n.t("job_categories.#{k}"),v] }
  end

end
```

### Helper

最後是如何把 `category_str ` 從 model 搬出來。

#### 這樣很明顯是錯的

* 這應該是 view 要做的事。
* 應該善用 Ruby 的特性，而不是跑 each 比較拿數值。

```
def category_str
   Job.categories.each { |item| 
     return item[:titleize] if item[:downcase] == self.job_category 
   }
end
```

#### 利用 Ruby 的 Hash 的 key，從翻譯檔裡面拿出正確的中文。

``` ruby app/helpers/job_helper.rb
  def render_job_category(job)
    key = JobData.job_categories.key(job.job_category)
    I18n.t("job_categories.#{key}")
  end
```

### 其他

如果以後想拿數值：

可以這樣下：

* `JobData.job_categories[:designer]` => 2
* `I18n.t("job_categories.designer")` => "美術設計師" 
