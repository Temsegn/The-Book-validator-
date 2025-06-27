const jwt = require("jsonwebtoken")
const User = require("../models/User")

const auth = async (req, res, next) => {
  try {
    const token = req.header("Authorization")?.replace("Bearer ", "")

    if (!token) {
      return res.status(401).json({ success: false, message: "Access denied. No token provided." })
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET || "your-secret-key")
    const user = await User.findById(decoded.userId)

    if (!user) {
      return res.status(401).json({ success: false, message: "Invalid token." })
    }

    req.user = user
    next()
  } catch (error) {
    res.status(401).json({ success: false, message: "Invalid token." })
  }
}

const adminAuth = async (req, res, next) => {
  try {
    await auth(req, res, () => {
      if (!req.user.isAdmin) {
        return res.status(403).json({ success: false, message: "Access denied. Admin privileges required." })
      }
      next()
    })
  } catch (error) {
    res.status(401).json({ success: false, message: "Authentication failed." })
  }
}

module.exports = { auth, adminAuth }
