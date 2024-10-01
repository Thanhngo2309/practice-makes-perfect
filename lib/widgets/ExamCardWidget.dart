import 'package:flutter/material.dart';
import 'package:myapp/model/dto/ExamResponse.dart';

import '../model/Exam.dart';
import 'QuestionListWidget.dart';

class ExamCardWidget extends StatelessWidget {
  final ExamResponse exam;

  const ExamCardWidget({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionListWidget(
              exam.examId,
              exam.duration,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.name,
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDetailItem(Icons.timer, '${exam.duration} phút'),
                const SizedBox(width: 16),
                _buildDetailItem(Icons.question_answer, '30 câu'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }
}
