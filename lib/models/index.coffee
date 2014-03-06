config = require 'config'
log4js = require 'log4js'
logger = log4js.getLogger 'models/index'

_ = require 'lodash'

requireAll = require 'require-all'
mongoose = require 'mongoose'
baucis = require 'baucis'

mongo = config['mongo']
connectionString = "mongodb://#{mongo.host}:#{mongo.port}/#{mongo.db}"

mongoose.connect connectionString
logger.info "Connected to MongoDB: #{connectionString}"

models = null

module.exports = ({passport})->
  return models if models

  models = requireAll {
    dirname: __dirname
    filter: /^(.+)\-model\.coffee$/
  }

  _.forEach models, (model, name)->
    logger.debug 'name', name
    controller = baucis.rest name
    controller.use passport.initialize()

    controller.use '/', (req, res, next)->
      console.log 'controller.all', req.body

      auth = passport.authenticate 'local', (err, user, info)->
        if err? or not user
          res.send(401, error:info);
        else
          next();

      auth req, res

  ## init user for the first time
  models.user.findOne {email: 'test@tungv.com'}, (err, user)->
    return logger.fatal 'Cannot connect to mongo' if err?

    ## do nothing if admin is there
    return if user


    admin = new models.user {
      email: 'test@tungv.com'
      displayName: 'Admin'
      password: require('crypto').createHash('md5').update('test').digest("hex")
    }

    ## insert admin to db
    admin.save()

  ## init books for the first time
  models.book.count {}, (err, c)->
    if err?
      logger.fatal 'Cannot connect to mongo'
      return

    initBooks() if c is 0

  return models

initBooks = ->
  filePath = '../../tests/price.json'
  books = require filePath

  ## books loaded
  ## using Collection.insert to save db connection
  models.book.create books, (err, data)->
    if err?
      logger.warn 'Cannot initialize books', err
      return

    logger.info "Succesfully initialize #{books.length} books"

