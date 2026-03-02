import 'package:flutter/material.dart';

class CardListPanel extends StatelessWidget {
  const CardListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text('Card Database', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Expanded(
              child: Center(child: Text('Card list + delete buttons (stub)')),
            ),
          ],
        ),
      ),
    );
  }
}