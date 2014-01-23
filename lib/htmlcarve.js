(function() {
  var Htmlcarve, buildLinkDerivats, chardet, cheerio, combineInfoPartials, extractKeywords, iconv, link, link2, link3, link4, link5, mergeObjects, parsePageBody, parser, request, splitToWords,
    __hasProp = {}.hasOwnProperty;

  Htmlcarve = (typeof exports !== "undefined" && exports !== null) && exports || (this.Htmlcarve = {});

  cheerio = require("cheerio");

  request = require("request");

  iconv = require("iconv-lite");

  chardet = require("chardet");

  parser = {
    ogp: require("./ogp_parser"),
    tc: require("./tc_parser"),
    meta: require("./meta_parser")
  };

  Htmlcarve.fromUrl = function(url, fn) {
    var headers;
    headers = {
      'User-Agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"
    };
    return request({
      url: url,
      encoding: null,
      timeout: 10000,
      headers: headers
    }, function(error, response, body) {
      return parsePageBody(error, response, body, function(error, page) {
        var data;
        data = Htmlcarve.fromString(page);
        data.links = buildLinkDerivats(url);
        if (fn) {
          return fn(null, data);
        }
      });
    });
  };

  Htmlcarve.fromString = function(text) {
    var $, data;
    $ = cheerio.load(text, {
      ignoreWhitespace: true
    });
    data = {};
    data.source = {
      html_meta: parser.meta.execute($),
      open_graph: parser.ogp.execute($),
      twitter_card: parser.tc.execute($)
    };
    data.result = combineInfoPartials(data.source);
    return data;
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

  if (process.argv[1] === __filename) {
    link = "http://www.spiegel.de/politik/deutschland/parteien-betonen-offenheit-vor-koalitions-sondierungen-a-927551.html";
    link2 = "http://venturebeat.com/2013/10/10/apple-iwatch-is-actually-a-home-automation-play-not-a-smartphone-companion-analyst/#Zjpr2zSfqX79WaPc.99";
    link3 = "http://vsr.informatik.tu-chemnitz.de/";
    link4 = "http://thetoolbox.cc/";
    link5 = "https://www.google.de/search?safe=off&site=&source=hp&q=mein+sack&oq=mein+sack&gs_l=hp.3..0j0i22i30l9.1456.6450.0.6627.26.17.8.1.1.0.146.1397.13j4.17.0....0...1c.1.28.hp..0.26.1442.I6vvc0IAjjo";
    PageExtractor.load(process.argv[2] || link4);
  }

}).call(this);
