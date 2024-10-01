import 'package:flutter/material.dart';
import 'package:myapp/data/ExamData.dart';
import 'package:myapp/model/Exam.dart';
import 'package:myapp/model/Subject.dart';
import 'package:myapp/util/SubjectConverter.dart';
import 'package:myapp/widgets/QuestionEditor.dart';

class AddExam extends StatefulWidget {
  @override
  _AddExam createState() => _AddExam();
}

class _AddExam extends State<AddExam> {
  List<String> subjects = [
    'math',
    'physics',
    'history',
    'geography',
    'literature',
    'language',
    'chemistry',
    'art',
    'biology',
    'english',
  ];
  
  Subject? selectedSubject;
  String name = '';
  String description = '';
  int duration = 0;

  void clearSelectedSubjects() {
    setState(() {
      selectedSubject = null;
      name = '';
      description = '';
      duration = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm mới bài kiểm tra')),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Thông tin chi tiết", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const Text("Lưu ý:  Điền đầy đủ thông tin cho các trường có dấu hoa thị", style: TextStyle(color: Colors.red, fontSize: 12, fontStyle: FontStyle.italic),),
              const SizedBox(height: 20,),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Môn học",
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Chọn Môn Học',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 210, 210, 210)
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                items: subjects.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(
                      subject,
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedSubject = SubjectConverter.stringToSubject(value);
                      duration = (selectedSubject == Subject.math) ? 90 :
                                (selectedSubject == Subject.literature) ? 180 : 60;
                    });
                  }
                },
                icon: const Icon(Icons.arrow_drop_down), // Biểu tượng mũi tên cuộn xuống
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Tên môn học",
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
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.add),
                  hintText: 'Tên',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 210, 210, 210)),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 210, 210, 210)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Môn học",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              const SizedBox(height: 5,),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Mô tả',
                  filled: true,
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
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                scrollController: ScrollController(initialScrollOffset: 50.0), 
              ),
              const SizedBox(height: 20),
              Center(child: Text("Thời gian: $duration phút", textAlign: TextAlign.center,),),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[ 
                  ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.red, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  ),
                  child: const Text("Xoá", style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                  onPressed: () {
                    if (selectedSubject == null || name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')),
                      );
                      return;
                    }

                    Exam exam = Exam(name, selectedSubject!, "");
                    ExamData.getInstance().save(exam);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuestionEditor(exam: exam)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  ),
                  child: const Text(
                    'Tiếp theo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),]
              )
            ],
          ),
        ),
      ),
    );
  }
}
