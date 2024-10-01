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

    // Future<void> _initializeQuestions() async {
  //   if (questions.isEmpty) {
  //     questions.addAll([
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 1+1",
  //         choiceContent: ["2", "3", "4", "5"],
  //         number: 1,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 2+2",
  //         choiceContent: ["4", "3", "4", "5"],
  //         number: 2,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 3+3",
  //         choiceContent: ["6", "3", "4", "5"],
  //         number: 3,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 4+4",
  //         choiceContent: ["8", "3", "4", "5"],
  //         number: 4,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 5+5",
  //         choiceContent: ["10", "3", "4", "5"],
  //         number: 5,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 6+6",
  //         choiceContent: ["12", "3", "4", "5"],
  //         number: 6,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 7+7",
  //         choiceContent: ["14", "3", "4", "5"],
  //         number: 7,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 8+8",
  //         choiceContent: ["16", "3", "4", "5"],
  //         number: 8,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 9+9",
  //         choiceContent: ["18", "3", "4", "5"],
  //         number: 9,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 10+10",
  //         choiceContent: ["20", "3", "4", "5"],
  //         number: 10,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 11+11",
  //         choiceContent: ["22", "3", "4", "5"],
  //         number: 11,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 12+12",
  //         choiceContent: ["24", "3", "4", "5"],
  //         number: 12,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 13+13",
  //         choiceContent: ["26", "3", "4", "5"],
  //         number: 13,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 14+14",
  //         choiceContent: ["28", "3", "4", "5"],
  //         number: 14,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 15+15",
  //         choiceContent: ["30", "3", "4", "5"],
  //         number: 15,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 16+16",
  //         choiceContent: ["32", "3", "4", "5"],
  //         number: 16,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 17+17",
  //         choiceContent: ["34", "3", "4", "5"],
  //         number: 17,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 18+18",
  //         choiceContent: ["36", "3", "4", "5"],
  //         number: 18,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 19+19",
  //         choiceContent: ["38", "3", "4", "5"],
  //         number: 19,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 20+20",
  //         choiceContent: ["40", "3", "4", "5"],
  //         number: 20,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 21+21",
  //         choiceContent: ["42", "3", "4", "5"],
  //         number: 21,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 22+22",
  //         choiceContent: ["44", "3", "4", "5"],
  //         number: 22,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 23+23",
  //         choiceContent: ["46", "3", "4", "5"],
  //         number: 23,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 24+24",
  //         choiceContent: ["48", "3", "4", "5"],
  //         number: 24,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 25+25",
  //         choiceContent: ["50", "3", "4", "5"],
  //         number: 25,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 26+26",
  //         choiceContent: ["52", "3", "4", "5"],
  //         number: 26,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 27+27",
  //         choiceContent: ["54", "3", "4", "5"],
  //         number: 27,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 28+28",
  //         choiceContent: ["56", "3", "4", "5"],
  //         number: 28,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 29+29",
  //         choiceContent: ["58", "3", "4", "5"],
  //         number: 29,
  //         imagePath: "",
  //       ),
  //       Question(
  //         examId: "SGDVDT-HD-Toan-20/12",
  //         questionText: "What is 30+30",
  //         choiceContent: ["60", "3", "4", "5"],
  //         number: 30,
  //         imagePath: "",
  //       ),
  //     ]);
  //   }

  //   await saveAll(questions);
  // }
}
