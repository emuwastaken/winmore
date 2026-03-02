import 'package:flutter/material.dart';

import '../widgets/admin_login.dart';
import '../widgets/card_list_panel.dart';
import '../widgets/card_detail_panel.dart';
import '../widgets/card_edit_panel.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 1000;

          if (isNarrow) {
            // Mobile/narrow fallback: stacked sections
            return const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminLogin(),
                  SizedBox(height: 12),
                  CardListPanel(),
                  SizedBox(height: 12),
                  CardDetailPanel(),
                  SizedBox(height: 12),
                  CardEditPanel(),
                  SizedBox(height: 24),
                ],
              ),
            );
          }

          // Desktop/web: 3 columns
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // top bar / login stub
                const SizedBox(height: 72, child: AdminLogin()),
                const SizedBox(height: 16),

                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      // Left column: list + add/search new + delete buttons (later)
                      Expanded(flex: 3, child: CardListPanel()),
                      SizedBox(width: 16),

                      // Center column: big card image + JSON weights/synergies (later)
                      Expanded(flex: 5, child: CardDetailPanel()),
                      SizedBox(width: 16),

                      // Right column: edit weights/synergies + search database add (later)
                      Expanded(flex: 4, child: CardEditPanel()),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}