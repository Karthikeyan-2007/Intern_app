import 'package:flutter/material.dart';

class TeacherNotesUploadPage extends StatefulWidget {
  const TeacherNotesUploadPage({super.key});

  @override
  State<TeacherNotesUploadPage> createState() => _TeacherNotesUploadPageState();
}

class _TeacherNotesUploadPageState extends State<TeacherNotesUploadPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String _selectedClass = 'Grade 10 - A';
  String _selectedSubject = 'Mathematics';
  String _visibility = 'class';
  bool _isPublishing = false;
  bool _showPreview = false;

  final List<String> _attachedFiles = [];

  final List<String> _classes = ['Grade 10 - A', 'Grade 10 - B', 'Grade 11 - A'];
  final Map<String, List<String>> _subjectsByClass = {
    'Grade 10 - A': ['Mathematics', 'Physics', 'English'],
    'Grade 10 - B': ['Mathematics', 'Chemistry', 'Biology'],
    'Grade 11 - A': ['Calculus', 'Physics', 'Computer Science'],
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addAttachment() {
    setState(() => _attachedFiles.add('chapter_3_notes.pdf'));
  }

  void _removeAttachment(String file) {
    setState(() => _attachedFiles.remove(file));
  }

  Future<void> _publishNote() async {
    if (_titleController.text.trim().isEmpty || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isPublishing = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes published successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _isPublishing = false;
        _titleController.clear();
        _descController.clear();
        _attachedFiles.clear();
        _showPreview = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Upload Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3A8A),
        elevation: 0.4,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isPublishing
            ? null
            : _showPreview
                ? _publishNote
                : () => setState(() => _showPreview = true),
        icon: _isPublishing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
            : Icon(_showPreview ? Icons.cloud_upload_rounded : Icons.remove_red_eye_rounded),
        label: Text(_isPublishing
            ? 'Publishing...'
            : _showPreview
                ? 'Publish'
                : 'Preview'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showPreview ? _buildPreview() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sectionCard(
            title: 'Class & Subject',
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedClass,
                    items: _classes
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedClass = val;
                          _selectedSubject = _subjectsByClass[val]!.first;
                        });
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Class', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    items: (_subjectsByClass[_selectedClass] ?? [])
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedSubject = val!),
                    decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Note Content',
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    helperText: 'Include explanations, examples or diagrams',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Attachments',
            child: Column(
              children: [
                OutlinedButton.icon(
                  onPressed: _addAttachment,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Attach File'),
                ),
                if (_attachedFiles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _attachedFiles
                        .map((file) => Chip(
                              label: Text(file),
                              onDeleted: () => _removeAttachment(file),
                              deleteIcon: const Icon(Icons.close, size: 16),
                            ))
                        .toList(),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Visibility',
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'class',
                  groupValue: _visibility,
                  onChanged: (val) => setState(() => _visibility = val!),
                  title: const Text('Only this class'),
                  subtitle: Text('Visible to students in $_selectedClass'),
                ),
                RadioListTile<String>(
                  value: 'school',
                  groupValue: _visibility,
                  onChanged: (val) => setState(() => _visibility = val!),
                  title: const Text('Entire school'),
                  subtitle: const Text('All teachers and students in school'),
                ),
                RadioListTile<String>(
                  value: 'public',
                  groupValue: _visibility,
                  onChanged: (val) => setState(() => _visibility = val!),
                  title: const Text('Public'),
                  subtitle: const Text('Anyone with the link (use cautiously)'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _sectionCard(
        title: 'Preview Note',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(_selectedSubject),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: const TextStyle(color: Color(0xFF2563EB)),
                ),
                const Spacer(),
                Text(_selectedClass, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _titleController.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(_descController.text),
            if (_attachedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Attachments:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ..._attachedFiles.map((f) => Text('📄 $f')).toList(),
            ],
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  _visibility == 'class'
                      ? Icons.lock
                      : _visibility == 'school'
                          ? Icons.school
                          : Icons.public,
                  size: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  _visibility == 'class'
                      ? 'Visible to $_selectedClass'
                      : _visibility == 'school'
                          ? 'Visible to entire school'
                          : 'Publicly accessible',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF1E3A8A))),
        const SizedBox(height: 12),
        child
      ]),
    );
  }
}
