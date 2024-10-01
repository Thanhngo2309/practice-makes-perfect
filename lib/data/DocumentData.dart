import 'package:myapp/model/Document.dart';

class DocumentData {
  List<Document> documents = [
    Document(
        id: 1,
        title:
            "Chinh phục câu hỏi lý thuyết và kỹ thuật giải nhanh hiện đại môn Vật Lý",
        author: "Chu Văn Biên",
        pages: 633),
    Document(
        id: 2,
        title: "Đề cương ôn tập HK2 Vật lý 12",
        author: "Sưu tầm ",
        pages: 40),
    Document(
        id: 3,
        title: "Phương pháp giải nahnh Vật lý 12",
        author: "Lê Tiến Hà",
        pages: 99)
  ];

  static final DocumentData _instance = DocumentData._internal();

  DocumentData._internal();

  static DocumentData getInstance() {
    return _instance;
  }

  List<Document> getDocuments() {
    return documents;
  }
}
