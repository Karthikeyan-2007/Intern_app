import 'package:flutter/material.dart';

class StudentDoubtChatPage extends StatefulWidget {
  const StudentDoubtChatPage({super.key});

  @override
  State<StudentDoubtChatPage> createState() => _StudentDoubtChatPageState();
}

class _StudentDoubtChatPageState extends State<StudentDoubtChatPage> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  bool _isTyping = false;

  // Mock conversation (in real app, this comes from /chat/sessions/{id}/messages)
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 'msg1',
      'role': 'assistant',
      'content': 'Hi Alex! 👋 I’m your AI study buddy. Ask me anything about Physics, Math, or your assignments!',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'citations': [],
    },
    {
      'id': 'msg2',
      'role': 'user',
      'content': 'Why is the sky blue?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 4)),
    },
    {
      'id': 'msg3',
      'role': 'assistant',
      'content': 'Great question! 🌤️ The sky appears blue because of **Rayleigh scattering**. Sunlight reaches Earth’s atmosphere and is scattered in all directions by gases and particles. Blue light is scattered more because it travels in shorter, smaller waves.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
      'citations': [
        {'note_id': 'note_phys_101', 'title': 'Light & Scattering - Class 10 Notes'},
      ],
    },
    {
      'id': 'msg4',
      'role': 'user',
      'content': 'Can you explain Newton’s Second Law?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
    },
    {
      'id': 'msg5',
      'role': 'assistant',
      'content': 'Of course! 📘 **Newton’s Second Law** states:\n\n> *The acceleration of an object is directly proportional to the net force acting on it and inversely proportional to its mass.*\n\nFormula: **F = m × a**\n\nExample: Pushing a light box vs. a heavy box with the same force — the lighter one accelerates more.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 1)),
      'citations': [
        {'note_id': 'note_phys_205', 'title': 'Newton’s Laws - Grade 10 Physics'},
      ],
    },
  ];

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
        'role': 'user',
        'content': _textController.text.trim(),
        'timestamp': DateTime.now(),
      });
      _textController.clear();
      _isTyping = true;
    });

    // Simulate AI response after delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'id': 'ai_${DateTime.now().millisecondsSinceEpoch}',
            'role': 'assistant',
            'content': 'I’ve noted your question! Let me check our resources and get back to you shortly. 💡',
            'timestamp': DateTime.now(),
            'citations': [],
          });
          _scrollToBottom();
        });
      }
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Ask Your Doubt',
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
              // TODO: Open help / guidelines
            },
            icon: const Icon(Icons.help_outline),
            color: Colors.blue.shade700,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  final msg = _messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),
          ),
          _buildInputBox(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isUser = msg['role'] == 'user';
    final citations = msg['citations'] as List<dynamic>? ?? [];

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue.shade700 : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                ),
              ),
              child: Text(
                msg['content'],
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.grey[900],
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
            if (!isUser && citations.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📚 Related Resources:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey),
                    ),
                    ...citations.map((cite) {
                      final note = cite as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          // TODO: Navigate to note detail
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            note['title'],
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            Text(
              _formatTime(msg['timestamp'] as DateTime),
              style: TextStyle(
                fontSize: 11,
                color: isUser ? Colors.blue.shade200 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 8, height: 8, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 8),
            Text('Thinking...', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // TODO: Attach image (e.g., photo of textbook problem)
            },
            icon: const Icon(Icons.attach_file, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Ask your doubt (e.g., "How to solve quadratic equations?")',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}