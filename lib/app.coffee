config = require 'config'
log4js = require 'log4js'
logger = log4js.getLogger('app.coffee')

crypto = require('crypto')

## cache index file
## TODO: use req.render
fs = require 'fs'
indexPath = __dirname+'/../app/index.html'
index = String fs.readFileSync indexPath
fs.watchFile indexPath, ->
  logger.debug 'index changed'
  index = String fs.readFileSync indexPath

## init app
express = require 'express'
app = express()
app.set 'port', config['app']['port'] or 3000

## basic middlewares
app.use express.json()
app.use express.urlencoded()
app.use express.compress()
app.use express.methodOverride()


## init models and authentication
models = require './models/index.coffee'
baucis = require 'baucis'
passport = require './authentication.coffee'

## passport middlewares
app.use passport.initialize()
app.use passport.session()

app.use express.static __dirname + '/../app'

## restful routes
app.use '/api', baucis()

app.get '/', (req, res)->
  res.send index

app.get '/api/me', (req, res)->
  logger.debug 'hit me'
  res.json req.user

app.all '/api/login', (req, res, next)->
  ## hash password if needed
  password = req.body['password']

  hashed = req.query['hashed']
  hashed = hashed and hashed isnt 'false'

  req.body['password'] = md5 password if password?.length and not hashed
  next();

app.post '/api/login', (req, res)->
  auth = passport.authenticate 'local', (err ,user ,info)->
    if err
      res.json err
    else if user
      res.json user.userInfo
    else
      res.json error:info

  auth req, res

md5 = (text)->
  crypto.createHash('md5').update(text).digest("hex")


app.all '/*', (req, res)->
  res.send 200, index


exports.start = (cb)->
  port = app.get 'port'
  env = app.get 'env'
  app.listen port
  logger.info "Application start listening on port #{port} - mode: #{env}"
