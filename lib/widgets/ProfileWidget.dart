import 'package:flutter/material.dart';
import 'package:myapp/data/AttemptData.dart';
import 'package:myapp/model/Attempt.dart';
import 'package:myapp/service/AuthService.dart';
import 'package:myapp/widgets/ResultWidget.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String? email;
  List<Attempt> attempts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    email = AuthService.currentUser?.email; // Lấy email của người dùng hiện tại
    _fetchAttempts(); // Lấy danh sách các lần thi
  }

  Future<void> _fetchAttempts() async {
    String userId = AuthService.getCurrentUserId()!; // Lấy userId
    attempts = await AttemptData.getInstance().getAttemptsByUserId(userId);
    setState(() {
      loading = false; // Cập nhật trạng thái loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Thông tin'),
              Tab(text: 'Lịch sử thi'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab hiển thị thông tin email
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Email: ${email ?? "Chưa có thông tin"}', // Hiển thị email
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Tên người dùng: ${AuthService.currentUser?.displayName ?? "Chưa có thông tin"}', // Hiển thị tên người dùng
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            // Tab hiển thị lịch sử thi
            loading
                ? Center(child: CircularProgressIndicator()) // Hiển thị loading khi đang lấy dữ liệu
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: attempts.length,
                        itemBuilder: (context, index) {
                          Attempt attempt = attempts[index];
                          return ListTile(
                            title: Text('Đề thi: ${attempt.examId} - Điểm: ${attempt.result.score}'),
                            subtitle: Text('Nhấn vào để xem chi tiết'), 
                            onTap: () {
                              // Điều hướng đến ResultWidget
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultWidget(attempt),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}