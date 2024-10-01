import 'package:myapp/model/Attempt.dart';
import 'package:myapp/model/Question.dart'; // Thêm import cho Question
import 'package:myapp/model/Choice.dart'; // Thêm import cho Choice
import 'package:myapp/model/Result.dart';
import 'package:myapp/model/SelectedAnswer.dart';
import 'package:myapp/model/dto/QuestionResponse.dart';

class AttemptConverter {
  static Map<String, dynamic> convert(Attempt attempt) {
    return {
      'userId':attempt.userId,
      'attemptId': attempt.attemptId,
      'result': {
        'score': attempt.result.score,
        'correctNumbers': attempt.result.correctNumbers,
        'incorrectNumbers': attempt.result.incorrectNumbers,
        'unanswerNumbes': attempt.result.unanswerNumbes,
      },
      'questions': attempt.questions.map(
        (question) => {
          'examId': question.examId,
          'questionId': question.questionId,
          'questionText': question.questionText,
          'choices': question.choices.map(
            (choice) => {
              'label': choice.label,
              'content': choice.content,
              'image': choice.image,
            },
          ).toList(),
          'number': question.number,
          'imagePath': question.imagePath,
        },
      ).toList(),
      'selectedAnswers': attempt.selectedAnswers.map(
        (selectedAnswer) => {
          'examId': selectedAnswer.examId,
          'questionId': selectedAnswer.questionId,
          'selectedAnswer': selectedAnswer.selectedAnswer,
          'isCorrect': selectedAnswer.isCorrect,
        },
      ).toList(),
      'examId': attempt.examId,
      'totalTime': attempt.totalTime,
    };
  }

  static Attempt convertFromJson(Map<String, dynamic> json) {
    // Chuyển đổi từ JSON sang Attempt
    final result = Result(
      json['result']['score'],
      json['result']['correctNumbers'],
      json['result']['incorrectNumbers'],
      json['result']['unanswerNumbes'],
    );

    final questions = (json['questions'] as List)
        .map((q) => QuestionResponse(
              q['examId'],
              q['questionId'],
              q['questionText'],
              (q['choices'] as List)
                  .map((c) => Choice(
                        c['label'],
                        c['content'],
                        c['image'],
                      ))
                  .toList(),
              q['number'],
              q['imagePath'],
            ))
        .toList();

    final selectedAnswers = (json['selectedAnswers'] as List)
        .map((sa) => SelectedAnswer(
              examId: sa['examId'],
              questionId: sa['questionId'],
              selectedAnswer: sa['selectedAnswer'],
            ))
        .toList();

    final attempt = Attempt(questions, selectedAnswers, json['examId']);
    attempt.attemptId = json['attemptId'];
    attempt.result = result;
    attempt.totalTime = json['totalTime'];

    return attempt;
  }
}