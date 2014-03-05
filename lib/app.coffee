config = require 'config'

express = require 'express'
app = express()

log4js = require 'log4js'

logger = log4js.getLogger('app.coffee')

app.set 'port', config['app']['port'] or 3000
app.set 'env', process.env.NODE_ENV or 'development'

exports.start = (cb)->
  port = app.get 'port'
  env = app.get 'env'
  app.listen port
  logger.info "Application start listening on port #{port} - mode: #{env}"


app.get '/', (req, res)->
  res.send 'done'
