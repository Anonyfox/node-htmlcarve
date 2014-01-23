# http://ogp.me/

OgpParser = exports? and exports or @OgpParser = {}

# expects a "dom" object created by cheerio
OgpParser.execute = ($) ->
  title:    $("meta[property='og:title']").first().attr("content")
  summary:  $("meta[property='og:description']").first().attr("content")
  image:    $("meta[property='og:image']").first().attr("content")
  language: $("meta[property='og:locale']").first().attr("content")
