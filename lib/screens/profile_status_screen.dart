import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class ProfileStatusScreen extends StatelessWidget {
  const ProfileStatusScreen({
    super.key,
    required this.title,
    required this.message,
    required this.onSignOut,
  });

  final String title;
  final String message;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shield_outlined, size: 42),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      onPressed: onSignOut,
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(strings.signOut),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
