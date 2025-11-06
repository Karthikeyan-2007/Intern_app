import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class TeacherAssignmentManagerPage extends StatefulWidget {
  const TeacherAssignmentManagerPage({super.key});

  @override
  State<TeacherAssignmentManagerPage> createState() =>
      _TeacherAssignmentManagerPageState();
}

class _TeacherAssignmentManagerPageState
    extends State<TeacherAssignmentManagerPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  String _selectedClass = 'Grade 10 - A';
  String _selectedType = 'formative';
  List<String> _attachedFiles = [];
  bool _isCreating = false;
  String _selectedStatusFilter = 'All';

  // Mock data from your DB schema
  final List<String> _classes = [
    'Grade 10 - A',
    'Grade 10 - B',
    'Grade 11 - A',
  ];

  final List<Map<String, dynamic>> _assignments = [
    {
      'id': 'test_001',
      'title': 'Physics Lab Report',
      'class': 'Grade 10 - A',
      'due_date': DateTime.now().add(const Duration(days: 2)),
      'type': 'summative',
      'total_students': 42,
      'submitted': 38,
      'graded': 35,
      'status': 'active',
    },
    {
      'id': 'test_002',
      'title': 'Math Algebra Quiz',
      'class': 'Grade 10 - B',
      'due_date': DateTime.now().add(const Duration(days: 5)),
      'type': 'formative',
      'total_students': 38,
      'submitted': 30,
      'graded': 25,
      'status': 'active',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _addAttachment() {
    setState(() {
      _attachedFiles.add('assignment_instructions.pdf');
    });
  }

  void _removeAttachment(String file) {
    setState(() => _attachedFiles.remove(file));
  }

  Future<void> _createAssignment() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() => _isCreating = true);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assignment created successfully!')),
      );
      setState(() {
        _isCreating = false;
        _titleController.clear();
        _descController.clear();
        _attachedFiles.clear();
      });
    }
  }

  List<Map<String, dynamic>> get _filteredAssignments {
    if (_selectedStatusFilter == 'All') return _assignments;
    if (_selectedStatusFilter == 'Submitted') {
      return _assignments.where((a) => a['submitted'] > 0).toList();
    }
    return _assignments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Assignments',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1976D2),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFF1976D2).withOpacity(0.2), height: 1),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Export
            },
            icon: const Icon(Icons.download_outlined),
            color: const Color(0xFF1976D2),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: const Color(0xFF1976D2),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF1976D2),
                tabs: const [
                  Tab(text: 'Manage'),
                  Tab(text: 'Submissions'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildManageTab(context),
                  TeacherMarksUploadPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageTab(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        backgroundColor: const Color(0xFF2563EB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📊 Submission Progress Chart
            _buildProgressChart(),
            const SizedBox(height: 24),

            // 🔍 Status Filter Buttons
            _buildStatusFilter(),
            const SizedBox(height: 24),

            // 📋 Assignment List
            if (_filteredAssignments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    "No assignments found.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else
              ..._filteredAssignments.map((assign) => _buildAssignmentCard(assign)).toList(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    final data = _assignments.map((a) {
      final submitted = (a['submitted'] ?? 0) as int;
      final total = (a['total_students'] ?? 1) as int; // avoid division by zero
      final submittedPercent = (submitted / total) * 100.0;

      return AssignmentProgress(a['class']?.toString() ?? 'Unknown', submittedPercent);
    }).toList();

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
          const Text(
            'Submission Progress',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 100),
              series: <CartesianSeries<AssignmentProgress, String>>[
                ColumnSeries<AssignmentProgress, String>(
                  dataSource: data,
                  xValueMapper: (AssignmentProgress progress, _) => progress.className,
                  yValueMapper: (AssignmentProgress progress, _) => progress.percentage,
                  color: const Color(0xFF3B82F6),
                ),
              ],
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
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
        children: [
          const Text('Filter: ', style: TextStyle(fontWeight: FontWeight.bold)),
          ...['All', 'Submitted', 'Graded'].map((status) {
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: FilterChip(
                label: Text(status),
                selected: _selectedStatusFilter == status,
                onSelected: (selected) => setState(() => _selectedStatusFilter = status),
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF3B82F6),
                labelStyle: TextStyle(
                  color: _selectedStatusFilter == status ? Colors.white : Colors.grey[800],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assign) {
    final submittedPercent = (assign['submitted'] as int) / (assign['total_students'] as int) * 100;
    final isOverdue = (assign['due_date'] as DateTime).isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: assign['type'] == 'summative' ? Colors.red.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  assign['type'].toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: assign['type'] == 'summative' ? Colors.red : Colors.orange,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                isOverdue ? 'OVERDUE' : 'Active',
                style: TextStyle(
                  color: isOverdue ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            assign['title'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            assign['class'],
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Due: ${DateFormat('MMM d, y').format(assign['due_date'])}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: submittedPercent / 100,
            backgroundColor: Colors.grey[200],
            color: Colors.blue,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 6),
          Text(
            '${assign['submitted']} of ${assign['total_students']} submitted',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  // TODO: View submissions
                },
                child: const Text('View Submissions'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  // TODO: Send reminder
                },
                child: const Text('Remind'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create New Assignment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Class & Type
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedClass,
                      items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => _selectedClass = v!),
                      decoration: const InputDecoration(
                        labelText: 'Class',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedType,
                      items: [
                        DropdownMenuItem(value: 'formative', child: Text('Formative')),
                        DropdownMenuItem(value: 'summative', child: Text('Summative')),
                      ],
                      onChanged: (v) => setState(() => _selectedType = v!),
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Due Date
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('Due Date: ${DateFormat('MMM d, y').format(_dueDate)}'),
                onTap: _openDatePicker,
              ),

              // Attachments
              if (_attachedFiles.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _attachedFiles.map((file) {
                    return Chip(
                      label: Text(file),
                      onDeleted: () => _removeAttachment(file),
                      deleteIcon: const Icon(Icons.close, size: 16),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _addAttachment,
                icon: const Icon(Icons.attach_file),
                label: const Text('Attach File'),
              ),

              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isCreating ? null : _createAssignment,
                child: _isCreating
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)))
                    : const Text('Create Assignment'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AssignmentProgress {
  final String className;
  final double percentage;

  AssignmentProgress(this.className, this.percentage);
}

class TeacherMarksUploadPage extends StatefulWidget {
  const TeacherMarksUploadPage({super.key});

  @override
  State<TeacherMarksUploadPage> createState() => _TeacherMarksUploadPageState();
}

class _TeacherMarksUploadPageState extends State<TeacherMarksUploadPage> {
  String _selectedClass = 'Grade 10 - A';
  String _selectedSubject = 'Mathematics';
  String _selectedTest = 'Algebra Quiz';
  bool _isPublishing = false;

  // Mock data from your DB schema
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

  final Map<String, List<String>> _testsBySubject = {
    'Mathematics': ['Algebra Quiz', 'Geometry Test', 'Calculus Midterm'],
    'Physics': ['Newton’s Laws Test', 'Optics Quiz'],
    'English': ['Essay Writing', 'Grammar Test'],
  };

  // Student roster from `enrollments` + `users`
  final List<Map<String, dynamic>> _students = [
    {'id': 's1', 'name': 'Alex Johnson', 'roll': '10A-01', 'marks': 95.0},
    {'id': 's2', 'name': 'Emma Davis', 'roll': '10A-02', 'marks': 88.0},
    {'id': 's3', 'name': 'Rohan Patel', 'roll': '10A-03', 'marks': null},
    {'id': 's4', 'name': 'Priya Singh', 'roll': '10A-04', 'marks': 92.0},
    {'id': 's5', 'name': 'Liam Brown', 'roll': '10A-05', 'marks': 85.0},
  ];

  List<Map<String, dynamic>> _marksList = [];

  @override
  void initState() {
    super.initState();
    _marksList = List<Map<String, dynamic>>.from(_students);
  }

  void _updateMarks(String studentId, String value) {
    final numValue = value.isEmpty ? null : double.tryParse(value);
    setState(() {
      final student = _marksList.firstWhere((s) => s['id'] == studentId);
      student['marks'] = numValue;
    });
  }

  void _bulkAction(String action) {
    setState(() {
      for (var student in _marksList) {
        if (action == 'clear') {
          student['marks'] = null;
        } else if (action == 'auto') {
          // Simulate AI-assisted grading
          student['marks'] = (student['marks'] ?? 85.0) + 2.0;
        }
      }
    });
  }

  double? _calculateAverage() {
    final validMarks = _marksList.where((s) => s['marks'] != null).map((s) => s['marks'] as double).toList();
    if (validMarks.isEmpty) return null;
    return validMarks.reduce((a, b) => a + b) / validMarks.length;
  }

  Future<void> _publishGrades() async {
    setState(() => _isPublishing = true);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grades published successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final average = _calculateAverage();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            _buildFilters(),

            const SizedBox(height: 24),

            // Summary Card
            _buildSummaryCard(average),

            const SizedBox(height: 24),

            // Bulk Actions
            _buildBulkActions(),

            const SizedBox(height: 24),

            // Student Marks Table
            _buildMarksTable(),

            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isPublishing ? null : _publishGrades,
        icon: _isPublishing
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
            : const Icon(Icons.publish, size: 20),
        label: Text(_isPublishing ? 'Publishing...' : 'Publish Grades'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFilters() {
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
          const Text(
            'Select Assessment',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        _selectedTest = _testsBySubject[_selectedSubject]!.first;
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
                      setState(() {
                        _selectedSubject = value;
                        _selectedTest = _testsBySubject[value]!.first;
                      });
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
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedTest,
            items: (_testsBySubject[_selectedSubject] ?? [])
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedTest = value);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Assessment',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(double? average) {
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
          _buildSummaryItem('Total Students', '${_marksList.length}', Colors.grey),
          _buildSummaryItem(
            'Graded',
            '${_marksList.where((s) => s['marks'] != null).length}',
            Colors.blue,
          ),
          _buildSummaryItem(
            'Avg Marks',
            average != null ? '${average.toStringAsFixed(1)}' : '—',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
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
            onPressed: () => _bulkAction('auto'),
            child: const Text('Auto-Fill'),
          ),
          FilledButton.tonal(
            onPressed: () => _bulkAction('clear'),
            child: const Text('Clear All'),
          ),
          OutlinedButton(
            onPressed: () {
              // TODO: Save draft
            },
            child: const Text('Save Draft'),
          ),
        ],
      ),
    );
  }

  Widget _buildMarksTable() {
    return Container(
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                SizedBox(width: 60),
                Expanded(child: Text('Student', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                Text('Roll No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 120),
                Text('Marks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ..._marksList.map((student) => _buildStudentRow(student)).toList(),
        ],
      ),
    );
  }

  Widget _buildStudentRow(Map<String, dynamic> student) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade100,
            ),
            child: const Icon(Icons.person, size: 20, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(student['roll'], style: TextStyle(color: Colors.grey[700])),
          const SizedBox(width: 16),
          SizedBox(
            width: 100,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '0.0',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              controller: TextEditingController(text: student['marks']?.toString()),
              onChanged: (value) => _updateMarks(student['id'], value),
            ),
          ),
        ],
      ),
    );
  }
}