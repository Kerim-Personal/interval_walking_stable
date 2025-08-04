// lib/screens/login_screen.dart (Doğru ve Final Versiyon)

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:interval_walking/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _sceneAnimationController;
  late AnimationController _contentAnimationController;
  late AnimationController _starAnimationController;
  late AnimationController _personController; // Kişi için ayrı bir controller

  @override
  void initState() {
    super.initState();
    _sceneAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 45),
    )..repeat();

    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    _starAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    // Kişinin yürüme animasyonu için özel, yavaş bir controller
    _personController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // Yürüme süresi (daha yavaş)
    )..repeat();
  }

  @override
  void dispose() {
    _sceneAnimationController.dispose();
    _contentAnimationController.dispose();
    _starAnimationController.dispose();
    _personController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation:
            Listenable.merge([_sceneAnimationController, _starAnimationController, _personController]),
            builder: (context, child) {
              return CustomPaint(
                painter: EnchantedNightPainter(
                  sceneAnimation: _sceneAnimationController,
                  starAnimation: _starAnimationController,
                  personAnimation: _personController, // Yeni controller'ı painter'a iletiyoruz
                ),
                child: Container(),
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -1.5),
                radius: 1.2,
                colors: [
                  const Color.fromRGBO(255, 255, 255, 0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    _AnimatedContent(
                      controller: _contentAnimationController,
                      delay: 0.1,
                      child: Column(
                        children: [
                          Text(
                            "Ufuktaki Maceran",
                            textAlign: TextAlign.center,
                            style: textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 52,
                              letterSpacing: 1.2,
                              shadows: [
                                const Shadow(color: Colors.black, blurRadius: 30),
                                Shadow(
                                    color: Colors.blue.withOpacity(0.5),
                                    blurRadius: 40),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            "Her adım, sadece bir başlangıç.",
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 19,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 4),
                    _AnimatedContent(
                      controller: _contentAnimationController,
                      delay: 0.4,
                      child: Column(
                        children: [
                          const Text(
                            "Yolculuğa Katıl",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 15),
                          _GoogleSignInButton(
                            onTap: () => authService.signInWithGoogle(),
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

class EnchantedNightPainter extends CustomPainter {
  final Animation<double> sceneAnimation;
  final Animation<double> starAnimation;
  final Animation<double> personAnimation; // Kişi animasyonu için

  final Paint roadPaint = Paint()..color = const Color(0xFF1A1A2A);
  final Paint moonPaint = Paint()..color = Colors.white;
  late final Paint moonGlowPaint;
  final List<Star> stars;
  late final Paint starPaint;

  EnchantedNightPainter({
    required this.sceneAnimation,
    required this.starAnimation,
    required this.personAnimation,
  }) : stars = List.generate(200, (index) => Star(index)),
        super(repaint: Listenable.merge([sceneAnimation, starAnimation, personAnimation])) {
    starPaint = Paint()..color = const Color.fromRGBO(255, 255, 255, 0.8);
    moonGlowPaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas, size);
    _drawStars(canvas, size);
    _drawMoon(canvas, size);
    _drawRoad(canvas, size);
    _drawStreetLights(canvas, size);
    _drawSinglePerson(canvas, size);
  }

  // _drawSky, _drawStars, _drawMoon, _drawRoad, _drawStreetLights metotları aynı kalır...
  // (Bu metotlar önceki versiyonlardaki gibi, burada yer kaplamaması için gizlendi)
  void _drawSky(Canvas canvas, Size size) {
    final skyPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, size.height * 0.1),
        Offset(0, size.height * 0.7),
        [const Color(0xFF0F1020), const Color(0xFF2C3E50)],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    final auroraValue = (sceneAnimation.value * 2 * math.pi);
    final auroraPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height * 0.5),
        [
          Colors.transparent,
          Colors.green.withOpacity(0.02 + 0.03 * math.sin(auroraValue)),
          Colors.teal.withOpacity(0.03 + 0.04 * math.cos(auroraValue)),
          Colors.purple.withOpacity(0.02 + 0.03 * math.sin(auroraValue / 2)),
          Colors.transparent,
        ],
        [0.0, 0.3, 0.5, 0.7, 1.0],
      );
    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.25 + 50 * math.sin(auroraValue),
        size.height * 0.3 - 50 * math.cos(auroraValue),
        size.width * 0.5,
        size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.75 - 50 * math.cos(auroraValue),
        size.height * 0.5 + 50 * math.sin(auroraValue),
        size.width,
        size.height * 0.4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, auroraPaint);
  }

  void _drawStars(Canvas canvas, Size size) {
    final starGlow = starAnimation.value;
    for (var star in stars) {
      final opacity = star.baseOpacity * (0.5 + starGlow * 0.5);
      starPaint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(star.position * size.width, star.radius, starPaint);

      if (star.isShooting) {
        star.updateShooting(sceneAnimation.value);
        if (star.shootingProgress > 0 && star.shootingProgress < 1) {
          final tailPaint = Paint()
            ..shader = ui.Gradient.linear(
                star.shootingStart * size.width,
                star.shootingEnd * size.width,
                [Colors.white.withOpacity(opacity * 0.8), Colors.transparent]);
          canvas.drawLine(star.shootingStart * size.width,
              star.shootingEnd * size.width, tailPaint..strokeWidth = star.radius * 2);
        }
      }
    }
  }

  void _drawMoon(Canvas canvas, Size size) {
    final moonPosition = Offset(size.width * 0.85, size.height * 0.15);
    final moonRadius = size.width * 0.08;
    canvas.drawCircle(moonPosition, moonRadius, moonGlowPaint);
    canvas.drawCircle(moonPosition, moonRadius, moonPaint);
  }

  void _drawRoad(Canvas canvas, Size size) {
    final horizonY = size.height * 0.45;
    final centerX = size.width / 2;

    final path = Path();
    path.moveTo(centerX - size.width * 2, size.height);
    path.lineTo(centerX, horizonY);
    path.lineTo(centerX + size.width * 2, size.height);
    path.close();
    canvas.drawPath(path, roadPaint);
  }

  void _drawStreetLights(Canvas canvas, Size size) {
    final horizonY = size.height * 0.45;
    const lightCount = 8;

    for (int i = 0; i < lightCount; i++) {
      final depth = i / (lightCount - 1.0);
      final perspective = 0.1 + math.pow(depth, 2) * 0.9;
      final y = horizonY + (size.height - horizonY) * math.pow(depth, 2);

      final side = i.isEven ? -1 : 1;
      final x = size.width / 2 + (side * size.width * 0.1) + (side * perspective * size.width * 0.3);

      if (y < size.height) {
        final poleHeight = size.height * 0.2 * perspective;
        final lightRadius = 6 * perspective;
        final lightCenter = Offset(x, y - poleHeight);

        final polePaint = Paint()
          ..color = Colors.black.withOpacity(0.4)
          ..strokeWidth = 3 * perspective;
        canvas.drawLine(Offset(x, y), lightCenter, polePaint);

        final lightGlowPaint = Paint()
          ..color = Colors.amber.withOpacity(0.5)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15 * perspective);
        canvas.drawCircle(lightCenter, lightRadius * 3, lightGlowPaint);

        final lightPaint = Paint()..color = Colors.yellow.shade200;
        canvas.drawCircle(lightCenter, lightRadius, lightPaint);

        final groundLightPath = Path();
        groundLightPath.addOval(Rect.fromCenter(
            center: Offset(x, y + 5 * perspective),
            width: 100 * perspective,
            height: 20 * perspective));
        final groundLightPaint = Paint()
          ..color = Colors.yellow.withOpacity(0.1 * (1-depth))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
        canvas.drawPath(groundLightPath, groundLightPaint);
      }
    }
  }


  void _drawSinglePerson(Canvas canvas, Size size) {
    // *** TEMEL MANTIK HATASI DÜZELTİLDİ ***
    // Animasyonun tersine çevrilmesi: 1.0'dan başlayıp 0.0'a gitmesi sağlanıyor.
    // Böylece figür AŞAĞIDAN (büyük) YUKARIYA (küçük) doğru yürüyor.
    final double t = 1.0 - personAnimation.value;

    // Figürü yolun tam ortasında çizmek için lane = 0.
    _drawPersonSilhouette(canvas, size, t, 0);
  }

  void _drawPersonSilhouette(Canvas canvas, Size size, double t, double lane) {
    final horizonY = size.height * 0.45;
    final y = horizonY + (size.height * 0.55) * math.pow(t, 2);
    final perspective = 0.05 + t * 0.95;
    final x = size.width / 2 + (lane * size.width * 0.4 * t);

    final bodyHeight = 40 * perspective;

    // Yürüme döngüsü genel sahne animasyonunun hızına bağlı
    final walkCycle = sceneAnimation.value * 20;
    final legSwing = math.sin(walkCycle) * (bodyHeight * 0.4);
    final armSwing = math.cos(walkCycle) * (bodyHeight * 0.3);
    final bodyBob = (math.cos(walkCycle * 2) + 1) * (bodyHeight * 0.05);

    if (y < size.height && y > horizonY) { // Sadece yol üzerinde ise çiz
      final paint = Paint()
        ..color = Colors.black.withOpacity(0.8) // Görünür bir renk
        ..style = PaintingStyle.fill;

      final personPath = Path();
      final headRadius = bodyHeight * 0.18;
      final headPos = Offset(x, y - bodyHeight * 0.85 - bodyBob);
      personPath.addOval(Rect.fromCircle(center: headPos, radius: headRadius));

      final torsoTop = Offset(x, y - bodyHeight * 0.8 - bodyBob);
      final torsoBottom = Offset(x, y - bodyHeight * 0.4 - bodyBob);
      personPath.moveTo(torsoTop.dx - bodyHeight * 0.15, torsoTop.dy);
      personPath.lineTo(torsoTop.dx + bodyHeight * 0.15, torsoTop.dy);
      personPath.lineTo(torsoBottom.dx + bodyHeight * 0.1, torsoBottom.dy);
      personPath.lineTo(torsoBottom.dx - bodyHeight * 0.1, torsoBottom.dy);
      personPath.close();

      final legPath = Path();
      legPath.moveTo(torsoBottom.dx, torsoBottom.dy);
      legPath.lineTo(torsoBottom.dx + legSwing, torsoBottom.dy + bodyHeight * 0.5);
      legPath.moveTo(torsoBottom.dx, torsoBottom.dy);
      legPath.lineTo(torsoBottom.dx - legSwing, torsoBottom.dy + bodyHeight * 0.5);

      final armPath = Path();
      armPath.moveTo(torsoTop.dx, torsoTop.dy);
      armPath.lineTo(torsoTop.dx + armSwing, torsoTop.dy + bodyHeight * 0.4);
      armPath.moveTo(torsoTop.dx, torsoTop.dy);
      armPath.lineTo(torsoTop.dx - armSwing, torsoTop.dy + bodyHeight * 0.4);

      canvas.drawPath(personPath, paint);
      final strokePaint = Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(legPath, strokePaint..strokeWidth=bodyHeight*0.1);
      canvas.drawPath(armPath, strokePaint..strokeWidth=bodyHeight*0.08);
    }
  }

  @override
  bool shouldRepaint(covariant EnchantedNightPainter oldDelegate) => true;
}


// Star, _GoogleSignInButton, ve _AnimatedContent sınıfları değişmeden kalır.
class Star {
  final int index;
  late final Offset position;
  late final double radius;
  late final double baseOpacity;
  late final bool isShooting;
  double shootingProgress = 0.0;
  late Offset shootingStart;
  late Offset shootingEnd;

  Star(this.index) {
    final random = math.Random(index);
    position = Offset(random.nextDouble(), random.nextDouble() * 0.45);
    radius = 0.5 + random.nextDouble() * 1.5;
    baseOpacity = 0.3 + random.nextDouble() * 0.5;
    isShooting = random.nextDouble() > 0.995;
    if (isShooting) {
      shootingStart = position;
      shootingEnd =
          position + Offset(random.nextDouble() * 0.2 - 0.1, random.nextDouble() * 0.1);
    }
  }

  void updateShooting(double animationValue) {
    final random = math.Random(index);
    shootingProgress = (animationValue * (1 + random.nextDouble())) % 1.0;
  }
}

class _GoogleSignInButton extends StatefulWidget {
  final VoidCallback onTap;
  const _GoogleSignInButton({required this.onTap});

  @override
  State<_GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<_GoogleSignInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _glowAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(50),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          final glowValue = _glowAnimation.value;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3 + glowValue * 0.3),
                  blurRadius: 15 + glowValue * 15,
                  spreadRadius: 2 + glowValue * 3,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Image.asset('assets/google_logo.png', height: 40),
      ),
    );
  }
}

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
        curve: Interval(0.4 + delay, 1.0, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.7),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.4 + delay, 1.0, curve: Curves.decelerate),
        )),
        child: child,
      ),
    );
  }
}