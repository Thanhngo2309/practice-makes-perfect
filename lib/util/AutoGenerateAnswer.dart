import 'package:myapp/model/Answer.dart';
import 'package:myapp/model/Question.dart';

class AutoGenerateAnswer {
  static List<Answer> generate(List<Question> questions){

    List<Answer> answers = [];
    questions.forEach((question){
      answers.add(Answer(question.examId, question.questionId, '', ''));
    });

    return answers;
  }
}