import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class ParentAttendancePage extends StatefulWidget {
  const ParentAttendancePage({super.key});

  @override
  State<ParentAttendancePage> createState() => _ParentAttendancePageState();
}

class _ParentAttendancePageState extends State<ParentAttendancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _attendanceRecords = [
    {'date': DateTime(2025, 11, 10), 'status': 'present', 'source': 'manual', 'time': '08:45 AM'},
    {'date': DateTime(2025, 11, 9), 'status': 'present', 'source': 'manual', 'time': '08:30 AM'},
    {'date': DateTime(2025, 11, 8), 'status': 'absent', 'source': 'manual'},
    {'date': DateTime(2025, 11, 7), 'status': 'late', 'source': 'manual', 'time': '09:15 AM'},
    {'date': DateTime(2025, 10, 31), 'status': 'present', 'source': 'manual', 'time': '08:35 AM'},
    {'date': DateTime(2025, 10, 28), 'status': 'excused', 'source': 'parent', 'metadata': {'leave_reason': 'Medical appointment', 'approved_by': 'Mr. Rajesh', 'approved_at': '2025-10-21'}},
    {'date': DateTime(2025, 10, 27), 'status': 'present', 'source': 'manual', 'time': '08:40 AM'},
    {'date': DateTime(2025, 10, 24), 'status': 'present', 'source': 'manual', 'time': '08:25 AM'},
  ];

  final List<Map<String, dynamic>> _leaveRequests = [
    {'date': DateTime(2025, 10, 22), 'type': 'leave', 'reason': 'Medical appointment', 'status': 'approved', 'requestedOn': DateTime(2025, 10, 20)},
    {'date': DateTime(2025, 10, 30), 'type': 'onduty', 'reason': 'Inter-school competition', 'status': 'pending', 'requestedOn': DateTime(2025, 10, 26)},
  ];

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedType = 'leave';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dateController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  int get _presentCount => _attendanceRecords.where((r) => r['status'] == 'present').length;
  int get _absentCount => _attendanceRecords.where((r) => r['status'] == 'absent').length;
  int get _lateCount => _attendanceRecords.where((r) => r['status'] == 'late').length;
  int get _totalDays => _attendanceRecords.length;
  double get _attendancePercentage => _totalDays > 0 ? (_presentCount / _totalDays * 100) : 0;

  Future<void> _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  void _submitRequest() {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Please enter a reason'),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _leaveRequests.insert(0, {
        'date': _selectedDate,
        'type': _selectedType,
        'reason': _reasonController.text,
        'status': 'pending',
        'requestedOn': DateTime.now(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('${_selectedType == 'leave' ? 'Leave' : 'On-Duty'} request submitted!'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    _reasonController.clear();
    _dateController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
    _selectedDate = DateTime.now();
    Navigator.of(context).pop();
  }

  void _openLeaveRequestSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.edit_calendar, color: Colors.blue.shade700, size: 26),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Request Leave / On-Duty',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton(
                          'Leave',
                          Icons.event_busy,
                          _selectedType == 'leave',
                          Colors.blue,
                          () => setModalState(() => setState(() => _selectedType = 'leave')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeButton(
                          'On-Duty',
                          Icons.work_outline,
                          _selectedType == 'onduty',
                          Colors.purple,
                          () => setModalState(() => setState(() => _selectedType = 'onduty')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                      ),
                    ),
                    onTap: _openDatePicker,
                  ),
                  const SizedBox(height: 16),

                  // Reason
                  TextField(
                    controller: _reasonController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: _selectedType == 'leave' ? 'Reason for Leave' : 'On-Duty Purpose',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.description, color: Colors.blue.shade700),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedType == 'leave' ? Colors.blue.shade700 : Colors.purple.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 3,
                    ),
                    child: Text(
                      _selectedType == 'leave' ? 'Submit Leave Request' : 'Submit On-Duty Request',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 50,),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTypeButton(String label, IconData icon, bool isSelected, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey.shade600, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.grey.shade700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Attendance',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 1.0),
              colors: [
                Color(0xFF0D47A1),
                Color(0xFF1976D2),
              ],
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Attendance report exported!')),
              );
            },
            icon: const Icon(Icons.file_download, size: 26),
            tooltip: 'Export Report',
          ),
          IconButton(
            onPressed: _openLeaveRequestSheet,
            icon: const Icon(Icons.add_circle, size: 28),
            tooltip: 'Request Leave',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          tabs: const [
            Tab(text: 'Overview',),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildRequestsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: () async => Future.delayed(Duration(seconds: 1)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentBanner(),
            const SizedBox(height: 10),
            _buildAttendancePercentageCard(),
            const SizedBox(height: 10),
            _buildSummaryCards(),
            const SizedBox(height: 10),
            _buildTrendChart(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Attendance',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_month, size: 18),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._attendanceRecords.take(5).map(_buildAttendanceRow),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTab() {
    final filtered = _leaveRequests.where((r) {
      final reason = r['reason'] as String;
      return reason.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search requests...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note_outlined, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No matching requests',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _searchQuery.isEmpty
                            ? 'Tap + to create a new request'
                            : 'Try a different keyword',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _buildLeaveRequestCard(filtered[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildStudentBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 1.0),
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10),
              ],
            ),
            child: const Icon(Icons.person, size: 38, color: Colors.blue),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alex Johnson',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Grade 10 • Section A',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendancePercentageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: _attendancePercentage / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _attendancePercentage >= 90 ? Colors.green.shade600 :
                    _attendancePercentage >= 75 ? Colors.orange.shade600 : Colors.red.shade600,
                  ),
                ),
              ),
              Text(
                '${_attendancePercentage.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Rate',
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  '$_presentCount out of $_totalDays days',
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _attendancePercentage / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _attendancePercentage >= 90 ? Colors.green.shade600 :
                    _attendancePercentage >= 75 ? Colors.orange.shade600 : Colors.red.shade600,
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final summaryItems = [
      {'label': 'Present', 'count': _presentCount, 'color': Colors.green.shade600, 'icon': Icons.check_circle},
      {'label': 'Absent', 'count': _absentCount, 'color': Colors.red.shade600, 'icon': Icons.cancel},
      {'label': 'Late', 'count': _lateCount, 'color': Colors.orange.shade600, 'icon': Icons.access_time},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 120,
      ),
      itemCount: summaryItems.length,
      itemBuilder: (context, index) {
        final item = summaryItems[index];
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item['icon'] as IconData, size: 20, color: item['color'] as Color),
              const SizedBox(height: 10),
              Text(
                '${item['count']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: item['color'] as Color,
                ),
              ),
              Text(
                item['label'] as String,
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendChart() {
    final now = DateTime.now();
    final last8Days = List.generate(8, (index) {
      return DateTime(now.year, now.month, now.day - (7 - index));
    });

    final dailyStatus = <DateTime, String>{};
    for (final day in last8Days) {
      final record = _attendanceRecords.firstWhere(
        (r) => DateFormat('yyyy-MM-dd').format(r['date'] as DateTime) ==
              DateFormat('yyyy-MM-dd').format(day),
        orElse: () => {'status': 'none'},
      );
      dailyStatus[day] = record['status'] as String;
    }
    final barsData = <BarChartGroupData>[];
    for (int i = 0; i < last8Days.length; i++) {
      final day = last8Days[i];
      final status = dailyStatus[day] ?? 'none';

      Color barColor;
      double barHeight;

      switch (status) {
        case 'present':
          barColor = Colors.green.shade600;
          barHeight = 1.0;
          break;
        case 'late':
          barColor = Colors.orange.shade600;
          barHeight = 0.7;
          break;
        case 'excused':
          barColor = Colors.blue.shade600;
          barHeight = 0.5;
          break;
        case 'absent':
          barColor = Colors.red.shade600;
          barHeight = 0.3;
          break;
        default:
          barColor = Colors.grey.shade300;
          barHeight = 0.1;
      }

      barsData.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: barHeight,
              width: 30,
              borderRadius: BorderRadius.circular(8),
              color: barColor,
              borderSide: BorderSide(color: Colors.white, width: 1),
            ),
          ],
          showingTooltipIndicators: [1],
        ),
      );
    }

    final xLabels = last8Days.map((d) => '${d.day} ${DateFormat('MMM').format(d)}').toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendance Trend (Last 8 Days)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1.2,
                barGroups: barsData,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= xLabels.length) return const SizedBox();
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            xLabels[index],
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                      reservedSize: 24,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final day = last8Days[group.x.toInt()];
                      final status = dailyStatus[day] ?? 'none';
                      String statusText;
                      switch (status) {
                        case 'present': statusText = 'Present'; break;
                        case 'absent': statusText = 'Absent'; break;
                        case 'late': statusText = 'Late'; break;
                        case 'excused': statusText = 'Excused'; break;
                        default: statusText = 'No Record';
                      }
                      return BarTooltipItem(
                        '${DateFormat('EEE, dd MMM').format(day)}\n$statusText',
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      );
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem('Present', Colors.green.shade600),
              _buildLegendItem('Late', Colors.orange.shade600),
              _buildLegendItem('Excused', Colors.blue.shade600),
              _buildLegendItem('Absent', Colors.red.shade600),
              _buildLegendItem('No Record', Colors.grey.shade300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildAttendanceRow(Map<String, dynamic> record) {
    final date = record['date'] as DateTime;
    final status = record['status'] as String;
    final source = record['source'] as String;
    final time = record['time'] as String?;
    final metadata = record['metadata'] as Map<String, dynamic>?;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case 'present':
        statusColor = Colors.green.shade600;
        statusIcon = Icons.check_circle;
        statusText = 'Present';
        break;
      case 'absent':
        statusColor = Colors.red.shade600;
        statusIcon = Icons.cancel;
        statusText = 'Absent';
        break;
      case 'late':
        statusColor = Colors.orange.shade600;
        statusIcon = Icons.access_time;
        statusText = 'Late';
        break;
      case 'excused':
        statusColor = Colors.blue.shade600;
        statusIcon = Icons.event_available;
        statusText = 'Excused';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusText = 'Unknown';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: statusColor.withOpacity(0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: metadata != null
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Attendance Details'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${DateFormat('dd MMM yyyy').format(date)}'),
                          const SizedBox(height: 8),
                          Text('Status: $statusText'),
                          const SizedBox(height: 8),
                          Text('Reason: ${metadata['leave_reason']}'),
                          if (metadata['approved_by'] != null) ...[
                            const SizedBox(height: 8),
                            Text('Approved by: ${metadata['approved_by']}'),
                          ],
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 65,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('dd').format(date),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                      Text(
                        DateFormat('MMM').format(date).toUpperCase(),
                        style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(statusIcon, size: 22, color: statusColor),
                          const SizedBox(width: 10),
                          Text(
                            statusText,
                            style: TextStyle(fontWeight: FontWeight.w600, color: statusColor, fontSize: 16),
                          ),
                        ],
                      ),
                      if (time != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Time: $time',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                      if (metadata != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          metadata['leave_reason'],
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: source == 'parent' ? Colors.purple.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        source == 'parent' ? 'Parent' : 'School',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: source == 'parent' ? Colors.purple.shade700 : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveRequestCard(Map<String, dynamic> request) {
    final date = request['date'] as DateTime;
    final type = request['type'] as String;
    final reason = request['reason'] as String;
    final status = request['status'] as String;
    final requestedOn = request['requestedOn'] as DateTime;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case 'approved':
        statusColor = Colors.green.shade600;
        statusIcon = Icons.check_circle;
        statusText = 'Approved';
        break;
      case 'rejected':
        statusColor = Colors.red.shade600;
        statusIcon = Icons.cancel;
        statusText = 'Rejected';
        break;
      default:
        statusColor = Colors.orange.shade600;
        statusIcon = Icons.pending;
        statusText = 'Pending';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (type == 'leave' ? Colors.blue : Colors.purple).shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        type == 'leave' ? Icons.event_busy : Icons.work_outline,
                        color: type == 'leave' ? Colors.blue.shade700 : Colors.purple.shade700,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      type == 'leave' ? 'Leave Request' : 'On-Duty Request',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      statusText,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Date: ${DateFormat('dd MMM yyyy').format(date)}',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              'Reason: $reason',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              'Requested on: ${DateFormat('dd MMM yyyy').format(requestedOn)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}