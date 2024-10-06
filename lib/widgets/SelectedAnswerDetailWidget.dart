import 'package:flutter/material.dart';
import 'package:myapp/model/dto/QuestionResponse.dart';

import '../model/Answer.dart';
import '../model/SelectedAnswer.dart';
import 'ChatWidget.dart';

class SelectedAnswerDetailWidget extends StatelessWidget {
  final SelectedAnswer selectedAnswer;
  final QuestionResponse question;
  final Answer answer;

  const SelectedAnswerDetailWidget(this.selectedAnswer, this.question, this.answer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quay lại", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {
              // Thêm chức năng yêu thích tại đây
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị câu hỏi
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            // Hiển thị các lựa chọn
             Column(
                children: question.choices.map((choice) {
                  final bool isCorrect = choice.label == answer.correctAnswer;
                  final bool isSelectedWrong =
                      selectedAnswer.selectedAnswer == choice.label && !isCorrect;

                  return Container (
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                          color: (!isCorrect ? Colors.transparent : Colors.teal),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (!isCorrect ? Colors.black : Colors.teal),
                            width: 1, 
                          ),
                        ),
                        
                        child: Center(
                          child: Text(
                            choice.label,
                            style: TextStyle(
                              fontSize: 16,
                              color: isCorrect
                            ? Colors.white 
                           : (isSelectedWrong ? Colors.red : Colors.black),
                            )
                          ),
                        ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: Text(
                            choice.content,
                            style: TextStyle(
                              fontSize: 16,
                              color: isCorrect
                                  ? Colors.teal 
                                  : (isSelectedWrong ? Colors.red : Colors.black), // Màu đỏ nếu chọn sai
                            ),
                          ),
                        ),
                        if (choice.image != null)
                          Expanded(
                            flex: 2,
                            child: Image.network(
                              choice.image!,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            const Text("Hướng dẫn giải: ", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Text(
                answer.answerDetail,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            const Spacer(),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Dialog(
                child: ChatWidget(),
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.chat),
      ),
    );
  }
}
