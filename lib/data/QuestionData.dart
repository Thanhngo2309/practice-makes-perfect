import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/ChoiceConverter.dart';
import 'package:myapp/data/FirebaseFirestoreInst.dart';
import 'package:myapp/model/Choice.dart';
import 'package:myapp/model/Question.dart';
import 'package:myapp/model/dto/QuestionResponse.dart';

class QuestionData {
  static final QuestionData _instance = QuestionData._internal();
  static List<Question> questions = [];

  factory QuestionData() {
    return _instance;
  }

  QuestionData._internal() {
    // _initializeQuestions();
  }

  Future<List<QuestionResponse>> getQuestionsByExamId(String examId) async {
    List<QuestionResponse> questions = [];
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await db
          .collection("questions")
          .where("examId", isEqualTo: examId)
          .get();
      
      print("examId: $examId");
      print("Number of documents: ${querySnapshot.docs.length}");

      questions = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        List<Choice> choices = (data['choices'] as List)
            .map((choice) => ChoiceConverter.convert(choice))
            .toList();

        print("choices: $choices");
        return QuestionResponse(
          data['examId'], 
          data['questionId'],
          data['questionText'],
          choices,
          data['number'],
          data['imagePath']
        );
      }).toList();
    } catch (e) {
      print("Error fetching questions: $e");
    }
    return questions;
  }


  Future<void> save(Question question) async {
    FirebaseFirestore db = FirestoreInst.getInstance();
    db.collection("questions").add({
      "examId":question.examId,
      "questionId" : question.questionId,
      "questionText" : question.questionText,
      "choices" : [
        {
          "label":question.choices[0].label,
          "content":question.choices[0].content,
          "image":question.choices[0].image
        },
        {
          "label":question.choices[1].label,
          "content":question.choices[1].content,
          "image":question.choices[1].image
        },
        {
          "label":question.choices[2].label,
          "content":question.choices[2].content,
          "image":question.choices[2].image
        },
        {
          "label":question.choices[3].label,
          "content":question.choices[3].content,
          "image":question.choices[3].image
        },
      ],
      "number":question.number,
      "imagePath":question.imagePath
    }).then((value) {
      print("Question added with ID: ${value.id}");
    }).catchError((error) {
      print("Failed to add question: $error");
    });
    questions.add(question);
    print("Saved $question");
  }
  Future<void> saveAll(List<Question> newQuestions) async {

    print("Saved $newQuestions");

    FirebaseFirestore db = FirestoreInst.getInstance();
  
    for (var question in newQuestions) {
      List<Map<String, dynamic>> choices = question.choices.map((choice) {
        return {
          "label": choice.label,
          "content": choice.content,
          "image": choice.image,
        };
    }).toList();

    try {
      await db.collection("questions").add({
        "examId": question.examId,
        "questionId": question.questionId,
        "questionText": question.questionText,
        "choices": choices,
        "number": question.number,
        "imagePath": question.imagePath,
      }).then((value) {
        print("Question added with ID: ${value.id}");
      });
    } catch (error) {
      print("Failed to add question: $error");
    }
  }

  questions.addAll(newQuestions);
}
}
