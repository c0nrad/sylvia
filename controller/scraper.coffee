request = require 'request'
cheerio = require 'cheerio'
_ = require 'underscore'

exports.START_URL = "http://en.wikipedia.org/wiki/Sylvia_Plath"

exports.grabWikiSentences = (url, next) ->
  request.get url, (err, resp, body) =>
    next(err) if err?
    $ = cheerio.load(body)
    allLinesOnPage = ["Sylvia Plath"]
    $("#mw-content-text p").each (i, tag) ->
      values = _.compact($(@).text().replace(/\[.*]/g, "").replace(".", "\n").split("\n"))
      allLinesOnPage = _.union allLinesOnPage, values
    next null, clean(allLinesOnPage)

clean = (lines) ->
  outlines = []
  for line in lines
    continue if line == ""
    line = line.replace(/[\.,-\/#!$%\^&\*;:{}=\-_`~()]/g,"").toLowerCase()
    outlines.push line.trim()
  return outlines
