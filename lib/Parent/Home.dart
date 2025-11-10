import 'package:flutter/material.dart';
import 'package:school_app/Parent/Alert.dart';
import 'package:school_app/Parent/Navigator.dart';
import 'dart:math' as math;
import 'Reports.dart';
import 'Timetable.dart';
import 'package:fl_chart/fl_chart.dart';


class ParentHomePage extends StatefulWidget {
  const ParentHomePage({super.key});

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> with TickerProviderStateMixin {
  int _activeChildIndex = 0;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> _children = [
    {
      'id': 'usr_student_01',
      'name': 'Alex Johnson',
      'class': 'Grade 10 - A',
      'profile_picture_url': null,
      'rank': 3,
      'total_students': 42,
      'attendance': 95,
      'upcoming_tests': 2,
      'assignments_pending': 3,
      'behavior_score': 'Excellent',
      'weekly_progress': [85, 88, 90, 87, 89, 91, 92],
      'subjects': [
        {'name': 'Mathematics', 'score': 92, 'color': Colors.blue},
        {'name': 'Physics', 'score': 88, 'color': Colors.purple},
        {'name': 'Chemistry', 'score': 85, 'color': Colors.green},
        {'name': 'English', 'score': 94, 'color': Colors.orange},
      ],
      'recent_activities': [
        {'type': 'test_graded', 'title': 'Physics Midterm', 'score': '92/100', 'time': '2 hours ago'},
        {'type': 'attendance', 'title': 'Marked absent', 'details': 'Oct 25', 'time': '1 day ago'},
        {'type': 'assignment', 'title': 'Math Homework Due', 'details': 'Chapter 5', 'time': '2 days ago'},
      ],
    },
    {
      'id': 'usr_student_02',
      'name': 'Emma Johnson',
      'class': 'Grade 7 - B',
      'profile_picture_url': null,
      'rank': 1,
      'total_students': 38,
      'attendance': 100,
      'upcoming_tests': 1,
      'assignments_pending': 1,
      'behavior_score': 'Outstanding',
      'weekly_progress': [92, 94, 95, 96, 97, 98, 96],
      'subjects': [
        {'name': 'Mathematics', 'score': 98, 'color': Colors.blue},
        {'name': 'Science', 'score': 96, 'color': Colors.green},
        {'name': 'English', 'score': 95, 'color': Colors.orange},
        {'name': 'History', 'score': 94, 'color': Colors.red},
      ],
      'recent_activities': [
        {'type': 'test_graded', 'title': 'Math Quiz', 'score': '20/20', 'time': '1 day ago'},
        {'type': 'note_uploaded', 'title': 'New Science Notes', 'details': 'Cell Biology', 'time': '2 days ago'},
        {'type': 'achievement', 'title': 'Star Student Award', 'details': 'Monthly Winner', 'time': '3 days ago'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = _children[_activeChildIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(child),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_children.length > 1) ...[
                    _buildChildSelector(),
                    const SizedBox(height: 20),
                  ],
                  _buildPerformanceOverview(child),
                  const SizedBox(height: 20),
                  _buildQuickActions(child),
                  const SizedBox(height: 20),
                  buildWeeklyProgressChart(child),
                  const SizedBox(height: 20),
                  _buildUpcomingEvents(),
                  const SizedBox(height: 20),
                  _buildRecentActivity(child),
                  const SizedBox(height: 20),
                  _buildTeacherRemarks(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> child) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D47A1),
                Color(0xFF1976D2),
              ]
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            child['name'].toString().substring(0, 1),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              child['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              child['class'],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationListPage(),
              ),
            );
          },
          icon: const Icon(Icons.notifications_outlined),
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildChildSelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _children.length,
        itemBuilder: (context, index) {
          final child = _children[index];
          final isActive = index == _activeChildIndex;
          return GestureDetector(
            onTap: () => setState(() => _activeChildIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [Colors.blue.shade600, Colors.purple.shade500],
                      )
                    : null,
                color: isActive ? null : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isActive ? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                    blurRadius: isActive ? 15 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.white24 : Colors.blue.shade50,
                    ),
                    child: Center(
                      child: Text(
                        child['name'].toString().substring(0, 1),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    child['name'],
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPerformanceOverview(Map<String, dynamic> child) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  child['behavior_score'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard('Rank', child['rank'].toString(), Icons.stars),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOverviewCard('Avg Score', '${child['attendance']}%', Icons.trending_up),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 23),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWeeklyProgressChart(Map<String, dynamic> child) {
    final progress = (child['weekly_progress'] as List).cast<num>();
    final maxValue = progress.reduce(math.max).toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Performance',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue + 10,

                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(10),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        "${progress[groupIndex]}%",
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),

                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                barGroups: List.generate(progress.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: progress[index].toDouble(),
                        width: 20,
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(Map<String, dynamic> child) {
    final actions = [
      {'icon': Icons.assessment, 'title': 'View\nReport', 'color': Colors.green, 'gradient': [Colors.green.shade400, Colors.green.shade600],'ontap':ParentExamReportPage()},
      {'icon': Icons.calendar_month, 'title': 'Time\nTable', 'color': Colors.purple, 'gradient': [Colors.purple.shade400, Colors.purple.shade600],'ontap': ParentSchedulePage()},
      {'icon': Icons.assignment, 'title': 'Pending\nTasks', 'color': Colors.red, 'gradient': [Colors.red.shade400, Colors.red.shade600],'ontap':''},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return GestureDetector(
              onTap: () {
                final target = action['ontap'];
                if (target is Widget) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => target));
                } else if (target is Function) {
                  final result = target();
                  if (result is Widget) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => result));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action not available')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action not implemented yet')));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: action['gradient'] as List<Color>,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (action['color'] as Color).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(action['icon'] as IconData, size: 28, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      action['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildEventItem('Parent-Teacher Meeting', 'Nov 2, 2024 - 3:00 PM', Colors.blue),
          _buildEventItem('Mathematics Test', 'Nov 5, 2024 - 10:00 AM', Colors.orange),
          _buildEventItem('Science Fair', 'Nov 10, 2024 - All Day', Colors.green),
        ],
      ),
    );
  }

  Widget _buildEventItem(String title, String date, Color color) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationListPage()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(Map<String, dynamic> child) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent view',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            child['recent_activities'].length,
            (i) {
              final activity = child['recent_activities'][i];
              return _buildActivityItem(activity);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    Color iconColor = Colors.orange;
    IconData icon = Icons.access_time;
    Color bgColor = Colors.orange.shade50;
    
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ParentNavigatorScreen(selectedIndex: 1,)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (activity['score'] != null)
                    Text(
                      'Score: ${activity['score']}',
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (activity['details'] != null)
                    Text(
                      activity['details'],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            Text(
              activity['time'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherRemarks() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.red.shade400],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.format_quote, color: Colors.white, size: 32),
              SizedBox(width: 8),
              Text(
                'Latest Teacher Remark',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Alex is showing excellent progress in Mathematics and Physics. Keep up the great work!',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                '— Mr. John Smith, Class Teacher',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}