import 'package:myapp/data/AnswerData.dart';
import 'package:myapp/data/AttemptData.dart';
import 'package:myapp/model/Answer.dart';
import 'package:myapp/model/Attempt.dart';
import 'package:myapp/model/Result.dart';
import 'package:myapp/model/SelectedAnswer.dart';
import 'package:myapp/model/dto/QuestionResponse.dart';

class CalculateScoreService {
  Future<Result> calculateScore( 
    Attempt attempt
      ) async { 
    
    if(attempt.result != null) return attempt.result;
    AnswerData answerData = AnswerData.getInstance();

    List<Answer> answers = await Future.wait( 
        attempt.questions.map((question) => answerData.getAnswerByQuestionId(question.questionId))
    ).then((values) => values.whereType<Answer>().toList());

    Result result = _calculateScore(attempt.selectedAnswers, answers);
    attempt.result = result;
    AttemptData.getInstance().save(attempt);
    return result;
  }

  Result _calculateScore(
      List<SelectedAnswer> selectedAnswers, List<Answer> answers) {
    Map<String, String> correctAnswerMap = {};

    for (var answer in answers) {
      correctAnswerMap[answer.questionId] = answer.correctAnswer;
    }

    int correctNumbers = 0;
    int unanswerNumbers = 0;
    int incorrectNumbers = 0;

    for (var selectedAnswer in selectedAnswers) {
      String? correctAnswer = correctAnswerMap[selectedAnswer.questionId];
      if (correctAnswer != null && selectedAnswer.isCorrectAnswer(correctAnswer)) {
        correctNumbers++;
      } else if (selectedAnswer.selectedAnswer == '') {
        unanswerNumbers++;
      } else {
        incorrectNumbers++;
      }
    }

    return Result(
        "$correctNumbers/30", correctNumbers, incorrectNumbers, unanswerNumbers);
  }
}