import 'package:flutter/material.dart';
import 'package:myapp/model/dto/ExamResponse.dart';
import 'ExamItem.dart';
import 'QuestionListWidget.dart';

class ExamList extends StatelessWidget {
  final List<ExamResponse> examsByObject;
  final String subjectName;
  const ExamList({super.key, required this.examsByObject, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    print("ExamList : $examsByObject size " + examsByObject.length.toString());
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemCount: examsByObject.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionListWidget(
                          examsByObject[index].examId,
                          examsByObject[index].duration,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ExamItem(
                      subject: subjectName,
                      exam: examsByObject[index],
                      withHeartIcon: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
