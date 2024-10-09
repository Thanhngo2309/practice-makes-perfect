import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/application-service/SharedPrefs.dart';
import 'package:myapp/model/Reminder.dart';

class ReminderData{


  static final ReminderData _instance = ReminderData._internal();

  factory ReminderData() {
    return _instance;
  }

  ReminderData._internal();

  Future<void> addReminder(Reminder reminder) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('reminders').add({
      'title': reminder.title,
      'time': reminder.time,
      'userId': reminder.userId,
      'date': reminder.date,
    });
    SharedPrefs.saveReminder(reminder);
  }
  Future<List<Reminder>> getRemindersByUserId(String userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection('reminders').where('userId', isEqualTo: userId).get();
    List<Reminder> remindersFromFirestore = querySnapshot.docs.map((doc){
      final data = doc.data() as Map<String, dynamic>;
      return Reminder(title: data['title'], time: data['time'], userId: data['userId'], date: data['date']);
    }).toList();
    return remindersFromFirestore;
  }
}