const express = require('express');
const router = express.Router();
const reportController = require('../controllers/reportController');

// Create a new report
router.post('/', reportController.createReport);

// Get all reports
router.get('/', reportController.getAllReports);

// Get a single report by ID
router.get('/:id', reportController.getReportById);

// Delete a report
router.delete('/:id', reportController.deleteReport);

module.exports = router;
