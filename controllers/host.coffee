path = require "path"
express = require "express"
port = process.env.PORT || 3000
app = express()
flash = require 'connect-flash';

# Settings
app.set "view engine", "jade"
app.set "view options", { layout: false }

app.configure "development", () ->
   app.use express.logger "dev"
   app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure "production", () ->
   app.use express.errorHandler()

# Middleware
app.use express.bodyParser()

app.use express.cookieParser('keyboard cat')
app.use express.session({ cookie: { maxAge: 60000 }})
app.use flash()

app.use require("connect-assets")()

app.use express.favicon __dirname + '/../public/favicon.ico', { maxAge: 2592000000 };

app.use (req, res, next) ->
   res.locals.viewClass = (locals) ->
      viewFile = locals.filename
      viewDir = path.join __dirname, "/../views/"

      viewFile.replace(viewDir, "")
              .replace(".jade", "")
              .replace(/\//g, "-")

   next()

# Services
app.use require "../services/event"

# Controllers
app.use require "./dashboard"

app.listen port
console.log "kansascity2 listening on #{port}"