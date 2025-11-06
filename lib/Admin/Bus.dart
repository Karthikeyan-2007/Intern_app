import 'package:flutter/material.dart';

class BusTransportManagement extends StatefulWidget {
  @override
  _BusTransportManagementState createState() => _BusTransportManagementState();
}

class _BusTransportManagementState extends State<BusTransportManagement> {
  String _searchQuery = "";
  String _statusFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6E8AFA),
        elevation: 0,
        title: Text(
          "Bus & Transport Management",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Stats Summary Cards
              _buildStatsSummary(),
              SizedBox(height: 24),
              
              // Search and Filter Row
              _buildSearchFilterRow(),
              SizedBox(height: 24),
              
              // Expense Alert Banner
              if (_expenseThisMonth > 8000.0) // Monthly budget threshold
                _buildExpenseAlertBanner(),
              
              SizedBox(height: 16),
              
              // Buses List
              _buildBusesList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseSheet,
        backgroundColor: Color(0xFFFF6B6B),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Container(
      height: 120,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
        children: [
          _buildStatCard("Total Buses", "5", Color(0xFF6E8AFA)),
          _buildStatCard("Active Routes", "3", Color(0xFF4ECDC4)),
          _buildStatCard("Expense This Month", "\$9,200", Color(0xFFFF6B6B)),
          _buildStatCard("Fuel Used", "\$6,500", Color(0xFFFFA07A)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
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

  Widget _buildSearchFilterRow() {
    return Container(
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search buses...",
                prefixIcon: Icon(Icons.search, color: Color(0xFF6E8AFA)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Container(
            width: 120,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              underline: SizedBox(),
              value: _statusFilter,
              items: ["All", "Active", "Maintenance", "Inactive"]
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 14)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _statusFilter = value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseAlertBanner() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFFFF5F5),
        border: Border.all(color: Color(0xFFFF6B6B), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Color(0xFFFF6B6B)),
          SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Budget Alert: ",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B6B)),
                  ),
                  TextSpan(
                    text: "Monthly transport expenses (\$9,200) exceeded the budget limit of \$8,000.",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusesList() {
    List<Bus> filteredBuses = sampleBuses
        .where((bus) => 
          (_searchQuery.isEmpty || 
            bus.number.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            bus.driver.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            bus.route.toLowerCase().contains(_searchQuery.toLowerCase())
          ) &&
          (_statusFilter == "All" || bus.status == _statusFilter)
        )
        .toList();

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
              "School Buses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...filteredBuses.map((bus) => Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50]!.withOpacity(0.5),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: bus.status == "Active" 
                          ? Color(0xFF4ECDC4).withOpacity(0.1)
                          : bus.status == "Maintenance"
                              ? Color(0xFFFFA07A).withOpacity(0.1)
                              : Color(0xFFFF6B6B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      bus.status == "Active" ? Icons.directions_bus : Icons.build,
                      color: bus.status == "Active" 
                          ? Color(0xFF4ECDC4)
                          : bus.status == "Maintenance"
                              ? Color(0xFFFFA07A)
                              : Color(0xFFFF6B6B),
                    ),
                  ),
                  title: Text(bus.number, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Route: ${bus.route}"),
                      Text("Driver: ${bus.driver}"),
                      Text("Students: ${bus.students}"),
                    ],
                  ),
                  trailing: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: bus.status == "Active"
                                ? Color(0xFF4ECDC4)
                                : bus.status == "Maintenance"
                                    ? Color(0xFFFFA07A)
                                    : Color(0xFFFF6B6B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            bus.status,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _showBusExpenses(bus),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6E8AFA).withOpacity(0.1),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Expenses",
                            style: TextStyle(color: Color(0xFF6E8AFA), fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ),
            )).toList(),
          ],
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
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.6,
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
                  labelText: "Bus Number",
                  border: OutlineInputBorder(),
                ),
                items: sampleBuses
                    .map((bus) => DropdownMenuItem(
                          value: bus.number,
                          child: Text(bus.number),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Expense Type",
                  border: OutlineInputBorder(),
                ),
                items: ["diesel", "maintenance", "insurance", "other"]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Amount",
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
                        backgroundColor: Color(0xFFFF6B6B),
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

  void _showBusExpenses(Bus bus) {
    List<Expense> busExpenses = sampleExpenses.where((exp) => exp.bus == bus.number).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Expenses for ${bus.number}"),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...busExpenses.map((expense) => ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _getExpenseTypeColor(expense.type),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_getExpenseTypeIcon(expense.type), size: 16, color: Colors.white),
                ),
                title: Text(expense.type.toUpperCase()),
                subtitle: Text(expense.date),
                trailing: Text("\$${expense.amount.toStringAsFixed(2)}"),
              )).toList(),
              if (busExpenses.isEmpty) ...[
                Text("No expenses recorded for this bus"),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  Color _getExpenseTypeColor(String type) {
    switch (type) {
      case 'diesel': return Color(0xFFFFA07A);
      case 'maintenance': return Color(0xFF6E8AFA);
      case 'insurance': return Color(0xFF4ECDC4);
      default: return Colors.grey;
    }
  }

  IconData _getExpenseTypeIcon(String type) {
    switch (type) {
      case 'diesel': return Icons.local_gas_station;
      case 'maintenance': return Icons.build;
      case 'insurance': return Icons.description;
      default: return Icons.monetization_on;
    }
  }
}

// Data Models
class Bus {
  String number;
  String route;
  String driver;
  int students;
  String status;

  Bus({
    required this.number,
    required this.route,
    required this.driver,
    required this.students,
    required this.status,
  });
}

class Expense {
  String type;
  double amount;
  String date;
  String bus;

  Expense({
    required this.type,
    required this.amount,
    required this.date,
    required this.bus,
  });
}

// Sample Data
List<Bus> sampleBuses = [
  Bus(number: "BUS-001", route: "North Zone", driver: "John Smith", students: 42, status: "Active"),
  Bus(number: "BUS-002", route: "South Zone", driver: "Robert Johnson", students: 38, status: "Active"),
  Bus(number: "BUS-003", route: "East Zone", driver: "Michael Davis", students: 45, status: "Maintenance"),
  Bus(number: "BUS-004", route: "West Zone", driver: "David Wilson", students: 40, status: "Active"),
  Bus(number: "BUS-005", route: "Central Zone", driver: "James Brown", students: 35, status: "Inactive"),
];

List<Expense> sampleExpenses = [
  Expense(type: "diesel", amount: 2450.0, date: "2025-11-01", bus: "BUS-001"),
  Expense(type: "maintenance", amount: 850.0, date: "2025-11-02", bus: "BUS-003"),
  Expense(type: "insurance", amount: 1200.0, date: "2025-11-03", bus: "BUS-002"),
  Expense(type: "diesel", amount: 2100.0, date: "2025-11-04", bus: "BUS-004"),
  Expense(type: "maintenance", amount: 650.0, date: "2025-11-05", bus: "BUS-001"),
  Expense(type: "diesel", amount: 1950.0, date: "2025-11-06", bus: "BUS-005"),
];
final double _expenseThisMonth = 9200.0;