import 'package:flutter/material.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.admin_panel_settings_outlined),
            const SizedBox(width: 10),
            const Text(
              'WinMore Admin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Spacer(),

            SizedBox(
              width: 220,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 220,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 10),

            ElevatedButton.icon(
              onPressed: () {
                // STUB: wire to /api/admin/login later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login (stub)')),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}