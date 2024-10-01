import 'package:flutter/material.dart';
import 'package:myapp/application-service/FavoriteFeature.dart';
import 'package:myapp/model/dto/ExamResponse.dart';

import '../data/ExamData.dart';
import 'ExamItem.dart';

class FavoriteList extends StatelessWidget {
  final String subjectName;

  FavoriteList({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExamResponse>>(
      future: ExamData.getInstance().getAllExams(), // Gọi hàm bất đồng bộ
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); 
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No exams found.')); // Không có đề thi
        }

        List<ExamResponse> exams = snapshot.data!;

        return FutureBuilder<List<String>>(
          future: Favoritefeature.getFavorites(subjectName), // Gọi hàm bất đồng bộ
          builder: (context, favoriteSnapshot) {
            if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Hiển thị loading
            } else if (favoriteSnapshot.hasError) {
              return Center(child: Text('Error: ${favoriteSnapshot.error}')); // Hiển thị lỗi nếu có
            } else if (!favoriteSnapshot.hasData || favoriteSnapshot.data!.isEmpty) {
              return Center(child: NotFound()); // Không có đề thi yêu thích
            }

            List<String> favoriteIds = favoriteSnapshot.data!;
            List<ExamResponse> favoriteExams = exams
                .where((e) => favoriteIds.contains(e.examId))
                .toList();

            return Padding(padding: EdgeInsets.all(20), child: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ExamItem(
                    exam: favoriteExams[index],
                    withHeartIcon: false,
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemCount: favoriteExams.length,
            ),);
          },
        );
      },
    );
  }
}

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Container(
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.height,
  child: const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Icon(Icons.file_copy, color: Colors.blue, size: 80,),
        SizedBox(height: 10,),
        Text(
          "Bạn chưa có đề thi yêu thích nào",
          style: TextStyle(color: Colors.blue),
        ),
        SizedBox(height: 5,),
        Text("Làm 1 đề thi bất kỳ -> Nhấn biểu tượng Trái Tim trên góc phải màn hình để thêm", textAlign: TextAlign.center, style: TextStyle(color: Colors.black87),)
      ],
    ),
  ),
),);
  }
}
