express = require("express")
routes = require("./routes")
user = require("./routes/user")
http = require("http")
path = require("path")
async = require("async")
coffeeMiddleware = require "coffee-middleware"


mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/sylvia'
Node = require './models/node'
Link = require './models/link'

baucis = require 'baucis'
baucis.rest('Node')
baucis.rest('Link')

app = express()

scraper = require "./controller/scraper.coffee"
learner = require "./controller/learn"

app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use require("stylus").middleware(path.join(__dirname, "public"))
app.use coffeeMiddleware {src: __dirname + '/public'}
app.use express.static(path.join(__dirname, "public"))

app.use express.errorHandler()  if "development" is app.get("env")
app.get "/", routes.index
app.use('/api', baucis());

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
  return
