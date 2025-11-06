import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Testscreen.dart';

class ParentAssessmentsDashboard extends StatefulWidget {
  const ParentAssessmentsDashboard({super.key});

  @override
  State<ParentAssessmentsDashboard> createState() =>
      _StudentAssessmentsDashboardState();
}

class _StudentAssessmentsDashboardState
    extends State<ParentAssessmentsDashboard> {
  late List<Map<String, dynamic>> _filteredAssignments;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredAssignments = _deriveUiAssignments(mockTestAssignments);
    _searchController.addListener(_filterAssignments);
  }

  List<Map<String, dynamic>> _deriveUiAssignments(
    List<Map<String, dynamic>> rawAssignments) {
    final now = DateTime.now();
    return rawAssignments.map((raw) {
      final scheduledAt = raw['scheduled_at'] as DateTime?;
      final dueAt = raw['due_at'] as DateTime?;
      final score = raw['score'] as num?;

      String uiStatus;
      if (score != null) {
        uiStatus = 'completed';
      } else if (scheduledAt != null && scheduledAt.isAfter(now)) {
        uiStatus = 'upcoming';
      } else if (dueAt != null && dueAt.isBefore(now)) {
        uiStatus = 'overdue';
      } else {
        uiStatus = 'live';
      }

      return {
        'id': raw['id'],
        'title': raw['title'],
        'subject': raw['subject'],
        'type': raw['type'],
        'mode': raw['mode'],
        'total_marks': raw['total_marks'],
        'duration_minutes': raw['duration_minutes'],
        'scheduled_at': scheduledAt,
        'due_at': dueAt,
        'status': uiStatus,
        'score': score,
        'questions': raw['questions'],
      };
    }).toList();
  }

  void _filterAssignments() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredAssignments = _deriveUiAssignments(mockTestAssignments);
      });
    } else {
      final all = _deriveUiAssignments(mockTestAssignments);
      setState(() {
        _filteredAssignments = all
            .where((item) =>
                (item['title'] as String).toLowerCase().contains(query) ||
                (item['subject'] as String).toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAssignments);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50,),
                  _buildSearchBar(),
                  const SizedBox(height: 28),
                  if (_filteredAssignments.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.assignment_outlined, size: 80, color: Color(0xFFB0B8D4)),
                          SizedBox(height: 20),
                          Text(
                            'No assessments found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF6B7599),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._groupAssignmentsBySubject(_filteredAssignments)
                        .entries
                        .map((entry) =>
                            _buildSubjectSection(entry.key, entry.value))
                        ,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search assessments or subjects...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6366F1), size: 22),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 20),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupAssignmentsBySubject(
      List<Map<String, dynamic>> assignments) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in assignments) {
      final subject = item['subject'] as String;
      grouped.putIfAbsent(subject, () => []).add(item);
    }
    return grouped;
  }

  Widget _buildSubjectSection(String subject, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getSubjectColor(subject).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getSubjectIcon(subject),
                  color: _getSubjectColor(subject),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                subject,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _getSubjectColor(subject),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getSubjectColor(subject).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${items.length}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _getSubjectColor(subject),
                  ),
                ),
              ),
            ],
          ),
        ),
        ...items.map((item) => _buildAssessmentCard(item)),
        const SizedBox(height: 24),
      ],
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics':
        return Icons.science_rounded;
      case 'mathematics':
        return Icons.calculate_rounded;
      case 'english':
        return Icons.menu_book_rounded;
      case 'biology':
        return Icons.biotech_rounded;
      case 'chemistry':
        return Icons.science_outlined;
      default:
        return Icons.school_rounded;
    }
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics':
        return const Color(0xFF7C3AED);
      case 'mathematics':
        return const Color(0xFF3B82F6);
      case 'english':
        return const Color(0xFF10B981);
      case 'biology':
        return const Color(0xFF06B6D4);
      case 'chemistry':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6366F1);
    }
  }

  Widget _buildAssessmentCard(Map<String, dynamic> item) {
    final status = item['status'] as String;
    final dueAt = item['due_at'] as DateTime?;
    final isCompleted = status == 'completed';
    final isLive = status == 'live';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParentAssessmentPage(test: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getSubjectColor(item['subject']).withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _getSubjectColor(item['subject']).withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getSubjectColor(item['subject']).withOpacity(0.05),
                      _getSubjectColor(item['subject']).withOpacity(0.02),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildTypeBadge(item['type']),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getSubjectColor(item['subject']).withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: _getSubjectColor(item['subject']),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${item['total_marks']} marks',
                                style: TextStyle(
                                  color: _getSubjectColor(item['subject']),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_rounded, size: 16, color: Color(0xFF6B7599)),
                              const SizedBox(width: 6),
                              Text(
                                '${item['duration_minutes']} min',
                                style: const TextStyle(
                                  color: Color(0xFF6B7599),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        _buildStatusPill(status),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCompleted)
                      _buildCompletedProgress(item['score'], item['total_marks'])
                    else if (isLive && dueAt != null)
                      _buildLiveTimer(dueAt)
                    else
                      _buildScheduleInfo(item['scheduled_at'], dueAt),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F4F6),
                          foregroundColor: const Color(0xFF6B7599),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        onPressed: isCompleted ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ParentAssessmentPage(test: item),
                            ),
                          );
                        } : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isCompleted ? Icons.visibility_rounded : Icons.clear,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isCompleted ? 'View Result' : 'Not started',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    final isSummative = type == 'summative';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSummative
            ? const Color(0xFFFEF2F2)
            : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isSummative ? const Color(0xFFDC2626) : const Color(0xFFEA580C),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color color;
    Color bgColor;
    String label;
    IconData icon;
    
    switch (status) {
      case 'live':
        color = const Color(0xFF10B981);
        bgColor = const Color(0xFFECFDF5);
        label = 'LIVE';
        icon = Icons.circle;
      case 'upcoming':
        color = const Color(0xFF3B82F6);
        bgColor = const Color(0xFFEFF6FF);
        label = 'UPCOMING';
        icon = Icons.schedule_rounded;
      case 'overdue':
        color = const Color(0xFFEF4444);
        bgColor = const Color(0xFFFEF2F2);
        label = 'OVERDUE';
        icon = Icons.error_outline_rounded;
      case 'completed':
        color = const Color(0xFF6B7599);
        bgColor = const Color(0xFFF3F4F6);
        label = 'COMPLETED';
        icon = Icons.check_circle_outline_rounded;
      default:
        color = const Color(0xFF6B7599);
        bgColor = const Color(0xFFF3F4F6);
        label = 'ASSIGNED';
        icon = Icons.assignment_outlined;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedProgress(num? score, num total) {
    if (score == null) return const SizedBox();
    final percentage = (score / total * 100).toInt().clamp(0, 100);
    final isPerfect = percentage == 100;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPerfect ? Icons.emoji_events_rounded : Icons.check_circle_rounded,
                color: const Color(0xFF10B981),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isPerfect ? 'Perfect Score!' : 'Assessment Completed',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10B981),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$score / $total',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Color(0xFF10B981),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: const Color(0xFFD1FAE5),
              color: const Color(0xFF10B981),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTimer(DateTime dueAt) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final remaining = dueAt.difference(now);
        if (remaining.isNegative) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.alarm_off_rounded, color: Color(0xFFEF4444), size: 20),
                SizedBox(width: 10),
                Text(
                  'Time\'s up!',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }
        final minutes = remaining.inMinutes;
        final seconds = remaining.inSeconds.remainder(60);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.timer_rounded, color: Color(0xFFEF4444), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Time Remaining',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7599),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$minutes:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEF4444),
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleInfo(DateTime? scheduledAt, DateTime? dueAt) {
    final formatter = DateFormat('MMM d, h:mm a');
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (scheduledAt != null)
            Row(
              children: [
                const Icon(Icons.play_circle_outline_rounded, size: 18, color: Color(0xFF6B7599)),
                const SizedBox(width: 10),
                const Text(
                  'Starts: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7599),
                    fontSize: 14,
                  ),
                ),
                Text(
                  formatter.format(scheduledAt),
                  style: const TextStyle(
                    color: Color(0xFF1A1F36),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          if (scheduledAt != null && dueAt != null) const SizedBox(height: 10),
          if (dueAt != null)
            Row(
              children: [
                const Icon(Icons.flag_outlined, size: 18, color: Color(0xFF6B7599)),
                const SizedBox(width: 10),
                const Text(
                  'Due: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7599),
                    fontSize: 14,
                  ),
                ),
                Text(
                  formatter.format(dueAt),
                  style: const TextStyle(
                    color: Color(0xFF1A1F36),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
final List<Map<String, dynamic>> mockTestAssignments = [
  {
    'id': 'test_001',
    'title': 'Grade 10 - Physics Midterm',
    'subject': 'Physics',
    'type': 'summative',
    'mode': 'online',
    'total_marks': 50,
    'duration_minutes': 45,
    'scheduled_at': DateTime.now().subtract(const Duration(hours: 1)),
    'due_at': DateTime.now().add(const Duration(minutes: 30)),
    'status': 'live',
    'questions': [
      {
        'id': 'q_phys_101',
        'type': 'mcq',
        'prompt': 'Which law states that the acceleration of an object is directly proportional to the net force acting on it and inversely proportional to its mass?',
        'options': [
          'Newton’s First Law of Motion',
          'Newton’s Second Law of Motion',
          'Newton’s Third Law of Motion',
          'Law of Universal Gravitation'
        ],
        'marks': 2.0,
        'difficulty': 'medium',
        'bloom_level': 'understand',
      },
      {
        'id': 'q_phys_102',
        'type': 'true_false',
        'prompt': 'Inertia is the tendency of an object to resist changes in its state of motion.',
        'options': ['True', 'False'],
        'marks': 1.0,
        'difficulty': 'easy',
        'bloom_level': 'remember',
      }
    ],
  },

  {
    'id': 'test_002',
    'title': 'Algebra Quiz',
    'subject': 'Mathematics',
    'type': 'formative',
    'mode': 'online',
    'total_marks': 20,
    'duration_minutes': 20,
    'scheduled_at': DateTime.now().add(const Duration(hours: 2)),
    'due_at': DateTime.now().add(const Duration(hours: 2, minutes: 20)),
    'status': 'upcoming',
    'questions': [
      {
        'id': 'q_math_201',
        'type': 'numerical',
        'prompt': 'Solve for x: 3x + 5 = 20',
        'marks': 3.0,
        'difficulty': 'medium',
        'bloom_level': 'apply',
      },
      {
        'id': 'q_math_202',
        'type': 'mcq',
        'prompt': 'What is the slope of the line y = 2x + 3?',
        'options': ['1', '2', '3', '0'],
        'marks': 2.0,
        'difficulty': 'easy',
        'bloom_level': 'understand',
      }
    ],
  },

  // OVERDUE English Test
  {
    'id': 'test_003',
    'title': 'Essay on Climate Change',
    'subject': 'English',
    'type': 'summative',
    'mode': 'offline',
    'total_marks': 30,
    'duration_minutes': 60,
    'scheduled_at': DateTime.now().subtract(const Duration(days: 1)),
    'due_at': DateTime.now().subtract(const Duration(hours: 2)),
    'status': 'overdue',
    'questions': [
      {
        'id': 'q_eng_301',
        'type': 'short_answer',
        'prompt': 'Write a paragraph explaining how deforestation contributes to climate change.',
        'marks': 10.0,
        'difficulty': 'hard',
        'bloom_level': 'evaluate',
      }
    ],
  },
  {
    'id': 'test_004',
    'title': 'Biology Lab Report',
    'subject': 'Biology',
    'type': 'formative',
    'mode': 'offline',
    'total_marks': 25,
    'duration_minutes': 40,
    'scheduled_at': DateTime.now().subtract(const Duration(days: 2)),
    'due_at': DateTime.now().subtract(const Duration(days: 1)),
    'status': 'completed',
    'score': 22,
    'questions': [
      {
        'id': 'q_bio_401',
        'type': 'mcq',
        'prompt': 'Which organelle is known as the powerhouse of the cell?',
        'options': ['Nucleus', 'Ribosome', 'Mitochondria', 'Lysosome'],
        'marks': 2.0,
        'difficulty': 'easy',
        'bloom_level': 'remember',
      },
      {
        'id': 'q_bio_402',
        'type': 'short_answer',
        'prompt': 'Describe the process of photosynthesis in 2-3 sentences.',
        'marks': 5.0,
        'difficulty': 'medium',
        'bloom_level': 'understand',
      }
    ],
  },
];