// Service for user-related business logic
const User = require('../models/user');

exports.findUserByEmail = async (email) => {
  return await User.findOne({ email });
};

exports.createUser = async (userData) => {
  const user = new User(userData);
  return await user.save();
};
