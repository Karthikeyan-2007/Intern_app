import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherAttendancePage extends StatefulWidget {
  const TeacherAttendancePage({super.key});

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedClass = 'Grade 10 - A';
  String _selectedSubject = 'Mathematics';
  bool _isSubmitting = false;
  bool _hasUnsavedChanges = false;

  final List<String> _classes = [
    'Grade 10 - A',
    'Grade 10 - B',
    'Grade 11 - A',
  ];

  final Map<String, List<String>> _subjectsByClass = {
    'Grade 10 - A': ['Mathematics', 'Physics', 'English'],
    'Grade 10 - B': ['Mathematics', 'Chemistry', 'Biology'],
    'Grade 11 - A': ['Calculus', 'Physics', 'Computer Science'],
  };

  final List<Map<String, dynamic>> _students = [
    {'id': 's1', 'name': 'Alex Johnson', 'roll': '10A-01', 'status': 'present'},
    {'id': 's2', 'name': 'Emma Davis', 'roll': '10A-02', 'status': 'present'},
    {'id': 's3', 'name': 'Rohan Patel', 'roll': '10A-03', 'status': 'absent'},
    {'id': 's4', 'name': 'Priya Singh', 'roll': '10A-04', 'status': 'on_duty'},
    {'id': 's5', 'name': 'Liam Brown', 'roll': '10A-05', 'status': 'present'},
  ];

  List<Map<String, dynamic>> _attendanceList = [];

  @override
  void initState() {
    super.initState();
    _attendanceList = List<Map<String, dynamic>>.from(_students);
  }

  void _updateStudentStatus(String studentId, String status) {
    setState(() {
      final student = _attendanceList.firstWhere((s) => s['id'] == studentId);
      student['status'] = status;
      _hasUnsavedChanges = true;
    });
  }

  void _markAll(String status) {
    setState(() {
      for (var student in _attendanceList) {
        student['status'] = status;
      }
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _submitAttendance() async {
    if (!_hasUnsavedChanges) return;

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _isSubmitting = false;
        _hasUnsavedChanges = false;
      });
    }
  }

  Future<void> _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // TODO: Fetch attendance for this date
        _attendanceList = List<Map<String, dynamic>>.from(_students);
        _hasUnsavedChanges = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final presentCount = _attendanceList.where((s) => s['status'] == 'present').length;
    final totalCount = _attendanceList.length;
    final presentPercent = totalCount > 0 ? (presentCount / totalCount * 100).toInt() : 0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            _buildDateAndFilters(),
            const SizedBox(height: 24),
            _buildSummaryCard(presentCount, totalCount, presentPercent),
            const SizedBox(height: 24),
            _buildBulkActions(),
            const SizedBox(height: 24),
            ..._attendanceList.map((student) => _buildStudentRow(student)).toList(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSubmitting ? null : _submitAttendance,
        icon: _isSubmitting
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
            : const Icon(Icons.check, size: 20),
        label: Text(_isSubmitting ? 'Submitting...' : 'Submit Attendance'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildDateAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Date:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _openDatePicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    DateFormat('EEEE, MMM d, y').format(_selectedDate),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // TODO: View history
                },
                icon: const Icon(Icons.history, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedClass,
                  items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedClass = value;
                        _selectedSubject = _subjectsByClass[value]!.first;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Class',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  items: (_subjectsByClass[_selectedClass] ?? [])
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedSubject = value);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int present, int total, int percent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryItem('Present', '$present', Colors.green),
          _buildSummaryItem('Total', '$total', Colors.grey),
          _buildSummaryItem('Attendance', '$percent%', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildBulkActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilledButton.tonal(
            onPressed: () => _markAll('present'),
            child: const Text('All Present'),
          ),
          FilledButton.tonal(
            onPressed: () => _markAll('absent'),
            child: const Text('All Absent'),
          ),
          FilledButton.tonal(
            onPressed: () {
              // TODO: Export
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentRow(Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade100,
            ),
            child: const Icon(Icons.person, size: 24, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'Roll: ${student['roll']}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          _buildStatusToggle(student['id'], student['status']),
        ],
      ),
    );
  }

  Widget _buildStatusToggle(String studentId, String currentStatus) {
    return Row(
      children: [
        _buildStatusButton(studentId, 'present', currentStatus == 'present', Icons.check, Colors.green),
        _buildStatusButton(studentId, 'absent', currentStatus == 'absent', Icons.close, Colors.red),
        _buildStatusButton(studentId, 'on_duty', currentStatus == 'on_duty', Icons.work, Colors.orange),
      ],
    );
  }

  Widget _buildStatusButton(String studentId, String status, bool isActive, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        padding: const EdgeInsets.all(8),
        onPressed: () => _updateStudentStatus(studentId, status),
        icon: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : color,
        ),
        style: IconButton.styleFrom(
          backgroundColor: isActive ? color : color.withOpacity(0.1),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}