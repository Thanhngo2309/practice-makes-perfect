// import 'package:flutter_application_1/model/Question.dart';

import 'package:myapp/util/SubjectConverter.dart';

import 'Subject.dart';

class Exam {
  late String examId;
  late String name;
  late Subject subject;
  late int duration;
  late String provider;
  late int numberOfQuestions;
  // List<Question> questions;



  Exam(this.name, this.subject, this.provider) {
    this.examId = "Đề thi " + name + SubjectConverter.subjectToString(subject) + provider; 
    if (subject == Subject.math) {
      duration = 60 * 90;
      numberOfQuestions = 2;
    } else if (subject == Subject.physics) {
      duration = 60 * 50;
      numberOfQuestions = 45;
    } else if (subject == Subject.chemistry) {
      duration = 60 * 50;
      numberOfQuestions = 45;
    } else if (subject == Subject.biology) {
      duration = 60 * 50;
      numberOfQuestions = 45;
    } else if (subject == Subject.english) {
      duration = 60 * 90;
      numberOfQuestions = 60;
    } else if (subject == Subject.history) {
      duration = 60 * 90;
      numberOfQuestions = 45;
    } else if (subject == Subject.geography) {
      duration = 60 * 90;
      numberOfQuestions = 45;
    } else if (subject == Subject.literature) {
      duration = 60 * 90;
      numberOfQuestions = 3;
    } else if (subject == Subject.language) {
      duration = 60 * 90;
    } else if (subject == Subject.art) {
      duration = 60 * 90;
      numberOfQuestions = 3;
    }
  }

}
