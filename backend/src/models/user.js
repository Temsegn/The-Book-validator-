const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    unique: true,
    required: true
  },
  email: {
    type: String,
    unique: true,
    required: true
  },
  password: {
    type: String,
    required: true
  },
  books: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Book' }],
  songs: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Song' }],
  reports: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Report' }],
}, {
  timestamps: true
});

module.exports = mongoose.model('User', userSchema);
