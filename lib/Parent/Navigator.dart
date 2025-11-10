import 'package:flutter/material.dart';
import 'Assesment.dart';
import 'Attendance.dart';
import 'Home.dart';
import 'Profile.dart';
import 'Teacher.dart';

class ParentNavigatorScreen extends StatefulWidget {
  final int? selectedIndex;
  const ParentNavigatorScreen({super.key, this.selectedIndex});

  @override
  _MainNavigatorScreenState createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<ParentNavigatorScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ParentHomePage(),
    ParentAssessmentsDashboard(),
    ParentAttendancePage(),
    ParentTeacherDirectoryPage(),
    ParentProfilePage(),
  ];

  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body:  _pages[_currentIndex],
        bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.blue.shade100,
        height: 70,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home),label: 'Home',),
          NavigationDestination(icon: Icon(Icons.assignment),label: 'Assessment',),
          NavigationDestination(icon: Icon(Icons.fact_check), label: 'Attendance',),
          NavigationDestination(icon: Icon(Icons.group),label: 'Teachers',),
          NavigationDestination(icon: Icon(Icons.person),label: 'Profile',),
        ],
      ),
      ),
    );
  }
}
