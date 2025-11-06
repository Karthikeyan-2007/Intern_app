import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EventFundManager extends StatefulWidget {
  @override
  _EventFundManagerState createState() => _EventFundManagerState();
}

class _EventFundManagerState extends State<EventFundManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6E8AFA),
        elevation: 0,
        title: Text(
          "Event & Fund Allocation",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Summary Cards
              _buildSummaryCards(),
              SizedBox(height: 24),
              
              // Pie Chart
              _buildPieChart(),
              SizedBox(height: 24),
              
              // Create Event Button
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showCreateEventSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6E8AFA),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    "Create New Event",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Events List
              _buildEventsList(),
              SizedBox(height: 24),
              
              // Expense Timeline
              _buildExpenseTimeline(),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showAddExpenseSheet,
            backgroundColor: Color(0xFFFF6B6B),
            mini: true,
            child: Icon(Icons.add, color: Colors.white),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: _showFundAllocationSheet,
            backgroundColor: Color(0xFF4ECDC4),
            mini: true,
            child: Icon(Icons.money, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      height: 120,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
        children: [
          _buildSummaryCard("Total Events", sampleEvents.length.toString(), Color(0xFF6E8AFA)),
          _buildSummaryCard("Remaining Balance", "\$${totalRemainingBalance.toStringAsFixed(2)}", Color(0xFF4ECDC4)),
          _buildSummaryCard("Total Allocated", "\$${totalAllocatedAmount.toStringAsFixed(2)}", Color(0xFFFFA07A)),
          _buildSummaryCard("Total Spent", "\$${totalSpentAmount.toStringAsFixed(2)}", Color(0xFFFF6B6B)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      height: 250,
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
          children: [
            Text(
              "Fund Utilization",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: totalEventsSpent,
                      color: Color(0xFF6E8AFA),
                      title: "Events",
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: totalBusExpenses,
                      color: Color(0xFFFFA07A),
                      title: "Bus",
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: totalSalaryExpenses,
                      color: Color(0xFF4ECDC4),
                      title: "Salary",
                      radius: 60,
                    ),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return Container(
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
              "Recent Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...sampleEvents.map((event) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: EdgeInsets.all(8),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF6E8AFA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.event, color: Color(0xFF6E8AFA)),
                ),
                title: Text(event.name),
                subtitle: Text("${event.date} • Allocated: \$${event.budget.toStringAsFixed(2)}"),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF4ECDC4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "\$${event.spent.toStringAsFixed(2)} spent",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseTimeline() {
    return Container(
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
              "Recent Expenses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...sampleExpenses.map((expense) => Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getExpenseColor(expense.type),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getExpenseIcon(expense.type),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.description,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${expense.date} • ${expense.eventName}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "-\$${expense.amount.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Color _getExpenseColor(String type) {
    switch (type) {
      case 'event': return Color(0xFF6E8AFA);
      case 'bus': return Color(0xFFFFA07A);
      case 'salary': return Color(0xFF4ECDC4);
      default: return Colors.grey;
    }
  }

  IconData _getExpenseIcon(String type) {
    switch (type) {
      case 'event': return Icons.event;
      case 'bus': return Icons.directions_bus;
      case 'salary': return Icons.payments;
      default: return Icons.monetization_on;
    }
  }

  void _showCreateEventSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Text(
                "Create New Event",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Event Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Budget Amount",
                  prefixText: "\$",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Event Date",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Create event logic
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6E8AFA),
                      ),
                      child: Text("Create Event", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddExpenseSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Text(
                "Add New Expense",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Expense Type",
                  border: OutlineInputBorder(),
                ),
                items: ["event", "bus", "salary"]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Event",
                  border: OutlineInputBorder(),
                ),
                items: sampleEvents
                    .map((event) => DropdownMenuItem(
                          value: event.name,
                          child: Text(event.name),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Expense Amount",
                  prefixText: "\$",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add expense logic
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6E8AFA),
                      ),
                      child: Text("Add Expense", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFundAllocationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Fund Allocation Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.event, color: Color(0xFF6E8AFA)),
              title: Text("Events"),
              trailing: Text("\$${totalEventsSpent.toStringAsFixed(2)}"),
            ),
            ListTile(
              leading: Icon(Icons.directions_bus, color: Color(0xFFFFA07A)),
              title: Text("Bus Expenses"),
              trailing: Text("\$${totalBusExpenses.toStringAsFixed(2)}"),
            ),
            ListTile(
              leading: Icon(Icons.payments, color: Color(0xFF4ECDC4)),
              title: Text("Salary Expenses"),
              trailing: Text("\$${totalSalaryExpenses.toStringAsFixed(2)}"),
            ),
            Divider(),
            ListTile(
              title: Text("Total Expenses", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(
                "\$${(totalEventsSpent + totalBusExpenses + totalSalaryExpenses).toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models
class Event {
  String name;
  DateTime date;
  double budget;
  double spent;
  String description;

  Event({
    required this.name,
    required this.date,
    required this.budget,
    required this.spent,
    required this.description,
  });
}

class Expense {
  String eventName;
  String description;
  double amount;
  String type;
  String date;

  Expense({
    required this.eventName,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
  });
}

// Sample Data
List<Event> sampleEvents = [
  Event(
    name: "Annual Day",
    date: DateTime.now(),
    budget: 15000.0,
    spent: 12500.0,
    description: "Annual cultural event for all students",
  ),
  Event(
    name: "Sports Day",
    date: DateTime.now().add(Duration(days: 10)),
    budget: 8000.0,
    spent: 6500.0,
    description: "Annual sports competition",
  ),
  Event(
    name: "Science Fair",
    date: DateTime.now().add(Duration(days: 20)),
    budget: 5000.0,
    spent: 3200.0,
    description: "Student science project exhibition",
  ),
];

List<Expense> sampleExpenses = [
  Expense(
    eventName: "Annual Day",
    description: "Stage decoration",
    amount: 2500.0,
    type: "event",
    date: "Nov 1, 2025",
  ),
  Expense(
    eventName: "Annual Day",
    description: "Bus rental for event",
    amount: 1200.0,
    type: "bus",
    date: "Oct 30, 2025",
  ),
  Expense(
    eventName: "Sports Day",
    description: "Trophy & medals",
    amount: 800.0,
    type: "event",
    date: "Oct 25, 2025",
  ),
  Expense(
    eventName: "Science Fair",
    description: "Materials for experiments",
    amount: 600.0,
    type: "event",
    date: "Oct 20, 2025",
  ),
];

double totalAllocatedAmount = sampleEvents.fold(0, (sum, event) => sum + event.budget);
double totalSpentAmount = sampleEvents.fold(0, (sum, event) => sum + event.spent);
double totalRemainingBalance = totalAllocatedAmount - totalSpentAmount;
double totalEventsSpent = sampleExpenses.where((e) => e.type == 'event').fold(0, (sum, e) => sum + e.amount);
double totalBusExpenses = sampleExpenses.where((e) => e.type == 'bus').fold(0, (sum, e) => sum + e.amount);
double totalSalaryExpenses = sampleExpenses.where((e) => e.type == 'salary').fold(0, (sum, e) => sum + e.amount);