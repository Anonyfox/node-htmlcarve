#!/usr/bin/env coffee

Htmlcarve = exports? and exports or @Htmlcarve = {}

cheerio = require "cheerio"
request = require "request"
iconv = require "iconv-lite"
chardet = require "chardet"
parser = 
  ogp: require "./ogp_parser"
  tc: require "./tc_parser"
  meta: require "./meta_parser"

Htmlcarve.fromUrl = (url, fn) ->
  headers = {'User-Agent':"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"}
  request {url: url, encoding: null, timeout: 10000, headers: headers}, (error, response, body) ->
    parsePageBody error, response, body, (error, page) ->
      data = Htmlcarve.fromString page
      data.links = buildLinkDerivats(url)
      fn null, data if fn

Htmlcarve.fromString = (text) ->
  $ = cheerio.load text, {ignoreWhitespace: true}
  data = {}
  data.source = {html_meta: parser.meta.execute($), open_graph: parser.ogp.execute($), twitter_card: parser.tc.execute($)}
  data.result = combineInfoPartials data.source
  return data

### private functions below ###

parsePageBody = (error, response, body, fn) ->
  if not response or not body
    console.log "error (empty response or body) while parsing... "
  else if error or response.statusCode isnt 200
    console.log "error (http: #{response.statusCode}) while parsing... "
  else
    coding = chardet.detect body[0...1000] # 5000 characters should be enough for guessing, this algo is expensive !!
    page = iconv.decode body, coding # converting just the html HEAD part may be enough...
  fn error, (page or "") if fn

### STANDARD EXTRACTORS ###
# The following informations are needed:
# {title, summary, image, feed, author, keywords, language, favicon}

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

# when started directly as script
if process.argv[1] is __filename
  # some example links
  link = "http://www.spiegel.de/politik/deutschland/parteien-betonen-offenheit-vor-koalitions-sondierungen-a-927551.html"
  link2 = "http://venturebeat.com/2013/10/10/apple-iwatch-is-actually-a-home-automation-play-not-a-smartphone-companion-analyst/#Zjpr2zSfqX79WaPc.99"
  link3 = "http://vsr.informatik.tu-chemnitz.de/"
  link4 = "http://thetoolbox.cc/"
  link5 = "https://www.google.de/search?safe=off&site=&source=hp&q=mein+sack&oq=mein+sack&gs_l=hp.3..0j0i22i30l9.1456.6450.0.6627.26.17.8.1.1.0.146.1397.13j4.17.0....0...1c.1.28.hp..0.26.1442.I6vvc0IAjjo"
  PageExtractor.load( process.argv[2] or link4 )
