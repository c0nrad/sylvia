mongoose = require('mongoose')

LinkSchema = new mongoose.Schema
  count: {type: Number, default: 0}
  node1: mongoose.Schema.ObjectId
  node2: mongoose.Schema.ObjectId

module.exports = mongoose.model('Link', LinkSchema)


# l = new Link
#   count: 1
#   node1: mongoose.Types.ObjectId("531225d4833753f50d708755")
#   node2: mongoose.Types.ObjectId("531225d50786a1f80d103eca")

# l.save()