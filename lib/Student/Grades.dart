import 'package:flutter/material.dart';

class StudentClassRankPage extends StatelessWidget {
  const StudentClassRankPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data modeled after your DB schema
    final studentRankData = {
      'full_name': 'Alex Johnson',
      'class_name': 'Grade 10 - A',
      'academic_year': '2025–2026',
      'subject': 'Overall',
      'final_marks': 448.5,
      'total_marks': 500,
      'percentage': 89.7,
      'rank': 3,
      'total_students': 42,
      'percentile': 93.2,
      'grade': 'A+',
    };
    final List<Map<String, dynamic>> subjectRanks = [
      {'subject': 'Physics', 'marks': 92, 'total': 100, 'rank': 2},
      {'subject': 'Mathematics', 'marks': 95, 'total': 100, 'rank': 1},
      {'subject': 'Biology', 'marks': 88, 'total': 100, 'rank': 5},
      {'subject': 'English', 'marks': 89, 'total': 100, 'rank': 4},
      {'subject': 'Chemistry', 'marks': 84.5, 'total': 100, 'rank': 7},
    ];

    final percentile = studentRankData['percentile'] as double;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Class Rank',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.blue.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // Hero Card: Rank Summary
              _buildRankHeroCard(studentRankData),

              const SizedBox(height: 24),

              // Percentile & Progress
              _buildPercentileCard(percentile),

              const SizedBox(height: 24),

              // Subject-wise Ranks
              _buildSubjectRankSection(subjectRanks),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankHeroCard(Map<String, dynamic> data) {
    final rank = data['rank'] as int;
    final total = data['total_students'] as int;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Class Rank',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            '#$rank',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color.fromRGBO(21, 101, 192, 1)),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: 'out of ',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              children: [
                TextSpan(
                  text: '$total students',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[300], height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMetric('Score', '${data['final_marks']} / ${data['total_marks']}'),
              _buildMetric('Grade', data['grade']),
              _buildMetric('Avg', '${data['percentage']}%'),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(13, 71, 161, 1)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildPercentileCard(double percentile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'You scored better than',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            '${percentile.toStringAsFixed(1)}% of your class',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromRGBO(46, 125, 50, 1)),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percentile / 100,
            backgroundColor: Colors.grey[200],
            color: Colors.green.shade600,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectRankSection(List<Map<String, dynamic>> subjects) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
                width: 6,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.purple.shade700,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(3)),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Subject-wise Performance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(123, 31, 162, 1)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...subjects.map((sub) {
            final rank = sub['rank'] as int;
            final isTop3 = rank <= 3;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
                color: isTop3 ? Colors.blue.shade50 : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      sub['subject'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${sub['marks']} / ${sub['total']}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isTop3 ? Colors.orange.shade100 : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#${sub['rank']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isTop3 ? Colors.orange.shade800 : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}