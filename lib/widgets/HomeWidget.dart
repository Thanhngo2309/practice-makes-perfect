// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/service/AuthService.dart';

import '../model/Subject.dart';
import 'SubjectItem.dart';

class HomeScreen extends StatelessWidget {
  // final List<Subject> subjects = [
  //   Subject(Subject.MATH, 'assets/images/calculator.png', ''),
  //   Subject(Subject.PHYSICS, 'assets/images/physic.png', ''),
  //   Subject(SubjectType.CHEMISTRY, 'assets/images/hoahoc.png', ''),
  //   Subject(SubjectType.BIOLOGY, 'assets/images/bio.png', ''),
  //   Subject(SubjectType.LITERATURE, 'assets/images/book.png', ''),
  //   Subject(SubjectType.ENGLISH, 'assets/images/eng.png', ''),
  // ];

  Map<Subject, String> subjectImages = {
    Subject.math: 'assets/images/calculator.png',
    Subject.physics: 'assets/images/physic.png',
    Subject.chemistry: 'assets/images/hoahoc.png',
    Subject.biology: 'assets/images/bio.png',
    Subject.literature: 'assets/images/book.png',
    Subject.english: 'assets/images/eng.png',
  };

  User? user = AuthService.currentUser;

  HomeScreen({super.key});

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
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/chat");
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.chat),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
