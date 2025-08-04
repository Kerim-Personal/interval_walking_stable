// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:interval_walking/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authService = AuthService();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.directions_walk,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  "Aralıklı Yürüyüş'e Hoş Geldiniz",
                  style: textTheme.headlineSmall?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Antrenmanlarınızı takip etmek ve hedeflerinize ulaşmak için giriş yapın.",
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 70),
                ElevatedButton.icon(
                  onPressed: () {
                    authService.signInWithGoogle();
                  },
                  icon: Image.asset('assets/google_logo.png', height: 24.0), // Google logosu için
                  label: const Text("Google ile Giriş Yap"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}