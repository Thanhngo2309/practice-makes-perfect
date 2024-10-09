import 'package:myapp/model/dto/QuestionResponse.dart';
import 'package:myapp/services/AuthService.dart';

import 'Question.dart';
import 'Result.dart';
import 'SelectedAnswer.dart';

class Attempt {
  late String userId;
  late String attemptId;
  late Result result;
  late List<QuestionResponse> questions;
  late List<SelectedAnswer> selectedAnswers;
  String examId;
  String totalTime = '0';

  Attempt(this.questions, this.selectedAnswers, this.examId) {
    attemptId = '${examId}_${DateTime.now().toIso8601String()}';
    totalTime = '0';
    userId = AuthService.getCurrentUserId()!;
  }

  void setTotalTime(String totalTime) {
    this.totalTime = totalTime;
  }

  @override
  String toString() {
    return 'Attempt{examId: $examId, questions: $questions, selectedAnswers: $selectedAnswers}';
  }
}
