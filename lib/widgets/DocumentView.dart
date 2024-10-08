import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myapp/data/DocumentData.dart';

class DocumentView extends StatelessWidget {
  final int documentId;

  DocumentView({Key? key, required this.documentId}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Không thể mở URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Viewer'),
      ),
      body: FutureBuilder<String>(
        future: DocumentData.getInstance().getDocumentUrl(documentId),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi lấy URL: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            String urlDocument = snapshot.data!;
            return Center(
              child: ElevatedButton(
                onPressed: () => _launchURL(urlDocument),
                child: Text('Trên trình duyệt'),
              ),
            );
          } else {
            return Center(child: Text('Không tìm thấy tài liệu'));
          }
        },
      ),
    );
  }
}
