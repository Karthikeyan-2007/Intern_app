// prc_class_student_manager_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:school_app/Principal/Studentview.dart';
// Remove the problematic import

class PrcClassStudentManagerPage extends StatefulWidget {
  const PrcClassStudentManagerPage({super.key});

  @override
  State<PrcClassStudentManagerPage> createState() =>
      _PrcClassStudentManagerPageState();
}

class _PrcClassStudentManagerPageState
    extends State<PrcClassStudentManagerPage> with TickerProviderStateMixin {
  // --- Dummy data (replace with Firestore in future) ---
  List<Map<String, dynamic>>? _selectedClassStudents;
  Map<String, dynamic>? _selectedStudent;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _classes = [
    {
      'id': 'cls_10a',
      'name': 'Grade 10',
      'section': 'A',
      'academic_year': '2025–2026',
      'total_students': 42,
    },
    {
      'id': 'cls_10b',
      'name': 'Grade 10',
      'section': 'B',
      'academic_year': '2025–2026',
      'total_students': 38,
    },
    {
      'id': 'cls_11a',
      'name': 'Grade 11',
      'section': 'A',
      'academic_year': '2025–2026',
      'total_students': 40,
    },
  ];

  final List<Map<String, dynamic>> _allStudents = [
    {
      'id': 's1',
      'full_name': 'Alex Johnson',
      'roll_number': '10A-01',
      'class_id': 'cls_10a',
      'email': 'alex.j@student.edu',
      'phone': '+91 98765 43210',
      'date_of_birth': '2010-05-12',
      'profile_picture_url': null,
      'class': 'Grade 10 - A',
    },
    {
      'id': 's2',
      'full_name': 'Emma Davis',
      'roll_number': '10A-02',
      'class_id': 'cls_10a',
      'email': 'emma.d@student.edu',
      'phone': '+91 98765 43211',
      'date_of_birth': '2010-08-23',
      'profile_picture_url': null,
      'class': 'Grade 10 - A',
    },
    {
      'id': 's3',
      'full_name': 'Rohan Patel',
      'roll_number': '10A-03',
      'class_id': 'cls_10a',
      'email': 'rohan.p@student.edu',
      'phone': '+91 98765 43212',
      'date_of_birth': '2010-03-17',
      'profile_picture_url': null,
      'class': 'Grade 10 - A',
    },
  ];

  Map<String, bool> _attendanceForSelectedMonth = {};
  late final AnimationController _fabController;
  bool _fabOpen = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _generateAttendanceForMonth(DateTime.now());
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  // --- Helper getters / methods ---
  Map<String, dynamic>? _getClassById(String? classId) {
    if (classId == null) return null;
    return _classes.firstWhere((c) => c['id'] == classId, orElse: () => {});
  }

  List<Map<String, dynamic>> get _filteredStudents {
    if (_searchQuery.isEmpty) return _selectedClassStudents ?? [];
    return (_selectedClassStudents ?? []).where((student) {
      final nameMatch = student['full_name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final rollMatch = student['roll_number']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return nameMatch || rollMatch;
    }).toList();
  }

  void _goToClass(String classId) {
    final students = _allStudents.where((s) => s['class_id'] == classId).toList();
    setState(() {
      _selectedClassStudents = students;
      _selectedStudent = null;
    });
    _generateAttendanceForMonth(DateTime.now());
  }

  void _goToStudent(Map<String, dynamic> student) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StudentDetailPage(student: student)
      ),
    );
  }

  void _sendNotification(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: Colors.blue),
    );
  }

  void _goBackToClasses() {
    setState(() {
      _selectedClassStudents = null;
      _selectedStudent = null;
    });
  }

  // Generate random attendance (demo) for the month
  void _generateAttendanceForMonth(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final rnd = Random(month.day + month.month + month.year);
    final map = <String, bool>{};
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(month.year, month.month, d);
      // random present/absent pattern but keep high attendance
      map[_dateKey(date)] = rnd.nextDouble() > 0.12;
    }
    setState(() => _attendanceForSelectedMonth = map);
  }

  String _dateKey(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // --- action stubs ---
  void _sendMessageToParent(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message to parent: $message'), backgroundColor: Colors.green),
    );
  }

  void _exportStudentReport(Map<String, dynamic> student) {
    // Stub: replace with actual PDF generation or share logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting report (stub)'), backgroundColor: Colors.orange),
    );
  }

  // FAB control
  void _toggleFab() {
    setState(() {
      _fabOpen = !_fabOpen;
      if (_fabOpen) {
        _fabController.forward();
      } else {
        _fabController.reverse();
      }
    });
  }

  // --- BUILD ---
  @override
  Widget build(BuildContext context) {
    final bgGradient = LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary.withOpacity(0.06),
        Theme.of(context).scaffoldBackgroundColor,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      // subtle gradient + safe background
      appBar: AppBar(
        title: _buildAppBarTitle(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
            tooltip: 'Filters',
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            child: _selectedStudent != null
                ? const SizedBox.shrink() // we push new route for profile
                : _selectedClassStudents != null
                    ? _buildStudentListView()
                    : _buildClassListView(),
          ),
        ),
      ),
      floatingActionButton: _buildSpeedDialFAB(),
    );
  }

  Widget _buildAppBarTitle() {
    if (_selectedStudent != null) {
      return Text(_selectedStudent?['full_name'] ?? 'Student');
    } else if (_selectedClassStudents != null && _selectedClassStudents!.isNotEmpty) {
      final cls = _getClassById(_selectedClassStudents?.first['class_id']);
      return Text('${cls?['name'] ?? 'Class'} • ${cls?['section'] ?? 'X'}');
    } else {
      return const Text('Classes');
    }
  }

  // --- Class list (cards) ---
  Widget _buildClassListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a class',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: _classes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cls = _classes[index];
                return _classCard(cls);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _classCard(Map<String, dynamic> cls) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _goToClass(cls['id']),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.65),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'class_${cls['id']}',
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.class_, size: 28, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cls['name']} - ${cls['section']}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cls['academic_year']} • ${cls['total_students']} students',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }

  // --- Student list view ---
  Widget _buildStudentListView() {
    final cls = _getClassById(_selectedClassStudents!.first['class_id']);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      child: Column(
        children: [
          // search + back
          Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search students by name or roll...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _goBackToClasses,
                icon: const Icon(Icons.close),
                tooltip: 'Back to classes',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${cls?['name'] ?? ''} • Section ${cls?['section'] ?? ''}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _filteredStudents.isEmpty
                  ? Center(child: Text('No students found', style: Theme.of(context).textTheme.bodyMedium))
                  : ListView.separated(
                      key: ValueKey(_filteredStudents.length),
                      itemCount: _filteredStudents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final student = _filteredStudents[index];
                        return _studentCard(student);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _studentCard(Map<String, dynamic> student) {
    final avatarTag = 'student_avatar_${student['id']}';
    return InkWell(
      onTap: () => _goToStudent(student),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Hero(
              tag: avatarTag,
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  student['full_name'].toString().split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student['full_name'], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Roll: ${student['roll_number']}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showQuickStudentActions(student),
                  icon: const Icon(Icons.more_vert),
                ),
                const SizedBox(height: 4),
                _smallAttendanceIndicatorForStudent(student),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _smallAttendanceIndicatorForStudent(Map<String, dynamic> student) {
    // show a tiny badge showing last month's attendance percentage (demo random)
    final rnd = (student['id'].hashCode % 15) + 85; // 85-99
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: rnd > 90 ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('$rnd% attendance', style: TextStyle(fontSize: 12, color: rnd > 90 ? Colors.green : Colors.orange)),
    );
  }

  // --- Speed-dial fab ---
  Widget _buildSpeedDialFAB() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // dimming overlay when open
        if (_fabOpen)
          GestureDetector(
            onTap: _toggleFab,
            child: Container(
              color: Colors.black.withOpacity(0.25),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // secondary buttons
              ScaleTransition(
                scale: CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack),
                child: Column(
                  children: [
                    if (_fabOpen) ...[
                      _fabChild(Icons.upload_file, 'Export class', () {
                        // export class data
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export class (stub)')));
                        _toggleFab();
                      }),
                      const SizedBox(height: 8),
                      _fabChild(Icons.notifications_active, 'Notify all', () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notify all (stub)')));
                        _toggleFab();
                      }),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fabChild(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  // --- Quick actions for student (modal) ---
  void _showQuickStudentActions(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Wrap(
            runSpacing: 12,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View Profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  _goToStudent(student);
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Message Parent'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showMessageComposer(student);
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Export Report'),
                onTap: () {
                  Navigator.of(context).pop();
                  _exportStudentReport(student);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessageComposer(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: 'Hello ${student['full_name']}\'s parent, ...');
        return AlertDialog(
          title: const Text('Message Parent'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendMessageToParent(controller.text.trim());
              },
              child: const Text('Send'),
            )
          ],
        );
      },
    );
  }

  // --- filters ---
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(label: const Text('Top attendance'), selected: false, onSelected: (_) {}),
                ChoiceChip(label: const Text('Low attendance'), selected: false, onSelected: (_) {}),
                ChoiceChip(label: const Text('Recently absent'), selected: false, onSelected: (_) {}),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
          ],
        ),
      ),
    );
  }
}