import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PrincipalDashboardPage extends StatefulWidget {
  const PrincipalDashboardPage({super.key});

  @override
  State<PrincipalDashboardPage> createState() => _PrincipalDashboardPageState();
}

class _PrincipalDashboardPageState extends State<PrincipalDashboardPage>
    with SingleTickerProviderStateMixin {
  final String _principalName = 'Dr. Anjali Mehta';
  final String _schoolName = 'Education Academy';

  final Map<String, dynamic> _summary = {
    'total_students': 1240,
    'total_teachers': 85,
    'students_present': 1198,
    'teachers_present': 82,
    'active_classes': 32,
    'pending_tasks': 8,
  };

  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'title': 'Grade 10 Physics Midterm',
      'type': 'exam',
      'date': DateTime.now().add(const Duration(days: 2)),
      'class_count': 2,
    },
    {
      'title': 'Parent-Teacher Meeting',
      'type': 'event',
      'date': DateTime.now().add(const Duration(days: 5)),
      'class_count': 12,
    },
    {
      'title': 'Independence Day Holiday',
      'type': 'holiday',
      'date': DateTime.now().add(const Duration(days: 15)),
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_001',
      'title': 'Leave Requests Pending',
      'body': '4 requests awaiting approval',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'priority': 'high',
      'category': 'leave',
    },
    {
      'id': 'notif_002',
      'title': 'Proctoring Alert',
      'body': 'High-risk session detected in Grade 12 Math test',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'priority': 'medium',
      'category': 'proctoring',
    },
    {
      'id': 'notif_003',
      'title': 'New Parent Query',
      'body': 'Regarding Grade 10 timetable change',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'priority': 'low',
      'category': 'query',
    },
  ];

  final List<AttendanceData> _attendanceData = [
    AttendanceData('Mon', 95, 98),
    AttendanceData('Tue', 93, 96),
    AttendanceData('Wed', 96, 99),
    AttendanceData('Thu', 94, 97),
    AttendanceData('Fri', 97, 100),
  ];

  final List<PerformanceData> _performanceData = [
    PerformanceData('Physics', 88),
    PerformanceData('Mathematics', 92),
    PerformanceData('Biology', 85),
    PerformanceData('English', 89),
    PerformanceData('Chemistry', 90),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // ===== 1. Hero Header =====
          _buildHeroHeader(),

          // ===== 2. Summary Cards =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildSummaryCards(_summary),
            ),
          ),

          // ===== 3. Key Metrics =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildKeyMetrics(_summary),
            ),
          ),

          // ===== 4. Charts =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: _buildAttendanceChart(_attendanceData),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: _buildPerformanceChart(_performanceData), 
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: _buildUpcomingEventsSection(),
            ),
          ),

          // ===== 6. Priority Alerts =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: _buildSectionHeader('Priority Alerts', Icons.priority_high, Colors.red),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildNotificationCard(_notifications[index]),
                ),
                childCount: _notifications.length,
              ),
            ),
          ),

          // ===== 7. Quick Actions =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: _buildSectionHeader('Quick Actions', Icons.bolt, const Color(0xFF3B82F6)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildQuickActions(),
            ),
          ),

          // ===== 8. System Health =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSystemStatus(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 160,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF1E293B),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                      ),
                    ),
                    child: const Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        _principalName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Principal • $_schoolName',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== 2. Summary Cards =====
  Widget _buildSummaryCards(Map<String, dynamic> summary) {
    return Row(
      children: [
        _buildStatCard('Total\nStudents', summary['total_students'] ?? 0, Colors.blue, Icons.school),
        const SizedBox(width: 10),
        _buildStatCard('Total\nTeachers', summary['total_teachers'] ?? 0, Colors.green, Icons.person_outline),
        const SizedBox(width: 10),
        _buildStatCard('Students\nPresent', summary['students_present'] ?? 0, Colors.orange, Icons.check_circle_outline),
        const SizedBox(width: 10),
        _buildStatCard('Teachers\nPresent', summary['teachers_present'] ?? 0, Colors.purple, Icons.verified_outlined),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ===== 3. Key Metrics =====
  Widget _buildKeyMetrics(Map<String, dynamic> summary) {
    return Row(
      children: [
        _buildMetricCard('Active Classes', '${summary['active_classes']}', Colors.blue),
        const SizedBox(width: 12),
        _buildMetricCard('Pending Tasks', '${summary['pending_tasks']}', Colors.orange),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  // ===== 5. Upcoming Events =====
  Widget _buildUpcomingEventsSection() {
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.calendar_today, size: 16, color: Colors.red),
              ),
              const SizedBox(width: 8),
              const Text('Upcoming Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          ..._upcomingEvents.map(_buildEventCard),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    Color color = Colors.grey;
    IconData icon = Icons.event;
    String label = '';

    switch (event['type']) {
      case 'exam':
        color = Colors.red;
        icon = Icons.assignment;
        label = 'Exam';
        break;
      case 'event':
        color = const Color(0xFF3B82F6);
        icon = Icons.event;
        label = 'Event';
        break;
      case 'holiday':
        color = Colors.green;
        icon = Icons.celebration;
        label = 'Holiday';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 3)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Text(event['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            DateFormat('EEE, MMM d').format(event['date']),
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          if (event['class_count'] != null)
            Text('${event['class_count']} classes affected', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  // ===== Charts & Helpers =====
  Widget _buildAttendanceChart(List<AttendanceData> data) {
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
          const Text('Weekly Attendance Trend', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(labelStyle: const TextStyle(fontSize: 11)),
              primaryYAxis: NumericAxis(minimum: 80, maximum: 100, labelStyle: const TextStyle(fontSize: 11)),
              series: <CartesianSeries>[
                LineSeries<AttendanceData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.day,
                  yValueMapper: (d, _) => d.student,
                  name: 'Students',
                  color: Colors.blue,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
                LineSeries<AttendanceData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.day,
                  yValueMapper: (d, _) => d.teacher,
                  name: 'Teachers',
                  color: Colors.green,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
              legend: const Legend(isVisible: true, position: LegendPosition.bottom),
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(List<PerformanceData> data) {
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
          const Text('Subject Performance', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(labelRotation: -45, labelStyle: const TextStyle(fontSize: 10)),
              series: <CartesianSeries>[
                ColumnSeries<PerformanceData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.subject,
                  yValueMapper: (d, _) => d.marks,
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

  // ===== Notifications =====
  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> note) {
    Color color = Colors.grey;
    switch (note['priority']) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.notification_important, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(note['body'], style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, h:mm a').format(note['time']),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Approve Leaves',
        'icon': Icons.event_busy,
        'color': Colors.orange,
        'onTap': _approveLeaves
      },
      {
        'title': 'Send Alert',
        'icon': Icons.notifications_active,
        'color': Colors.blue,
        'onTap': _sendNotification
      },
      {
        'title': 'View Queries',
        'icon': Icons.question_answer,
        'color': Colors.purple,
        'onTap': _viewQueries
      },
      {
        'title': 'Generate Report',
        'icon': Icons.analytics,
        'color': Colors.green,
        'onTap': _generateReport
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.9, // Adjust height/width ratio
      ),
      itemBuilder: (context, index) {
        final action = actions[index];

        return GestureDetector(
          onTap: action['onTap'] as void Function()?,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  color: Colors.black.withOpacity(0.08),
                )
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (action['color'] as Color).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    action['icon'] as IconData,
                    color: action['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    action['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===== System Status =====
  Widget _buildSystemStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 16),
          _buildStatusRow('Active Sessions', '248', Colors.green),
          _buildStatusRow('Billing Cycle', 'Ends in 18 days', Colors.blue),
          _buildStatusRow('Storage Usage', '65% of 5 TB', Colors.orange),
          _buildStatusRow('Server Uptime', '99.8%', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // ===== Helpers =====
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _approveLeaves() => _showSnackBar('Opening leave requests...');
  void _sendNotification() => _showSnackBar('Composing school-wide notification...');
  void _viewQueries() => _showSnackBar('Loading parent and teacher queries...');
  void _generateReport() => _showSnackBar('Generating institutional report...');

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.blue, behavior: SnackBarBehavior.floating),
    );
  }
}

class AttendanceData {
  final String day;
  final int student;
  final int teacher;

  AttendanceData(this.day, this.student, this.teacher);
}

class PerformanceData {
  final String subject;
  final int marks;

  PerformanceData(this.subject, this.marks);
}