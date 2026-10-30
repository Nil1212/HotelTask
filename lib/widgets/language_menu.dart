import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class LanguageMenu extends StatelessWidget {
  const LanguageMenu({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return PopupMenuButton<Locale>(
      tooltip: strings.changeLanguage,
      onSelected: onLocaleChanged,
      itemBuilder: (context) => [
        PopupMenuItem(value: const Locale('en'), child: Text(strings.english)),
        PopupMenuItem(value: const Locale('km'), child: Text(strings.khmer)),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.translate_rounded,
              size: 20,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              locale.languageCode == 'km' ? 'ខ្មែរ' : 'EN',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
