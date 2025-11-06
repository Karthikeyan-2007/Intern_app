import 'package:flutter/material.dart';

class ParentExamReportPage extends StatelessWidget {
  const ParentExamReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final report = {
      'test_title': 'Grade 10 Midterm Examination',
      'academic_year': '2025–2026',
      'class_name': 'Grade 10 - A',
      'total_marks': 500,
      'obtained_marks': 448.5,
      'percentage': 89.7,
      'grade': 'A+',
      'rank': 3,
      'total_students': 42,
      'percentile': 93.2,
      'published_at': 'Oct 25, 2025',
      'teacher_comments': 'Alex demonstrates exceptional problem-solving skills in Mathematics and Physics. To further excel, focus on time management during Biology essays and review chemical equations in Chemistry.',
    };

    final List<Map<String, dynamic>> subjectPerformance = [
      {
        'subject': 'Physics',
        'marks_obtained': 92,
        'total_marks': 100,
        'grade': 'A+',
        'percentile': 95,
        'is_strength': true,
        'feedback': 'Excellent grasp of Newton’s laws and energy concepts.'
      },
      {
        'subject': 'Mathematics',
        'marks_obtained': 95,
        'total_marks': 100,
        'grade': 'A+',
        'percentile': 98,
        'is_strength': true,
        'feedback': 'Outstanding algebra and geometry skills.'
      },
      {
        'subject': 'Biology',
        'marks_obtained': 88,
        'total_marks': 100,
        'grade': 'A',
        'percentile': 85,
        'is_strength': false,
        'feedback': 'Good understanding of cell biology. Practice structured answers for long questions.'
      },
      {
        'subject': 'English',
        'marks_obtained': 89,
        'total_marks': 100,
        'grade': 'A',
        'percentile': 88,
        'is_strength': false,
        'feedback': 'Strong vocabulary. Work on essay structure and coherence.'
      },
      {
        'subject': 'Chemistry',
        'marks_obtained': 84.5,
        'total_marks': 100,
        'grade': 'B+',
        'percentile': 80,
        'is_strength': false,
        'feedback': 'Solid foundation. Review stoichiometry and periodic trends.'
      },
    ];

    final studentName = 'Alex Johnson';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Exam Report',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1976D2),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFF1976D2).withOpacity(0.2), height: 1),
        ),
        actions: [
          IconButton(
            onPressed: () => _showActions(context),
            icon: const Icon(Icons.more_vert),
            color: const Color(0xFF1976D2),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student & Test Header
              _buildReportHeader(report, studentName),

              const SizedBox(height: 24),

              // Overall Performance Card
              _buildOverallCard(report),

              const SizedBox(height: 24),

              // Teacher Feedback Banner
              _buildFeedbackBanner('${report['teacher_comments']!}'),

              const SizedBox(height: 24),
              const Text(
                'Subject-wise Analysis',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
              ),
              const SizedBox(height: 16),
              ...subjectPerformance.map((sub) => _buildSubjectCard(sub)),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportHeader(Map<String, dynamic> report, String studentName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            studentName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
          ),
          Text(
            '${report['class_name']} • ${report['academic_year']}',
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Text(
            report['test_title'],
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          Text(
            'Published on ${report['published_at']}',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallCard(Map<String, dynamic> report) {
    final percentage = report['percentage'] as double;
    final isExcellent = percentage >= 90;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Performance',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${report['obtained_marks']} / ${report['total_marks']}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1976D2)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isExcellent ? Colors.green.shade100 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report['grade'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isExcellent ? Colors.green.shade800 : Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            color: isExcellent ? Colors.green : Colors.blue,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMetric('Rank', '#${report['rank']} / ${report['total_students']}'),
              _buildMetric('Percentile', '${report['percentile']}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildFeedbackBanner(String feedback) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              const Text(
                'Teacher’s Feedback',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(feedback),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final isStrength = subject['is_strength'] as bool;
    final percentage = (subject['marks_obtained'] as num) / (subject['total_marks'] as num) * 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isStrength ? Colors.green.shade300 : Colors.orange.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isStrength ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isStrength ? 'Strength' : 'Growth Area',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isStrength ? Colors.green.shade800 : Colors.orange.shade800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${subject['marks_obtained']} / ${subject['total_marks']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subject['subject'],
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text('${subject['grade']} • '),
              Text('${subject['percentile']}th percentile', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            color: isStrength ? Colors.green : Colors.orange,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 12),
          Text(
            subject['feedback'],
            style: TextStyle(color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Download Report'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report downloaded')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: const Text('Share Report'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Share
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.purple),
              title: const Text('Message Teacher'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message sent to class teacher')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}