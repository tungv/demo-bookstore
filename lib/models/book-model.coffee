mongoose = require 'mongoose'

schema = new mongoose.Schema {
  desc: String
  id: Number
  name: String
  picture: String
  price: Number
}

module.exports = mongoose.model 'book', schema