import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class StudentAssessmentPage extends StatefulWidget {
  final Map<String, dynamic> test;

  const StudentAssessmentPage({super.key, required this.test});

  @override
  State<StudentAssessmentPage> createState() => _StudentAssessmentPageState();
}

class _StudentAssessmentPageState extends State<StudentAssessmentPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late CountdownTimer _timer;
  List<Map<String, dynamic>> _responses = [];
  Set<String> _flaggedQuestions = {};
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeResponses();
    final durationMinutes = widget.test['duration_minutes'] as int? ?? 30;
    _timer = CountdownTimer(
      duration: Duration(minutes: durationMinutes),
      onTick: () => setState(() {}),
      onComplete: _onTimeUp,
    );
    _tabController = TabController(length: 2, vsync: this);
  }

  void _initializeResponses() {
    final questions = widget.test['questions'] as List;
    _responses = List.generate(
      questions.length,
      (index) {
        final q = questions[index] as Map<String, dynamic>;
        return {
          'question_id': q['id'],
          'answer': null,
          'is_flagged': false,
          'time_spent_seconds': 0,
        };
      },
    );
  }

  void _onTimeUp() {
    _submitTest();
  }

  void _submitTest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test submitted successfully!')),
    );
    Navigator.pop(context);
  }

  void _saveAnswer(dynamic answer) {
    setState(() {
      _responses[_currentQuestionIndex]['answer'] = answer;
    });
  }

  void _toggleFlag() {
    final questions = widget.test['questions'] as List;
    final qId = (questions[_currentQuestionIndex] as Map)['id'] as String;
    final wasFlagged = _flaggedQuestions.contains(qId);

    setState(() {
      if (wasFlagged) {
        _flaggedQuestions.remove(qId);
        _responses[_currentQuestionIndex]['is_flagged'] = false;
      } else {
        _flaggedQuestions.add(qId);
        _responses[_currentQuestionIndex]['is_flagged'] = true;
      }
    });
  }

  void _navigateToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
      _tabController.animateTo(0);
    });
  }

  @override
  void dispose() {
    _timer.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final test = widget.test;
    final questions = test['questions'] as List;
    final bool isCompleted = widget.test['status'] == 'completed';
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(test['title']),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade800,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.blue.shade200, height: 1),
          ),
        ),
        body: const Center(child: Text('No questions available.')),
      );
    }

    final currentQ = questions[_currentQuestionIndex] as Map<String, dynamic>;

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            test['title'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade800,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.blue.shade200, height: 1),
          ),
          actions: [
            if (!isCompleted) _buildTimerChip(_timer.timeRemaining),
            if (!isCompleted)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ElevatedButton.icon(
                  onPressed: _submitTest,
                  icon: const Icon(Icons.send, size: 16),
                  label: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],

        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Q${_currentQuestionIndex + 1} of ${questions.length} • ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        children: [
                          TextSpan(
                            text: '${currentQ['marks']} marks',
                            style: TextStyle(color: Colors.blue.shade700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: isCompleted ? null : _toggleFlag,
                    child: Chip(
                      avatar: Icon(
                        _flaggedQuestions.contains(currentQ['id'])
                            ? Icons.flag
                            : Icons.flag_outlined,
                        size: 16,
                        color: _flaggedQuestions.contains(currentQ['id'])
                            ? Colors.red
                            : Colors.grey,
                      ),
                      label: const Text('Flag'),
                      backgroundColor: _flaggedQuestions.contains(currentQ['id'])
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentQ['prompt'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildQuestionInput(currentQ, _saveAnswer),
                        ],
                      ),
                    ),
                  ),
                  _buildReviewPanel(questions),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _tabController.animateTo(1),
                    icon: const Icon(Icons.list, size: 18),
                    label: const Text('Review'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      foregroundColor: Colors.grey[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const Spacer(),
                  if (_currentQuestionIndex > 0)
                    FilledButton.tonal(
                      onPressed: () => _navigateToQuestion(_currentQuestionIndex - 1),
                      child: const Text('Previous'),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      if (_currentQuestionIndex < questions.length - 1) {
                        _navigateToQuestion(_currentQuestionIndex + 1);
                      } else {
                        _submitTest();
                      }
                    },
                    child: Text(_currentQuestionIndex == questions.length - 1 ? 'Submit' : 'Next'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerChip(Duration remaining) {
    final isCritical = remaining.inMinutes < 5;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCritical ? Colors.red.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${remaining.inMinutes}:${remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isCritical ? Colors.red.shade800 : Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _buildQuestionInput(Map<String, dynamic> q, Function(dynamic) onAnswer) {
    final currentAnswer = _responses[_currentQuestionIndex]['answer'];
    final bool isCompleted = widget.test['status'] == 'completed';
    switch ((q['type'] as String).toLowerCase()) {
      case 'mcq':
        return Column(
          children: List.generate(
            (q['options'] as List).length,
            (i) => RadioListTile<String>(
              title: Text(q['options'][i]),
              value: q['options'][i],
              groupValue: currentAnswer,
              activeColor: Colors.blue.shade700,
              onChanged: isCompleted ? null : (val) => onAnswer(val),
            ),
          ),
        );

      case 'true_false':
        return ToggleButtons(
          isSelected: [
            currentAnswer == 'True',
            currentAnswer == 'False',
          ],
          onPressed: isCompleted ? null : (index) {
            onAnswer(index == 0 ? 'True' : 'False');
          },
          borderColor: Colors.grey,
          selectedColor: Colors.white,
          selectedBorderColor: Colors.blue.shade700,
          fillColor: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(8),
          children: const [
            Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('True')),
            Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('False')),
          ],
        );
      case 'short_answer':
        return TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: isCompleted ? null : onAnswer,
          readOnly: isCompleted,
          controller: TextEditingController(text: currentAnswer?.toString()),
        );

      case 'numerical':
        return TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Enter a number...',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged:  isCompleted ? null : onAnswer,
          controller: TextEditingController(text: currentAnswer?.toString()),
        );

      default:
        return Card(
          elevation: 0,
          color: Colors.grey[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Question type "${q['type']}" is not supported.'),
          ),
        );
    }
  }

  Widget _buildReviewPanel(List questions) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 21, 100, 211)),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                questions.length,
                (i) {
                  final q = questions[i] as Map<String, dynamic>;
                  final isAnswered = _responses[i]['answer'] != null;
                  final isFlagged = _flaggedQuestions.contains(q['id']);
                  Color bgColor;
                  if (isFlagged && isAnswered) {
                    bgColor = Colors.orange;
                  } else if (isFlagged) {
                    bgColor = Colors.red;
                  } else if (isAnswered) {
                    bgColor = Colors.green;
                  } else {
                    bgColor = Colors.grey;
                  }

                  return GestureDetector(
                    onTap: () => _navigateToQuestion(i),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey, height: 1),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
                children: [
                  const TextSpan(text: 'Legend: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  WidgetSpan(
                    child: Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                  const TextSpan(text: ' Answered  '),
                  WidgetSpan(
                    child: Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                    ),
                  ),
                  const TextSpan(text: ' Not Answered  '),
                  WidgetSpan(
                    child: Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                    ),
                  ),
                  const TextSpan(text: ' Flagged & Answered  '),
                  WidgetSpan(
                    child: Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
                  const TextSpan(text: ' Flagged'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple countdown timer
class CountdownTimer {
  final Duration duration;
  final VoidCallback onTick;
  final VoidCallback onComplete;

  late Timer _timer;
  Duration _remaining;

  CountdownTimer({
    required this.duration,
    required this.onTick,
    required this.onComplete,
  }) : _remaining = duration {
    _start();
  }

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        _remaining -= const Duration(seconds: 1);
        onTick();
      } else {
        _timer.cancel();
        onComplete();
      }
    });
  }

  Duration get timeRemaining => _remaining;

  void dispose() {
    _timer.cancel();
  }
}