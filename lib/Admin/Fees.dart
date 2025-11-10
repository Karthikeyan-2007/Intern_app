import 'package:flutter/material.dart';

class FeesFinancePage extends StatefulWidget {
  @override
  _FeesFinancePageState createState() => _FeesFinancePageState();
}

class _FeesFinancePageState extends State<FeesFinancePage> {
  int _currentTab = 0;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF4F6FF),
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
        body: _currentTab == 0
            ? _buildStudentFeesSection()
            : _buildTeacherSalarySection(),
      ),
    );
  }

  Widget _buildStudentFeesSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCards(),

          SizedBox(height: 16),

          _buildSearchBar(),

          SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: sampleStudentFees.length,
              itemBuilder: (context, index) {
                final fee = sampleStudentFees[index];
                return _buildFeeCard(fee);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherSalarySection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCards(),
          SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: sampleTeacherSalaries.length,
              itemBuilder: (context, index) {
                final salary = sampleTeacherSalaries[index];
                return _buildSalaryCard(salary);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- SEARCH BAR -----------------
  Widget _buildSearchBar() {
    return Container(
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
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search student by name / roll...",
          prefixIcon: Icon(Icons.search, color: Color(0xFF6E8AFA)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  // ----------------- PREMIUM CARD UI: STUDENT FEES -----------------
  Widget _buildFeeCard(StudentFee fee) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fee.studentName,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildStatusTag(fee.status == "Paid"),
              ],
            ),

            SizedBox(height: 6),

            Text("Class: ${fee.classSection}",
                style: TextStyle(fontSize: 15, color: Colors.grey[600])),

            SizedBox(height: 6),

            Text("Amount: ₹${fee.amount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16)),

            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
          ],
        ),
      ),
    );
  }

  // ----------------- PREMIUM CARD UI: TEACHER SALARY -----------------
  Widget _buildSalaryCard(TeacherSalary salary) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  salary.teacherName,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildStatusTag(salary.status == "Paid"),
              ],
            ),

            SizedBox(height: 6),

            Text("Department: ${salary.department}",
                style: TextStyle(fontSize: 15, color: Colors.grey[600])),

            SizedBox(height: 6),

            Text("Salary: ₹${salary.salary.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16)),

            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
          ],
        ),
      ),
    );
  }

  // ----------------- STATUS TAG -----------------
  Widget _buildStatusTag(bool isPaid) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPaid ? Color(0xFF4ECDC4) : Color(0xFFFF6B6B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPaid ? "Paid" : "Pending",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ----------------- SUMMARY CARDS -----------------
  Widget _buildSummaryCards() {
    return Container(
      height: 120,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _moneyCard("Total Collected", "₹42,560", Color(0xFF4ECDC4)),
          _moneyCard("Pending", "₹12,450", Color(0xFFFF6B6B)),
          _moneyCard("Salary Paid", "₹18,900", Color(0xFF6E8AFA)),
          _moneyCard("Expenses", "₹3,200", Color(0xFFFFA07A)),
        ],
      ),
    );
  }

  Widget _moneyCard(String title, String value, Color color) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    );
  }

  // ----------------- PAYMENT SHEETS / POPUPS -----------------
  void _showPaymentSheet(StudentFee fee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          _paymentBottomSheet("Process Payment", fee.studentName, fee.amount),
    );
  }

  void _generateReceipt(StudentFee fee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Receipt Generated"),
        content: Text("Digital receipt for ${fee.studentName} generated."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  void _showSalaryPaymentSheet(TeacherSalary salary) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _paymentBottomSheet(
          "Salary Payment", salary.teacherName, salary.salary),
    );
  }

  void _showSalaryHistory(TeacherSalary salary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Salary History"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text("October 2025"), subtitle: Text("Paid")),
            ListTile(title: Text("September 2025"), subtitle: Text("Paid")),
            ListTile(title: Text("August 2025"), subtitle: Text("Unpaid")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Close"))
        ],
      ),
    );
  }

  Widget _paymentBottomSheet(String title, String name, double amount) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          ListTile(title: Text(name), subtitle: Text("Amount: ₹$amount")),
          SizedBox(height: 16),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6E8AFA)),
              child: Text("Confirm Payment", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}

// ------------------ DATA MODELS ------------------
class StudentFee {
  String studentName, classSection, status;
  double amount;
  StudentFee({
    required this.studentName,
    required this.classSection,
    required this.amount,
    required this.status,
  });
}

class TeacherSalary {
  String teacherName, department, status;
  double salary;
  TeacherSalary({
    required this.teacherName,
    required this.department,
    required this.salary,
    required this.status,
  });
}

// ------------------ SAMPLE DATA ------------------
List<StudentFee> sampleStudentFees = [
  StudentFee(studentName: "John Doe", classSection: "10-A", amount: 1200.0, status: "Pending"),
  StudentFee(studentName: "Jane Smith", classSection: "11-B", amount: 1500.0, status: "Paid"),
  StudentFee(studentName: "Robert Johnson", classSection: "12-C", amount: 1350.0, status: "Pending"),
  StudentFee(studentName: "Emily Davis", classSection: "9-A", amount: 1100.0, status: "Paid"),
];

List<TeacherSalary> sampleTeacherSalaries = [
  TeacherSalary(teacherName: "Dr. Sarah Connor", department: "Math", salary: 4500.0, status: "Paid"),
  TeacherSalary(teacherName: "Mr. James Smith", department: "Science", salary: 4200.0, status: "Paid"),
  TeacherSalary(teacherName: "Ms. Linda Brown", department: "English", salary: 4000.0, status: "Unpaid"),
  TeacherSalary(teacherName: "Prof. David Wilson", department: "History", salary: 3800.0, status: "Paid"),
];
