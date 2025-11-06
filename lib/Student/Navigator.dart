import 'package:flutter/material.dart';
import 'package:school_app/Student/Assesment.dart';
import 'package:school_app/Student/Home.dart';
import 'package:school_app/Student/Profile.dart';
import 'package:school_app/Student/Questionpaper.dart';
import 'package:school_app/Student/chatbot.dart';

class StudentNavigatorScreen extends StatefulWidget {
  @override
  _MainNavigatorScreenState createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<StudentNavigatorScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    StudentHomePage(),
    StudentAssessmentsDashboard(),
    StudentDoubtChatPage(),
    QuestionPaper(),
    StudentProfileWithParents()
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
          NavigationDestination(icon: Icon(Icons.assessment), label: 'Assessments'),
          NavigationDestination(icon: Icon(Icons.android_rounded), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.notes), label: 'QPapers'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      ),
    );
  }
}
