path = require "path"
express = require "express"
port = process.env.PORT || 3000
app = express()

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

app.use require("connect-assets")()
app.use express.static __dirname + "/../public"
app.use (req, res, next) ->
	res.locals.viewClass = (locals) ->
		viewFile = locals.filename
		viewDir = path.join __dirname, "/../views/"

		viewFile.replace(viewDir, "")
				  .replace(".jade", "")
				  .replace(/\//g, "-")

	next()

# Services


# Controllers
app.use require "./dashboard"

app.listen port
console.log "kansascity2 listening on #{port}"