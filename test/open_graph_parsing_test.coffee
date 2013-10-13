# interesting tutorial for chai and mocha: http://net.tutsplus.com/tutorials/javascript-ajax/better-coffeescript-testing-with-mocha/

chai = require "chai"
chai.should()

htmlcarve = require "../lib/htmlcarve"

describe "Basic OGP Recognition", ->
  file = require("fs").readFileSync("#{__dirname}/ogp_testsite.html")
  it "should be parseable", ->
    info = htmlcarve.fromString file
    info.open_graph.title.should.equal "VentureBeat"
