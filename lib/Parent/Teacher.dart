import 'package:flutter/material.dart';
import 'Chat.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentTeacherDirectoryPage extends StatefulWidget {
  const ParentTeacherDirectoryPage({super.key});

  @override
  State<ParentTeacherDirectoryPage> createState() =>
      _ParentTeacherDirectoryPageState();
}

class _ParentTeacherDirectoryPageState
    extends State<ParentTeacherDirectoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSubject = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mock data modeled after your DB schema
  final classInfo = {
    'class_name': 'Grade 10 - A',
    'academic_year': '2025–2026',
  };

  final classTeacher = {
    'id': 'usr_teacher_01',
    'full_name': 'Mr. Rajesh Kumar',
    'email': 'rajesh.k@school.edu',
    'phone': '+91 98765 11111',
    'profile_picture_url': null,
    'role': 'Class Teacher',
    'subjects': ['Mathematics'],
  };

  final List<Map<String, dynamic>> subjectTeachers = [
    {
      'subject': 'Physics',
      'teacher': {
        'id': 'usr_teacher_02',
        'full_name': 'Dr. Meera Patel',
        'email': 'meera.p@school.edu',
        'phone': '+91 98765 22222',
        'profile_picture_url': null,
        'subjects': ['Physics', 'Chemistry'],
      },
    },
    {
      'subject': 'Biology',
      'teacher': {
        'id': 'usr_teacher_03',
        'full_name': 'Ms. Ananya Singh',
        'email': 'ananya.s@school.edu',
        'phone': '+91 98765 33333',
        'profile_picture_url': null,
        'subjects': ['Biology'],
      },
    },
    {
      'subject': 'English',
      'teacher': {
        'id': 'usr_teacher_04',
        'full_name': 'Mrs. Priya Desai',
        'email': 'priya.d@school.edu',
        'phone': '+91 98765 44444',
        'profile_picture_url': null,
        'subjects': ['English', 'Literature'],
      },
    },
  ];

  List<String> get _subjects {
    final subjects = <String>{'All'};
    for (final item in subjectTeachers) {
      subjects.add(item['subject']);
    }
    return subjects.toList();
  }

  List<Map<String, dynamic>> get _filteredTeachers {
    final query = _searchController.text.toLowerCase();
    return subjectTeachers.where((item) {
      final teacher = item['teacher'] as Map<String, dynamic>;
      final matchesSearch = query.isEmpty ||
          teacher['full_name'].toLowerCase().contains(query) ||
          item['subject'].toLowerCase().contains(query);
      final matchesFilter =
          _selectedSubject == 'All' || item['subject'] == _selectedSubject;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('Could not call $phone');
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('Could not open email app');
    }
  }

  void _showError(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startConversation(Map<String, dynamic> teacher) {
    // TODO: POST /conversations
    // {
    //   "regarding_student_id": "usr_student_01",
    //   "topic": "Query for ${teacher['full_name']}",
    //   "category": "academic",
    //   "assigned_to": teacher['id']
    // }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message sent to ${teacher['full_name']}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              _buildClassBanner(classInfo),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search teachers or subjects...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    final subject = _subjects[index];
                    final isSelected = _selectedSubject == subject;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(subject),
                        selected: isSelected,
                        onSelected: (selected) =>
                            setState(() => _selectedSubject = subject),
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF1976D2),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[800],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _buildTeacherCard(
                teacher: classTeacher,
                role: 'Class Teacher',
                isClassTeacher: true,
                onMessage: () => _startConversation(classTeacher),
                onCall: () => _launchPhone('${classTeacher['phone']}'),
                onEmail: () => _launchEmail('${classTeacher['email']}'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Subject Teachers',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_filteredTeachers.length} teachers',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_filteredTeachers.isEmpty)
                Center(
                  child: Column(
                    children: const [
                      Icon(Icons.search_off, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No teachers found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                ..._filteredTeachers.map((item) {
                  final teacher = item['teacher'] as Map<String, dynamic>;
                  return _buildSubjectTeacherCard(
                    subject: item['subject'],
                    teacher: teacher,
                    onMessage: () => _startConversation(teacher),
                    onCall: () => _launchPhone(teacher['phone']),
                    onEmail: () => _launchEmail(teacher['email']),
                  );
                }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildClassBanner(Map<String, dynamic> classInfo) {
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
            classInfo['class_name'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          Text(
            classInfo['academic_year'],
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          const Text(
            'Reach out to your child’s teachers for academic support, updates, or concerns.',
            style: TextStyle(fontSize: 14, color: Color(0xFF616161)),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard({
    required Map<String, dynamic> teacher,
    required String role,
    required bool isClassTeacher,
    required VoidCallback onMessage,
    required VoidCallback onCall,
    required VoidCallback onEmail,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isClassTeacher ? const Color(0xFF1976D2) : Colors.grey.shade200,
          width: isClassTeacher ? 2 : 1,
        ),
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
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  border: Border.all(
                    color: isClassTeacher
                        ? const Color(0xFF1976D2)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.person,
                    size: 32, color: Color(0xFF1976D2)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher['full_name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(role, style: TextStyle(color: Colors.grey[700])),
                    if (teacher['subjects'] != null)
                      Text(
                        '${teacher['subjects'].join(', ')}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      children: [
                        _buildActionChip(
                          Icons.phone,
                          'Call',
                          Colors.green,
                          onCall,
                        ),
                        _buildActionChip(
                          Icons.email,
                          'Email',
                          Colors.blue,
                          onEmail,
                        ),
                        _buildActionChip(
                          Icons.chat_bubble,
                          'chat',
                          const Color(0xFF1976D2),
                          ParentTeacherChatPage(conversation: {'id': 'conv_001',
                            'teacher': {
                              'id': 'usr_teacher_01',
                              'full_name': '${teacher['full_name']}',
                              'email': '${teacher['email']}',
                            },
                            'regarding_student_id': 'usr_student_01',
                            'topic': 'Academic Query',
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectTeacherCard({
    required String subject,
    required Map<String, dynamic> teacher,
    required VoidCallback onMessage,
    required VoidCallback onCall,
    required VoidCallback onEmail,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getSubjectColor(subject).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSubjectIcon(subject),
                  size: 24,
                  color: _getSubjectColor(subject),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getSubjectColor(subject),
                      ),
                    ),
                    Text(
                      teacher['full_name'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: [
                        _buildContactChip(Icons.email, teacher['email']),
                        _buildContactChip(Icons.phone, teacher['phone']),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: onCall,
                icon: const Icon(Icons.phone, size: 16),
                label: const Text('Call', style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  side: const BorderSide(color: Colors.green),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onEmail,
                icon: const Icon(Icons.email, size: 16),
                label: const Text('Email', style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
              FilledButton.icon(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ParentTeacherChatPage(conversation: {'id': 'conv_001',
                    'teacher': {
                      'id': 'usr_teacher_01',
                      'full_name': '${teacher['full_name']}',
                      'email': '${teacher['email']}',
                    },
                    'regarding_student_id': 'usr_student_01',
                    'topic': 'Academic Query',
                  }),));
                },
                icon: const Icon(Icons.chat_bubble, size: 16),
                label: const Text('chat', style: TextStyle(fontSize: 13)),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, Color color, onTap) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> onTap));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactChip(IconData icon, String? value) {
    if (value == null) return const SizedBox();
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
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