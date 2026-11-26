import 'package:flutter/material.dart';

const supportEmail = String.fromEnvironment('BERRY_BUDDY_SUPPORT_EMAIL');

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'About NoteWeave',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 14),
      Card(
        color: Colors.white,
        child: Column(
          children: [
            _section(
              Icons.privacy_tip_outlined,
              'Privacy Policy',
              'NoteWeave: Berry Buddy does not ask for an account or collect personal '
                  'information through the game. This build has no ads, '
                  'analytics, or in-app purchases. Your pet’s progress is held '
                  'in the current game session and resets when you restart the app.',
            ),
            _section(
              Icons.description_outlined,
              'Terms & Conditions',
              'NoteWeave: Berry Buddy is a virtual pet game for personal entertainment. '
                  'Food, health, and other game items are virtual and have no '
                  'cash value. Access to this test build is free. Restarting '
                  'the app starts a new game session.',
            ),
            _section(
              Icons.mail_outline_rounded,
              'Contact Us',
              supportEmail.isEmpty
                  ? 'This test build has no support email configured. Send '
                        'feedback to the person who shared this build with you.'
                  : 'For support or feedback, email $supportEmail.',
            ),
          ],
        ),
      ),
    ],
  );

  Widget _section(IconData icon, String title, String body) => ExpansionTile(
    key: PageStorageKey(title),
    shape: const Border(),
    leading: Icon(icon),
    title: Text(title),
    childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    children: [SelectionArea(child: Text(body))],
  );
}
