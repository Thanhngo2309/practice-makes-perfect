import 'package:flutter/material.dart';
import 'package:myapp/widgets/DocumentView.dart';
import '../data/DocumentData.dart';
import '../model/Document.dart';
import 'DocumentItem.dart';

class DocumentScreen extends StatelessWidget {
  final List<Document> documents;

  DocumentScreen({super.key})
      : documents = DocumentData.getInstance().getDocuments();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentView(documentId: documents[index].id)));
                    },
                    child: DocumentItem(document: documents[index]),
                  ));
            },
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemCount: documents.length));
  }
}
