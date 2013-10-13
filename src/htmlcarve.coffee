#!/usr/bin/env coffee

Htmlcarve = exports? and exports or @Htmlcarve = {}

cheerio = require "cheerio"
request = require "request"
iconv = require "iconv-lite"
chardet = require "chardet"

# shorthands:
# - OG = "OpenGraph"
# - TC = "Twitter Card"
# - $  = serverside DOM, usable like jquery, see the cheerio github page for details

Htmlcarve.fromUrl = (url, fn) ->
  request url, {encoding: null, timeout: 10000}, (error, response, body) ->
    parsePageBody error, response, body, (error, page) ->
      info = Htmlcarve.fromString page
      info.links = buildLinkDerivats(url)
      fn null, info if fn

Htmlcarve.fromString = (text) ->
  $ = cheerio.load text, {ignoreWhitespace: true}
  info = {html_meta: extractMeta($), open_graph: extractOG($), twitter_card: extractTC($)}
  info.info = combineInfoPartials info
  return info

### private functions below ###

parsePageBody = (error, response, body, fn) ->
  console.log "error (http: #{response.statusCode}) while parsing... ", error if error or response.statusCode isnt 200
  coding = chardet.detect body[0...1000] # 5000 characters should be enough for guessing, this algo is expensive !!
  page = iconv.decode body, coding # converting just the html HEAD part may be enough...
  fn error, (page or "") if fn

### STANDARD EXTRACTORS ###
# The following informations are needed:
# {title, summary, image, feed, author, keywords, language, favicon}

extractOG = ($) ->
  {
    title:    $("meta[property='og:title']").first().attr("content")
    summary:  $("meta[property='og:description']").first().attr("content")
    image:    $("meta[property='og:image']").first().attr("content")
    language: $("meta[property='og:locale']").first().attr("content")
  }

extractMeta = ($) ->
  {
    title:    $("title").first().text() or $("h1").first().text() or $("h2").first().text() or $("h3").first().text()
    summary:  $("meta[name='description']").first().attr("content")
    image:    $("div img").first().attr("src")
    language: $("html").attr("lang") or $("meta[http-equiv='content-language']").attr("content") or $("meta[name='language']").attr("content")
    feed:     $("link[type='application/rss+xml']").attr("href") or $("link[type='application/atom+xml']").attr("href") or $("link[rel='alternate']").attr("href")
    favicon:  $("link[rel='apple-touch-icon']").attr("href") or $("link[rel='shortcut icon']").attr("href") or $("link[rel='icon']").attr("href")
    keywords: $("meta[name='keywords']").first().attr("content")
    author:   $("meta[name='author']").first().attr("content")
  }

extractTC = ($) ->
  {
    title:    $("meta[name='twitter:title']").attr("content")
    summary:  $("meta[name='twitter:description']").attr("content")
    image:    $("meta[name='twitter:image']").attr("content")
    author:   $("meta[name='twitter:creator']").attr("content")
  }

buildLinkDerivats = (link) ->
  url = require("url").parse(link)
  {
    deep: url.href
    shallow: url.protocol + "//" + url.hostname + url.pathname
    base: url.protocol + "//" + url.hostname
  }

combineInfoPartials = (info) ->
  # explicit open graph data is usually of the best quality. Add other sources if nothing was found in open graph.
  do (base = JSON.parse(JSON.stringify(info.open_graph))) ->
    mergeObjects base, info.twitter_card
    mergeObjects base, info.html_meta
    return base

mergeObjects = (base, additions) ->
  base[k] or= v for own k,v of additions


### ADVANCED ALOGRITHMS (expensive) ###
# should only be used if none of the metadata-extractors above found something useful.

extractKeywords = (title, text) ->
  hash = {}

splitToWords = (text) ->
  clean = text.replace(/[^äöüßa-z0-9\s-\*_#]/gi, "").replace(/\s/g, " ").replace(/\s{2,}/g, " ").replace(/(A-ZÄÖÜ)(a-zäöü)/g, "$1 $2")
  console.log clean
  words = clean.split(" ")

logObject = (str, obj) ->
  # clc = require "cli-color"
  # pj = require "prettyjson"
  # console.log clc.blue("\n+" + Array(79).join("="))
  # console.log clc.blue("|") + clc.red(str)
  # console.log clc.blue("+" + Array(79).join("="))
  # console.log pj.render(obj)
  console.log str, obj

# when started directly as script
if process.argv[1] is __filename
  link = "http://www.spiegel.de/politik/deutschland/parteien-betonen-offenheit-vor-koalitions-sondierungen-a-927551.html"
  link2 = "http://venturebeat.com/2013/10/10/apple-iwatch-is-actually-a-home-automation-play-not-a-smartphone-companion-analyst/#Zjpr2zSfqX79WaPc.99"
  link3 = "http://vsr.informatik.tu-chemnitz.de/"
  link4 = "http://thetoolbox.cc/"
  link5 = "https://www.google.de/search?safe=off&site=&source=hp&q=mein+sack&oq=mein+sack&gs_l=hp.3..0j0i22i30l9.1456.6450.0.6627.26.17.8.1.1.0.146.1397.13j4.17.0....0...1c.1.28.hp..0.26.1442.I6vvc0IAjjo"
  PageExtractor.load( process.argv[2] or link4 )
