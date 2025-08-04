// lib/screens/login_screen.dart (Ufka Yürüyüş Versiyonu)

import 'package:flutter/material.dart';
import 'package:interval_walking/services/auth_service.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _contentAnimationController;

  @override
  void initState() {
    super.initState();
    // Ana sahne animasyonu için controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Animasyon süresini uzattık
    )..repeat();

    // İçeriklerin giriş animasyonu için controller
    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: Stack(
        children: [
          // Hareketli Sahne (Yol, İnsanlar, Gökyüzü)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: ScenePainter(animation: _animationController),
                child: Container(),
              );
            },
          ),
          // Işık ve gölge efektleri için gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -1.2),
                radius: 1.5,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Ana İçerik
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    // Animasyonlu başlık ve metinler
                    _AnimatedContent(
                      controller: _contentAnimationController,
                      child: Column(
                        children: [
                          Text(
                            "Kendi Yolunu Çiz",
                            textAlign: TextAlign.center,
                            style: textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 46,
                              letterSpacing: 1.1,
                              shadows: [
                                const Shadow(color: Colors.black, blurRadius: 25)
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Her gün, hedeflerine doğru atacağın yeni bir adımdır.",
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 4),
                    // Giriş Butonu
                    _AnimatedContent(
                      controller: _contentAnimationController,
                      delay: 0.2,
                      child: Column(
                        children: [
                          const Text(
                            "Hemen Başla",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 15),
                          InkWell(
                            onTap: () => authService.signInWithGoogle(),
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.4),
                                    blurRadius: 25,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Image.asset('assets/google_logo.png', height: 40),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Tüm sahneyi çizen CustomPainter
class ScenePainter extends CustomPainter {
  final Animation<double> animation;
  final Paint roadPaint = Paint()..color = const Color(0xFF212121);
  final Paint linePaint = Paint()..color = Colors.white.withOpacity(0.15);
  final Paint skyPaint = Paint()
    ..shader = const LinearGradient(
      colors: [Color(0xFFE57373), Color(0xFF0A7C7E)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, 0, 500, 400));

  ScenePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final horizonY = size.height * 0.4;

    // Gökyüzü
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, horizonY), skyPaint);

    // Yol
    final path = Path();
    path.moveTo(centerX - size.width * 1.5, size.height);
    path.lineTo(centerX, horizonY);
    path.lineTo(centerX + size.width * 1.5, size.height);
    path.close();
    canvas.drawPath(path, roadPaint);

    // Yol çizgileri
    const lineCount = 20;
    for (int i = 0; i < lineCount; i++) {
      final animationValue = (animation.value + (i / lineCount)) % 1.0;
      final y = horizonY + (size.height - horizonY) * (animationValue * animationValue);
      final perspective = 0.5 + animationValue * 0.5;
      if (y < size.height) {
        final paint = Paint()
          ..color = Colors.white.withOpacity(0.2 * (1 - animationValue))
          ..strokeWidth = 4 * perspective;
        canvas.drawLine(
          Offset(centerX - 10 * perspective, y),
          Offset(centerX + 10 * perspective, y),
          paint,
        );
      }
    }

    // Yürüyen insanlar
    const peopleCount = 15;
    for (int i = 0; i < peopleCount; i++) {
      final animationValue = (animation.value + (i / peopleCount)) % 1.0;
      _drawPerson(canvas, size, animationValue, i);
    }
  }

  void _drawPerson(Canvas canvas, Size size, double animationValue, int index) {
    final random = math.Random(index);
    final lane = (random.nextDouble() - 0.5) * 2; // -1 (sol) ile 1 (sağ) arası
    final speed = 0.5 + random.nextDouble() * 0.5;

    final t = (animationValue * speed) % 1.0;

    final y = size.height * 0.4 + (size.height * 0.6) * (t*t);
    final perspective = 0.1 + t * 0.9;
    final x = size.width / 2 + (lane * size.width * 0.6 * t);

    // Yürüme animasyonu için bacak salınımı
    final legSwing = math.sin(animation.value * 20 + random.nextDouble() * math.pi) * 8 * perspective;

    if (y < size.height) {
      final paint = Paint()..color = Colors.black.withOpacity(0.8 * (1 - t));
      final bodyHeight = 30 * perspective;
      final headRadius = 6 * perspective;

      // Kafa
      canvas.drawCircle(Offset(x, y - bodyHeight), headRadius, paint);
      // Gövde
      canvas.drawLine(Offset(x, y - bodyHeight + headRadius), Offset(x, y), paint..strokeWidth = 4 * perspective);
      // Bacaklar
      canvas.drawLine(Offset(x, y), Offset(x - legSwing, y + bodyHeight * 0.8), paint);
      canvas.drawLine(Offset(x, y), Offset(x + legSwing, y + bodyHeight * 0.8), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ScenePainter oldDelegate) => true;
}

// İçeriklerin animasyonlu girişi (Değişiklik yok)
class _AnimatedContent extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  final double delay;

  const _AnimatedContent({
    required this.controller,
    required this.child,
    this.delay = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: controller,
        curve: Interval(0.5 + delay, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.5 + delay, 1.0, curve: Curves.decelerate),
        )),
        child: child,
      ),
    );
  }
}