import 'package:flutter/material.dart';
import 'package:school_app/Student/Grades.dart';
import 'package:school_app/Student/Subject.dart';
import 'package:school_app/Student/notes.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, dynamic> _studentProfile = {
    'id': 'usr_7f3a9b2c',
    'full_name': 'Alex Johnson',
    'email': 'alex.j@student.edu',
    'profile_picture_url': null,
  };

  final String _currentRank = '5';
  final int _upcomingTasks = 3;
  final int _unreadMessages = 5;

  final List<Map<String, dynamic>> _upcomingEvents = [
    {'title': 'Maths Assessment', 'date': '2025-10-28', 'time': '09:00 AM', 'formatted_date': 'Oct 28, 2025'},
    {'title': 'Tamil Test', 'date': '2025-11-02', 'time': '08:00 AM', 'formatted_date': 'Nov 2, 2025'},
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {'title': 'Math Assignment', 'subtitle': 'Due tomorrow at 11:59 PM', 'icon': Icons.assignment, 'color': Color(0xFFFF6B6B)},
    {'title': 'Science Quiz Results', 'subtitle': 'You scored 92%', 'icon': Icons.science, 'color': Color(0xFF4ECDC4)},
    {'title': 'Parent-Teacher Meeting', 'subtitle': 'Scheduled for Friday, 3 PM', 'icon': Icons.people, 'color': Color(0xFF95E1D3)},
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.menu_book_rounded, 'title': 'Notes', 'color': Color(0xFF6C5CE7), 'ontap': StudentPdfLibraryPage()},
    {'icon': Icons.library_books_rounded, 'title': 'Subjects', 'color': Color(0xFF00B894), 'ontap': StudentSubjectOverviewPage()},
    {'icon': Icons.grade_rounded, 'title': 'Grades', 'color': Color(0xFFFFBE0B), 'ontap': StudentClassRankPage()},
  ];

  final String _schoolName = "EDUCATION ACADEMY";
  final String _schoolTagline = "Empowering Every Student";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final cleanUrl = url.trim();
    if (await canLaunchUrl(Uri.parse(cleanUrl))) {
      await launchUrl(Uri.parse(cleanUrl));
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open: $cleanUrl'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FE),
              Color(0xFFE8EAF6),
              Color(0xFFF3E5F5),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildPremiumAppBar(),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
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
                    Text(
                      'Welcome back,',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _studentProfile['full_name'],
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Current Rank', _currentRank, Icons.trending_up)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard('Upcoming', '$_upcomingTasks', Icons.event)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard('Messages', '$_unreadMessages', Icons.mail_outline)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: FadeTransition(opacity: _fadeAnimation, child: _buildQuickActionsGrid())),
            SliverToBoxAdapter(child: FadeTransition(opacity: _fadeAnimation, child: _buildRecentActivity())),
            SliverToBoxAdapter(child: FadeTransition(opacity: _fadeAnimation, child: _buildUpcomingTasks())),
            SliverToBoxAdapter(child: FadeTransition(opacity: _fadeAnimation, child: _buildSchoolInfo())),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumAppBar() {
    return SliverAppBar(
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
                  Text(_schoolName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  Text(_schoolTagline, style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w400)),
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
            if (_unreadMessages > 0)
              Positioned(
                right: 12,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6B6B),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(0xFFFF6B6B).withOpacity(0.5), blurRadius: 4)],
                  ),
                  constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text('$_unreadMessages', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
    );
  }

  Widget _buildQuickActionsGrid() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4, bottom: 16),
            child: Text('Quick Actions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
          ),
          Row(
            children: _quickActions.asMap().entries.map((entry) {
              int idx = entry.key;
              var item = entry.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: idx < _quickActions.length - 1 ? 12 : 0),
                  child: _buildPremiumQuickAction(item['icon'], item['title'], item['color'], item['ontap']),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumQuickAction(IconData icon, String title, Color color, ontap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (ontap is Widget) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ontap));
          }
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.white.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.15), blurRadius: 15, offset: Offset(0, 8)),
              BoxShadow(color: Colors.white, blurRadius: 10, offset: Offset(-5, -5)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, offset: Offset(0, 6))],
                ),
                child: Icon(icon, size: 20, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3436))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
          SizedBox(height: 20),
          ..._recentActivities.map((item) => _buildPremiumActivityItem(item['title'], item['subtitle'], item['icon'], item['color'])),
        ],
      ),
    );
  }

  Widget _buildPremiumActivityItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [color.withOpacity(0.08), color.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3436))),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 18, color: color),
        ],
      ),
    );
  }

  Widget _buildUpcomingTasks() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.event_note_rounded, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Text('Upcoming Tasks', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
            ],
          ),
          SizedBox(height: 20),
          ..._upcomingEvents.map((event) => _buildPremiumEventItem(event['title'], event['formatted_date'], event['time'])),
        ],
      ),
    );
  }

  Widget _buildPremiumEventItem(String title, String date, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA).withOpacity(0.08), Color(0xFF764BA2).withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF667EEA).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3436))),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 13, color: Color(0xFF667EEA)),
                    SizedBox(width: 6),
                    Text(date, style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w500)),
                    SizedBox(width: 16),
                    Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF667EEA)),
                    SizedBox(width: 6),
                    Text(time, style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolInfo() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4, bottom: 16),
            child: Text('About the School', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
          ),
          _buildPremiumInfoCard(
            title: 'Mission & Vision',
            icon: Icons.flag_rounded,
            color: Color(0xFF6C5CE7),
            content: ['• Empowering students through innovative education', '• Fostering critical thinking and creativity', '• Building compassionate global citizens'],
          ),
          _buildPremiumInfoCard(
            title: 'Achievements',
            icon: Icons.military_tech_rounded,
            color: Color(0xFFFFBE0B),
            content: ['National Blue Ribbon School 2020', 'State Science Olympiad Champions 2022', '98% College Acceptance Rate', '15 National Merit Scholars (2023)'],
          ),
          _buildPremiumActionCard(
            title: 'Staff Directory',
            icon: Icons.people_rounded,
            subtitle: 'Contact teachers and administration',
            color: Color(0xFF00B894),
            onTap: () => _launchUrl('https://your-school.com/staff-directory'),
          ),
          _buildPremiumActionCard(
            title: 'School Policies',
            icon: Icons.description_rounded,
            subtitle: 'Code of conduct, academic policies',
            color: Color(0xFF0984E3),
            onTap: () => _launchUrl('https://your-school.com/policies'),
          ),
          _buildPremiumInfoCard(
            title: 'Contact Us',
            icon: Icons.contact_mail_rounded,
            color: Color(0xFFFF6B6B),
            content: ['(555) 123-4567', 'info@yourschool.edu', '123 Education Lane, Learning City, LC 12345'],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumInfoCard({required String title, required IconData icon, required Color color, required List<String> content}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 8))],
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              SizedBox(width: 14),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
            ],
          ),
          SizedBox(height: 16),
          ...content.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 8, left: 4),
                child: Text(item, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5)),
              )),
        ],
      ),
    );
  }

  Widget _buildPremiumActionCard({required String title, required IconData icon, required String subtitle, required Color color, required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 8))],
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3436))),
                      SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 18, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: Colors.blue.shade700),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}