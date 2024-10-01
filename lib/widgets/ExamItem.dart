import 'package:flutter/material.dart';
import 'package:myapp/application-service/FavoriteFeature.dart';
import 'package:myapp/model/dto/ExamResponse.dart';

import '../application-service/SharedPrefs.dart';
import '../model/Exam.dart';

class ExamItem extends StatefulWidget {
  final String? subject;
  final ExamResponse exam;
  final bool withHeartIcon;

  const ExamItem({
    super.key,
    required this.exam,
    required this.withHeartIcon,
    this.subject
  });

  @override
  State<ExamItem> createState() => ExamItemState();
}

class ExamItemState extends State<ExamItem> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    bool exists = await Favoritefeature.checkExamExist(widget.subject!, widget.exam.examId);
    setState(() {
      isFavorite = exists; // Cập nhật isFavorite sau khi có kết quả
    });
  }

  Future<void> toogleFavorite() async {
    await Favoritefeature.addOrRemoveExam(widget.subject!, widget.exam.examId);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.exam.name),
        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.purple,),
            const SizedBox(width: 4),
            Text('${widget.exam.duration ~/ 60} phút', style: const TextStyle(color: Colors.purple),),
            const SizedBox(width: 10),
            const Icon(Icons.question_answer, size: 16, color: Colors.purple,),
            const SizedBox(width: 4),
            Text('${widget.exam.numberOfQuestions} câu', style: const TextStyle(color: Colors.purple),),
            const SizedBox(width: 10),
            const Icon(Icons.star, size: 16, color: Colors.purple,),
            const SizedBox(width: 4),
            Text(widget.exam.subject.name,  style: const TextStyle(color: Colors.purple),),
            const SizedBox(width: 10),
            widget.withHeartIcon
                ? GestureDetector(
                    onTap: toogleFavorite,
                    child: Icon(
                      Icons.favorite,
                      size: 16,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  )
                : const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
