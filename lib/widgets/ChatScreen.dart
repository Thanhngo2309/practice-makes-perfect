import 'package:flutter/material.dart';

class ChatSreen extends StatefulWidget {
  ChatSreen({super.key});
  TextEditingController textEditingController = TextEditingController();

  @override
  State<ChatSreen> createState() => ChatSreenState();
}

class ChatSreenState extends State<ChatSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/");
        },
        child: const Text("Go Back"),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Hello World"),
            TextField(
              controller: widget.textEditingController,
              decoration: const InputDecoration(
                labelText: 'Hỏi Chat GPT',
              ),
            )
          ],
        ),
      ),
    );
  }
}
