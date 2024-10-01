import 'package:myapp/model/Answer.dart';

class AnswerConverter {
  static Answer convert(Map<String,dynamic> map){
    Answer answer = Answer(map['examId'], map['questionId'], map['correctAnswer'], map['answerDetail']);
    return answer;
  }
}