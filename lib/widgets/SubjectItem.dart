import 'package:flutter/material.dart';
import '../model/Subject.dart';
import 'ExamScreenWidget.dart';

class SubjectItem extends StatelessWidget {
  final Subject subject;
  final String iconPath;

  const SubjectItem({super.key, required this.subject, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: GestureDetector(
      onTap: () {
        print("You clicked on ${subject.name}");

        Navigator.pushNamed(context, ExamScreenWidget.routeName,
            arguments: subject);
      },
      child: Container(decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 50,
            height: 50,
          ),
          const SizedBox(height: 8),
          Text(
            subject.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),),
    ),
    );
  }
}
