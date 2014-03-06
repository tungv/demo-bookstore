exports.ensureAuthCriteria = (req, res, next)->
  ## extract information from request
  email = req.body['email'] or req.headers['x-auth-username']
  password = req.body['password'] or req.headers['x-auth-token']
  hashed = req.query['hashed'] or req.headers['x-auth-hashed']

  ## verify hashing status
  hashed = hashed and hashed isnt 'false'

  ## hash password if needed
  password = md5 password if password?.length and not hashed

  ## reinsert authentication data back to body to unify with passport stardard
  req.body['password'] = password if password?.length
  req.body['email'] = email if email?.length
  next()