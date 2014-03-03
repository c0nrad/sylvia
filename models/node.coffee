mongoose = require('mongoose')

NodeSchema = new mongoose.Schema
  type: {type: String, trim: true}
  data: {type: String}

module.exports = mongoose.model('Node', NodeSchema)

# n = new Node
#   type: "word"
#   data: "Sylvia Plath"
# n.save()
