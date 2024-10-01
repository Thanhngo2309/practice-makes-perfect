import 'package:flutter/material.dart';

import '../model/Document.dart';

class DocumentItem extends StatelessWidget {
  final Document document;
  const DocumentItem({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(document.title),
      Row(
        children: [
          const Icon(Icons.person, size: 16, color: Colors.purple,),
          const SizedBox(width: 4),
          Text(document.author, style: const TextStyle(color: Colors.purple),),
          const SizedBox(width: 10),
          const Icon(Icons.pages, size: 16, color: Colors.purple,),
          const SizedBox(width: 4),
          Text('${document.pages} trang', style: const TextStyle(color: Colors.purple),),
        ],
      ),
    ]);
  }
}
