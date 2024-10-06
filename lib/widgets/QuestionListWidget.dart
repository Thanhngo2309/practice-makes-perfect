import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/data/AttemptData.dart';
import 'package:myapp/data/QuestionData.dart';
import 'package:myapp/model/Attempt.dart';
import 'package:myapp/model/SelectedAnswer.dart';
import 'package:myapp/model/dto/QuestionResponse.dart';
import 'package:myapp/util/AutoGenerateSelectedAnswerService.dart';
import 'package:myapp/util/TimeConvert.dart';
import 'package:myapp/widgets/QuestionCardWidget.dart';
import 'package:myapp/widgets/ResultWidget.dart';

class QuestionListWidget extends StatefulWidget {
  final String examId;
  final int duration;

  const QuestionListWidget(this.examId, this.duration, {super.key});

  @override
  State<QuestionListWidget> createState() => _QuestionListWidgetState();
}

class _QuestionListWidgetState extends State<QuestionListWidget> {
  late Map<int, SelectedAnswer> selectedAnswersMap;
  late int currentQuestionIndex;
  late Attempt attempt;
  late int remainingSeconds;
  Timer? _timer;
  bool isExamCompleted = false;
  List<QuestionResponse>? questions;
  bool loading = true;
  String? errorMsg;

  Future<void> fetchQuestions(String examId) async {
    setState(() {
      loading = true;
    });

    try {
      List<QuestionResponse> fetchedQuestions = await QuestionData().getQuestionsByExamId(examId);
      setState(() {
        loading = false;
        questions = fetchedQuestions;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('QuestionListWidget thrown an exception: $e');
    }
  }

  Future<void> _initializeQuestions() async {
    await fetchQuestions(widget.examId); // Chờ cho việc lấy câu hỏi hoàn tất

    // Chỉ sau khi câu hỏi được lấy, thực hiện các thiết lập tiếp theo
    currentQuestionIndex = 0;
    remainingSeconds = widget.duration;
    selectedAnswersMap = AutoGenerateSelectedAnswerService.getInstance().generate(questions!, widget.examId);
    
    // Debugging: Check the fetched questions and selected answers
    print('Fetched Questions: $questions');
    print('Selected Answers Map: $selectedAnswersMap');

    attempt = Attempt(questions!, selectedAnswersMap.values.toList(), widget.examId);
    
    // Debugging: Check the attempt object
    print('Attempt Object: ${attempt.toString()}');
    
    _startCountdown();
  }

  @override
  void initState(){
    super.initState();
    _initializeQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void onSelect(String selectedLabel, QuestionResponse question) {
    setState(() {
      selectedAnswersMap[currentQuestionIndex] = SelectedAnswer(
        questionId: question.questionId,
        selectedAnswer: selectedLabel,
        examId: widget.examId,
      );
      if (currentQuestionIndex < questions!.length - 1) {
        currentQuestionIndex++;
      } else {
        isExamCompleted = true;
      }
    });
  }

  void goBack() {
    if (currentQuestionIndex > 0) {  
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void next() {
    if (currentQuestionIndex < questions!.length - 1) { 
      setState(() {
        currentQuestionIndex++;
      });
    }
  }


  void submitExam() {
    List<SelectedAnswer> selectedAnswers = selectedAnswersMap.values.toList();    
    attempt.selectedAnswers = selectedAnswers;
    attempt.selectedAnswers.forEach((selectedAnswer) => {
      print("Selected answer : ${selectedAnswer.examId} , questionId : ${selectedAnswer.questionId} , selectedAnswer : ${selectedAnswer.selectedAnswer} , isCorrect : ${selectedAnswer.isCorrect}") // Fixed string interpolation
    });
    attempt.setTotalTime(
        TimeConvert.secondsToHHMMSS(widget.duration - remainingSeconds));
    // AttemptData.getInstance().save(attempt);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultWidget(attempt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMsg != null) {
      return Center(child: Text('Lỗi: $errorMsg'));
    } else if (questions == null || questions!.isEmpty) {
      return const Center(child: Text('Không có câu hỏi nào.'));
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Câu ${currentQuestionIndex + 1}/${questions!.length}',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  TimeConvert.secondsToHHMMSS(remainingSeconds),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton(
                  onPressed: submitExam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Nộp bài",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: QuestionCardWidget(
                questions![currentQuestionIndex],
                selectedAnswersMap[currentQuestionIndex]?.selectedAnswer,
                onSelect,
                goBack,
                next
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            _timer?.cancel();
            submitExam();
          }
        });
      }
    });
  }
}
