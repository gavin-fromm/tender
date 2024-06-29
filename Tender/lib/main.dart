import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user-interface/admin/admin_page.dart';
import 'user-interface/home_page.dart';
import 'user-interface/user-functions/login_page.dart';
import 'back-end/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(MyApp());
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) return _pageForUser(session.user);
          return LoginPage();
        }
        final session = snapshot.data!.session;
        if (session != null) return _pageForUser(session.user);
        return LoginPage();
      },
    );
  }

  Widget _pageForUser(User user) {
    if (user.email == 'admin@admin.com') return AdminPage();
    return HomePage();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const AuthGate(),
    );
  }

  ThemeData _buildTheme() {
    const primary = Color(0xFFE8120C);
    const background = Color(0xFFFAF9F6);
    const textPrimary = Color(0xFF1C1917);
    const textSecondary = Color(0xFF78716C);
    const borderColor = Color(0xFFE7E5E4);

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Oswald',
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        surface: Colors.white,
        onSurface: textPrimary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Oswald',
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0EFEB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        labelStyle: const TextStyle(
          fontFamily: 'Oswald',
          color: textSecondary,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Oswald',
          color: Color(0xFFA8A29E),
          fontWeight: FontWeight.w300,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade200,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: 'Oswald',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: borderColor, width: 1.5),
          textStyle: const TextStyle(
            fontFamily: 'Oswald',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: textSecondary,
        titleTextStyle: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: 0.3,
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          fontFamily: 'Oswald',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Oswald',
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: textSecondary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: const TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w500),
      ),
    );
  }
}
