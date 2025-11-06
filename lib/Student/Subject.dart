import 'package:flutter/material.dart';

class StudentSubjectOverviewPage extends StatelessWidget {
  const StudentSubjectOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> subjects = [
      {
        'name': 'Science',
        'code': 'SCI10',
        'teacher': 'Mrs. Kavitha',
        'lessons': 12,
        'assignments': 5,
        'question_papers': 4,
        'progress': 85,
        'attendance': 93,
        'next_exam': '12 Nov, 10:00 AM',
      },
      {
        'name': 'Mathematics',
        'code': 'MAT10',
        'teacher': 'Mr. Senthil',
        'lessons': 15,
        'assignments': 7,
        'question_papers': 6,
        'progress': 92,
        'attendance': 96,
        'next_exam': '10 Nov, 09:00 AM',
      },
      {
        'name': 'English',
        'code': 'ENG10',
        'teacher': 'Ms. Priya',
        'lessons': 10,
        'assignments': 6,
        'question_papers': 5,
        'progress': 98,
        'attendance': 97,
        'next_exam': '15 Nov, 12:00 PM',
      },
      {
        'name': 'Social Science',
        'code': 'SOC10',
        'teacher': 'Mr. Arun',
        'lessons': 11,
        'assignments': 4,
        'question_papers': 3,
        'progress': 90,
        'attendance': 94,
        'next_exam': '20 Nov, 09:30 AM',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff0f4ff),
      appBar: AppBar(
        title: const Text(
          'My Subjects',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return _premiumCard(context, subjects[index]);
        },
      ),
    );
  }

  Widget _premiumCard(BuildContext context, Map<String, dynamic> subject) {
    const Color themeColor = Color(0xFF0057D9);

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Opening ${subject['name']}..."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [themeColor, themeColor.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title + Icon Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: const Icon(Icons.menu_book_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      subject['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(subject['code'],
                      style: TextStyle(color: Colors.white.withOpacity(0.9))),
                ],
              ),

              const SizedBox(height: 12),

              /// Teacher Info
              Text(
                "Teacher: ${subject['teacher']}",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.95), fontSize: 14),
              ),

              const SizedBox(height: 15),

              /// Subject Stats (Grid Row)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _info("Lessons", "${subject['lessons']}"),
                  _info("Assigns", "${subject['assignments']}"),
                  _info("QPapers", "${subject['question_papers']}"),
                  _info("Attend", "${subject['attendance']}%"),
                ],
              ),

              const SizedBox(height: 15),

              /// Exam Chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_rounded,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "Next Exam: ${subject['next_exam']}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Progress",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text("${subject['progress']}%",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),

              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: LinearProgressIndicator(
                  value: subject['progress'] / 100,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            )),
        Text(title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 11,
            )),
      ],
    );
  }
}
