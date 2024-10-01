import 'package:myapp/model/Subject.dart';

class SubjectConverter {
  static String subjectToString(Subject subject) {
  return subject.toString().split('.').last; // Lấy tên enum
}

// Phương thức chuyển String thành Subject
  static Subject stringToSubject(String subjectString) {
    return Subject.values.firstWhere((subject) => subject.toString().split('.').last == subjectString);
  }
}