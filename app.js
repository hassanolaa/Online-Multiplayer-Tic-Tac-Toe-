
const mongoose = require('mongoose');


const user = mongoose.Schema({
    name:String,
    age:String
})

module.exports=mongoose.model('user',user)