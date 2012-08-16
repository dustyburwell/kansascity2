express = require "express"
app = module.exports = express()

class Event
   constructor: () ->

   get_all: () -> 
      monthly: [
         {
            title: "Thing1"
            people: "Rubyists"
            url: "http://google.com"
            when: "First Monday"
         },

         {
            title: "Thing2"
            people: "Hobbyists"
            url: "http://hobbys.com"
            when: "Second Tuesday"
            },
      ]
      "bi-monthly": [
         {
            title: "Thing2"
            people: "Pythonistas"
            url: "http://blah.com"
            when: "Third Friday"
         }
      ]

   add: () ->

event = new Event()

app.use (req, res, next) ->
   console.log "hello"
   req.services or= {}
   req.services.event = event
   next()