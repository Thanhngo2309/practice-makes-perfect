import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/ReminderData.dart';
import 'package:myapp/model/Reminder.dart';
import 'package:myapp/services/AuthService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ReminderModal.dart'; // Nhập ReminderModal

import '../model/Subject.dart';
import 'SubjectItem.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<Subject, String> subjectImages = {
    Subject.math: 'assets/images/calculator.png',
    Subject.physics: 'assets/images/physic.png',
    Subject.chemistry: 'assets/images/hoahoc.png',
    Subject.biology: 'assets/images/bio.png',
    Subject.literature: 'assets/images/book.png',
    Subject.english: 'assets/images/eng.png',
  };

  User? user = AuthService.currentUser;
  late List<Reminder> reminders = []; // Khởi tạo danh sách reminders

  @override
  void initState() {
    super.initState();
    _updateReminders();
  }

  Future<void> _updateReminders() async {
    List<Reminder> fetchedReminders = await ReminderData().getRemindersByUserId(user?.email ?? '');
    setState(() {
      reminders = fetchedReminders; // Cập nhật danh sách reminders
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EduX',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // profile button
              Row(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/profile");
                    }, 
                    child: const Icon(Icons.person)
                  ),
                  Text("Hồ sơ", style: TextStyle(fontSize: 15),)
                ],
              ),
              SizedBox(width: 10),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Lịch nhắc 🎉"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: reminders.map((reminder) => Text(reminder.title + " " + reminder.time + " " + reminder.date)).toList(),
                            ),
                          );
                        },
                      );
                    }, 
                    icon: Icon(Icons.notifications),
                  ),
                  if (reminders.isNotEmpty) // Kiểm tra nếu reminders không rỗng
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '${reminders.length}', // Hiển thị số lượng reminders
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  user != null ? AuthService.signOut(context) : Navigator.pushNamed(context, "/signin");
                }, 
                child: Text(user != null ? "Đăng xuất" : "Đăng nhập")
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 245, 244, 244)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: subjectImages.length,
            itemBuilder: (context, index) {
              final subject = subjectImages.keys.elementAt(index);
              final iconPath = subjectImages.values.elementAt(index);
              return SubjectItem(subject: subject, iconPath: iconPath);
            },
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, "/chat");
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.chat),
            ),
            const SizedBox(width: 10), 
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReminderModal(
                      onReminderAdded: () {
                        _updateReminders();
                      },
                    );
                  },
                );
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.add_alarm),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed:(){
                launch('https://www.facebook.com/share/g/HFveZDLY8y6mbBGj/');
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.facebook),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}