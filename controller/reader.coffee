fs = require 'fs'

exports.FILENAME = "./controller/belljar.txt"

exports.readFile = (filename, next) ->
  data = fs.readFileSync(filename, "utf8").replace(".", "\n").split("\n")
  next null, clean(data)

clean = (lines) ->
  outlines = []
  for line in lines
    continue if line == ""
    line = line.replace(/[\.,-\/#!$%\^&\*;:{}=\-_`~()]/g,"").toLowerCase().trim()
    outlines.push line.trim()
  return outlines



