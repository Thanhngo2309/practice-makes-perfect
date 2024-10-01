import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/FirebaseFirestoreInst.dart';
import 'package:myapp/model/Exam.dart';
import 'package:myapp/model/Subject.dart';
import 'package:myapp/model/dto/ExamResponse.dart';
import 'package:myapp/util/SubjectUtils.dart';

class ExamData {
  static List<Exam> exams = [
    Exam(
        "Đề thi thử Môn Toán 2023 - Sở giáo dục và đào tạo Hải Dương",
        Subject.math,
        "SGDVDT-HD"),
    Exam(
        "Đề thi thử Môn Toán 2023 - Sở giáo dục và đào tạo Hà Nội,",
        Subject.math,
        "SGDVDT-HN"),
    Exam(
        "Đề thi thử Môn Lý 2023 - Sở giáo dục và đào tạo Hải Dương",
        Subject.physics,
        "SGDVDT-HD"),
    Exam(
        "Đề thi thử Môn Hóa 2023 - Sở giáo dục và đào tạo Hải Dương",
        Subject.chemistry,
        "SGDVDT-HD"),
    Exam(
        "Đề thi thử Môn Sinh 2023 - Sở giáo dục và đào tạo Hải Dương",
        Subject.biology,
        "SGDVDT-HD"),
    Exam(
        "Đề thi thử Môn Văn 2023 - Sở giáo dục và đào tạo Hải Dương",
        Subject.literature,
        "SGDVDT-HD"),
    Exam(
        "Đề thi thử Môn Sử 2023 - Sở giáo dục và đào tạo Hải Dương",
        Subject.history,
        "SGDVDT-HD"),
    Exam(
        "Đề thi thử Môn Địa 2023 - Sở giáo dục và đào tạo Hải Dương",
        Subject.geography,
        "SGDVDT-HD"),
  ];

  static final ExamData _instance = ExamData._internal();
  ExamData._internal();

  static ExamData getInstance() {
    return _instance;
  }

  Future<void> saveAllExams() async {
    for (Exam exam in exams) {
      await save(exam); // Gọi phương thức save cho từng exam
    }
  }

  // Phương thức save cho từng exam
  Future<void> save(Exam exam) async {
    
    FirebaseFirestore db = FirestoreInst.getInstance();
    try {
      await db.collection("exams").add({
        "name": exam.name,
        "subject": exam.subject.toString(),
        "examId": exam.examId,
        "duration":exam.duration,
        "provider":exam.provider,
        "numberOfQuestions": exam.numberOfQuestions
      }).then((value) {
        print("Exam added with ID: ${value.id}");
        print("Saved $exam");
      });
    } catch (error) {
      print("Failed to add exam: $error");
    }
  }


  Exam getExamByExamId(String examId) {
    return exams.firstWhere((exam) => exam.examId == examId);
  }

  Future<List<ExamResponse>> getAllExams() async {
    List<ExamResponse> exams = []; // Khởi tạo danh sách exam
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await db.collection("exams").get();

      exams = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ExamResponse(
          data['examId'],
          data['name'],
          SubjectUtils.stringToSubject(data['subject']),
          data['duration'],
          data['provider'],
          data['numberOfQuestions'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching exams: $e");
    }
    return exams;
  }

  Future<List<ExamResponse>> getExamsBySubject(Subject subject) async {
    print("subject ${subject.name}");
    List<ExamResponse> exams = []; // Đổi List<Exam> thành List<ExamResponse>
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await db
          .collection("exams")
          .where("subject", isEqualTo: SubjectUtils.subjectToString(subject))
          .get();

      exams = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Khởi tạo đối tượng ExamResponse
        ExamResponse response = ExamResponse(
          data['examId'],
          data['name'],
          SubjectUtils.stringToSubject(data['subject']),
          data['duration'],
          data['provider'],
          data['numberOfQuestions'],
        );

        return response;
      }).toList();
    } catch (e) {
      print("Error fetching exams: $e");
    }
    return exams;
  }


}
