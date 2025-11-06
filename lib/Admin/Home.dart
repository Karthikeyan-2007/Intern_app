import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE6F0FF), Color(0xFFFAFAFF)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        child: Icon(Icons.school, color: Color(0xFF6E8AFA)),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Admin Dashboard",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Springfield High School",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Stats Cards
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildStatCard(
                        title: "Total Students",
                        value: "1,248",
                        icon: Icons.people,
                        color: Color(0xFF6E8AFA),
                      ),
                      _buildStatCard(
                        title: "Active Teachers",
                        value: "42",
                        icon: Icons.school,
                        color: Color(0xFF4ECDC4),
                      ),
                      _buildStatCard(
                        title: "Pending Fees",
                        value: "\$12,450",
                        subtitle: "48 Students",
                        icon: Icons.money,
                        color: Color(0xFFFF6B6B),
                      ),
                      _buildStatCard(
                        title: "Monthly Expenses",
                        value: "\$24,890",
                        subtitle: "Event: \$3,200 | Bus: \$1,800 | Salary: \$19,890",
                        icon: Icons.account_balance_wallet,
                        color: Color(0xFFFFA07A),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // ✅ Alerts / Notifications Card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Important Alerts",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),

                          _buildAlert(
                            icon: Icons.warning_amber_rounded,
                            text: "48 Students have pending fees",
                            color: Colors.redAccent,
                          ),
                          _buildAlert(
                            icon: Icons.money_off_csred_outlined,
                            text: "Annual Event exceeded budget by ₹8,200",
                            color: Colors.orange,
                          ),
                          _buildAlert(
                            icon: Icons.bus_alert,
                            text: "Bus maintenance cost crossed monthly threshold",
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // ✅ Recent Login Sessions
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recent Login Sessions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12),

                          _buildLoginHistory("Windows", "11:23 PM • 05 Nov"),
                          _buildLoginHistory("Android • App", "6:15 PM • 05 Nov"),
                          _buildLoginHistory("Chrome Browser", "2:40 PM • 05 Nov"),
                        ],
                      ),
                    ),
                  ),

                  
                  SizedBox(height: 24),
                  
                  // Chart Card
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Revenue vs Expenses",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Last 6 months",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 22,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                        List<String> months = ["Jun", "Jul", "Aug", "Sep", "Oct", "Nov"];
                                        return Text(months[value.toInt()]);
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: true),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(0, 12),
                                      FlSpot(1, 15),
                                      FlSpot(2, 18),
                                      FlSpot(3, 14),
                                      FlSpot(4, 19),
                                      FlSpot(5, 22),
                                    ],
                                    isCurved: true,
                                    color: Color(0xFF6E8AFA),
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Color(0xFF6E8AFA).withOpacity(0.1),
                                    ),
                                  ),
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(0, 8),
                                      FlSpot(1, 10),
                                      FlSpot(2, 12),
                                      FlSpot(3, 14),
                                      FlSpot(4, 16),
                                      FlSpot(5, 18),
                                    ],
                                    isCurved: true,
                                    color: Color(0xFFFF6B6B),
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Color(0xFFFF6B6B).withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Timeline Card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recent Activities",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildTimelineItem(
                            icon: Icons.receipt,
                            title: "Receipt Generated",
                            subtitle: "For student ID: 2025-0456",
                            time: "2 hours ago",
                            color: Color(0xFF4ECDC4),
                          ),
                          _buildTimelineItem(
                            icon: Icons.payment,
                            title: "Salaries Paid",
                            subtitle: "October salaries for 42 teachers",
                            time: "Yesterday",
                            color: Color(0xFF6E8AFA),
                          ),
                          _buildTimelineItem(
                            icon: Icons.event,
                            title: "Event Expenses",
                            subtitle: "Annual Day preparation costs",
                            time: "Oct 28, 2025",
                            color: Color(0xFFFFA07A),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, String? subtitle, required IconData icon, required Color color}) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color.withOpacity(0.1),
                  ),
                  child: Icon(icon, color: color),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({required IconData icon, required String title, required String subtitle, required String time, required Color color}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickAction(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        width: 120,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Color(0xFF6E8AFA)),
            SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildAlert({required IconData icon, required String text, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginHistory(String device, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.device_hub, color: Colors.grey[700]),
          SizedBox(width: 10),
          Text(device, style: TextStyle(fontSize: 14)),
          Spacer(),
          Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

}