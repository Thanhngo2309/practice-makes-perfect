import 'package:flutter/material.dart';
import 'package:myapp/model/dto/ExamResponse.dart';
import '../data/ExamData.dart';
import '../model/Exam.dart';
import '../model/Subject.dart';
import 'DocumentScreen.dart';
import 'ExamList.dart';
import 'FavoriteList.dart';

class ExamScreenWidget extends StatefulWidget {
  static const routeName = "/exam";
  final Subject subject;

  ExamScreenWidget({super.key, required this.subject});

  @override
  _ExamScreenWidgetState createState() => _ExamScreenWidgetState();
}

class _ExamScreenWidgetState extends State<ExamScreenWidget> {
  List<ExamResponse>? exams;
  bool isLoading = true;
  String? errorMessage;

  void initState() {
    super.initState();
    fetchExams(); 
  }

  Future<void> fetchExams() async {
    try {
      List<ExamResponse> fetchedExams =
          await ExamData.getInstance().getExamsBySubject(widget.subject);
      setState(() {
        print("ExamScreen : $fetchedExams" );
        exams = fetchedExams;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.subject.name),
          bottom: const TabBar(tabs: [
            Tab(
              text: "Đề thi",
            ),
            Tab(
              text: "Yêu thích",
            ),
            Tab(text: "Tài liệu"),
          ]),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text('Lỗi: $errorMessage'))
                : TabBarView(
                    children: [
                      ExamList(examsByObject: exams!, subjectName: widget.subject.name,),
                      FavoriteList(subjectName: widget.subject.name),
                      DocumentScreen(),
                    ],
                  ),
      ),
    );
  }
}

// class ExamScreenWidget extends StatelessWidget {
//   static const routeName = "/exam";
//   final Subject subject;
//   final List<Exam> exams;

//   ExamScreenWidget({super.key, required this.subject})
//       : exams = ExamData.getInstance().getExamsBySubject(subject);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         length: 3,
//         child: Scaffold(
//             appBar: AppBar(
//               title: Text(subject.name),
//               bottom: const TabBar(tabs: [
//                 Tab(
//                   text: "Đề thi",
//                 ),
//                 Tab(
//                   text: "Yêu thích",
//                 ),
//                 Tab(text: "Tài liệuu")
//               ]),
//             ),
//             body: TabBarView(children: [
//               ExamList(examList: exams),
//               FavoriteList(examTitle: 'Toán'),
//               DocumentScreen(),
//             ])));
//   }
// }
