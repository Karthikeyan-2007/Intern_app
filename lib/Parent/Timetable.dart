import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ParentSchedulePage extends StatefulWidget {
  const ParentSchedulePage({super.key});

  @override
  State<ParentSchedulePage> createState() => _ParentSchedulePageState();
}

class _ParentSchedulePageState extends State<ParentSchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final studentName = 'Alex Johnson';
  final className = 'Grade 10 - A';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mock data aligned with your DB schema
    final List<Map<String, dynamic>> timetable = [
      {'day': 'Monday', 'slots': _mondaySlots},
      {'day': 'Tuesday', 'slots': _tuesdaySlots},
      // Add more days as needed
    ];

    final List<Map<String, dynamic>> exams = [
      {
        'title': 'Physics Midterm',
        'subject': 'Physics',
        'date': DateTime(2025, 11, 5),
        'time': '09:00 AM - 10:30 AM',
        'duration': '90 min',
        'type': 'summative',
        'room': 'Lab 3',
        'teacher': 'Dr. Meera Patel',
      },
      {
        'title': 'Mathematics Quiz',
        'subject': 'Mathematics',
        'date': DateTime(2025, 11, 12),
        'time': '11:00 AM - 11:45 AM',
        'duration': '45 min',
        'type': 'formative',
        'room': 'Room 102',
        'teacher': 'Mr. Rajesh Kumar',
      },
      {
        'title': 'Biology Practical',
        'subject': 'Biology',
        'date': DateTime(2025, 11, 18),
        'time': '01:00 PM - 02:30 PM',
        'duration': '90 min',
        'type': 'summative',
        'room': 'Bio Lab',
        'teacher': 'Ms. Ananya Singh',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Schedule',
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
            onPressed: () => _showActions(context),
            icon: const Icon(Icons.more_vert),
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
                controller: _tabController,
                labelColor: const Color(0xFF1976D2),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF1976D2),
                tabs: const [
                  Tab(text: 'Timetable'),
                  Tab(text: 'Exams'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTimetableTab(timetable),
                  _buildExamsTab(exams),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableTab(List<Map<String, dynamic>> timetable) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: timetable.length,
      itemBuilder: (context, index) {
        final day = timetable[index];
        return _buildDayCard(day['day'] as String, (day['slots'] as List).cast<Map<String, dynamic>>());
      },
    );
  }

  Widget _buildExamsTab(List<Map<String, dynamic>> exams) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        return _buildExamCard(exams[index]);
      },
    );
  }

  Widget _buildDayCard(String day, List<Map<String, dynamic>> slots) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Text(
              day,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            ),
          ),
          ...slots.map((slot) => _buildSlotRow(slot)).toList(),
        ],
      ),
    );
  }

  Widget _buildSlotRow(Map<String, dynamic> slot) {
    final subject = slot['subject'] as String;
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
              color: _getSubjectColor(subject).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getSubjectIcon(subject),
              size: 20,
              color: _getSubjectColor(subject),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(slot['subject'], style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  '${slot['time']} • ${slot['teacher']}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Text(slot['room'], style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildExamCard(Map<String, dynamic> exam) {
    final subject = exam['subject'] as String;
    final examDate = exam['date'] as DateTime;
    final isUpcoming = !examDate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUpcoming ? _getSubjectColor(subject) : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUpcoming ? _getSubjectColor(subject).withOpacity(0.1) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isUpcoming ? 'Upcoming' : 'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isUpcoming ? _getSubjectColor(subject) : Colors.grey,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(exam['type']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    exam['type'].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              exam['title'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(_getSubjectIcon(subject), size: 16, color: _getSubjectColor(subject)),
                const SizedBox(width: 6),
                Text(
                  exam['subject'],
                  style: TextStyle(color: _getSubjectColor(subject), fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today, DateFormat('EEE, MMM d, y').format(exam['date'])),
            _buildInfoRow(Icons.access_time, exam['time']),
            _buildInfoRow(Icons.location_on, exam['room']),
            _buildInfoRow(Icons.person, exam['teacher']),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _contactTeacher(context, exam['teacher']),
                    icon: const Icon(Icons.email, size: 16),
                    label: const Text('Contact Teacher', style: TextStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _getSubjectColor(subject)),
                      foregroundColor: _getSubjectColor(subject),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () => _addReminder(context, exam['title']),
                  icon: const Icon(Icons.notifications, size: 16),
                  label: const Text('Remind Me', style: TextStyle(fontSize: 13)),
                  style: FilledButton.styleFrom(
                    backgroundColor: _getSubjectColor(subject),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Download Schedule'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule downloaded')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _contactTeacher(BuildContext context, String teacherName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message sent to $teacherName')),
    );
  }

  void _addReminder(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder set for $title')),
    );
  }

  List<Map<String, dynamic>> get _mondaySlots => [
        {'subject': 'Mathematics', 'time': '08:00 - 08:45', 'teacher': 'Mr. Rajesh', 'room': '101'},
        {'subject': 'Physics', 'time': '08:45 - 09:30', 'teacher': 'Dr. Meera', 'room': 'Lab 3'},
        {'subject': 'English', 'time': '10:00 - 10:45', 'teacher': 'Mrs. Priya', 'room': '102'},
      ];

  List<Map<String, dynamic>> get _tuesdaySlots => [
        {'subject': 'Biology', 'time': '08:00 - 08:45', 'teacher': 'Ms. Ananya', 'room': 'Bio Lab'},
        {'subject': 'Chemistry', 'time': '08:45 - 09:30', 'teacher': 'Dr. Meera', 'room': 'Chem Lab'},
      ];

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics':
        return Icons.science;
      case 'mathematics':
        return Icons.calculate;
      case 'english':
        return Icons.book;
      case 'biology':
        return Icons.biotech;
      case 'chemistry':
        return Icons.science_outlined;
      default:
        return Icons.school;
    }
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics':
        return Colors.deepPurple;
      case 'mathematics':
        return Colors.blue;
      case 'english':
        return Colors.green;
      case 'biology':
        return Colors.teal;
      case 'chemistry':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  Color _getTypeColor(String type) {
    if (type == 'summative') return Colors.red;
    if (type == 'formative') return Colors.orange;
    return Colors.grey;
  }
}