import 'Choice.dart';


class Question {
  String examId;
  late String questionId;
  String questionText;
  late List<Choice> choices;
  int number;
  String imagePath;

  Question({
    required this.examId,
    required this.questionText,
    required List<String> choiceContent,
    required this.number,
    required this.imagePath,
  }) {
    questionId = examId + "-" + number.toString();
    if (choiceContent.length != 4) {
      throw Exception("Too many choices");
    }
    // label in turn A, B, C, D
    choices = choiceContent
        .asMap()
        .entries
        .map((entry) =>
            Choice(String.fromCharCode(65 + entry.key), entry.value, ''))
        .toList();
  }
}
