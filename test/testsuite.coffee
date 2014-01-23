# interesting tutorial for chai and mocha: http://net.tutsplus.com/tutorials/javascript-ajax/better-coffeescript-testing-with-mocha/
# chai syntax: http://chaijs.com/api/bdd/
chai = require "chai"
chai.should()
expect = chai.expect

htmlcarve = require "../lib/htmlcarve"
fs = require "fs"

# sample files, grabbed from the interwebz:
files = {
  ogp_basic: fs.readFileSync("#{__dirname}/samples/ogp_basic.html")
  html_complete: fs.readFileSync("#{__dirname}/samples/html_meta_complete.html")
  tc_and_more: fs.readFileSync("#{__dirname}/samples/tc_and_more.html")
}


###############################
### Result Object Structure ###
###############################

describe "Result Object Structure", ->
  data = htmlcarve.fromString files.ogp_basic

  it "should have source and a result component", ->
    expect( data ).to.include.keys("source", "result")

  it "should have open_graph, twitter_card and html_meta included in the source component", ->
    expect( data.source ).to.include.keys("open_graph", "twitter_card", "html_meta")

  it "should have all attributes in the result component", ->
    attrs = ["title","summary","image","author","feed","favicon","language","keywords"]
    expect( data.result ).to.include.keys attrs...


###################################
### Open Graph Protocol Parsing ###
###################################

describe "Open Graph Protocol Recognition", ->
  data = htmlcarve.fromString files.ogp_basic

  it "should find basic metadata", ->
    og = data.source.open_graph
    expect( og.title ).to.equal "VentureBeat"
    expect( og.summary ).to.equal "News About Tech, Money and Innovation"
    expect( og.image ).to.equal "http://0.gravatar.com/blavatar/c6d8c27ffa1c5a7f106f97e434437baf?s=200"
    expect( og.language ).to.be.undefined


##############################
### HTML Meta Tags Parsing ###
##############################

describe "HTML Meta Tags Parser", ->
  data = htmlcarve.fromString files.html_complete

  it "should find basic metadata", ->
    meta = data.source.html_meta
    expect( meta.title ).to.equal "Distributed and Self-organizing Systems (VSR)"
    expect( meta.summary ).to.equal "Technische Universität Chemnitz, TU Chemnitz, Distributed and Self-organizing Systems (VSR), Computer Science: VSR Research Group"
    expect( meta.image ).to.equal "https://www.tu-chemnitz.de/tucal/img/banner_engl.gif"
    expect( meta.language ).to.equal "en"
    expect( meta.feed ).to.equal "/news/rss/"
    expect( meta.favicon ).to.equal "https://vsr.informatik.tu-chemnitz.de/img/favicon.ico"
    expect( meta.keywords ).to.equal "Technische Universität Chemnitz, TU Chemnitz, Distributed and Self-organizing Systems Research Group, Computer Science, VSR Research Group, Web Engineering, Web, Collaboration, Cooperation, Agile, Research, Software Development, Linked Data, Semantic Web, Web 2.0, Web 3.0"
    expect( meta.author ).to.equal "VSR Research Group"


#############################
### Twitter Cards Parsing ###
#############################

describe "Twitter Cards Recognition", ->
  data = htmlcarve.fromString files.tc_and_more

  it "should find basic metadata", ->
    tc = data.source.twitter_card
    expect( tc.title ).to.equal "Stream Miserable's Cratering 'Halloween Dream'"
    expect( tc.summary ).to.equal "Ex-Whirr singer preps solo EP for February 18 release"
    expect( tc.image ).to.equal "http://www.spin.com/sites/all/files/140122-miserable.jpg"
    expect( tc.author ).to.be.undefined
