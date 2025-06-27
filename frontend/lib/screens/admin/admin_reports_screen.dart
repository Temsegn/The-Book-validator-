import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/report.dart';

class AdminReportsScreen extends StatefulWidget {
  @override
  _AdminReportsScreenState createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  List<Report> _reports = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      final reports = await ApiService.getReports();
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading reports: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Report> get _filteredReports {
    if (_selectedFilter == 'all') return _reports;
    return _reports.where((report) => report.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports Management'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredReports.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadReports,
                        child: ListView.builder(
                          itemCount: _filteredReports.length,
                          itemBuilder: (context, index) =>
                              _buildReportCard(_filteredReports[index]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = {
      'All': 'all',
      'Pending': 'pending',
      'Reviewed': 'reviewed',
      'Resolved': 'resolved',
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: filters.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildFilterChip(entry.key, entry.value),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.report_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No reports found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Report report) {
    Color statusColor;
    switch (report.status) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'reviewed':
        statusColor = Colors.blue;
        break;
      case 'resolved':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: report.type == 'book' ? Colors.blue.shade100 : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            report.type == 'book' ? Icons.book : Icons.music_note,
            color: report.type == 'book' ? Colors.blue.shade800 : Colors.orange.shade800,
          ),
        ),
        title: Text(report.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reported by: ${report.reporterName}'),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(report.description),
                SizedBox(height: 16),
                if (report.screenshotUrl.isNotEmpty) _buildScreenshot(report.screenshotUrl),
                _buildActionButtons(report),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenshot(String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Screenshot:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, color: Colors.grey),
                        Text('Screenshot not available', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActionButtons(Report report) {
    return Row(
      children: [
        if (report.status == 'pending') ...[
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateReportStatus(report.id, 'reviewed'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Mark as Reviewed', style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(width: 8),
        ],
        if (report.status != 'resolved') ...[
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateReportStatus(report.id, 'resolved'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Mark as Resolved', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _updateReportStatus(String reportId, String status) async {
    try {
      // await ApiService.updateReportStatus(reportId, status); // Backend call

      setState(() {
        final index = _reports.indexWhere((r) => r.id == reportId);
        if (index != -1) {
          final oldReport = _reports[index];
          _reports[index] = Report(
            id: oldReport.id,
            type: oldReport.type,
            title: oldReport.title,
            description: oldReport.description,
            screenshotUrl: oldReport.screenshotUrl,
            reporterId: oldReport.reporterId,
            reporterName: oldReport.reporterName,
            createdAt: oldReport.createdAt,
            status: status,
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report status updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update report status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
