(function() {
  var MetaParser;

  MetaParser = (typeof exports !== "undefined" && exports !== null) && exports || (this.MetaParser = {});

  MetaParser.execute = function($) {
    return {
      title: $("title").first().text() || $("h1").first().text() || $("h2").first().text() || $("h3").first().text(),
      summary: $("meta[name='description']").first().attr("content"),
      image: $("div img").first().attr("src"),
      language: $("html").attr("lang") || $("meta[http-equiv='content-language']").attr("content") || $("meta[name='language']").attr("content"),
      feed: $("link[type='application/rss+xml']").attr("href") || $("link[type='application/atom+xml']").attr("href") || $("link[rel='alternate']").attr("href"),
      favicon: $("link[rel='apple-touch-icon']").attr("href") || $("link[rel='shortcut icon']").attr("href") || $("link[rel='icon']").attr("href"),
      keywords: $("meta[name='keywords']").first().attr("content"),
      author: $("meta[name='author']").first().attr("content")
    };
  };

}).call(this);
