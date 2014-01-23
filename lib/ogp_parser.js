(function() {
  var OgpParser;

  OgpParser = (typeof exports !== "undefined" && exports !== null) && exports || (this.OgpParser = {});

  OgpParser.execute = function($) {
    return {
      title: $("meta[property='og:title']").first().attr("content"),
      summary: $("meta[property='og:description']").first().attr("content"),
      image: $("meta[property='og:image']").first().attr("content"),
      language: $("meta[property='og:locale']").first().attr("content")
    };
  };

}).call(this);
