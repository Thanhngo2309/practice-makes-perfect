import 'package:myapp/model/dto/QuestionResponse.dart';

import '../model/Question.dart';
import '../model/SelectedAnswer.dart';

class AutoGenerateSelectedAnswerService {
  static final AutoGenerateSelectedAnswerService _instance =
      AutoGenerateSelectedAnswerService._internal();

  AutoGenerateSelectedAnswerService._internal();

  static AutoGenerateSelectedAnswerService getInstance() {
    return _instance;
  }

  Map<int, SelectedAnswer> generate(List<QuestionResponse> questions, String examId) {
    return {
      for (var index in List.generate(questions.length, (index) => index))
        index: SelectedAnswer(
            examId: examId,
            questionId: questions[index].questionId,
            selectedAnswer: '')
    };
  }
}
