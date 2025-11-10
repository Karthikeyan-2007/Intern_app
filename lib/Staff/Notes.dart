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
  bool _showPreview = false;

  final List<String> _attachedFiles = [];
  final List<String> _classes = ['Grade 10 - A', 'Grade 10 - B'];
  final Map<String, List<String>> _subjectsByClass = {
    'Grade 10 - A': ['Mathematics', 'Physics', 'English'],
    'Grade 10 - B': ['Biology', 'Chemistry', 'Computer Science'],
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addAttachment() {
    setState(() => _attachedFiles.add("example_notes.pdf"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Upload Notes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0059FF),
        elevation: 5,
        onPressed: () {
          setState(() => _showPreview = !_showPreview);
        },
        icon: Icon(_showPreview ? Icons.arrow_back : Icons.remove_red_eye_rounded),
        label: Text(_showPreview ? "Back to Edit" : "Preview",
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _showPreview ? _previewUI() : _formUI(),
      ),
    );
  }
  Widget _formUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _frostedCard(
            title: "Class & Subject",
            child: Column(
              children: [
                _dropDown("Class", _selectedClass, _classes, (val) {
                  setState(() {
                    _selectedClass = val!;
                    _selectedSubject = _subjectsByClass[val]!.first;
                  });
                }),
                const SizedBox(height: 12),
                _dropDown(
                  "Subject",
                  _selectedSubject,
                  _subjectsByClass[_selectedClass]!,
                  (val) => setState(() => _selectedSubject = val!),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _frostedCard(
            title: "Note Details",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _inputField("Title", _titleController),
                const SizedBox(height: 12),
                _inputField("Description - Add details or instructions",
                    _descController, maxLines: 5),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _frostedCard(
            title: "Attachments",
            child: Column(
              children: [
                OutlinedButton.icon(
                  onPressed: _addAttachment,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Add Attachment"),
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      )),
                ),
                if (_attachedFiles.isNotEmpty)
                  ..._attachedFiles.map(
                    (file) => Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.picture_as_pdf_rounded, color: Colors.blue),
                          const SizedBox(width: 10),
                          Expanded(child: Text(file)),
                          GestureDetector(
                            onTap: () => setState(() => _attachedFiles.remove(file)),
                            child: const Icon(Icons.close, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  ///----------------------------
  /// PREVIEW UI SECTION
  ///----------------------------
  Widget _previewUI() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              color: Colors.black12.withOpacity(0.07),
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoChip(_selectedSubject),
            const SizedBox(height: 10),
            Text(
              _titleController.text.trim().isEmpty
                  ? "Untitled Note"
                  : _titleController.text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002366),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              _descController.text.trim().isEmpty
                  ? "No description added."
                  : _descController.text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 12),
            if (_attachedFiles.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("📎 Attachments",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._attachedFiles.map((f) => Text("• $f")).toList()
                ],
              ),
          ],
        ),
      ),
    );
  }

  ///----------------------------
  /// UI SMALL COMPONENTS
  ///----------------------------

  Widget _dropDown(String label, String selected, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField(
      value: selected,
      decoration: _inputDecoration(label),
      onChanged: onChanged,
      items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
    );
  }

  Widget _inputField(String label, TextEditingController c, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _frostedCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child
          ]),
    );
  }

  Widget _infoChip(String label) {
    return Chip(
      padding: const EdgeInsets.all(6),
      label: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColor: Colors.blueAccent,
    );
  }
}
