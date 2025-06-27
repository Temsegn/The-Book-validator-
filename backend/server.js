const express = require("express")
const mongoose = require("mongoose")
const cors = require("cors")
const dotenv = require("dotenv")
const authRoutes = require("./routes/auth")
const bookRoutes = require("./routes/books")
const songRoutes = require("./routes/songs")
const reportRoutes = require("./routes/reports")
const notificationRoutes = require("./routes/notifications")
const adminRoutes = require("./routes/admin")

dotenv.config()

const app = express()
const PORT = process.env.PORT || 3000

// Middleware
app.use(cors())
app.use(express.json({ limit: "10mb" }))
app.use(express.urlencoded({ extended: true, limit: "10mb" }))

// MongoDB connection
mongoose
  .connect(process.env.MONGODB_URI || "mongodb+srv://tom:1234tom2394@wisdomwalk.db2qsqm.mongodb.net/orthodx?retryWrites=true&w=majority&appName=wisdomwalk", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("MongoDB connection error:", err))

// Routes
app.use("/api/auth", authRoutes)
app.use("/api/books", bookRoutes)
app.use("/api/songs", songRoutes)
app.use("/api/reports", reportRoutes)
app.use("/api/notifications", notificationRoutes)
app.use("/api/admin", adminRoutes)

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).json({ success: false, message: "Something went wrong!" })
})

// 404 handler
app.use("*", (req, res) => {
  res.status(404).json({ success: false, message: "Route not found" })
})

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`)
})
