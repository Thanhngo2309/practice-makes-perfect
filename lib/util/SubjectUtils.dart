import 'package:myapp/model/Subject.dart';

class SubjectUtils {
  static Subject stringToSubject(String subject) {
    String subjectType = subject.split('.').last;

    switch (subjectType) {
      case 'math':
        return Subject.math;
      case 'physics':
        return Subject.physics;
      case 'chemistry':
        return Subject.chemistry;
      case 'biology':
        return Subject.biology;
      case 'literature':
        return Subject.literature;
      case 'history':
        return Subject.history;
      case 'geography':
        return Subject.geography;
      default:
        throw Exception("Unknown subject: $subjectType");
    }
  }

  static String subjectToString(Subject subject){
    
    return 'Subject.${subject.name}';
  }

}
