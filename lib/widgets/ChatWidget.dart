import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/GeminiApiKey.dart';
import '../model/Message.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isResponding = false;
  final List<Message> _messages = [];
  static String? _geminiApiKey = GeminiApiKey.geminiApiKey;

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    print(_controller.text);

    final userMessage = _controller.text;
    setState(() {
      _messages.add(Message(true, userMessage));
      _isResponding = true;
    });
    _controller.clear();

    try {
      // Tạo body cho request
      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": userMessage}
            ]
          }
        ]
      });

      // Gửi request POST
      final response = await http.post(
        Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${_geminiApiKey}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: body, // Sử dụng body đã tạo
      );

      print(response.body);

        final jsonResponse = jsonDecode(response.body);
        final aiMessage = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _messages.add(Message(false, aiMessage));
          _isResponding = false;
        });
    } catch (e) {
      print('Error in _sendMessage: $e'); // In lỗi ra console
      setState(() {
        _isResponding = false;
        _messages.add(
            Message(false, "Error: Unable to get response. Please try again."));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            color: Colors.grey[200],
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ListTile(
                  title: Align(
                    alignment: message.isSender
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            message.isSender ? Colors.blue[100] : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(message.msg),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (_isResponding)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("AI is typing...",
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
