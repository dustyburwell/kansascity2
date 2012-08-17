express = require "express"
app = module.exports = express()
_ = require("underscore")
db = require("mongojs").connect('stuff', ['events']);


phases = ["First", "Second", "Third", "Fourth", "Last"]
days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

class Event

   hsv_to_rgb: (h, s, v) ->
      h_i = parseInt h*6
      f = h*6 - h_i
      p = v * (1 - s)
      q = v * (1 - f*s)
      t = v * (1 - (1 - f) * s)
      [r, g, b] = [v, t, p] if h_i == 0
      [r, g, b] = [q, v, p] if h_i == 1
      [r, g, b] = [p, v, t] if h_i == 2
      [r, g, b] = [p, q, v] if h_i == 3
      [r, g, b] = [t, p, v] if h_i == 4
      [r, g, b] = [v, p, q] if h_i == 5
      [parseInt(r*256), parseInt(g*256), parseInt(b*256)]

   generate_color: () ->
      golden_ratio_conjugate = 0.618033988749895
      h = Math.random() # use random start value
      h += golden_ratio_conjugate
      h %= 1
      @hsv_to_rgb(h, 0.5, 0.95)

   get_all: (callback) -> 
      db.events.find (err, events) ->
         callback null, 
            _.groupBy(events, 'frequency')

   add: (owner_name, owner_email, event_title, event_url, event_frequency, event_phase, event_day, event_people, callback) ->
      event_frequency = event_frequency.toLowerCase()
      
      [time, error] = switch event_frequency
         when "monthly", "bi-monthly"
            if event_day not in days 
               ['', 'Must specify event day']
            else if event_phase not in phases 
               ['', 'Must specify event phase']
            else ["#{event_phase} #{event_day}", '']
         when 'weekly'
            if event_day not in days 
               ['', 'Must specify event day']
            else ["Every #{event_day}", '']
         when 'irregular'
            ['Varies', '']
         else
            ['', 'Must specify event frequency']

      if error
         callback(error)

      db.events.save {
         title: event_title
         people: event_people
         url: event_url
         frequency: event_frequency
         when: time
         color: "rgb(#{@generate_color()})"
      }, callback

event = new Event()

app.use (req, res, next) ->
   console.log "hello"
   req.services or= {}
   req.services.event = event
   next()