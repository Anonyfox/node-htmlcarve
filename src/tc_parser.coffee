# https://dev.twitter.com/docs/cards

TcParser = exports? and exports or @TcParser = {}

# expects a "dom" object created by cheerio
TcParser.execute = ($) ->
  title:    $("meta[name='twitter:title']").attr("content")
  summary:  $("meta[name='twitter:description']").attr("content")
  image:    $("meta[name='twitter:image']").attr("content")
  author:   $("meta[name='twitter:creator']").attr("content")
