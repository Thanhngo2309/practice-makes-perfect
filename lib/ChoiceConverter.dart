import 'dart:collection';

import 'package:myapp/model/Choice.dart';

class ChoiceConverter {
  static Choice convert(LinkedHashMap<String,dynamic> map){
    return Choice(map['label']!, map['content']!, map['image']!);
  }
  static convertToRaw(String label, String image, String content) {
    return Choice(label, content, image);
  }
}