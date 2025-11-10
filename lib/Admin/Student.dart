import 'package:flutter/material.dart';

class AdminTeacherManager extends StatefulWidget {
  @override
  _AdminTeacherManagerState createState() => _AdminTeacherManagerState();
}

class _AdminTeacherManagerState extends State<AdminTeacherManager> {
  TextEditingController searchController = TextEditingController();
  String selectedFilter = "All";
  String selectedStatus = "All";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6E8AFA),
          elevation: 0,
          title: Text(
            "Student & Teacher Manager",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Students"),
              Tab(text: "Teachers"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (DefaultTabController.of(context).index == 0) {
              _showAddEditDialog(isStudent: true);
            } else {
              _showAddEditDialog(isStudent: false);
            }
          },
          backgroundColor: Color(0xFF6E8AFA),
          child: Icon(Icons.add, color: Colors.white),
        ),
        body: TabBarView(
          children: [
            _buildTable(isStudent: true),
            _buildTable(isStudent: false),
          ],
        ),
      ),
    );
  }

  // ******************************************************
  // TABLE + SEARCH + FILTER
  // ******************************************************
  Widget _buildTable({required bool isStudent}) {
    List<dynamic> list = isStudent ? sampleStudents : sampleTeachers;

    List<dynamic> filteredList = list.where((item) {
      bool matchesSearch = item.name.toLowerCase().contains(searchController.text.toLowerCase());
      bool matchesFilter = selectedFilter == "All" ||
          (isStudent ? item.classSection : item.department) == selectedFilter;
      bool matchesStatus = selectedStatus == "All" || item.status == selectedStatus;
      return matchesSearch && matchesFilter && matchesStatus;
    }).toList();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(),
          SizedBox(height: 10),
          _buildFilterRow(isStudent),
          SizedBox(height: 10),

          Expanded(
  child: filteredList.isEmpty
      ? Center(child: Text("No data found"))
      : ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final item = filteredList[index];

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAME
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: item.status == "Active"
                                ? Color(0xFF4ECDC4)
                                : Color(0xFFFF6B6B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.status,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isStudent
                          ? "Class : ${item.classSection}"
                          : "Department : ${item.department}",
                      style: TextStyle(fontSize: 15),
                    ),

                    SizedBox(height: 4),

                    // PHONE
                    Text(
                      "Phone : ${item.phone}",
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showAddEditDialog(
                              isStudent: isStudent, data: item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteItem(item, isStudent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
)

        ],
      ),
    );
  }
  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: "Search by name...",
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.search, color: Color(0xFF6E8AFA)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
  Widget _buildFilterRow(bool isStudent) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            decoration: _dropdownDecoration(),
            value: "All",
            items: (isStudent
                    ? ["All", "9-A", "10-A", "11-B", "12-C"]
                    : ["All", "Math", "Science", "English"])
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => setState(() => selectedFilter = value.toString()),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField(
            decoration: _dropdownDecoration(),
            value: "All",
            items: ["All", "Active", "Inactive"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => setState(() => selectedStatus = value.toString()),
          ),
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration() => InputDecoration(
      filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)));

  void _showAddEditDialog({required bool isStudent, dynamic data}) {
    TextEditingController name = TextEditingController(text: data?.name);
    TextEditingController classOrDept =
        TextEditingController(text: isStudent ? data?.classSection : data?.department);
    TextEditingController phone = TextEditingController(text: data?.phone);
    String status = data?.status ?? "Active";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data == null ? "Add New ${isStudent ? "Student" : "Teacher"}" : "Edit Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _txtField(name, "Name"),
              SizedBox(height: 10),
              _txtField(classOrDept, isStudent ? "Class" : "Department"),
              SizedBox(height: 10),
              _txtField(phone, "Phone"),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: status,
                items: ["Active", "Inactive"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => status = value.toString(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6E8AFA)),
              onPressed: () {
                if (data == null) {
                  setState(() {
                    if (isStudent) {
                      sampleStudents.add(Student(name: name.text, classSection: classOrDept.text, phone: phone.text, status: status));
                    } else {
                      sampleTeachers.add(
                          Teacher(name: name.text, department: classOrDept.text, phone: phone.text, status: status));
                    }
                  });
                } else {
                  setState(() {
                    data.name = name.text;
                    data.phone = phone.text;
                    isStudent ? data.classSection = classOrDept.text : data.department = classOrDept.text;
                    data.status = status;
                  });
                }
                Navigator.pop(context);
              },
              child: Text(data == null ? "Add" : "Save"),
            )
          ],
        );
      },
    );
  }

  Widget _txtField(TextEditingController controller, String hint) => TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      );
  _deleteItem(dynamic item, bool isStudent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete?"),
        content: Text("Are you sure you want to delete ${item.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isStudent ? sampleStudents.remove(item) : sampleTeachers.remove(item);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Delete"),
          )
        ],
      ),
    );
  }
}

class Student {
  String name;
  String classSection;
  String phone;
  String status;
  Student({required this.name, required this.classSection, required this.phone, required this.status});
}

class Teacher {
  String name;
  String department;
  String phone;
  String status;
  Teacher({required this.name, required this.department, required this.phone, required this.status});
}

List<Student> sampleStudents = [
  Student(name: "John", classSection: "10-A", phone: "+1 555-0123", status: "Active"),
  Student(name: "Robert", classSection: "12-C", phone: "+1 555-0125", status: "Inactive"),
];

List<Teacher> sampleTeachers = [
  Teacher(name: "Dr. Sarah", department: "Math", phone: "+1 555-0201", status: "Active"),
  Teacher(name: "Ms. Linda", department: "English", phone: "+1 555-0203", status: "Inactive"),
];
