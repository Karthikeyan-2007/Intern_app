import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentDetailPage extends StatefulWidget {
  final Map<String, dynamic> student;

  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  final List<Map<String, dynamic>> marks = [
    {"subject": "Math", "Unit Test 1": 88, "Unit Test 2": 92, "Term": 90},
    {"subject": "English", "Unit Test 1": 78, "Unit Test 2": 81, "Term": 85},
    {"subject": "Science", "Unit Test 1": 91, "Unit Test 2": 87, "Term": 89},
    {"subject": "Tamil", "Unit Test 1": 83, "Unit Test 2": 79, "Term": 88},
  ];

  final int attendancePercent = 92;
  final List<Map<String, dynamic>> leaves = [
    {"date": DateTime.now(), "reason": "Fever", "status": "Pending"}
  ];

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: const SizedBox(height: 50,),
          ),
           SliverToBoxAdapter(
            child: _buildStudentHeaderCard(student),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _attendanceCard(),
                  const SizedBox(height: 20),
                  _personalDetails(student),
                  const SizedBox(height: 20),
                  _excelMarksTable(),
                  const SizedBox(height: 20),
                  _leaveRequestSection(),
                  const SizedBox(height: 20),
                  _quickActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Attendance ⭮ Premium card
  Widget _attendanceCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 85,
                  width: 85,
                  child: CircularProgressIndicator(
                    value: attendancePercent / 100,
                    strokeCap: StrokeCap.round,
                    strokeWidth: 10,
                    color: attendancePercent >= 75 ? Colors.green : Colors.red,
                  ),
                ),
                Text("$attendancePercent%",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: LinearProgressIndicator(
                value: attendancePercent / 100,
                minHeight: 10,
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
            )
          ],
        ),
      );

  Widget _buildStudentHeaderCard(Map<String, dynamic> student) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.blueAccent,
                width: 2,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student["full_name"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.school, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      student["class"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}
  // ✅ Excel-like Marks Table
  Widget _excelMarksTable() => Container(
        decoration: _cardDecoration(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Performance (Excel View)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(Colors.blue.shade50),
                border:
                    TableBorder.all(color: Colors.grey.shade300, width: 1),
                columns: marks.first.keys
                    .map((key) => DataColumn(
                          label: Text(
                            key.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
                rows: marks
                    .map(
                      (row) => DataRow(
                        cells: row.values
                            .map((v) => DataCell(Text(v.toString())))
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      );

  // ✅ Expandable Leave Requests
  Widget _leaveRequestSection() => Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Leave Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...leaves.map((leave) => Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.orange.shade50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${DateFormat("MMM d").format(leave['date'])}"),
                      Text("Reason: ${leave['reason']}"),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            leave["status"],
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      );

  // ✅ Personal Info Section
  Widget _personalDetails(Map<String, dynamic> student) => Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Personal Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _infoRow("Email", student['email']),
            _infoRow("Phone", student['phone']),
            _infoRow("DOB", student['date_of_birth']),
          ],
        ),
      );

  Widget _quickActions() => Row(
        children: [
          _actionButton(Icons.chat, "Message"),
          const SizedBox(width: 12),
          _actionButton(Icons.description, "Report"),
        ],
      );

  Widget _actionButton(IconData icon, String label) => Expanded(
        child: Container(
          decoration: _cardDecoration(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(height: 6),
              Text(label),
            ],
          ),
        ),
      );

  Widget _infoRow(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text("$title:")),
            Expanded(
                child: Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      );

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 3))
        ],
      );
}
