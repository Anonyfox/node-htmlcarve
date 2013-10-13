(function() {
  var Htmlcarve, buildLinkDerivats, chardet, cheerio, combineInfoPartials, extractKeywords, extractMeta, extractOG, extractTC, iconv, link, link2, link3, link4, link5, logObject, mergeObjects, parsePageBody, request, splitToWords,
    __hasProp = {}.hasOwnProperty;

  Htmlcarve = (typeof exports !== "undefined" && exports !== null) && exports || (this.Htmlcarve = {});

  cheerio = require("cheerio");

  request = require("request");

  iconv = require("iconv-lite");

  chardet = require("chardet");

  Htmlcarve.fromUrl = function(url, fn) {
    return request(url, {
      encoding: null,
      timeout: 10000
    }, function(error, response, body) {
      return parsePageBody(error, response, body, function(error, page) {
        var info;
        info = Htmlcarve.fromString(page);
        info.links = buildLinkDerivats(url);
        if (fn) {
          return fn(null, info);
        }
      });
    });
  };

  Htmlcarve.fromString = function(text) {
    var $, info;
    $ = cheerio.load(text, {
      ignoreWhitespace: true
    });
    info = {
      html_meta: extractMeta($),
      open_graph: extractOG($),
      twitter_card: extractTC($)
    };
    info.info = combineInfoPartials(info);
    return info;
  };

  /* private functions below*/


  parsePageBody = function(error, response, body, fn) {
    var coding, page;
    if (error || response.statusCode !== 200) {
      console.log("error (http: " + response.statusCode + ") while parsing... ", error);
    }
    coding = chardet.detect(body.slice(0, 1000));
    page = iconv.decode(body, coding);
    if (fn) {
      return fn(error, page || "");
    }
  };

  /* STANDARD EXTRACTORS*/


  extractOG = function($) {
    return {
      title: $("meta[property='og:title']").first().attr("content"),
      summary: $("meta[property='og:description']").first().attr("content"),
      image: $("meta[property='og:image']").first().attr("content"),
      language: $("meta[property='og:locale']").first().attr("content")
    };
  };

  extractMeta = function($) {
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

  extractTC = function($) {
    return {
      title: $("meta[name='twitter:title']").attr("content"),
      summary: $("meta[name='twitter:description']").attr("content"),
      image: $("meta[name='twitter:image']").attr("content"),
      author: $("meta[name='twitter:creator']").attr("content")
    };
  };

  buildLinkDerivats = function(link) {
    var url;
    url = require("url").parse(link);
    return {
      deep: url.href,
      shallow: url.protocol + "//" + url.hostname + url.pathname,
      base: url.protocol + "//" + url.hostname
    };
  };

  combineInfoPartials = function(info) {
    return (function(base) {
      mergeObjects(base, info.twitter_card);
      mergeObjects(base, info.html_meta);
      return base;
    })(JSON.parse(JSON.stringify(info.open_graph)));
  };

  mergeObjects = function(base, additions) {
    var k, v, _results;
    _results = [];
    for (k in additions) {
      if (!__hasProp.call(additions, k)) continue;
      v = additions[k];
      _results.push(base[k] || (base[k] = v));
    }
    return _results;
  };

  /* ADVANCED ALOGRITHMS (expensive)*/


  extractKeywords = function(title, text) {
    var hash;
    return hash = {};
  };

  splitToWords = function(text) {
    var clean, words;
    clean = text.replace(/[^äöüßa-z0-9\s-\*_#]/gi, "").replace(/\s/g, " ").replace(/\s{2,}/g, " ").replace(/(A-ZÄÖÜ)(a-zäöü)/g, "$1 $2");
    console.log(clean);
    return words = clean.split(" ");
  };

  logObject = function(str, obj) {
    return console.log(str, obj);
  };

  if (process.argv[1] === __filename) {
    link = "http://www.spiegel.de/politik/deutschland/parteien-betonen-offenheit-vor-koalitions-sondierungen-a-927551.html";
    link2 = "http://venturebeat.com/2013/10/10/apple-iwatch-is-actually-a-home-automation-play-not-a-smartphone-companion-analyst/#Zjpr2zSfqX79WaPc.99";
    link3 = "http://vsr.informatik.tu-chemnitz.de/";
    link4 = "http://thetoolbox.cc/";
    link5 = "https://www.google.de/search?safe=off&site=&source=hp&q=mein+sack&oq=mein+sack&gs_l=hp.3..0j0i22i30l9.1456.6450.0.6627.26.17.8.1.1.0.146.1397.13j4.17.0....0...1c.1.28.hp..0.26.1442.I6vvc0IAjjo";
    PageExtractor.load(process.argv[2] || link4);
  }

}).call(this);
