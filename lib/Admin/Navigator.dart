import 'package:flutter/material.dart';
import 'package:school_app/Admin/Bus.dart';
import 'package:school_app/Admin/Event.dart';
import 'package:school_app/Admin/Fees.dart';
import 'package:school_app/Admin/Home.dart';
import 'package:school_app/Admin/Student.dart';
class AdminNavigatorScreen extends StatefulWidget {
  const AdminNavigatorScreen({super.key});

  @override
  _MainNavigatorScreenState createState() => _MainNavigatorScreenState();
}

class _MainNavigatorScreenState extends State<AdminNavigatorScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AdminDashboard(),
    AdminTeacherManager(),
    FeesFinancePage(),
    EventFundManager(),
    BusTransportManagement(),
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
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_alt),
            label: 'Members',
          ),
          NavigationDestination(
            icon: Icon(Icons.currency_rupee),
            label: 'Fees',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_bus_filled),
            label: 'Transport',
          ),
        ],
      ),
      ),
    );
  }
}
