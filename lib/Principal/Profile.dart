import 'package:flutter/material.dart';
import 'package:school_app/LoginScreen/LoginScreen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// =============== MODELS ===============
class EventItem {
  final String id;
  String title;
  String description;
  DateTime date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String audience;
  bool isHoliday;

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.startTime,
    this.endTime,
    this.audience = 'Everyone',
    this.isHoliday = false,
  });
}

class Announcement {
  final String id;
  String title;
  String message;
  String audience;
  DateTime createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    this.audience = 'Everyone',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

// =============== MAIN PAGE ===============
class PrincipalProfilePage extends StatefulWidget {
  const PrincipalProfilePage({super.key});

  @override
  State<PrincipalProfilePage> createState() => _PrincipalProfilePageState();
}

class _PrincipalProfilePageState extends State<PrincipalProfilePage> with SingleTickerProviderStateMixin {
  // Profile data
  String _principalName = "Dr. Amina Khan";
  String _email = "principal@springfieldschool.edu";
  String _phone = "+1 (555) 123-4567";
  String _schoolName = "Springfield High School";
  String _role = "School Principal";
  String _bio = "Educational leader with 15+ years of experience in K-12 administration.";

  // Preferences
  bool _darkMode = false;
  bool _pushEnabled = true;
  bool _emailEnabled = true;

  // Calendar
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<EventItem>> _events = {};

  // Data
  final List<Announcement> _announcements = [];
  late TabController _tabController;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDay = _focusedDay;
    _addSampleData();
  }

  void _addSampleData() {
    final today = DateTime.now();
    _addEvent(EventItem(
      id: _uuid.v4(),
      title: 'Board Exams Start',
      description: 'Class X & XII board examinations begin.',
      date: today.add(const Duration(days: 3)),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      audience: 'Students',
    ));
    _addEvent(EventItem(
      id: _uuid.v4(),
      title: 'Founders Day (Holiday)',
      description: 'School closed for Founders Day celebrations.',
      date: today.add(const Duration(days: 7)),
      isHoliday: true,
      audience: 'Everyone',
    ));
    _announcements.add(Announcement(
      id: _uuid.v4(),
      title: 'Parent Meeting',
      message: 'A parent-teacher meeting is scheduled next week at 4:00 PM.',
      audience: 'Parents',
    ));
  }

  void _addEvent(EventItem event) {
    final day = DateTime(event.date.year, event.date.month, event.date.day);
    _events.update(day, (list) => list..add(event), ifAbsent: () => [event]);
    setState(() {});
  }

  void _updateEvent(EventItem updated) {
    final day = DateTime(updated.date.year, updated.date.month, updated.date.day);
    if (_events.containsKey(day)) {
      final idx = _events[day]!.indexWhere((e) => e.id == updated.id);
      if (idx >= 0) _events[day]![idx] = updated;
      setState(() {});
    }
  }

  void _removeEvent(EventItem event) {
    final day = DateTime(event.date.year, event.date.month, event.date.day);
    _events[day]?.removeWhere((e) => e.id == event.id);
    if (_events[day]?.isEmpty ?? true) _events.remove(day);
    setState(() {});
  }

  List<EventItem> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalendarTab(),
          _buildAnnouncementsTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(130),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.blue[800], size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _principalName,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _role,
                        style: const TextStyle(color: Color.fromRGBO(187, 222, 251, 1), fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _openEditProfile(context),
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => _showSettingsMenu(context),
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                ),
              ],
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.blue[100],
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Calendar'),
                Tab(text: 'Announcements'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarCard(),
          const SizedBox(height: 20),
          _buildDayEventsCard(),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            TableCalendar<EventItem>(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _getEventsForDay,
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(color: Colors.black87),
                weekendTextStyle: const TextStyle(color: Colors.black54),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Events on ${DateFormat('EEE, MMM d, y').format(_selectedDay ?? _focusedDay)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openCreateEvent(_selectedDay ?? _focusedDay),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Event'),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDayEventsCard() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);
    return events.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.event_available, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text('No events scheduled', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            ),
          )
        : Column(
            children: events.map((e) => _buildEventTile(e)).toList(),
          );
  }

  Widget _buildEventTile(EventItem e) {
    final color = e.isHoliday ? Colors.green.shade600 : const Color(0xFF3B82F6);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 4)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(e.isHoliday ? Icons.celebration : Icons.event, color: color, size: 24),
          ),
          title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (e.startTime != null)
                Text(
                  '${e.startTime!.format(context)}${e.endTime != null ? ' – ${e.endTime!.format(context)}' : ''}',
                  style: const TextStyle(fontSize: 13),
                ),
              Text(e.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  e.audience,
                  style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () => _showEventMenu(e),
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sent Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (_announcements.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text('No announcements yet', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _announcements.length,
                itemBuilder: (context, idx) {
                  final a = _announcements[idx];
                  return _buildAnnouncementCard(a);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement a) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    a.audience,
                    style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(a.message, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 12),
            Text(
              'Sent ${DateFormat('MMM d, h:mm a').format(a.createdAt)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _resendAnnouncement(a),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Resend', style: TextStyle(fontSize: 13)),
                ),
                TextButton.icon(
                  onPressed: () => _openEditAnnouncement(a),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit', style: TextStyle(fontSize: 13)),
                ),
                TextButton.icon(
                  onPressed: () => _confirmDeleteAnnouncement(a),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete', style: TextStyle(fontSize: 13, color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF2563EB),
      foregroundColor: Colors.white,
      onPressed: _onFabPressed,
      icon: const Icon(Icons.add),
      label: Text(_tabController.index == 0 ? 'Event' : 'Announcement'),
    );
  }

  // =============== ACTIONS ===============
  void _onFabPressed() {
    if (_tabController.index == 0) {
      _openCreateEvent(_selectedDay ?? _focusedDay);
    } else {
      _openCreateAnnouncement();
    }
  }

  void _showEventMenu(EventItem e) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
              title: const Text('Edit Event'),
              onTap: () {
                Navigator.pop(context);
                _openEditEvent(e);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Event'),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteEvent(e);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active, color: Color(0xFF3B82F6)),
              title: const Text('Send Notification'),
              onTap: () {
                Navigator.pop(context);
                _sendEventNotification(e);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =============== MODALS & SHEETS ===============
  Future<void> _openCreateEvent(DateTime date) async {
    final result = await showModalBottomSheet<EventItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EventFormSheet(date: date),
    );
    if (result != null) {
      _addEvent(result);
      _showSuccess('Event created successfully!');
    }
  }

  Future<void> _openEditEvent(EventItem event) async {
    final result = await showModalBottomSheet<EventItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EventFormSheet(editEvent: event),
    );
    if (result != null) {
      _updateEvent(result);
      _showSuccess('Event updated!');
    }
  }

  Future<void> _openCreateAnnouncement() async {
    final result = await showModalBottomSheet<Announcement>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AnnouncementFormSheet(),
    );
    if (result != null) {
      setState(() => _announcements.insert(0, result));
      _showSuccess('Announcement published!');
    }
  }

  Future<void> _openEditAnnouncement(Announcement a) async {
    final result = await showModalBottomSheet<Announcement>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AnnouncementFormSheet(editAnnouncement: a),
    );
    if (result != null) {
      setState(() {
        final idx = _announcements.indexWhere((x) => x.id == a.id);
        if (idx >= 0) _announcements[idx] = result;
      });
      _showSuccess('Announcement updated!');
    }
  }

  void _resendAnnouncement(Announcement a) => _showSuccess('Announcement resent to ${a.audience}');
  void _confirmDeleteEvent(EventItem e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeEvent(e);
              _showSuccess('Event deleted');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAnnouncement(Announcement a) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: const Text('Delete this announcement?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _announcements.removeWhere((x) => x.id == a.id));
              _showSuccess('Announcement deleted');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  void _sendEventNotification(EventItem e) => _showSuccess('Notification sent to ${e.audience}');

  // Profile Editing & Settings (Your existing code)
  void _openEditProfile(BuildContext context) {
    final nameController = TextEditingController(text: _principalName);
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);
    final bioController = TextEditingController(text: _bio);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 12),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            const SizedBox(height: 12),
            TextField(controller: bioController, maxLines: 3, decoration: const InputDecoration(labelText: 'Bio / About')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (context.mounted) {
                  setState(() {
                    _principalName = nameController.text;
                    _email = emailController.text;
                    _phone = phoneController.text;
                    _bio = bioController.text;
                  });
                  _showSuccess('Profile updated successfully!');
                }
                nameController.dispose();
                emailController.dispose();
                phoneController.dispose();
                bioController.dispose();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.info_outline), title: const Text('About App'), onTap: () {Navigator.pop(context); _showAboutDialog(context);} ),
            ListTile(leading: const Icon(Icons.security), title: const Text('Security'), subtitle: const Text('Change password, 2FA'), onTap: () {Navigator.pop(context); _showSuccess('Security settings opened');}),
            ListTile(leading: const Icon(Icons.cloud_upload), title: const Text('Sync Now'), subtitle: const Text('Sync events & announcements'), onTap: () {Navigator.pop(context); _showSuccess('Sync complete (mock)');}),
            const Divider(),
            ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Sign Out', style: TextStyle(color: Colors.red)), onTap: () {Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Loginscreen()),
              (route) => false,      // ⬅ Clears entire navigation stack
              );
            }),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SchoolSync Admin'),
        content: const Text('Version 2.1.0\n\nA comprehensive school management platform for principals, teachers, and staff.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  void _showSuccess(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
      );
    }
  }
}

// =============== FORM SHEETS (Your existing logic, unchanged but working) ===============
// Keep your _EventFormSheet and _AnnouncementFormSheet classes as-is below
// They already work perfectly with the premium UI

class _EventFormSheet extends StatefulWidget {
  final DateTime? date;
  final EventItem? editEvent;
  const _EventFormSheet({this.date, this.editEvent});

  @override
  State<_EventFormSheet> createState() => _EventFormSheetState();
}

class _EventFormSheetState extends State<_EventFormSheet> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late DateTime _date;
  TimeOfDay? _start;
  TimeOfDay? _end;
  String _audience = 'Everyone';
  bool _isHoliday = false;

  @override
  void initState() {
    super.initState();
    final e = widget.editEvent;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    _date = e?.date ?? widget.date ?? DateTime.now();
    _start = e?.startTime;
    _end = e?.endTime;
    _audience = e?.audience ?? 'Everyone';
    _isHoliday = e?.isHoliday ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.editEvent == null ? 'Create Event' : 'Edit Event', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 8),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(DateFormat('EEE, MMM d, y').format(_date)),
              trailing: IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate),
            ),
            Row(children: [
              Expanded(child: ListTile(contentPadding: EdgeInsets.zero, title: const Text('Start'), subtitle: Text(_start?.format(context) ?? '--'), trailing: IconButton(icon: const Icon(Icons.access_time), onPressed: _pickStart),)),
              Expanded(child: ListTile(contentPadding: EdgeInsets.zero, title: const Text('End'), subtitle: Text(_end?.format(context) ?? '--'), trailing: IconButton(icon: const Icon(Icons.access_time), onPressed: _pickEnd),)),
            ]),
            DropdownButtonFormField<String>(
              value: _audience,
              items: const ["Everyone", "Students", "Teachers", "Parents"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _audience = v ?? 'Everyone'),
              decoration: const InputDecoration(labelText: 'Audience'),
            ),
            SwitchListTile.adaptive(title: const Text('Mark as Holiday'), value: _isHoliday, onChanged: (v) => setState(() => _isHoliday = v)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () => _save(), child: const Text('Save')),
            ])
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final res = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (res != null) setState(() => _date = res);
  }

  Future<void> _pickStart() async {
    final res = await showTimePicker(context: context, initialTime: _start ?? const TimeOfDay(hour: 9, minute: 0));
    if (res != null) setState(() => _start = res);
  }

  Future<void> _pickEnd() async {
    final res = await showTimePicker(context: context, initialTime: _end ?? const TimeOfDay(hour: 10, minute: 0));
    if (res != null) setState(() => _end = res);
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title required')));
      return;
    }

    final id = widget.editEvent?.id ?? const Uuid().v4();
    final ev = EventItem(
      id: id,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      date: _date,
      startTime: _start,
      endTime: _end,
      audience: _audience,
      isHoliday: _isHoliday,
    );

    Navigator.pop(context, ev);
  }
}

class _AnnouncementFormSheet extends StatefulWidget {
  final Announcement? editAnnouncement;
  const _AnnouncementFormSheet({this.editAnnouncement});

  @override
  State<_AnnouncementFormSheet> createState() => _AnnouncementFormSheetState();
}

class _AnnouncementFormSheetState extends State<_AnnouncementFormSheet> {
  late TextEditingController _titleCtrl;
  late TextEditingController _msgCtrl;
  String _audience = 'Everyone';

  @override
  void initState() {
    super.initState();
    final a = widget.editAnnouncement;
    _titleCtrl = TextEditingController(text: a?.title ?? '');
    _msgCtrl = TextEditingController(text: a?.message ?? '');
    _audience = a?.audience ?? 'Everyone';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(widget.editAnnouncement == null ? 'Create Announcement' : 'Edit Announcement', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
        const SizedBox(height: 8),
        TextField(controller: _msgCtrl, decoration: const InputDecoration(labelText: 'Message'), maxLines: 4),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(value: _audience, items: const ["Everyone", "Students", "Teachers", "Parents"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => _audience = v ?? 'Everyone'), decoration: const InputDecoration(labelText: 'Audience')),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))), const SizedBox(width: 8), ElevatedButton(onPressed: _save, child: const Text('Publish'))])
      ]),
    );
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty || _msgCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title and message are required')));
      return;
    }

    final a = Announcement(id: const Uuid().v4(), title: _titleCtrl.text.trim(), message: _msgCtrl.text.trim(), audience: _audience);
    Navigator.pop(context, a);
  }
}