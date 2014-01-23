# checks for html meta tags

MetaParser = exports? and exports or @MetaParser = {}

# expects a "dom" object created by cheerio
MetaParser.execute = ($) ->
  title:    $("title").first().text() or $("h1").first().text() or $("h2").first().text() or $("h3").first().text()
  summary:  $("meta[name='description']").first().attr("content")
  image:    $("div img").first().attr("src")
  language: $("html").attr("lang") or $("meta[http-equiv='content-language']").attr("content") or $("meta[name='language']").attr("content")
  feed:     $("link[type='application/rss+xml']").attr("href") or $("link[type='application/atom+xml']").attr("href") or $("link[rel='alternate']").attr("href")
  favicon:  $("link[rel='apple-touch-icon']").attr("href") or $("link[rel='shortcut icon']").attr("href") or $("link[rel='icon']").attr("href")
  keywords: $("meta[name='keywords']").first().attr("content")
  author:   $("meta[name='author']").first().attr("content")
