import 'package:flutter/material.dart';
import 'package:school_app/Principal/Class.dart';
import 'package:school_app/Principal/Profile.dart';
import 'package:school_app/Principal/Task.dart';
import 'package:school_app/Principal/Teacher_fixed.dart';
import 'package:school_app/principal/Home.dart';

class PrcNavigatorScreen extends StatefulWidget {
  const PrcNavigatorScreen({super.key});

  @override
  _MainNavigatorScreenState createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<PrcNavigatorScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PrincipalDashboardPage(),
    const PrcClassStudentManagerPage(),
    const PrincipalTeacherManagementPage(),
    const PrincipalWorkflowDashboardPage(),
    const PrincipalProfilePage()
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
          NavigationDestination(icon: Icon(Icons.school), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Teacher'),
          NavigationDestination(icon: Icon(Icons.task), label: 'Task'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      ),
    );
  }
}
