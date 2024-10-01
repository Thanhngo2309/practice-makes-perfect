import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/model/Answer.dart';
import 'package:myapp/util/AnswerConverter.dart';

class AnswerData {
  static final AnswerData _instance = AnswerData._internal();

  AnswerData._internal();

  static AnswerData getInstance() {
    return _instance;
  }

  // Lấy danh sách câu trả lời theo examId từ Firestore
  Future<List<Answer>> getAnswersByExamId(String examId) async {
    List<Answer> answers = [];
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await db
          .collection("answers")
          .where("examId", isEqualTo: examId)
          .get();
      answers = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AnswerConverter.convert(data);
      }).toList();
    } catch (e) {
      print("Error fetching answers by exam ID: $e");
    }
    return answers;
  }

  // Lưu tất cả câu trả lời vào Firestore
  Future<void> saveAll(List<Answer> answers) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    for (var answer in answers) {
      try {
        await db.collection('answers').add({
          'examId': answer.examId,
          'questionId': answer.questionId,
          'correctAnswer': answer.correctAnswer,
          'answerDetail': answer.answerDetail,
        }).then((id) {
          print('Answer added with id: $id');
        });
      } catch (e) {
        print("Error adding answer: $e");
      }
    }
  }

  Future<Answer?> getAnswerByQuestionId(String questionId) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await db.collection('answers')
          .where('questionId', isEqualTo: questionId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        return AnswerConverter.convert(data);
      }
    } catch (e) {
      print("Error fetching answer by question ID: $e");
    }
    return null;
  }
}
