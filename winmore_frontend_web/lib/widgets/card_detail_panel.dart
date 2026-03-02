import 'package:flutter/material.dart';

class CardDetailPanel extends StatelessWidget {
  const CardDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selected Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Big image placeholder
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('Card Image (stub)'),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              flex: 4,
              child: Row(
                children: [
                  // Weights
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weights', style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(height: 8),
                          Text('Aggro: 3.8'),
                          Text('Control: 1.5'),
                          Text('Combo: 0.8'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Synergies
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Synergies', style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(height: 8),
                          Text('Angels: High'),
                          Text('Lifegain: Moderate'),
                          Text('Tokens: Moderate'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                // STUB: selection/edit flow later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Open editor (stub)')),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Weights & Synergies'),
            ),
          ],
        ),
      ),
    );
  }
}