---
layout: post
title: "Don't Name Your Ruby Project With Underscore on Github"
date: 2012-02-09 16:15
comments: true
categories: 
---

I had a ruby project named "[bootstrap_helper](https://github.com/xdite/bootstrap_helper)", which has 43 watchers on Github.

<a href="http://www.flickr.com/photos/xdite/6845375847/" title="螢幕快照 2012-02-09 下午4.09.51 by xdite, on Flickr"><img src="http://farm8.staticflickr.com/7026/6845375847_0eed10698d.jpg" width="500" height="100" alt="螢幕快照 2012-02-09 下午4.09.51"></a>

I thought having 43 watchers is sort of popular. But there is a weired thing:  when I search keyword : "bootstrap helper", my gem is not in first page result.

<a href="http://www.flickr.com/photos/xdite/6845392075/" title="螢幕快照 2012-02-09 下午3.59.56 by xdite, on Flickr"><img src="http://farm8.staticflickr.com/7045/6845392075_cfcd2676c5.jpg" width="500" height="485" alt="螢幕快照 2012-02-09 下午3.59.56"></a>

Then I found I made a hugh mistake: Ruby naming convention told Ruby developer to name everything with underscore. So every developer names their projects with underscore.

But it's a giant SEO mistake: Search Engine treats snake_keywords as CamelKeywords. If your project's name contains  meaningful keywords, it won't be matched. Because "snake_keywords" means "SnakeKeyword" not "snake keywords".

It's really bad for SEO.
