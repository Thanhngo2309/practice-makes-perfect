import 'package:flutter/material.dart';
import 'package:myapp/data/ReminderData.dart';
import 'package:myapp/model/Reminder.dart';
import 'package:myapp/services/AuthService.dart';

class ReminderModal extends StatefulWidget {
  final Function onReminderAdded; // Callback để thông báo khi thêm reminder

  ReminderModal({required this.onReminderAdded});

  @override
  _ReminderModalState createState() => _ReminderModalState();
}

class _ReminderModalState extends State<ReminderModal> {
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitReminder() {
    final String title = _titleController.text;
    final String time = _selectedTime.format(context);
    final String date = "${_selectedDate.toLocal()}".split(' ')[0];
    Reminder reminder = Reminder(title: title, time: time, userId: AuthService.currentUser!.email ?? '', date: date);
    ReminderData().addReminder(reminder);  
    widget.onReminderAdded();  
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Reminder'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Reminder Title'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time: ${_selectedTime.format(context)}"),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Select Time'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date: ${_selectedDate.toLocal()}".split(' ')[0]),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Submit'),
          onPressed: _submitReminder,
        ),
      ],
    );
  }
}