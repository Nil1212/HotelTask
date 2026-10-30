import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'language_menu.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.compact,
    required this.userEmail,
    required this.onSignOut,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.locale,
    required this.onLocaleChanged,
    this.onMenuPressed,
  });

  final bool compact;
  final String userEmail;
  final VoidCallback onSignOut;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context)!;

    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 30),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          if (compact)
            IconButton(onPressed: onMenuPressed, icon: const Icon(Icons.menu)),
          const Spacer(),
          LanguageMenu(locale: locale, onLocaleChanged: onLocaleChanged),
          IconButton(
            tooltip: isDarkMode ? strings.switchToLight : strings.switchToNight,
            onPressed: onThemeToggle,
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: colors.onSurfaceVariant,
            ),
          ),
          IconButton(
            tooltip: strings.notifications,
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 28, color: colors.outlineVariant),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            tooltip: strings.accountMenu,
            onSelected: (value) {
              if (value == 'signOut') onSignOut();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'signOut',
                child: Row(
                  children: [
                    const Icon(Icons.logout_rounded, size: 18),
                    const SizedBox(width: 10),
                    Text(strings.signOut),
                  ],
                ),
              ),
            ],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colors.primaryContainer,
                  child: Text(
                    userEmail.isEmpty ? '?' : userEmail[0].toUpperCase(),
                    style: TextStyle(
                      color: colors.onPrimaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(width: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 190),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userEmail,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          strings.signedIn,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(width: 5),
                Icon(Icons.keyboard_arrow_down, color: colors.onSurfaceVariant),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
