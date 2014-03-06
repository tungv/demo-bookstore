config = require 'config'
log4js = require 'log4js'
logger = log4js.getLogger 'app.coffee'

## libraries
express = require 'express'
fs = require 'fs'
baucis = require 'baucis'
crypto = require 'crypto'
_ = require 'lodash'

## cache index file
## TODO: use req.render

indexPath = __dirname+'/../app/index.html'
index = String fs.readFileSync indexPath
fs.watchFile indexPath, ->
  index = String fs.readFileSync indexPath
  logger.debug 'index changed'


## init app
app = express()
app.set 'port', config['app']['port'] or 3000

## basic middlewares
app.use express.json()
app.use express.urlencoded()
app.use express.compress()
app.use express.methodOverride()
app.use express.static __dirname + '/../app'

## custom middlewares
middlewares = require './middlewares.coffee'
app.use '/api', middlewares.ensureAuthCriteria


## init models and authentication
passport = require './authentication.coffee'
models = require('./models/index.coffee') {passport}

## passport middlewares
app.use passport.initialize()
app.use passport.session()

## restful api routes
app.use '/api', baucis()

## custom api routes
app.post '/api/login', (req, res)->
  auth = passport.authenticate 'local', (err ,user ,info)->
    if err
      res.json err
    else if user
      res.json user.userInfo
    else
      res.json error:info

  auth req, res

app.post '/api/logout', (req, res)->
  req.logOut()
  res.send(204)

app.get '/', (req, res)->
  res.send 200, index

app.get '/*', (req, res)->
  res.send 200, index


exports.start = (cb)->
  port = app.get 'port'
  env = app.get 'env'
  app.listen port
  logger.info "Application start listening on port #{port} - mode: #{env}"


md5 = (text)->
  crypto.createHash('md5').update(text).digest("hex")

