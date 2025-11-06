import 'package:flutter/material.dart';
import 'Attendance.dart';
import 'Home.dart';
import 'Profile.dart';
import 'Student.dart';
import 'Task.dart';

class StaffNavigatorScreen extends StatefulWidget {
  @override
  _MainNavigatorScreenState createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<StaffNavigatorScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TeacherHomePage(),
    TeacherAttendancePage(),
    TeacherAssignmentManagerPage(),
    TeacherStudentManagerPage(),
    TeacherProfileHubPage()
  ];

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
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Attendance'),
          NavigationDestination(icon: Icon(Icons.task), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.school_outlined), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      ),
    );
  }
}
