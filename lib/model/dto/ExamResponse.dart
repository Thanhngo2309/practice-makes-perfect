import 'package:myapp/model/Subject.dart';

class ExamResponse {
  late String examId;
  late String name;
  late Subject subject;
  late int duration;
  late String provider;
  late int numberOfQuestions;


  ExamResponse(this.examId,this.name,this.subject,this.duration,this.provider,this.numberOfQuestions);
}