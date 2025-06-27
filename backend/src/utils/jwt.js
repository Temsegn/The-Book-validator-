// utils/jwt.js
const jwt = require('jsonwebtoken');

exports.generateToken = (payload, secret, expiresIn = '1d') => {
  return jwt.sign(payload, secret, { expiresIn });
};

exports.verifyToken = (token, secret) => {
  return jwt.verify(token, secret);
};
