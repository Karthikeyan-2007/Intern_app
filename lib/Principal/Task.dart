import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrincipalWorkflowDashboardPage extends StatefulWidget {
  const PrincipalWorkflowDashboardPage({super.key});

  @override
  State<PrincipalWorkflowDashboardPage> createState() =>
      _PrincipalWorkflowDashboardPageState();
}

class _PrincipalWorkflowDashboardPageState
    extends State<PrincipalWorkflowDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final TextEditingController _leaveRemarkController = TextEditingController();
  final TextEditingController _queryReplyController = TextEditingController();

  String _selectedTab = "Tasks";

  // ===== MOCK DATA =====
  List<TaskItem> _tasks = [
    TaskItem(
      id: 'task1',
      title: 'Submit Grade 10 Math Syllabus',
      description: 'Deadline: Friday, 5 PM',
      assignedTo: 'Mr. Rajesh Kumar',
      status: TaskStatus.pending,
      dueDate: DateTime.now().add(Duration(days: 2)),
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    TaskItem(
      id: 'task2',
      title: 'Upload Lab Safety Guidelines',
      description: 'For Science Dept',
      assignedTo: 'Dr. Meera Patel',
      status: TaskStatus.completed,
      dueDate: DateTime.now().subtract(Duration(days: 1)),
      createdAt: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

  List<LeaveRequest> _leaveRequests = [
    LeaveRequest(
      id: 'leave1',
      name: 'Ms. Ananya Singh',
      role: 'Teacher',
      fromDate: '2025-11-10',
      toDate: '2025-11-12',
      reason: 'Family wedding',
      status: LeaveStatus.pending,
      remarks: '',
    ),
    LeaveRequest(
      id: 'leave2',
      name: 'Rohan Patel',
      role: 'Student',
      fromDate: '2025-10-28',
      toDate: '2025-10-29',
      reason: 'Medical checkup',
      status: LeaveStatus.approved,
      remarks: 'Approved - Doctor certificate received',
    ),
  ];

  List<QueryItem> _queries = [
    QueryItem(
      id: 'q1',
      senderName: 'Dr. Meera Patel',
      role: 'Teacher',
      subject: 'Urgent: Lab Equipment Missing',
      message:
          'Two Bunsen burners are missing from Room 304. Request immediate replacement.',
      timestamp: DateTime.now().subtract(Duration(hours: 3)),
      isResolved: false,
      replies: [
        Reply(
          sender: 'Principal',
          message: 'Noted. Will check with storekeeper.',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
        )
      ],
    ),
    QueryItem(
      id: 'q2',
      senderName: 'Alex Johnson',
      role: 'Student',
      subject: 'Request for Library Access',
      message: 'Can I get weekend access to the library for project work?',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      isResolved: true,
      replies: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = ["Tasks", "Leave", "Queries"][_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskTitleController.dispose();
    _taskDescController.dispose();
    _leaveRemarkController.dispose();
    _queryReplyController.dispose();
    super.dispose();
  }

  // =============================================================
  //  TASK FORM
  // =============================================================
  void _showTaskForm() {
    _taskTitleController.clear();
    _taskDescController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _glassContainer(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Assign New Task",
                  style: Theme.of(ctx)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Title
              TextField(
                controller: _taskTitleController,
                decoration: const InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Description
              TextField(
                controller: _taskDescController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              FilledButton(
                onPressed: () {
                  if (_taskTitleController.text.trim().isNotEmpty) {
                    setState(() {
                      _tasks.insert(
                        0,
                        TaskItem(
                          id: "task${_tasks.length + 1}",
                          title: _taskTitleController.text.trim(),
                          description: _taskDescController.text.trim(),
                          assignedTo: "Selected Teacher(s)",
                          status: TaskStatus.pending,
                          dueDate: DateTime.now().add(Duration(days: 3)),
                          createdAt: DateTime.now(),
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Task assigned ✅")),
                    );
                  }
                },
                child: const Text("Assign Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: Offset(0, 4),
              color: Colors.black.withOpacity(0.15),
            )
          ],
        ),
        child: child,
      ),
    );
  }

  // =============================================================
  //  UI BUILD
  // =============================================================
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(227, 242, 253, 1),
            Color.fromRGBO(187, 222, 251, 1),
            Color.fromRGBO(227, 242, 253, 1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text("Communication & Management",
              style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Tasks", icon: Icon(Icons.assignment)),
              Tab(text: "Leave", icon: Icon(Icons.calendar_month)),
              Tab(text: "Queries", icon: Icon(Icons.chat)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTasksTab(),
            _buildLeaveTab(),
            _buildQueriesTab(),
          ],
        ),
        floatingActionButton: _selectedTab == "Tasks"
            ? FloatingActionButton(
                onPressed: _showTaskForm,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  // =============================================================
  //  TAB WIDGETS  (Tasks / Leave / Queries)
  // =============================================================

  Widget _buildTasksTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 16),
          child: _glassContainer(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        _statusChip(task.status),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (task.description.isNotEmpty)
                      Text(task.description,
                          style: const TextStyle(color: Colors.black87)),
                    const SizedBox(height: 12),

                    Text("Assigned to: ${task.assignedTo}",
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),

                    Text("Due: ${DateFormat('MMM d').format(task.dueDate)}",
                        style: const TextStyle(color: Colors.black54)),
                  ]),
            ),
          ),
        );
      },
    );
  }

  Widget _statusChip(TaskStatus s) {
    Color c = s == TaskStatus.completed ? Colors.green : Colors.orange;
    return Chip(
      label:
          Text(s.name.capitalize, style: TextStyle(color: Colors.white)),
      backgroundColor: c,
    );
  }

  Widget _buildLeaveTab() {
    final pending = _leaveRequests.where((x) => x.status == LeaveStatus.pending).toList();
    final resolved = _leaveRequests.where((x) => x.status != LeaveStatus.pending).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pending.isNotEmpty) ...[
          const Text("Pending Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ...pending.map((leave) => _leaveCard(leave, true)),
          const SizedBox(height: 24),
        ],
        const Text("Approved / Rejected",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        ...resolved.map((leave) => _leaveCard(leave, false)),
      ],
    );
  }

  Widget _leaveCard(LeaveRequest leave, bool isPending) {
    Color c = leave.status == LeaveStatus.approved
        ? Colors.green
        : leave.status == LeaveStatus.rejected
            ? Colors.red
            : Colors.orange;

    return _glassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(leave.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Chip(label: Text(leave.role)),
          ]),
          const SizedBox(height: 8),
          Text("Reason: ${leave.reason}"),
          Text("From: ${leave.fromDate} → To: ${leave.toDate}"),
          const SizedBox(height: 12),
          if (isPending)
            Row(
              children: [
                FilledButton.tonal(
                    onPressed: () => _approveLeave(leave, false),
                    child: const Text("Reject")),
                const SizedBox(width: 12),
                FilledButton(
                    onPressed: () => _approveLeave(leave, true),
                    child: const Text("Approve")),
              ],
            )
          else
            Chip(
              label: Text(leave.status.name.capitalize),
              backgroundColor: c,
              labelStyle: const TextStyle(color: Colors.white),
            )
        ]),
      ),
    );
  }

  void _approveLeave(LeaveRequest leave, bool approve) {
    _leaveRemarkController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _glassContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(mainAxisSize: MainAxisSize.min, children: [
            Text("${approve ? 'Approve' : 'Reject'} Leave Request",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            TextField(
              controller: _leaveRemarkController,
              decoration: const InputDecoration(
                hintText: "Add remark (optional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            Row(children: [
              Expanded(
                  child: FilledButton.tonal(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"))),
              const SizedBox(width: 12),
              Expanded(
                  child: FilledButton(
                onPressed: () {
                  setState(() {
                    leave.status =
                        approve ? LeaveStatus.approved : LeaveStatus.rejected;
                    leave.remarks = _leaveRemarkController.text.trim();
                  });
                  Navigator.pop(ctx);
                },
                child: Text(approve ? "Approve" : "Reject"),
              ))
            ])
          ]),
        ),
      ),
    );
  }

  Widget _buildQueriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _queries.length,
      itemBuilder: (context, index) {
        final q = _queries[index];
        return _glassContainer(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(q.senderName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Chip(label: Text(q.role)),
                    const Spacer(),
                    Switch(
                      value: q.isResolved,
                      onChanged: (_) {
                        setState(() => q.isResolved = !q.isResolved);
                      },
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(q.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(q.message),
                  const SizedBox(height: 10),

                  if (q.replies.isNotEmpty)
                    ...q.replies.map((reply) => Align(
                          alignment: reply.sender == "Principal"
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: reply.sender == "Principal"
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(reply.sender,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(reply.message),
                                  Text(
                                    DateFormat('h:mm a').format(reply.timestamp),
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ),
                                ]),
                          ),
                        )),
                  const SizedBox(height: 10),

                  if (!q.isResolved)
                    TextField(
                      controller: _queryReplyController,
                      decoration: InputDecoration(
                        hintText: "Reply to ${q.senderName}...",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            setState(() {
                              q.replies.add(Reply(
                                sender: "Principal",
                                message: _queryReplyController.text.trim(),
                                timestamp: DateTime.now(),
                              ));
                              _queryReplyController.clear();
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                ]),
          ),
        );
      },
    );
  }
}

// =============== MODELS ===============
enum TaskStatus { pending, completed }
enum LeaveStatus { pending, approved, rejected }

extension on TaskStatus {
  String get name => toString().split('.').last;
}

extension on LeaveStatus {
  String get name => toString().split('.').last;
}

extension on String {
  String get capitalize =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1)}";
}

class TaskItem {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  TaskStatus status;
  final DateTime dueDate;
  final DateTime createdAt;

  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.status,
    required this.dueDate,
    required this.createdAt,
  });
}

class LeaveRequest {
  String id;
  String name;
  String role;
  String fromDate;
  String toDate;
  String reason;
  LeaveStatus status;
  String remarks;

  LeaveRequest({
    required this.id,
    required this.name,
    required this.role,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
    required this.remarks,
  });
}

class QueryItem {
  String id;
  String senderName;
  String role;
  String subject;
  String message;
  DateTime timestamp;
  bool isResolved;
  List<Reply> replies;

  QueryItem({
    required this.id,
    required this.senderName,
    required this.role,
    required this.subject,
    required this.message,
    required this.timestamp,
    required this.isResolved,
    required this.replies,
  });
}

class Reply {
  final String sender;
  final String message;
  final DateTime timestamp;

  Reply({required this.sender, required this.message, required this.timestamp});
}
