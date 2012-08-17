express = require "express"
app = module.exports = express()

app.get "/", (req, res) ->
	req.services.event.get_all (err, data) ->
	   res.render "index", 
	   	events: data

app.get "/add_event", (req, res) ->
	res.render "event"

app.post "/add_event", (req, res) ->
	post = req.body

	req.services.event.add(
		post.owner.name, post.owner.email, 
		post.event.title, post.event.url, 
		post.event.frequency, post.event.phase, 
		post.event.day, post.event.people,
		(err) ->
			res.redirect "/")

app.get "/color", (req, res) ->
	res.render "color", 
		color: req.services.event.generate_color()