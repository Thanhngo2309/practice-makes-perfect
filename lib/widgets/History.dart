import 'package:flutter/material.dart';
import 'package:myapp/model/Attempt.dart';
import 'package:myapp/util/TimeConvert.dart';
import 'package:myapp/widgets/ResultWidget.dart';

class History extends StatelessWidget {
  final List<Attempt> attempts;

  History({required this.attempts});

  @override
  Widget build(BuildContext context) {
    double calculateAverageScore(List<Attempt> attempts) {
      if (attempts.isEmpty) return 0.0;

      double totalScore = 0.0;
      int correctAnswers = 0;
      int incorrectAnswers = 0;
      int unanswerAnswers = 0;

      for (var attempt in attempts) {
        correctAnswers += attempt.result.correctNumbers;
        incorrectAnswers += attempt.result.incorrectNumbers;
        unanswerAnswers += attempt.result.unanswerNumbes;
      }

      // Tránh chia cho 0
      if ((correctAnswers + incorrectAnswers + unanswerAnswers) == 0) return 0.0;

      totalScore = (correctAnswers) / (correctAnswers + incorrectAnswers + unanswerAnswers);
      return totalScore * 10;
    }

    double averageScore = attempts.isNotEmpty
        ? calculateAverageScore(attempts)
        : 0.0;

    int totalAttempts = attempts.length;

    int totalHours = attempts.fold(0, (sum, attempt) {
      int totalSeconds = TimeConvert.HHMMSSToSeconds(attempt.totalTime);
      return sum + totalSeconds;
    });
    String totalTime = TimeConvert.secondsToHHMMSS(totalHours);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Số lần làm bài: $totalAttempts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Điểm trung bình: ${averageScore.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tổng số giờ làm bài: $totalTime',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: attempts.length,
                itemBuilder: (context, index) {
                  Attempt attempt = attempts[index];

                  return Card(
                    color: attempt.result.correctNumbers > attempt.result.incorrectNumbers
                    ? Colors.green
                    : attempt.result.correctNumbers == attempt.result.incorrectNumbers
                    ? Colors.yellow
                    : Colors.red,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bo tròn góc
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Đề thi: ${attempt.examId}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Icon(
                                attempt.result.correctNumbers > attempt.result.incorrectNumbers
                                ? Icons.sentiment_very_satisfied
                                : Icons.sentiment_very_dissatisfied,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Điểm: ${attempt.result.score}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Thời gian: ${attempt.totalTime}',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Điều hướng đến ResultWidget
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultWidget(attempt),
                                ),
                              );
                            },
                            child: Text('Xem chi tiết'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal, // Màu nền nút
                              foregroundColor: Colors.white, // Màu chữ nút
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}