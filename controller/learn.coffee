Node = require "../models/node"
Link = require "../models/link"
async = require "async"
_ = require 'underscore'
scraper = require "./scraper"
reader = require "./reader"
type = require './types'

learnWikiURL = (url) =>
  scraper.grabWikiSentences url, (err, results) ->
    for line in results
      learnSentence(line)

learnBellJar = (filename) =>
  i = 0
  reader.readFile filename, (err, results) =>
    async.eachLimit results, 10, (line, next) ->
      i += 1
      console.log i, line
      learnSentence(line, next)

learnSentence = (line, next) ->
  words = _.uniq line.split(" ")
  
  for w1, x in words 
    for w2, y in words[x+1..]
      addLink(w1, w2, next)

addLink = (word1, word2, next) ->
  async.auto
    w1: (next) =>
      Node.findOneAndUpdate {data:word1}, {type: type.type(word1)}, {upsert:true}, next

    w2: (next) =>
      Node.findOneAndUpdate {data:word2}, {type: type.type(word2)}, {upsert:true}, next

    l: ["w1", "w2", (next, {w1, w2}) =>
      if !w1? or !w2? or !w1.id? or !w2.id?
        return next(null, null)
      [w1, w2] = [w2,w1] if (w1.id < w2.id)
      Link.findOneAndUpdate {node1: w1.id, node2: w2.id}, {$inc : {count: 1}}, {upsert: 1}, next
    ]
  , next

#learnWikiURL("https://en.wikipedia.org/wiki/Poetry")
#learnBellJar reader.FILENAME
#console.log "DONE"
