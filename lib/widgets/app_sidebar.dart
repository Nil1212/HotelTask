import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.selectedPage,
    required this.onPageSelected,
    required this.onLogout,
  });

  final int selectedPage;
  final ValueChanged<int> onPageSelected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      width: 252,
      color: const Color(0xFF141326),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 18, 30),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF7058F5), Color(0xFFB44BEE)],
                      ),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'HotelTask',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 12, 10),
              child: Text(
                strings.workspace,
                style: TextStyle(
                  color: Color(0xFF7F8AA6),
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _NavItem(
              icon: Icons.grid_view_rounded,
              label: strings.dashboard,
              selected: selectedPage == 0,
              onTap: () => onPageSelected(0),
            ),
            _NavItem(
              icon: Icons.task_alt_rounded,
              label: strings.tasks,
              selected: selectedPage == 1,
              onTap: () => onPageSelected(1),
            ),
            _NavItem(
              icon: Icons.people_alt_outlined,
              label: strings.staff,
              selected: selectedPage == 2,
              onTap: () => onPageSelected(2),
            ),
            _NavItem(
              icon: Icons.meeting_room_outlined,
              label: strings.rooms,
              selected: selectedPage == 3,
              onTap: () => onPageSelected(3),
            ),
            _NavItem(
              icon: Icons.bar_chart_rounded,
              label: strings.reports,
              selected: selectedPage == 4,
              onTap: () => onPageSelected(4),
            ),
            const Spacer(),
            const Divider(color: Color(0xFF2A344C), indent: 20, endIndent: 20),
            _NavItem(
              icon: Icons.settings_outlined,
              label: strings.settings,
              enabled: false,
            ),
            _NavItem(
              icon: Icons.logout_rounded,
              label: strings.logout,
              onTap: onLogout,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 22),
              child: Text(
                'HOTELTASK • DEMO',
                style: TextStyle(color: Color(0xFF66718B), fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.enabled = true,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: selected ? const Color(0xFF382C63) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          dense: true,
          leading: Icon(
            icon,
            size: 19,
            color: !enabled
                ? const Color(0xFF59637A)
                : selected
                ? Colors.white
                : const Color(0xFF9BA5BA),
          ),
          title: Text(
            label,
            style: TextStyle(
              color: !enabled
                  ? const Color(0xFF59637A)
                  : selected
                  ? Colors.white
                  : const Color(0xFFB0B8C9),
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          onTap: enabled ? onTap : null,
        ),
      ),
    );
  }
}
