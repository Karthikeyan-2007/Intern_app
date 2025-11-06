import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_app/Staff/Notes.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {

  final List<Map<String, dynamic>> _todayTimetable = [
    {
      'subject': 'Mathematics',
      'class': 'Grade 10 - A',
      'room': 'Room 101',
      'start': '08:00',
      'end': '08:45',
      'status': 'completed', 
    },
    {
      'subject': 'Physics',
      'class': 'Grade 10 - B',
      'room': 'Lab 3',
      'start': '10:00',
      'end': '10:45',
      'status': 'upcoming',
    },
    {
      'subject': 'Chemistry',
      'class': 'Grade 11 - A',
      'room': 'Chem Lab',
      'start': '01:00',
      'end': '01:45',
      'status': 'upcoming',
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'parent_message',
      'title': 'New message from parent',
      'body': 'Regarding Alex’s Physics test',
      'time': DateTime.now().subtract(const Duration(minutes: 15)),
      'is_read': false,
    },
    {
      'type': 'principal_announcement',
      'title': 'Staff Meeting Today',
      'body': '3:00 PM in Conference Room',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'is_read': true,
    },
    {
      'type': 'student_update',
      'title': 'Attendance Alert',
      'body': '3 students marked absent in Grade 10-A',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'is_read': false,
    },
  ];

  final Map<String, dynamic> _attendanceSummary = {
    'today': {'present': 87, 'absent': 3, 'total': 90},
    'week': {'present': 420, 'absent': 12, 'total': 432},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                title: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Icon(Icons.school_rounded, color: Color(0xFF667EEA), size: 24),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("ABC hr. sec. school", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                        Text("welcome to school", style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_rounded, color: Colors.white),
                      tooltip: "Notifications",
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu_rounded, color: Colors.white),
                  tooltip: "Menu",
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Teacher ID: TCH12345",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Name: Karthikeyan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        SizedBox(height: 6,),
                        Text(
                          "Email: karthi.keyan@bluevalley.edu",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Department: Science",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.edit, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: NavigationCard(
              title: 'Upload Notes',
              subtitle: 'Class-wise learning material',
              icon: Icons.upload_file,
              iconColor: Colors.green,
              width: double.infinity,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TeacherNotesUploadPage()),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildAttendanceCard(_attendanceSummary),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildSectionHeader('Today’s Schedule'),
            ),
          ),
          ..._todayTimetable.map((slot) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: _buildTimetableSlot(slot),
                ),
              )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: _buildSectionHeader('Notifications'),
            ),
          ),
          ..._notifications.map((note) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: _buildNotificationCard(note),
                ),
              )),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> summary) {
    final today = summary['today'] as Map<String, int>;
    final week = summary['week'] as Map<String, int>;
    final todayPercent = (today['present']! / today['total']! * 100).toInt();
    final weekPercent = (week['present']! / week['total']! * 100).toInt();

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
            'Attendance Summary',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildAttendanceRow('Today', todayPercent, today['present']!, today['total']!),
          const SizedBox(height: 12),
          _buildAttendanceRow('This Week', weekPercent, week['present']!, week['total']!),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(String label, int percent, int present, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$label: $present/$total'),
            const Spacer(),
            Text('$percent%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percent / 100,
          backgroundColor: Colors.grey[200],
          color: Colors.green,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
    );
  }

  Widget _buildTimetableSlot(Map<String, dynamic> slot) {
    final isUpcoming = slot['status'] == 'upcoming';
    final color = isUpcoming ? Colors.blue : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${slot['start']} – ${slot['end']}',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              Text(slot['room'], style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(slot['subject'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(slot['class'], style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
          if (isUpcoming)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Upcoming', style: TextStyle(color: Colors.blue, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> note) {
    final isRead = note['is_read'] as bool;
    final type = note['type'] as String;
    Color iconColor;
    IconData icon;
    if (type == 'parent_message') {
      icon = Icons.chat_bubble;
      iconColor = Colors.blue;
    } else if (type == 'principal_announcement') {
      icon = Icons.announcement;
      iconColor = Colors.purple;
    } else {
      icon = Icons.person_off;
      iconColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey[50] : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: isRead
            ? null
            : Border(left: BorderSide(color: Colors.blue.shade400, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(note['body'], style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(note['time']),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final double? width;

  const NavigationCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    required this.icon,
    this.iconColor = Colors.blue,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, size: 28, color: iconColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  ],
                ),
                if (description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
