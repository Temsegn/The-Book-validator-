const mongoose = require("mongoose")

const reviewSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    userName: {
      type: String,
      required: true,
    },
    comment: {
      type: String,
      required: [true, "Review comment is required"],
      maxlength: [1000, "Review cannot be more than 1000 characters"],
    },
    rating: {
      type: Number,
      required: [true, "Rating is required"],
      min: [1, "Rating must be at least 1"],
      max: [5, "Rating cannot be more than 5"],
    },
    likes: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
      },
    ],
    isVerified: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  },
)

const bookSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, "Book title is required"],
      trim: true,
      maxlength: [200, "Title cannot be more than 200 characters"],
    },
    author: {
      type: String,
      required: [true, "Author is required"],
      trim: true,
      maxlength: [100, "Author name cannot be more than 100 characters"],
    },
    description: {
      type: String,
      required: [true, "Description is required"],
      maxlength: [2000, "Description cannot be more than 2000 characters"],
    },
    category: {
      type: String,
      required: true,
      enum: [
        "Theology",
        "Liturgy",
        "Spirituality",
        "History",
        "Biography",
        "Prayer Book",
        "Scripture",
        "Patristics",
        "General",
      ],
      default: "General",
    },
    tags: [
      {
        type: String,
        trim: true,
        maxlength: [30, "Tag cannot be more than 30 characters"],
      },
    ],
    language: {
      type: String,
      required: true,
      default: "English",
    },
    pageCount: {
      type: Number,
      min: [1, "Page count must be at least 1"],
      default: 0,
    },
    isbn: {
      type: String,
      trim: true,
      match: [
        /^(?:ISBN(?:-1[03])?:? )?(?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]$/,
        "Please enter a valid ISBN",
      ],
    },
    unitsAvailable: {
      type: Number,
      required: [true, "Units available is required"],
      min: [0, "Units available cannot be negative"],
      default: 0,
    },
    imageUrl: {
      type: String,
      default: "",
    },
    reviews: [reviewSchema],
    averageRating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5,
    },
    totalReviews: {
      type: Number,
      default: 0,
    },
    submittedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    status: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
    },
    rejectionReason: {
      type: String,
      maxlength: [500, "Rejection reason cannot be more than 500 characters"],
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
    verifiedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
    verifiedAt: {
      type: Date,
    },
    viewCount: {
      type: Number,
      default: 0,
    },
    downloadCount: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  },
)

// Indexes for better query performance
bookSchema.index({ title: "text", author: "text", description: "text" })
bookSchema.index({ category: 1 })
bookSchema.index({ status: 1 })
bookSchema.index({ isVerified: 1 })
bookSchema.index({ averageRating: -1 })
bookSchema.index({ createdAt: -1 })
bookSchema.index({ submittedBy: 1 })

// Calculate average rating when reviews are modified
bookSchema.methods.calculateAverageRating = function () {
  if (this.reviews.length === 0) {
    this.averageRating = 0
    this.totalReviews = 0
  } else {
    const sum = this.reviews.reduce((acc, review) => acc + review.rating, 0)
    this.averageRating = Math.round((sum / this.reviews.length) * 10) / 10
    this.totalReviews = this.reviews.length
  }
  return this.save()
}

// Add review
bookSchema.methods.addReview = function (reviewData) {
  // Check if user already reviewed this book
  const existingReview = this.reviews.find((review) => review.userId.toString() === reviewData.userId.toString())

  if (existingReview) {
    throw new Error("User has already reviewed this book")
  }

  this.reviews.push(reviewData)
  return this.calculateAverageRating()
}

// Update review
bookSchema.methods.updateReview = function (reviewId, updateData) {
  const review = this.reviews.id(reviewId)
  if (!review) {
    throw new Error("Review not found")
  }

  Object.assign(review, updateData)
  return this.calculateAverageRating()
}

// Delete review
bookSchema.methods.deleteReview = function (reviewId) {
  this.reviews.id(reviewId).remove()
  return this.calculateAverageRating()
}

// Increment view count
bookSchema.methods.incrementViewCount = function () {
  this.viewCount += 1
  return this.save()
}

// Increment download count
bookSchema.methods.incrementDownloadCount = function () {
  this.downloadCount += 1
  return this.save()
}

// Approve book
bookSchema.methods.approve = function (adminId) {
  this.status = "approved"
  this.isVerified = true
  this.verifiedBy = adminId
  this.verifiedAt = new Date()
  this.rejectionReason = undefined
  return this.save()
}

// Reject book
bookSchema.methods.reject = function (reason) {
  this.status = "rejected"
  this.rejectionReason = reason
  return this.save()
}

module.exports = mongoose.model("Book", bookSchema)
