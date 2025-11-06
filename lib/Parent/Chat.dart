import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ParentTeacherChatPage extends StatefulWidget {
  final Map<String, dynamic> conversation;

  const ParentTeacherChatPage({super.key, required this.conversation});

  @override
  State<ParentTeacherChatPage> createState() => _ParentTeacherChatPageState();
}

class _ParentTeacherChatPageState extends State<ParentTeacherChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  // Mock messages from `conversation_messages` table
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 'msg1',
      'sender': {
        'id': 'usr_teacher_01',
        'full_name': 'Mr. Rajesh Kumar',
        'role': 'teacher',
      },
      'body': 'Hello! How can I help you with Alex’s progress?',
      'sent_at': DateTime.now().subtract(const Duration(minutes: 10)),
      'is_read': true,
    },
    {
      'id': 'msg2',
      'sender': {
        'id': 'usr_parent_01',
        'full_name': 'Parent',
        'role': 'parent',
      },
      'body': 'Hi Mr. Rajesh! I wanted to ask about his recent Physics test.',
      'sent_at': DateTime.now().subtract(const Duration(minutes: 9)),
      'is_read': true,
    },
    {
      'id': 'msg3',
      'sender': {
        'id': 'usr_teacher_01',
        'full_name': 'Mr. Rajesh Kumar',
        'role': 'teacher',
      },
      'body': 'Of course! Alex scored 92/100 — excellent work on Newton’s laws. He lost a few marks on the numerical problems.',
      'sent_at': DateTime.now().subtract(const Duration(minutes: 8)),
      'is_read': true,
    },
    {
      'id': 'msg4',
      'sender': {
        'id': 'usr_parent_01',
        'full_name': 'Parent',
        'role': 'parent',
      },
      'body': 'Thank you! Could you suggest some practice resources?',
      'sent_at': DateTime.now().subtract(const Duration(minutes: 7)),
      'is_read': true,
    },
    {
      'id': 'msg5',
      'sender': {
        'id': 'usr_teacher_01',
        'full_name': 'Mr. Rajesh Kumar',
        'role': 'teacher',
      },
      'body': 'I’ve shared extra practice sheets in the Study Materials section. Let me know if you need more!',
      'sent_at': DateTime.now().subtract(const Duration(minutes: 6)),
      'is_read': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    // Add parent message
    final newMessage = {
      'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
      'sender': {
        'id': 'usr_parent_01',
        'full_name': 'Parent',
        'role': 'parent',
      },
      'body': _textController.text.trim(),
      'sent_at': DateTime.now(),
      'is_read': false,
    };

    setState(() {
      _messages.add(newMessage);
      _textController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate teacher reply after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'id': 'ai_${DateTime.now().millisecondsSinceEpoch}',
            'sender': {
              'id': 'usr_teacher_01',
              'full_name': 'Mr. Rajesh Kumar',
              'role': 'teacher',
            },
            'body': 'You’re welcome! I’ll also share a video tutorial on numerical problem-solving later today.',
            'sent_at': DateTime.now(),
            'is_read': false,
          });
          _scrollToBottom();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final teacher = widget.conversation['teacher'] as Map<String, dynamic>;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1976D2),
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade100,
                ),
                child: const Icon(Icons.person, size: 18, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher['full_name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Class Teacher • Online',
                    style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: View profile, call, etc.
              },
              icon: const Icon(Icons.more_vert),
              color: const Color(0xFF1976D2),
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
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isParent = msg['sender']['role'] == 'parent';

    return Row(
      mainAxisAlignment: isParent ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: _buildMessageContent(msg, isParent),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(Map<String, dynamic> msg, bool isParent) {
    final sentAt = msg['sent_at'] as DateTime;
    
    return Column(
      crossAxisAlignment: isParent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isParent ? const Color(0xFF1976D2) : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isParent ? const Radius.circular(18) : const Radius.circular(4),
              bottomRight: isParent ? const Radius.circular(4) : const Radius.circular(18),
            ),
          ),
          child: Text(
            msg['body'],
            style: TextStyle(
              color: isParent ? Colors.white : Colors.grey[900],
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('h:mm a').format(sentAt),
          style: TextStyle(
            fontSize: 11,
            color: isParent ? Colors.blue.shade100 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 8, height: 8, child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 8),
                Text('Teacher is typing...', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
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
              // TODO: Attach file (PDF, image)
            },
            icon: const Icon(Icons.attach_file, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
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
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}