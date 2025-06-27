const Report = require('../models/report');

// Create a new report
exports.createReport = async (req, res) => {
  try {
    const report = new Report({
      user: req.body.user,
      content: req.body.content
    });
    await report.save();
    res.status(201).json(report);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Get all reports
exports.getAllReports = async (req, res) => {
  try {
    const reports = await Report.find().populate('user');
    res.json(reports);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get a single report by ID
exports.getReportById = async (req, res) => {
  try {
    const report = await Report.findById(req.params.id).populate('user');
    if (!report) return res.status(404).json({ error: 'Report not found' });
    res.json(report);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Delete a report
exports.deleteReport = async (req, res) => {
  try {
    const report = await Report.findByIdAndDelete(req.params.id);
    if (!report) return res.status(404).json({ error: 'Report not found' });
    res.json({ message: 'Report deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
