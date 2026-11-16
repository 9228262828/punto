import 'package:flutter/material.dart';

import 'ui.dart';

enum PuntoLegalDocument { privacy, terms }

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({
    super.key,
    required this.document,
  });

  final PuntoLegalDocument document;

  bool get _isPrivacy => document == PuntoLegalDocument.privacy;

  @override
  Widget build(BuildContext context) {
    final sections = _isPrivacy ? _privacySections : _termsSections;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isPrivacy ? 'Privacy Policy' : 'Terms & Conditions'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Text(
            'PUNTO — SCORE KEEPER',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: puntoPurple,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _isPrivacy ? 'Privacy Policy' : 'Terms & Conditions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            'Effective date: November 16, 2026',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(.55),
                ),
          ),
          const SizedBox(height: 18),
          Text(
            _isPrivacy
                ? 'This Privacy Policy explains how PUNTO (the App) handles information when you use the PUNTO Score Keeper mobile application.'
                : 'By downloading or using PUNTO (the App), you agree to these Terms & Conditions. If you do not agree, please do not use the App.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55),
          ),
          const SizedBox(height: 22),
          for (final section in sections) ...[
            Text(
              section.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 7),
            Text(
              section.body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.55,
                  ),
            ),
            const SizedBox(height: 20),
          ],
          if (_isPrivacy)
            Text(
              'Note: This policy describes the current offline version of PUNTO. It should be updated if the app later adds online services, analytics, advertising or other data processing.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          const SizedBox(height: 12),
          const SelectableText('Contact: sabahabib5756@gmail.com'),
        ],
      ),
    );
  }
}

class _LegalSection {
  const _LegalSection(this.title, this.body);

  final String title;
  final String body;
}

const _privacySections = <_LegalSection>[
  _LegalSection(
    '1. Information You Enter',
    'PUNTO lets you create scoreboards, enter player names, record scores and view round history. This information is stored locally on your device using on-device storage. The App does not require you to create an account, and the current version does not send your scoreboard information to us or to a remote server.',
  ),
  _LegalSection(
    '2. Data Collection and Sharing',
    'The current version of PUNTO does not operate a backend service and does not collect or transmit your scoreboard data. It does not include advertising SDKs, analytics SDKs or cloud synchronization. We do not sell, rent or share information entered into your scoreboards because that information remains on your device under the current app design.',
  ),
  _LegalSection(
    '3. Local Storage and Your Choices',
    'Your scoreboards, player names, round records and theme preference are saved locally on your device. You can delete an individual scoreboard from within the App, or use Clear all data in Settings to delete all local scoreboards and the saved theme preference. Removing the App or clearing its app data may also remove locally stored information. Please keep your own records if you need a separate backup.',
  ),
  _LegalSection(
    '4. Permissions',
    'PUNTO’s core scorekeeping features do not require access to your contacts, location, camera, microphone or photos.',
  ),
  _LegalSection(
    '5. Children’s Privacy',
    'PUNTO does not knowingly collect personal information from children. The App does not include an account system or a mechanism for sending player names to us. A device user should follow the age and consent requirements that apply in their location.',
  ),
  _LegalSection(
    '6. Security',
    'Because score data is stored locally, the security of the device and its operating-system account settings helps protect that information. No method of electronic storage is completely secure, so use your device’s normal security protections.',
  ),
  _LegalSection(
    '7. Changes to This Policy',
    'We may update this Privacy Policy if the App’s features or data practices change. The updated version will be posted with a revised effective date. If a future version introduces features that collect or transmit information, this policy will be updated to explain those practices before or alongside their release.',
  ),
  _LegalSection(
    '8. Contact Us',
    'If you have questions about this Privacy Policy or PUNTO’s privacy practices, contact us at sabahabib5756@gmail.com.',
  ),
];

const _termsSections = <_LegalSection>[
  _LegalSection(
    '1. About PUNTO',
    'PUNTO is a simple scorekeeping tool that helps users create scoreboards, add players, record points, review rounds and undo the latest saved round.',
  ),
  _LegalSection(
    '2. Your Use of the App',
    'You are responsible for the names and score information you enter. Use the App lawfully and respectfully, and do not use it to harass, threaten or infringe the rights of others.',
  ),
  _LegalSection(
    '3. Local Data',
    'The current version stores scoreboards and preferences locally on your device. You are responsible for maintaining any separate copy of information you want to preserve. Uninstalling the App or clearing its data may remove locally stored scoreboards.',
  ),
  _LegalSection(
    '4. No Guarantee of Data Recovery',
    'PUNTO is provided as a lightweight scorekeeping utility. We do not guarantee that locally stored information can be recovered if your device is lost, damaged, reset or if app data is cleared.',
  ),
  _LegalSection(
    '5. Availability and Changes',
    'We may update, change, suspend or discontinue features of the App when reasonably necessary. We will make reasonable efforts to keep the App useful, but do not guarantee uninterrupted availability or compatibility with every device.',
  ),
  _LegalSection(
    '6. Disclaimer',
    'The App is provided on an “as is” and “as available” basis to the extent permitted by applicable law. PUNTO is a scorekeeping aid; users are responsible for checking that recorded scores are correct and for resolving any disagreements about game rules or results.',
  ),
  _LegalSection(
    '7. Limitation of Liability',
    'To the extent permitted by applicable law, we are not liable for indirect, incidental, special or consequential loss arising from use of the App, including loss of locally stored score data. Nothing in these Terms excludes liability that cannot legally be excluded.',
  ),
  _LegalSection(
    '8. Changes to These Terms',
    'These Terms may be updated from time to time. The latest version will be available with its effective date.',
  ),
  _LegalSection(
    '9. Contact',
    'For questions about these Terms, email sabahabib5756@gmail.com.',
  ),
];

class AboutPuntoScreen extends StatelessWidget {
  const AboutPuntoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About PUNTO')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          const Center(child: PuntoLogo()),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Score Keeper',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.6),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: puntoPurple.withOpacity(.12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: puntoPurple,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Text(
            'Good times. Fair scores.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'PUNTO keeps the score so you can stay focused on the game. Create scoreboards, add players, track every round and see who is leading.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(.7),
                ),
          ),
          const SizedBox(height: 26),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What you can do',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  const _FeatureLine('Create multiple scoreboards'),
                  const _FeatureLine('Keep track of 2 to 8 players'),
                  const _FeatureLine('Add quick or custom points'),
                  const _FeatureLine('Review round history and undo the last round'),
                  const _FeatureLine('Use PUNTO offline on your device'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('Questions or feedback? Reach us at:'),
                  const SizedBox(height: 6),
                  const SelectableText(
                    'sabahabib5756@gmail.com',
                    style: TextStyle(
                      color: puntoPurple,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Made for the moments that matter.',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.45),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: Color(0xFF269B75), size: 19),
          const SizedBox(width: 9),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
