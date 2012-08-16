express = require "express"
app = module.exports = express()

app.get "/", (req, res) ->
   res.render "index"

app.get "/add_event", (req, res) ->
	res.render "event"

app.post "/add_event", (req, res) ->
	res.redirect "/"