import 'package:flutter/material.dart';
import 'dart:math';

class FeesFinancePage extends StatefulWidget {
  @override
  _FeesFinancePageState createState() => _FeesFinancePageState();
}

class _FeesFinancePageState extends State<FeesFinancePage> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6E8AFA),
          elevation: 0,
          title: Text(
            "Fees & Finance",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            onTap: (index) => setState(() => _currentTab = index),
            tabs: [
              Tab(text: "Student Fees"),
              Tab(text: "Teacher Salary"),
            ],
          ),
        ),
        body: _currentTab == 0 ? _buildStudentFeesSection() : _buildTeacherSalarySection(),
      ),
    );
  }

  Widget _buildStudentFeesSection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(),
          SizedBox(height: 16),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search student by name/roll...",
                prefixIcon: Icon(Icons.search, color: Color(0xFF6E8AFA)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Data Table
          Expanded(
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Color(0xFF6E8AFA)),
              headingTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              columns: [
                DataColumn(label: Text("Student")),
                DataColumn(label: Text("Class")),
                DataColumn(label: Text("Amount")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Actions")),
              ],
              rows: sampleStudentFees.map((fee) {
                return DataRow(
                  cells: [
                    DataCell(Text(fee.studentName)),
                    DataCell(Text(fee.classSection)),
                    DataCell(Text("\$${fee.amount.toStringAsFixed(2)}")),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: fee.status == "Paid" 
                              ? Color(0xFF4ECDC4) 
                              : Color(0xFFFF6B6B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          fee.status,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.payments, color: Color(0xFF6E8AFA)),
                            onPressed: () => _showPaymentSheet(fee),
                          ),
                          IconButton(
                            icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                            onPressed: () => _generateReceipt(fee),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherSalarySection() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(),
          SizedBox(height: 16),
          
          // Data Table
          Expanded(
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Color(0xFF6E8AFA)),
              headingTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              columns: [
                DataColumn(label: Text("Teacher")),
                DataColumn(label: Text("Department")),
                DataColumn(label: Text("Salary")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Actions")),
              ],
              rows: sampleTeacherSalaries.map((salary) {
                return DataRow(
                  cells: [
                    DataCell(Text(salary.teacherName)),
                    DataCell(Text(salary.department)),
                    DataCell(Text("\$${salary.salary.toStringAsFixed(2)}")),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: salary.status == "Paid" 
                              ? Color(0xFF4ECDC4) 
                              : Color(0xFFFF6B6B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          salary.status,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.payments, color: Color(0xFF6E8AFA)),
                            onPressed: () => _showSalaryPaymentSheet(salary),
                          ),
                          IconButton(
                            icon: Icon(Icons.history, color: Colors.orange),
                            onPressed: () => _showSalaryHistory(salary),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      height: 120,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
        children: [
          _buildSummaryCard("Total Collected", "\$42,560", Color(0xFF4ECDC4)),
          _buildSummaryCard("Pending", "\$12,450", Color(0xFFFF6B6B)),
          _buildSummaryCard("Salary Paid", "\$18,900", Color(0xFF6E8AFA)),
          _buildSummaryCard("Event Expenses", "\$3,200", Color(0xFFFFA07A)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSheet(StudentFee fee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Process Payment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text("Student: ${fee.studentName}"),
              subtitle: Text("Class: ${fee.classSection}"),
            ),
            ListTile(
              title: Text("Amount Due: \$${fee.amount.toStringAsFixed(2)}"),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Pending",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Payment Amount",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Process payment
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6E8AFA),
                    ),
                    child: Text("Process Payment", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _generateReceipt(StudentFee fee) {
    // Generate PDF receipt
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Receipt Generated"),
        content: Text("Digital receipt for ${fee.studentName} has been generated successfully."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSalaryPaymentSheet(TeacherSalary salary) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Process Salary Payment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text("Teacher: ${salary.teacherName}"),
              subtitle: Text("Department: ${salary.department}"),
            ),
            ListTile(
              title: Text("Monthly Salary: \$${salary.salary.toStringAsFixed(2)}"),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Unpaid",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Process salary payment
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6E8AFA),
                    ),
                    child: Text("Pay Salary", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSalaryHistory(TeacherSalary salary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Salary History - ${salary.teacherName}"),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("October 2025"),
                subtitle: Text("\$${salary.salary.toStringAsFixed(2)} - Paid"),
              ),
              ListTile(
                title: Text("September 2025"),
                subtitle: Text("\$${salary.salary.toStringAsFixed(2)} - Paid"),
              ),
              ListTile(
                title: Text("August 2025"),
                subtitle: Text("\$${salary.salary.toStringAsFixed(2)} - Unpaid"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}

// Data Models
class StudentFee {
  String studentName;
  String classSection;
  double amount;
  String status;

  StudentFee({
    required this.studentName,
    required this.classSection,
    required this.amount,
    required this.status,
  });
}

class TeacherSalary {
  String teacherName;
  String department;
  double salary;
  String status;

  TeacherSalary({
    required this.teacherName,
    required this.department,
    required this.salary,
    required this.status,
  });
}

// Sample Data
List<StudentFee> sampleStudentFees = [
  StudentFee(studentName: "John Doe", classSection: "10-A", amount: 1200.0, status: "Pending"),
  StudentFee(studentName: "Jane Smith", classSection: "11-B", amount: 1500.0, status: "Paid"),
  StudentFee(studentName: "Robert Johnson", classSection: "12-C", amount: 1350.0, status: "Pending"),
  StudentFee(studentName: "Emily Davis", classSection: "9-A", amount: 1100.0, status: "Paid"),
  StudentFee(studentName: "Michael Wilson", classSection: "10-B", amount: 1250.0, status: "Pending"),
];

List<TeacherSalary> sampleTeacherSalaries = [
  TeacherSalary(teacherName: "Dr. Sarah Connor", department: "Math", salary: 4500.0, status: "Paid"),
  TeacherSalary(teacherName: "Mr. James Smith", department: "Science", salary: 4200.0, status: "Paid"),
  TeacherSalary(teacherName: "Ms. Linda Brown", department: "English", salary: 4000.0, status: "Unpaid"),
  TeacherSalary(teacherName: "Prof. David Wilson", department: "History", salary: 3800.0, status: "Paid"),
  TeacherSalary(teacherName: "Dr. Anna Taylor", department: "Art", salary: 3500.0, status: "Unpaid"),
];