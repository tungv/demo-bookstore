mongoose = require 'mongoose'

crypto = require 'crypto'

schema = new mongoose.Schema {
  email: String
  displayName: String

  salt: String
  hashedPassword: String
}

encryptPassword = (password, salt)->
  crypto.createHash('md5').update(password+salt).digest("hex")

schema.virtual('password')
  .set (password)->
    ## get a random 5 character to make salt
    @salt = (~~(Math.random() * 1e8)).toString(36)[0..4]
    @hashedPassword = encryptPassword(password, @salt)

schema.virtual('userInfo').get ()-> {
  displayName: @displayName
  email: @email
}

schema.methods.checkPassword = (password)->
  encryptPassword(password, @salt) is @hashedPassword

module.exports = mongoose.model 'user', schema