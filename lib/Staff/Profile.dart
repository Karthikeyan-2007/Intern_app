import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../LoginScreen/LoginScreen.dart';

class TeacherProfileHubPage extends StatefulWidget {
  const TeacherProfileHubPage({super.key});

  @override
  State<TeacherProfileHubPage> createState() => _TeacherProfileHubPageState();
}

class _TeacherProfileHubPageState extends State<TeacherProfileHubPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _teacherName = 'Mr. Karthi';
  final String _email = 'karthi.m@school.edu';
  final String _phone = '+91 98765 00001';
  final String _department = 'Mathematics & Physics';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 240,
            elevation: 6,
            backgroundColor: const Color(0xFF1E3A8A),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E3A8A),
                      Color(0xFF2563EB),
                      Color(0xFF3B82F6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20,0,20,70),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 45,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30,),
                              Text(
                                _teacherName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _department,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      "Faculty Member",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF1E3A8A),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF3B82F6),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(fontSize: 14),
                  tabs: const [
                    Tab(icon: Icon(Icons.person_outline), text: 'Profile'),
                    Tab(icon: Icon(Icons.message_outlined), text: 'Messages'),
                    Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Calendar'),
                    Tab(icon: Icon(Icons.settings_outlined), text: 'Settings'),
                  ],
                ),
              ),
            ),
          )

        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProfileTab(),
            _buildMessagesTab(),
            _buildCalendarTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }


  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileCard(),
        ],
      ),
    );
  }


  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Full Name', _teacherName),
          _buildInfoRow('Email', _email),
          _buildInfoRow('Phone', _phone),
          _buildInfoRow('Department', _department),
          const SizedBox(height: 20),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () => _editProfile(),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => _changePassword(),
                child: const Text('Change Password'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    final List<Map<String, dynamic>> _messages = [
      {
        'id': 'conv1',
        'sender': 'Parent of Alex Johnson',
        'preview': 'Regarding Physics test feedback',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'is_read': false,
      },
      {
        'id': 'conv2',
        'sender': 'Principal',
        'preview': 'Staff meeting tomorrow at 3 PM',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'is_read': true,
      },
      {
        'id': 'conv3',
        'sender': 'Admin',
        'preview': 'Please submit your lesson plans',
        'time': DateTime.now().subtract(const Duration(days: 3)),
        'is_read': true,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Messages',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._messages.map((msg) => _buildMessageCard(msg)).toList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: msg['is_read'] ? Colors.grey[50] : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: !msg['is_read']
            ? Border(left: BorderSide(color: Colors.blue.shade400, width: 3))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: const Icon(Icons.person, size: 24, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg['sender'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  msg['preview'],
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, h:mm a').format(msg['time']),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    final List<Map<String, dynamic>> _events = [
      {
        'title': 'Physics Midterm Exam',
        'type': 'exam',
        'date': DateTime.now().add(const Duration(days: 2)),
      },
      {
        'title': 'Parent-Teacher Meeting',
        'type': 'event',
        'date': DateTime.now().add(const Duration(days: 5)),
      },
      {
        'title': 'Diwali Holiday',
        'type': 'holiday',
        'date': DateTime.now().add(const Duration(days: 10)),
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Events',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._events.map((event) => _buildEventCard(event)).toList(),
          const SizedBox(height: 24),
          Center(
            child: FilledButton(
              onPressed: () => _viewFullCalendar(),
              child: const Text('View Full Calendar'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    Color color;
    IconData icon;
    switch (event['type']) {
      case 'exam':
        color = Colors.red;
        icon = Icons.assignment;
        break;
      case 'event':
        color = Colors.purple;
        icon = Icons.event;
        break;
      default:
        color = Colors.green;
        icon = Icons.holiday_village;
    }

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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  DateFormat('EEEE, MMM d').format(event['date']),
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsCard('Account', [
            _buildSettingItem('Theme', 'Light', () => _changeTheme()),
            _buildSettingItem('Language', 'English', () => _changeLanguage()),
            _buildSettingItem('Notifications', 'Enabled', () => _toggleNotifications()),
          ]),
          const SizedBox(height: 24),
          _buildSettingsCard('Security', [
            _buildSettingItem('Change Password', '', () => _changePassword()),
            _buildSettingItem('Active Sessions', '2 devices', () => _viewSessions()),
          ]),
          const SizedBox(height: 24),
          Center(
            child: FilledButton.tonal(
              onPressed: () => _logout(context),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(String title, List<Widget> children) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem(String label, String value, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: value.isNotEmpty ? Text(value) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, overflow: TextOverflow.fade),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Editing profile...')));
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Changing password...')));
  }

  void _changeTheme() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Theme changed')));
  }

  void _changeLanguage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Language changed')));
  }

  void _toggleNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications updated')));
  }

  void _viewSessions() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Viewing active sessions...')));
  }

  void _viewFullCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening full calendar...')));
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Loginscreen()),
      (route) => false,
    );
  }
}