// Service for report-related business logic
const Report = require('../models/report');

exports.findReportsByUser = async (userId) => {
  return await Report.find({ user: userId });
};

exports.createReport = async (reportData) => {
  const report = new Report(reportData);
  return await report.save();
};
