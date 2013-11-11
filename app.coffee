CONFIG = require('config')
express = require("express")
app = express()
port = process.env.PORT || 3005
apiProxy = require('./server/apiProxy')

app.configure ->
  app.set('view engine', 'hbs')
  app.set('views', __dirname + '/server/views')
  app.use('/client', express.static(__dirname+'/public'))
  app.use(express.bodyParser())
  app.use(express.cookieParser())
  app.use(express.cookieSession({secret:'secret_heh'}))
  app.use (err, req, res, next) ->
    console.error err.stack
    res.send 500, "Something broke!"

  
#api urls use proxy to set headers
app.get "/api/*", (req, res) ->
  apiProxy.handler(req,res,"GET")
app.post "/api/*", (req,res) ->
  apiProxy.handler(req,res,'POST')
app.put "/api/*", (req,res) ->
  apiProxy.handler(req,res,'PUT')
app.delete "/api/*", (req,res) ->
  apiProxy.handler(req,res,'DELETE')

app.get "/robots.txt", (req, res) ->
  res.set
    'Content-Type': 'text/plain'
  res.render CONFIG.robotsFile

app.post "/login", (req, res) ->
  if req.body.username is 'curator' and req.body.password is 'cur@t0r'
    req.session.username = 'curator'
    res.redirect '/'
  else
    res.render "login.hbs"

app.get "/*", (req, res) ->
  if (!req.session.username)
    res.render "login.hbs"
  else
    data =
      development: CONFIG.development
      apiUrl : CONFIG.apiUrl
      baseUrl : CONFIG.baseUrl
      cloudinary : CONFIG.cloudinary
    res.render "index.hbs", data

app.listen(port);
console.log "Started Hoopla-Io-Curation Interface - http://localhost:#{port}"