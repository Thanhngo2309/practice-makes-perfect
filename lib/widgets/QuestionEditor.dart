import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/data/AnswerData.dart';
import 'package:myapp/data/QuestionData.dart';
import 'package:myapp/model/Answer.dart';
import 'package:myapp/model/Exam.dart';
import 'package:myapp/model/Question.dart';
import 'package:myapp/util/AutoGenerateAnswer.dart';

class QuestionEditor extends StatefulWidget {
  final String routeName = '/question';
  final Exam exam;

  QuestionEditor({Key? key, required this.exam}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  TextEditingController _questionController = TextEditingController();
  List<TextEditingController> _answerControllers = List.generate(4, (index) => TextEditingController());
  TextEditingController _explainController = TextEditingController();
  late List<Question> questions;
  late Map<String, Uint8List> tempImageQuestion; // Map<questionId, imageData>
  late Map<String, List<Uint8List>> tempImageChoice; // Map<question, List<imageData>>
  List<bool> showTextField = List.generate(4, (index)=>false);
  int currentIndex = 0;
  int? _correctAnswer;
  late List<Answer> answers;
  late Question currentQuestion;

  @override
  void initState() {
    super.initState();
    questions = List.generate(widget.exam.numberOfQuestions, (index) => Question(
      examId: widget.exam.examId,
      questionText: '',
      choiceContent: List.filled(4, ''),
      number: index + 1,
      imagePath: '',
    ));
    answers = AutoGenerateAnswer.generate(questions);
    currentQuestion = questions[currentIndex];
    tempImageQuestion = {};
    tempImageChoice = {};
    _correctAnswer = 0;
    _loadCurrentQuestion();
  }

  void changeCorrectAnswer(int correctAnswer){
    setState(() {
      this._correctAnswer = correctAnswer;
      showTextField = List.filled(4, false);
      showTextField[correctAnswer] = true;      
    });

  }

  Future<void> _pickImage(int answerIndex) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();  // Read the image
        if (answerIndex == -1) { 
          setState(() {
            tempImageQuestion[currentQuestion.questionId] = bytes;
          });
        } else { 
          if (!tempImageChoice.containsKey(currentQuestion.questionId)) {
            setState(() {
              tempImageChoice[currentQuestion.questionId] = List.filled(4, Uint8List(0));
            });
          }
          setState(() {
            tempImageChoice[currentQuestion.questionId]![answerIndex] = bytes; // Save the image to the specific choice index
          });
        }
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadImages() async {
    for (var question in questions) {
      try {
        if (tempImageQuestion.containsKey(question.questionId)) {
          Uint8List imageData = tempImageQuestion[question.questionId]!;
          String filePath = 'questions/${question.questionId}/${DateTime.now().millisecondsSinceEpoch}.png';
          // Lưu dữ liệu hình ảnh vào Firebase Storage
          await FirebaseStorage.instance.ref(filePath).putData(imageData,SettableMetadata(contentType: 'image/jpeg'));
          question.imagePath = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
        } else {
          print("No image for question ${question.number} in tempImageQuestion.");
        }

        if (tempImageChoice.containsKey(question.questionId)) {
          List<Future<void>> uploads = [];
          for (int i = 0; i < question.choices.length; i++) {
            if (tempImageChoice[question.questionId]!.length > i) {
              Uint8List imageData = tempImageChoice[question.questionId]![i];
              String filePath = 'choices/${question.questionId}-i/${DateTime.now().millisecondsSinceEpoch}.png';
              uploads.add(
                FirebaseStorage.instance.ref(filePath).putData(imageData,SettableMetadata(contentType: 'image/jpeg')).then((_) async {
                  question.choices[i].image = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
                })
              );
            }
          }
          await Future.wait(uploads);
        } else {
          print("No images for question ${question.number} in tempImageChoice.");
        }
      } catch (e) {
        print("Error uploading images for question ${question.number}: $e");
      }
    }
  }

  void _saveToDb() async {
    _saveCurrentQuestion();
    await _uploadImages();
    questions.forEach((question) {
      if (question.questionText.isEmpty) {
        print("Question text is empty for question number: ${question.number}");
      }
    });

    answers.forEach((answer){
      if(answer.answerDetail.isEmpty){
        print("Answer details could not be empty");
      };
    });

    QuestionData().saveAll(questions);
    AnswerData.getInstance().saveAll(answers);
    print("Questions saved to database.");
  }

  void _nextQuestion() {
    _saveCurrentQuestion();
    _saveCurrentAnswer();
    if (currentIndex < questions.length - 1) {
      setState(() {
        showTextField = List.filled(4, false);
        currentIndex++;
        currentQuestion = questions[currentIndex];
        answers[currentIndex].correctAnswer == '' ? _correctAnswer=-1 : _correctAnswer = answers[currentIndex].correctAnswer.codeUnitAt(0) - 'A'.codeUnitAt(0);
        _loadCurrentQuestion();
      });
    } else {
      print("You are at the last question.");
    }
  }

  void _previousQuestion() {
    if (currentIndex > 0) {
      _saveCurrentQuestion();
      setState(() {
        currentIndex--;
        currentQuestion = questions[currentIndex];
        _correctAnswer = answers[currentIndex].correctAnswer.codeUnitAt(0) - 'A'.codeUnitAt(0);
        _loadCurrentQuestion();
      });
    }
  }

  void _saveCurrentQuestion() {
    if (currentIndex < questions.length) {
      Question currentQuestion = questions[currentIndex];
      currentQuestion.questionText = _questionController.text;

      for (int i = 0; i < _answerControllers.length; i++) {
        currentQuestion.choices[i].content = _answerControllers[i].text;
      }
    }
  }

  void _loadCurrentQuestion() {
    if (currentIndex < questions.length) {
      Question currentQuestion = questions[currentIndex];
      _questionController.text = currentQuestion.questionText;

      for (int i = 0; i < _answerControllers.length; i++) {
        _answerControllers[i].text = currentQuestion.choices[i].content;
      }
    }
  }

  void _saveCurrentAnswer(){
    answers[currentIndex].answerDetail = _explainController.text;
    answers[currentIndex].correctAnswer = String.fromCharCode(_correctAnswer! + 65);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Question Editor")),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: 
           Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Question ${currentIndex + 1}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Câu hỏi",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "*", 
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      TextField(
                        controller: _questionController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Nhập câu hỏi...',
                          fillColor: Colors.white,
                          enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Color.fromARGB(255, 210, 210, 210)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: (!tempImageQuestion.containsKey(currentQuestion.questionId))
                            ? DottedBorder(
                                color: Colors.grey,
                                strokeWidth: 1,
                                dashPattern: const [4, 4],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.image),
                                          onPressed: () => _pickImage(-1),
                                        ),
                                        const Text(
                                          "Chọn ảnh từ máy bạn",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                              children: [
                                Center(child: IconButton(onPressed: ()=>{
                                  setState(() {
                                    tempImageQuestion.remove(currentQuestion.questionId);
                                  })
                                }, icon: Icon(Icons.delete)),),
                                Image.memory(tempImageQuestion[currentQuestion.questionId]!, height: 200, width: MediaQuery.of(context).size.width),
                              ],
                            ) 
                      ), 
                    ],
                    ),
                  ),
              const SizedBox(height: 20),
              const Text(
                "Đáp án",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_correctAnswer == -1)
                SizedBox(height: 10,),
                Text('Đâu là câu trả lời chính xác ? ', style: TextStyle(color: Colors.red),),
              const SizedBox(height: 10),
              ListView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Radio<int> (value: index , groupValue: _correctAnswer, onChanged: (value)=>changeCorrectAnswer(value!),),
                            SizedBox(width: 5,),

                            Expanded(
                              child: TextField(
                                controller: _answerControllers[index],
                                decoration: InputDecoration(
                                  hintText: 'Đáp án ${String.fromCharCode(65 + index)}',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.image),
                              onPressed: () => _pickImage(index),
                            ),
                          ],
                        ),
                        // Display the selected image next to the answer text field
                        if (tempImageChoice.containsKey(currentQuestion.questionId) &&
                            tempImageChoice[currentQuestion.questionId]!.length > index &&
                            tempImageChoice[currentQuestion.questionId]![index].isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.memory(
                              tempImageChoice[currentQuestion.questionId]![index],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if(showTextField[index])
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: _explainController,
                              decoration: InputDecoration(
                                hintText: 'Để lại lời giải thích ...',
                                border: const OutlineInputBorder()
                              ),
                            ),
                          )
                        else
                          SizedBox(height: 0,),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _previousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    ),
                    child: const Text("Quay lại", style: TextStyle(color: Colors.white),),
                  ),
                  currentIndex == widget.exam.numberOfQuestions - 1
                      ? ElevatedButton(
                          onPressed: _saveToDb,
                          child: const Icon(Icons.save_as),
                        )
                      : ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                          ),
                          child: const Text("Tiếp", style: TextStyle(color: Colors.white),),
                          ),
                ],
              ),
            ],
          ),
        ),
        )
      ),
    );
  }
}