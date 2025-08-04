// lib/screens/login_screen.dart (Devrim Versiyonu)

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:interval_walking/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _controllers;
  final List<Widget> _children = [];
  final int _count = 20; // Ekranda gezinecek obje sayısı

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    // Arka plan animasyonları için controller'lar
    _controllers = List.generate(
      _count,
          (index) => AnimationController(
        vsync: this,
        duration: Duration(seconds: Random().nextInt(20) + 10),
      )..repeat(reverse: true),
    );

    // Ekranda gezinen şekilleri oluştur
    for (int i = 0; i < _count; i++) {
      _children.add(
        AnimatedBubble(
          controller: _controllers[i],
          child: Icon(
            i.isEven ? Icons.directions_walk : Icons.timer_outlined,
            color: Colors.white.withOpacity(0.1),
            size: Random().nextDouble() * 40 + 20,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Dinamik Arka Plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A7C7E), Color(0xFF121212)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Gezinen objeler
          ..._children,

          // İçerik
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Giriş Animasyonu
                  _AnimatedEntry(
                    controller: _controller,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.directions_walk,
                          size: 100,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 20)
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Adımlar Geleceğe",
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Kişisel antrenman koçunuzla hedeflerinizi aşmaya hazır olun.",
                          style: textTheme.bodyLarge
                              ?.copyWith(color: Colors.white70, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
                  _AnimatedEntry(
                    controller: _controller,
                    delay: 0.5,
                    child: Column(
                      children: [
                        const Text(
                          "Başlamak için giriş yapın",
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () => authService.signInWithGoogle(),
                          borderRadius: BorderRadius.circular(40),
                          splashColor: Colors.white.withOpacity(0.4),
                          highlightColor: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 15,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/google_logo.png',
                              height: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Ekranda gezinen baloncuklar için yardımcı widget
class AnimatedBubble extends StatelessWidget {
  final AnimationController controller;
  final Widget child;

  const AnimatedBubble({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final random = Random();
    final startPosition =
    Offset(random.nextDouble() * size.width, size.height * 1.2);
    final endPosition =
    Offset(random.nextDouble() * size.width, -size.height * 0.2);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final position =
        Offset.lerp(startPosition, endPosition, controller.value);
        return Positioned(
          left: position?.dx,
          top: position?.dy,
          child: child,
        );
      },
    );
  }
}

// İçeriklerin animasyonlu girişi için yardımcı widget
class _AnimatedEntry extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  final double delay;

  const _AnimatedEntry({
    required this.controller,
    required this.child,
    this.delay = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: controller,
        curve: Interval(0.2 + delay * 0.5, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.2 + delay * 0.5, 1.0, curve: Curves.easeOut),
        )),
        child: child,
      ),
    );
  }
}