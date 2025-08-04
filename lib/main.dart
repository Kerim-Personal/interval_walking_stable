// lib/main.dart (Güncellenmiş Hali)

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interval_walking/screens/login_screen.dart';
import 'package:interval_walking/screens/walking_screen.dart';
import 'package:interval_walking/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firebase'i başlatmak için main fonksiyonunu async yap
Future<void> main() async {
  // Flutter binding'lerinin hazır olduğundan emin ol
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase'i başlat
  await Firebase.initializeApp();
  runApp(const IntervalWalkingApp());
}

class IntervalWalkingApp extends StatelessWidget {
  const IntervalWalkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema kodunuz burada (değişiklik yok)
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0A7C7E),
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0A7C7E),
        secondary: Color(0xFFE57373),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontFamily: 'sans-serif', fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.white),
        displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: TextStyle(fontSize: 85.0, fontWeight: FontWeight.w200, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 20.0, color: Colors.white70),
        labelLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A7C7E),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: Colors.white70)),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.white.withAlpha(26))),
      ),
    );

    return MaterialApp(
      title: 'Aralıklı Yürüyüş',
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      // Ana ekranı AuthWrapper ile değiştiriyoruz
      home: const AuthWrapper(),
    );
  }
}

// YENİ WIDGET: Kullanıcı giriş durumuna göre yönlendirme yapar
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        // Bağlantı bekleniyorsa yükleme ekranı göster
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        // Kullanıcı giriş yapmışsa ana ekrana yönlendir
        if (snapshot.hasData) {
          return const WalkingScreen();
        }
        // Kullanıcı giriş yapmamışsa giriş ekranına yönlendir
        return const LoginScreen();
      },
    );
  }
}