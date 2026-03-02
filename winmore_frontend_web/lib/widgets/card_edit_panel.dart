import 'package:flutter/material.dart';

class CardEditPanel extends StatelessWidget {
  const CardEditPanel({super.key});

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
              'Edit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: 'Add a new card (name)',
                hintText: 'e.g. Serra Angel',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // STUB: wire to POST /api/admin/cards later
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add card (stub)')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // STUB: open edit dialog later
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit JSON (stub)')),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit JSON'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            const Text(
              'Weights (JSON)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const SingleChildScrollView(
                  child: Text(
                    '{\n'
                        '  "aggro": 3.8,\n'
                        '  "control": 1.5,\n'
                        '  "combo": 0.8\n'
                        '}',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              'Synergies (JSON)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const SingleChildScrollView(
                  child: Text(
                    '{\n'
                        '  "angels": "high",\n'
                        '  "lifegain": "moderate",\n'
                        '  "tokens": "moderate"\n'
                        '}',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // STUB: wire to DELETE /api/admin/cards/{id} later
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delete (stub)')),
                      );
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // STUB: wire to PUT /api/admin/cards/{id} later
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Save (stub)')),
                      );
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}