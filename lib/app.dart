import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_status_screen.dart';
import 'screens/staff_task_screen.dart';
import 'services/auth_service.dart';
import 'services/user_profile_service.dart';
import 'models/user_profile.dart';
import 'l10n/app_localizations.dart';

class HotelTaskApp extends StatefulWidget {
  const HotelTaskApp({super.key});

  @override
  State<HotelTaskApp> createState() => _HotelTaskAppState();
}

class _HotelTaskAppState extends State<HotelTaskApp> {
  bool _isDarkMode = false;
  bool _isReadOnlyDemo = false;
  Locale _locale = const Locale('en');
  bool _localeLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final languageCode = await SharedPreferencesAsync().getString(
        'hotelTask.languageCode',
      );
      if (!mounted) return;
      setState(() {
        if (languageCode != null &&
            (languageCode == 'en' || languageCode == 'km')) {
          _locale = Locale(languageCode);
        }
        _localeLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _localeLoaded = true);
    }
  }

  Future<void> _changeLocale(Locale locale) async {
    setState(() => _locale = locale);
    try {
      await SharedPreferencesAsync().setString(
        'hotelTask.languageCode',
        locale.languageCode,
      );
    } catch (_) {
      // Keep the language change active for this session if saving fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightColors =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF7058F5),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF7058F5),
          onPrimary: Colors.white,
          secondary: const Color(0xFF079E9A),
          tertiary: const Color(0xFFED6680),
        );
    final darkColors =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFFAA9BFF),
          brightness: Brightness.dark,
          surface: const Color(0xFF1B1A2B),
        ).copyWith(
          primary: const Color(0xFFAA9BFF),
          onPrimary: const Color(0xFF21174D),
          secondary: const Color(0xFF63D8CA),
          tertiary: const Color(0xFFFF9AAC),
        );

    return MaterialApp(
      title: 'HotelTask',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('km')],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColors,
        scaffoldBackgroundColor: const Color(0xFFF7F6FC),
        fontFamily: _locale.languageCode == 'km'
            ? GoogleFonts.battambang().fontFamily
            : 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColors,
        scaffoldBackgroundColor: const Color(0xFF11111D),
        fontFamily: _locale.languageCode == 'km'
            ? GoogleFonts.battambang().fontFamily
            : 'Roboto',
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: StreamBuilder<User?>(
        stream: AuthService.instance.authStateChanges,
        builder: (context, snapshot) {
          final strings = AppLocalizations.of(context)!;
          if (!_localeLoaded) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text(strings.authStateError)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (_isReadOnlyDemo) {
            return DashboardScreen(
              userEmail: strings.portfolioDemo,
              onSignOut: () => setState(() => _isReadOnlyDemo = false),
              isDarkMode: _isDarkMode,
              onToggleTheme: () => setState(() => _isDarkMode = !_isDarkMode),
              locale: _locale,
              onLocaleChanged: _changeLocale,
              isReadOnlyDemo: true,
            );
          }

          final user = snapshot.data;
          if (user == null) {
            return LoginScreen(
              onLocaleChanged: _changeLocale,
              onExploreDemo: () => setState(() => _isReadOnlyDemo = true),
            );
          }

          return StreamBuilder<UserProfile?>(
            stream: UserProfileService.instance.watchProfile(user.uid),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.hasError) {
                return ProfileStatusScreen(
                  title: strings.profileLoadTitle,
                  message: strings.profileLoadMessage,
                  onSignOut: () => AuthService.instance.signOut(),
                );
              }
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final profile = profileSnapshot.data;
              if (profile == null) {
                return ProfileStatusScreen(
                  title: strings.profileNotFoundTitle,
                  message: strings.noStaffProfile,
                  onSignOut: () => AuthService.instance.signOut(),
                );
              }

              if (profile.role == UserRole.staff) {
                return StaffTaskScreen(
                  uid: user.uid,
                  displayName: profile.displayName,
                  onSignOut: () => AuthService.instance.signOut(),
                  locale: _locale,
                  onLocaleChanged: _changeLocale,
                );
              }

              if (profile.role != UserRole.manager) {
                return ProfileStatusScreen(
                  title: strings.roleNotSetTitle,
                  message: strings.roleNotSetMessage,
                  onSignOut: () => AuthService.instance.signOut(),
                );
              }

              return DashboardScreen(
                userEmail: profile.email.isEmpty
                    ? user.email ?? strings.signedIn
                    : profile.email,
                onSignOut: () => AuthService.instance.signOut(),
                isDarkMode: _isDarkMode,
                onToggleTheme: () => setState(() => _isDarkMode = !_isDarkMode),
                locale: _locale,
                onLocaleChanged: _changeLocale,
              );
            },
          );
        },
      ),
    );
  }
}
