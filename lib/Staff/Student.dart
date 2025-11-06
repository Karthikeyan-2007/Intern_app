import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
class TeacherStudentManagerPage extends StatefulWidget {

  @override
  State<TeacherStudentManagerPage> createState() =>
      _TeacherAssignmentManagerPageState();
}

class _TeacherAssignmentManagerPageState
    extends State<TeacherStudentManagerPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();


  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Approve Managment',
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
                  Tab(text: 'Approve'),
                  Tab(text: 'Stusents'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TeacherLeaveApprovalPage(),
                  TeacherStudentDashboardPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherStudentDashboardPage extends StatefulWidget {
  const TeacherStudentDashboardPage({super.key});

  @override
  State<TeacherStudentDashboardPage> createState() =>
      _TeacherStudentDashboardPageState();
}

class _TeacherStudentDashboardPageState
    extends State<TeacherStudentDashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<String, dynamic>? _selectedStudent;

  final List<Map<String, dynamic>> _allStudents = [
    {
      'id': 'usr_s1',
      'full_name': 'Alex Johnson',
      'roll_number': '10A-01',
      'email': 'alex.j@student.edu',
      'phone': '+91 98765 43210',
      'date_of_birth': '2010-05-12',
      'profile_picture_url': null,
      'class': 'Grade 10 - A',
    },
    {
      'id': 'usr_s2',
      'full_name': 'Emma Davis',
      'roll_number': '10A-02',
      'email': 'emma.d@student.edu',
      'phone': '+91 98765 43211',
      'date_of_birth': '2010-08-23',
      'profile_picture_url': null,
      'class': 'Grade 10 - A',
    },
    {
      'id': 'usr_s3',
      'full_name': 'Rohan Patel',
      'roll_number': '10A-03',
      'email': 'rohan.p@student.edu',
      'phone': '+91 98765 43212',
      'date_of_birth': '2010-03-17',
      'profile_picture_url': null,
      'class': 'Grade 10 - A',
    },
  ];

  final List<Map<String, dynamic>> _leaveRequests = [
    {
      'id': 'leave_001',
      'student_id': 'usr_s3',
      'reason': 'Medical appointment',
      'date': DateTime.now().add(const Duration(days: 2)),
      'status': 'pending',
    }
  ];

  final List<Map<String, dynamic>> _performanceData = [
    {'test': 'Physics Midterm', 'marks': 92.0},
    {'test': 'Math Quiz', 'marks': 95.0},
    {'test': 'Biology Test', 'marks': 88.0},
    {'test': 'English Essay', 'marks': 89.0},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredStudents {
    if (_searchQuery.isEmpty) return _allStudents;
    return _allStudents.where((student) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: _selectedStudent == null
          ? _buildStudentList()
          : _buildStudentDetail(_selectedStudent!),
    );
  }

  Widget _buildStudentList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return _buildStudentCard(student);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search by name or roll number...',
          prefixIcon: Icon(Icons.search, color: Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    return GestureDetector(
      onTap: () => setState(() => _selectedStudent = student),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              child: const Icon(Icons.person, size: 28, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['full_name'],
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Roll: ${student['roll_number']} • ${student['class']}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 🔹 Student Detail Screen
  Widget _buildStudentDetail(Map<String, dynamic> student) {
    final attendancePercent = 95;
    final leaveRequest = _leaveRequests
        .where((r) => r['student_id'] == student['id'])
        .toList()
        .firstOrNull;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          title: Text(student['full_name']),
          actions: [
            IconButton(
              onPressed: () => setState(() => _selectedStudent = null),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileSummary(student),
                const SizedBox(height: 24),
                _buildAttendanceCard(attendancePercent),
                const SizedBox(height: 24),
                _buildPerformanceGraph(),
                const SizedBox(height: 24),
                if (leaveRequest != null) _buildLeaveRequestCard(leaveRequest),
                const SizedBox(height: 24),
                _buildQuickActions(student),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSummary(Map<String, dynamic> student) => Container(
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('Email', student['email']),
            _buildInfoRow('Phone', student['phone']),
            _buildInfoRow('Date of Birth', student['date_of_birth']),
            _buildInfoRow('Class', student['class']),
          ],
        ),
      );

  Widget _buildAttendanceCard(int percent) => Container(
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Attendance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text('$percent% attendance this month',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildPerformanceGraph() {
    final data = _performanceData
        .map((d) => PerformanceData(d['test'] as String, d['marks'] as double))
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performance Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries>[
                LineSeries<PerformanceData, String>(
                  dataSource: data,
                  xValueMapper: (PerformanceData d, _) => d.test,
                  yValueMapper: (PerformanceData d, _) => d.marks,
                  color: const Color(0xFF3B82F6),
                  markerSettings: const MarkerSettings(isVisible: true),
                )
              ],
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestCard(Map<String, dynamic> leave) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Leave Request — Pending',
                style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 12),
            Text('Reason: ${leave['reason']}'),
            Text('Date: ${DateFormat('MMM d, y').format(leave['date'])}'),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton(
                    onPressed: () => _showSnack('Leave approved'),
                    child: const Text('Approve')),
                const SizedBox(width: 10),
                OutlinedButton(
                    onPressed: () => _showSnack('Leave rejected'),
                    child: const Text('Reject')),
              ],
            )
          ],
        ),
      );

  Widget _buildQuickActions(Map<String, dynamic> student) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionCard('Message Parent', Icons.chat_bubble, Colors.blue,
                  () => _showSnack('Chat started')),
                  SizedBox(width: 10,),
              _buildActionCard('Generate Report', Icons.bar_chart, Colors.green,
                  () => _showSnack('Report generated')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: 150,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 10),
                Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildInfoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
                width: 120,
                child: Text('$label:',
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Expanded(child: Text(value)),
          ],
        ),
      );
}

class PerformanceData {
  final String test;
  final double marks;
  PerformanceData(this.test, this.marks);
}

extension FirstOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}


class TeacherLeaveApprovalPage extends StatefulWidget {
  const TeacherLeaveApprovalPage({super.key});

  @override
  State<TeacherLeaveApprovalPage> createState() =>
      _TeacherLeaveApprovalPageState();
}

class _TeacherLeaveApprovalPageState extends State<TeacherLeaveApprovalPage> {
  // Mock data from your `leave_requests` table
  final List<Map<String, dynamic>> _pendingRequests = [
    {
      'id': 'leave_001',
      'student': {
        'name': 'Alex Johnson',
        'roll': '10A-01',
        'class': 'Grade 10 - A',
      },
      'type': 'leave',
      'reason': 'Medical appointment with dentist',
      'date_range': 'Nov 5, 2025',
      'applied_at': DateTime.now().subtract(const Duration(hours: 3)),
      'status': 'pending',
    },
    {
      'id': 'leave_002',
      'student': {
        'name': 'Rohan Patel',
        'roll': '10A-03',
        'class': 'Grade 10 - A',
      },
      'type': 'on_duty',
      'reason': 'Participating in State Science Exhibition',
      'date_range': 'Nov 7–8, 2025',
      'applied_at': DateTime.now().subtract(const Duration(hours: 12)),
      'status': 'pending',
    },
    {
      'id': 'leave_003',
      'student': {
        'name': 'Priya Singh',
        'roll': '10A-04',
        'class': 'Grade 10 - A',
      },
      'type': 'leave',
      'reason': 'Family function out of town',
      'date_range': 'Nov 12–13, 2025',
      'applied_at': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'pending',
    },
  ];

  Future<void> _approveLeave(String leaveId) async {
    // TODO: PATCH /leave-requests/{id}
    // { "status": "approved", "approved_by": "usr_teacher_01" }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Leave approved'), backgroundColor: Colors.green),
    );
    setState(() {
      final req = _pendingRequests.firstWhere((r) => r['id'] == leaveId);
      req['status'] = 'approved';
    });
  }

  Future<void> _rejectLeave(String leaveId) async {
    // TODO: PATCH /leave-requests/{id}
    // { "status": "rejected", "approved_by": "usr_teacher_01" }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Leave rejected'), backgroundColor: Colors.red),
    );
    setState(() {
      final req = _pendingRequests.firstWhere((r) => r['id'] == leaveId);
      req['status'] = 'rejected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _pendingRequests.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pendingRequests.length,
              itemBuilder: (context, index) {
                final req = _pendingRequests[index];
                return _buildLeaveCard(
                  req,
                  onApprove: () => _approveLeave(req['id']),
                  onReject: () => _rejectLeave(req['id']),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          SizedBox(height: 20),
          Text(
            'No pending leave requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'All requests have been processed',
            style: TextStyle(fontSize: 14, color: Color.fromRGBO(117, 117, 117, 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveCard(
    Map<String, dynamic> leave, {
    required VoidCallback onApprove,
    required VoidCallback onReject,
  }) {
    final isLeave = leave['type'] == 'leave';
    final student = leave['student'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Type + Student
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLeave ? Colors.red.shade100 : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLeave ? Icons.event_busy : Icons.work,
                        size: 16,
                        color: isLeave ? Colors.red : Colors.blue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isLeave ? 'Leave Request' : 'On-Duty Request',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isLeave ? Colors.red : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  student['class'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Student Name & Roll
            Text(
              student['name'],
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
            Text(
              'Roll: ${student['roll']}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),

            // Reason
            Text(
              leave['reason'],
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 12),

            // Date & Applied Time
            Wrap(
              spacing: 16,
              children: [
                _buildInfoChip(Icons.date_range, leave['date_range']),
                _buildInfoChip(Icons.access_time, 'Applied ${DateFormat('MMM d, h:mm a').format(leave['applied_at'])}'),
              ],
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: onReject,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onApprove,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}