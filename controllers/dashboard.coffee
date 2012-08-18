express = require "express"
app = module.exports = express()
util = require('util')

phases = ["First", "Second", "Third", "Fourth", "Last"]
days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

app.get "/", (req, res) ->
   req.services.event.get_all (err, data) ->
      res.render "index", 
         events: data

app.get "/add_event", (req, res) ->
   error = req.flash('error')
   data = req.flash('data')
   res.render "event", { error: error[0] or {}, data: data[0] or {} }

isEmpty = (object) ->
   for key, value of object
      return false
   return true

app.post "/add_event", (req, res) ->
   post = req.body
   error = {}

   if not post.owner.name
      error['owner[name]'] = "Must specify an owner name"
   if not post.owner.email
      error['owner[email]'] = "Must specify an owner email"
   if not post.event.title
      error['event[title]'] = "Must specify an event title"
   if not post.event.url
      error['event[url]'] = "Must specify an event url"
   if not post.event.frequency
      error['event[frequency]'] = "Must specify an event frequency"
   if not post.event.people
      error['event[people]'] = "Must specify an event people"

   switch post.event.frequency.toLowerCase()
      when "monthly", "bi-monthly"
         if post.event.phase not in phases
            error['event[phase]'] = "Must specify an event phase"
         if post.event.day not in days
            error['event[day]'] = "Must specify an event day"
      when "weekly"
         if poast.event.day not in days
            error['event[day]'] = "Must specify an event day"

   if not isEmpty(error)
      req.flash 'error', error
      req.flash 'data', post
      res.redirect "/add_event/"
   else
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