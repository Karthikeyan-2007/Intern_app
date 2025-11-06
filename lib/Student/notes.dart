import 'package:flutter/material.dart';

class StudentPdfLibraryPage extends StatelessWidget {
  const StudentPdfLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pdfNotes = [
      // Physics
      {'id': 'note_phys_001', 'title': 'Newton’s Laws of Motion', 'subject': 'Physics', 'file_name': 'newtons_laws_ch5.pdf', 'uploaded_at': '2025-10-10', 'view_count': 142},
      {'id': 'note_phys_002', 'title': 'Work, Energy & Power', 'subject': 'Physics', 'file_name': 'work_energy_ch6.pdf', 'uploaded_at': '2025-10-15', 'view_count': 98},
      {'id': 'note_phys_003', 'title': 'Gravitation', 'subject': 'Physics', 'file_name': 'gravitation_ch7.pdf', 'uploaded_at': '2025-10-18', 'view_count': 76},

      // Mathematics
      {'id': 'note_math_001', 'title': 'Quadratic Equations', 'subject': 'Mathematics', 'file_name': 'quadratic_ch3.pdf', 'uploaded_at': '2025-10-12', 'view_count': 210},
      {'id': 'note_math_002', 'title': 'Arithmetic Progressions', 'subject': 'Mathematics', 'file_name': 'ap_ch4.pdf', 'uploaded_at': '2025-10-20', 'view_count': 132},

      // Biology
      {'id': 'note_bio_001', 'title': 'Cell Structure', 'subject': 'Biology', 'file_name': 'cell_biology_ch1.pdf', 'uploaded_at': '2025-09-28', 'view_count': 87},
      {'id': 'note_bio_002', 'title': 'Tissues', 'subject': 'Biology', 'file_name': 'tissues_ch2.pdf', 'uploaded_at': '2025-10-05', 'view_count': 104},
      {'id': 'note_bio_003', 'title': 'Diversity in Living Organisms', 'subject': 'Biology', 'file_name': 'diversity_ch3.pdf', 'uploaded_at': '2025-10-22', 'view_count': 65},

      // English
      {'id': 'note_eng_001', 'title': 'Essay Writing Guide', 'subject': 'English', 'file_name': 'essay_writing.pdf', 'uploaded_at': '2025-10-01', 'view_count': 92},
    ];
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final note in pdfNotes) {
      final subject = note['subject'] as String;
      grouped.putIfAbsent(subject, () => []).add(note);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Study Materials',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Access chapter-wise PDF notes uploaded by your teachers.',
                style: TextStyle(fontSize: 15, color: Color.fromRGBO(97, 97, 97, 1)),
              ),
              const SizedBox(height: 24),
              ...grouped.entries.map((entry) {
                return _buildSubjectSection(context, entry.key, entry.value);
              }).toList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectSection(BuildContext context, String subject, List<Map<String, dynamic>> notes) {
    final color = _getSubjectColor(subject);
    final icon = _getSubjectIcon(subject);
    final count = notes.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject Header with Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Text(
                  '$subject',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count Chapter${count == 1 ? '' : 's'}',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // PDF Cards
          ...notes.map((note) => _buildPdfCard(context, note)).toList(),
        ],
      ),
    );
  }

  Widget _buildPdfCard(BuildContext context, Map<String, dynamic> note) {
    return GestureDetector(
      onTap: () {
        // TODO: Open PDF viewer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening: ${note['title']}')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.picture_as_pdf, size: 22, color: Colors.red),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note['title'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note['file_name'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildMetaTag('${note['view_count']} views', Icons.visibility, Colors.grey),
                      const SizedBox(width: 14),
                      _buildMetaTag(note['uploaded_at'], Icons.calendar_today, Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaTag(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics':
        return Icons.science;
      case 'mathematics':
        return Icons.calculate;
      case 'english':
        return Icons.book;
      case 'biology':
        return Icons.biotech;
      case 'chemistry':
        return Icons.science_outlined;
      default:
        return Icons.school;
    }
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics':
        return Colors.deepPurple;
      case 'mathematics':
        return Colors.blue;
      case 'english':
        return Colors.green;
      case 'biology':
        return Colors.teal;
      case 'chemistry':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}