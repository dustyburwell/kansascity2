express = require "express"
app = module.exports = express()

app.get "/", (req, res) ->
   res.render "index", 
   	events: req.services.event.get_all()

app.get "/add_event", (req, res) ->
	res.render "event"

app.post "/add_event", (req, res) ->
	post = req.body

	

	req.services.event.add 
	res.redirect "/"