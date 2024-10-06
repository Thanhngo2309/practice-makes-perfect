import 'package:flutter/material.dart';
import 'package:myapp/model/dto/QuestionResponse.dart';

class QuestionCardWidget extends StatelessWidget {
  final QuestionResponse question;
  final String? selectedLabel;
  final Function(String, QuestionResponse) onSelect;
  final Function goBack;
  final Function next;

  QuestionCardWidget(this.question, this.selectedLabel, this.onSelect, this.goBack, this.next, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the question text
            Text(
              question.questionText,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16),
            ),
            // image for question
            question.imagePath != ''
              ? Center(
                  child: Image.network(question.imagePath!),
                )
              : const SizedBox(),
            const SizedBox(height: 10),

            Column(
              children: question.choices.map((choice) {
                bool isSelected = choice.label == selectedLabel; 
                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.blue : const Color.fromARGB(0, 249, 96, 96), 
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () => onSelect(choice.label, question),
                            child: Text(
                              choice.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black, 
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Display choice content
                      Expanded(
                        child: Row(
                          children: [
                            // Display choice image if available
                            if (choice.image != null && choice.image!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                // image for choice
                                child: Image.network(
                                  choice.image!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Text(" ${choice.content}")
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Navigation buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => goBack(),
                    child: const Text('Quay lại'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => next(),
                    child: const Text('Next'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}