import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/Result.dart';
import 'package:myapp/model/dto/QuestionResponse.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../application-service/CalculateScoreService.dart';
import '../data/AnswerData.dart';
import '../model/Answer.dart';
import '../model/Attempt.dart';
import '../model/SelectedAnswer.dart';
import 'QuestionListWidget.dart';
import 'SelectedAnswerDetailWidget.dart';
import 'dart:html' as html; // Thêm import cho nền tảng web
import 'package:flutter/foundation.dart' show kIsWeb;

class ResultWidget extends StatelessWidget {
  
  Attempt attempt;
  ScreenshotController screenshotController = ScreenshotController();

  ResultWidget(this.attempt, {super.key});

  @override
  Widget build(BuildContext context) {
    print("Đang build");

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Text("Kết quả bài thi")),
            ElevatedButton(
                onPressed: () => retakeExam(context, attempt.examId),
                style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Thay 'primary' bằng 'backgroundColor'
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                ),
                child: const Text("Thử lại",  style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
      body: FutureBuilder<Result>(
        future: CalculateScoreService().calculateScore(attempt),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Handle error
          } else {
            attempt.result = snapshot.data!; // Assign the result
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(children: [
                Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3), 
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 61, 120),
                          borderRadius: BorderRadius.circular(4), 
                        ),
                        child: Text(
                          attempt.result.score,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Text(
                        "Điểm: ",
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.timer, color: Colors.purple, size: 25,),
                      Text(attempt.totalTime) // Ensure totalTime is a String
                    ],
                  ),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(children: [Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10), 
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4), 
                        ),
                        child: Text(
                          attempt.result.correctNumbers.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Text(
                        "Đúng",
                      ),],),
                      const SizedBox(width: 20),
                      Row(children: [Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10), 
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4), 
                        ),
                        child: Text(
                          attempt.result.incorrectNumbers.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Text(
                        "Sai",
                      ),],),
                      const SizedBox(width: 20),
                      Row(children: [Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10), 
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 232, 231, 231),
                          borderRadius: BorderRadius.circular(4), 
                        ),
                        child: Text(
                          attempt.result.unanswerNumbes.toString(), // Corrected typo
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Text(
                        "Chưa làm",
                      ),],),
                      
                    ],
                  ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Nhấn vào câu bất kỳ để xem đáp án và trả lời",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.count(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    crossAxisCount: 4,
                    children: attempt.selectedAnswers.asMap().entries.map((entry) {
                      int index = entry.key;
                      SelectedAnswer ans = entry.value;
                      double screenWidth = MediaQuery.of(context).size.width;
                      double screenHeight = MediaQuery.of(context).size.height;
                      double buttonHeight = screenHeight * 0.1;
                      double buttonWidth = buttonHeight * 3;
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(buttonWidth, buttonHeight),
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5), // Đặt border thành vuông
                                  ),
                            backgroundColor: (ans.isCorrect) ? Colors.blue : Colors.red,
                          ),
                          onPressed: () async { // Make this async
                            Answer? answer = await AnswerData.getInstance().getAnswerByQuestionId(attempt.questions[index].questionId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectedAnswerDetailWidget(ans, attempt.questions[index], answer!),
                              ),
                            );
                          },
                          child: Text(
                            "Câu ${index + 1}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: takeScreenshotAndShare,
                  child: Icon(Icons.share),
                )
              ]),
            );
          }
        },
      ),
    );
  }

  Future<Widget> answerDetail(
      BuildContext context, QuestionResponse question, SelectedAnswer ans) async {
    Answer? answer = await AnswerData.getInstance().getAnswerByQuestionId(question.questionId);
    return SelectedAnswerDetailWidget(ans, question, answer!);
  }

  void retakeExam(BuildContext context, String examId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QuestionListWidget(examId, 90 * 60)),
    );
  }
Future<void> takeScreenshotAndShare() async {
  try {
    // Chụp ảnh màn hình
    final image = await screenshotController.capture();
    if (image == null) return;

    if (kIsWeb) {
      // Chia sẻ trên nền tảng web
      final blob = html.Blob([image], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Tạo một thẻ download để người dùng tải ảnh về
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'screenshot.png')
        ..click();
      html.Url.revokeObjectUrl(url);

      // Sử dụng Web Share API để chia sẻ ảnh đã tải xuống
      if (await html.window.navigator.share != null) {
        // Chia sẻ link hình ảnh đã tải
        await html.window.navigator.share({
          'title': 'My Screenshot',
          'text': 'Check out my screenshot!',
          'url': url, // Chia sẻ URL của ảnh vừa tải
        });
      }
    } else {
      // Lưu ảnh chụp vào file tạm thời cho di động
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/screenshot.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      // Chia sẻ ảnh chụp màn hình
      await Share.shareXFiles([XFile(imageFile.path)],
          text: 'Check out my screenshot!');
    }
  } catch (e) {
    print("Lỗi khi chụp màn hình: $e");
  }
}

}
