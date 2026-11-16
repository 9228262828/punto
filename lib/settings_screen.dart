import 'package:flutter/material.dart';

import 'legal_screen.dart';
import 'store.dart';
import 'ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = PuntoStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: puntoPurple,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.settings_rounded,
                      color: Colors.white, size: 27),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Make PUNTO yours',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          )),
                      SizedBox(height: 4),
                      Text('Manage your app preferences and information.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.35,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionLabel('Appearance'),
          const SizedBox(height: 10),
          Card(
            child: SwitchListTile(
              value: store.isDarkMode,
              onChanged: store.setDarkMode,
              secondary: Icon(
                store.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: puntoPurple,
              ),
              title: const Text('Dark mode',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              subtitle: const Text('Choose a comfortable look for PUNTO.'),
            ),
          ),
          const SizedBox(height: 24),
          const SectionLabel('Legal & information'),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'How PUNTO stores and handles your data.',
                  onTap: () => _openLegal(context, PuntoLegalDocument.privacy),
                ),
                const Divider(height: 1, indent: 58),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle: 'Rules and conditions for using the app.',
                  onTap: () => _openLegal(context, PuntoLegalDocument.terms),
                ),
                const Divider(height: 1, indent: 58),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About PUNTO',
                  subtitle: 'App information, features and contact details.',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AboutPuntoScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionLabel('Data management'),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.delete_sweep_outlined,
                          color: Color(0xFFE06B69)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Clear all data',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Delete every scoreboard, player name, saved score and round history from this device.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.45,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.65),
                        ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmClearAll(context),
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Clear all data'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE06B69),
                        side: const BorderSide(color: Color(0x55E06B69)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: Text(
              'PUNTO · Score Keeper',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.45),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  void _openLegal(BuildContext context, PuntoLegalDocument document) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LegalDocumentScreen(document: document),
      ),
    );
  }

  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded,
            color: Color(0xFFE06B69), size: 34),
        title: const Text('Clear all app data?'),
        content: const Text(
          'This permanently deletes all scoreboards, player names, scores, round history and your saved theme preference from this device. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE06B69),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await PuntoStore.instance.clearAllData();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All local app data has been cleared.')),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: puntoPurple),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
