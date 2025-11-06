import 'package:flutter/material.dart';
import '../LoginScreen/LoginScreen.dart';

class StudentProfileWithParents extends StatelessWidget {
  const StudentProfileWithParents({super.key});

  @override
  Widget build(BuildContext context) {
    // --- MOCK DATA FROM YOUR DATABASE SCHEMA ---

    // From `users` (student)
    final student = {
      'full_name': 'Alex Johnson',
      'email': 'alex.j@student.edu',
      'phone': '+91 98765 43210',
      'date_of_birth': '12 May 2010',
      'gender': 'Male',
    };

    // From `enrollments` + `classes`
    final enrollment = {
      'roll_number': '10A-24',
      'enrollment_number': 'ENR20251001',
      'class': 'Grade 10',
      'section': 'A',
      'academic_year': '2025–2026',
    };

    // From `parent_links` + `users` (parents)
    final List<Map<String, dynamic>> parents = [
      {
        'full_name': 'Sarah Johnson',
        'relation': 'Mother',
        'email': 'sarah.j@example.com',
        'phone': '+91 98765 00001',
        'is_primary': true,
        'can_view_progress': true,
        'can_view_attendance': true,
        'can_communicate': true,
      },
      {
        'full_name': 'Michael Johnson',
        'relation': 'Father',
        'email': 'michael.j@example.com',
        'phone': '+91 98765 00002',
        'is_primary': false,
        'can_view_progress': true,
        'can_view_attendance': false,
        'can_communicate': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.blue.shade200, height: 1),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Edit profile or settings
            },
            icon: const Icon(Icons.settings_outlined),
            color: Colors.blue.shade700,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  // === STUDENT PROFILE CARD ===
                  _buildProfileCard(
                    title: 'Student Information',
                    color: Colors.blue.shade700,
                    child: Column(
                      children: [
                        _buildAvatar('Alex Johnson'),
                        const SizedBox(height: 16),
                        Text(
                          '${student['full_name']}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromRGBO(13, 71, 161, 1)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${enrollment['class']} • Section ${enrollment['section']}',
                          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow('Roll Number', '${enrollment['roll_number']}'),
                        _buildInfoRow('Enrollment ID', '${enrollment['enrollment_number']}'),
                        _buildInfoRow('Academic Year', '${enrollment['academic_year']}'),
                        _buildInfoRow('Date of Birth', '${student['date_of_birth']}'),
                        _buildInfoRow('Gender', '${student['gender']}'),
                        _buildInfoRow('Email', '${student['email']}'),
                        _buildInfoRow('Phone', '${student['phone']}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildProfileCard(
                    title: 'Parents & Guardians',
                    color: Colors.purple.shade700,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Linked family members who support your learning journey.',
                          style: TextStyle(fontSize: 14, color: Color.fromRGBO(97, 97, 97, 1)),
                        ),
                        const SizedBox(height: 16),
                        ...parents.map((parent) => _buildParentTile(context, parent)).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  premiumSignOutButton(context),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(3)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String name) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade50,
            border: Border.all(color: Colors.blue.shade200, width: 2),
          ),
          child: const Icon(Icons.person, size: 48, color: Color.fromRGBO(25, 118, 210, 1)),
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Color.fromRGBO(33, 33, 33, 1)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentTile(BuildContext context, Map<String, dynamic> parent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          parent['full_name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (parent['is_primary']) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Primary',
                              style: TextStyle(color: Color.fromRGBO(46, 125, 50, 1), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      parent['relation'],
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              if (parent['can_view_progress'])
                _buildPermissionBadge('View Progress', Colors.blue),
              if (parent['can_view_attendance'])
                _buildPermissionBadge('View Attendance', Colors.green),
              if (parent['can_communicate'])
                _buildPermissionBadge('Can Message', Colors.purple),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Email: ', style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: parent['email']),
                const TextSpan(text: '\nPhone: ', style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: parent['phone']),
              ],
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget premiumSignOutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginscreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Sign Out",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}