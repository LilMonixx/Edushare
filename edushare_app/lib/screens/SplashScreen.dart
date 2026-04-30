import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'HomeScreen.dart';



class SplashScreen extends StatefulWidget {




  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Stage controllers
  late AnimationController _glowController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _loadingController;
  late AnimationController _exitController;

  // Animations
  late Animation<double> _glowScale;
  late Animation<double> _glowOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoSlide;
  late Animation<double> _sparkleScale;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineOpacity;
  late Animation<double> _loadingOpacity;
  late Animation<double> _exitOpacity;
  late Animation<double> _exitScale;

  int _stage = 0;

  // Theme colors
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color backgroundColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF1A1A1A);
  static const Color borderColor = Color(0xFF2A2A2A);
  static const Color foregroundColor = Color(0xFFFAFAFA);
  static const Color mutedColor = Color(0xFF737373);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _glowScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeOut),
    );
    _glowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeOut),
    );

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
    _sparkleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _loadingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeOut),
    );

    // Exit animation
    _exitController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _exitOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );
    _exitScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _stage = 1);
    _glowController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _stage = 2);
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _stage = 3);
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _stage = 4);
    _loadingController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _stage = 5);
    _exitController.forward();

    await Future.delayed(const Duration(milliseconds: 500));

// gọi API refresh token
    //   await AuthService.refreshToken();

// 🔥 tránh crash
    if (!mounted) return;
//
// // navigate sang Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _loadingController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background glow effect
          Center(
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Opacity(
                  opacity: _glowOpacity.value,
                  child: Transform.scale(
                    scale: _glowScale.value,
                    child: Container(
                      width: 256,
                      height: 256,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.2),
                            blurRadius: 100,
                            spreadRadius: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Secondary glow rings
          if (_stage >= 2) ...[
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: Container(
                        width: 320,
                        height: 320,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryGreen.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: Container(
                        width: 384,
                        height: 384,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryGreen.withOpacity(0.05),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Main content
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_logoController, _exitController]),
              builder: (context, child) {
                return Opacity(
                  opacity: _stage >= 5 ? 1 - _exitOpacity.value : _logoOpacity.value,
                  child: Transform.scale(
                    scale: _stage >= 5 ? _exitScale.value : _logoScale.value,
                    child: SlideTransition(
                      position: _logoSlide,
                      child: child,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo with floating particles
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // App icon
                      Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: borderColor, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: primaryGreen.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: _buildBookIcon(),
                        ),
                      ),

                      // Sparkle badge
                      Positioned(
                        top: -4,
                        right: -4,
                        child: AnimatedBuilder(
                          animation: _logoController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _sparkleScale.value,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: backgroundColor,
                            ),
                          ),
                        ),
                      ),

                      // Floating particles
                      if (_stage >= 3) ...[
                        _buildFloatingParticle(-8, -8, 8, 0),
                        _buildFloatingParticle(100, 90, 6, 0.5),
                        _buildFloatingParticle(-16, 50, 4, 0.3),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // App name
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacity.value,
                        child: SlideTransition(
                          position: _textSlide,
                          child: child,
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'Edu',
                            style: TextStyle(color: primaryGreen),
                          ),
                          TextSpan(
                            text: 'Share',
                            style: TextStyle(color: foregroundColor),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _taglineOpacity.value,
                        child: child,
                      );
                    },
                    child: const Text(
                      'Learn together, grow together',
                      style: TextStyle(
                        fontSize: 14,
                        color: mutedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _loadingController,
              builder: (context, child) {
                return Opacity(
                  opacity: _stage >= 5 ? 0 : _loadingOpacity.value,
                  child: child,
                );
              },
              child: _buildLoadingDots(),
            ),
          ),

          // Exit fade overlay
          if (_stage >= 5)
            AnimatedBuilder(
              animation: _exitController,
              builder: (context, child) {
                return Opacity(
                  opacity: _exitOpacity.value,
                  child: Container(color: backgroundColor),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBookIcon() {
    return CustomPaint(
      size: const Size(56, 56),
      painter: BookIconPainter(color: primaryGreen),
    );
  }

  Widget _buildFloatingParticle(double left, double top, double size, double delay) {
    return Positioned(
      left: left,
      top: top,
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          final t = (_particleController.value + delay) % 1.0;
          final offset = math.sin(t * 2 * math.pi) * 6;
          return Transform.translate(
            offset: Offset(offset * 0.5, offset),
            child: child,
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: primaryGreen,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1400),
          builder: (context, value, child) {
            final delay = index * 0.2;
            final t = ((value + delay) % 1.0);
            final scale = 1.0 + 0.2 * math.sin(t * 2 * math.pi);
            final opacity = 0.3 + 0.7 * math.sin(t * 2 * math.pi).abs();
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: primaryGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class BookIconPainter extends CustomPainter {
  final Color color;

  BookIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Book shape
    final scale = size.width / 24;

    // Book cover path
    path.moveTo(6.5 * scale, 2 * scale);
    path.lineTo(20 * scale, 2 * scale);
    path.lineTo(20 * scale, 22 * scale);
    path.lineTo(6.5 * scale, 22 * scale);
    path.quadraticBezierTo(4 * scale, 22 * scale, 4 * scale, 19.5 * scale);
    path.lineTo(4 * scale, 4.5 * scale);
    path.quadraticBezierTo(4 * scale, 2 * scale, 6.5 * scale, 2 * scale);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);

    // Bottom page line
    final bottomPath = Path();
    bottomPath.moveTo(4 * scale, 19.5 * scale);
    bottomPath.quadraticBezierTo(4 * scale, 17 * scale, 6.5 * scale, 17 * scale);
    bottomPath.lineTo(20 * scale, 17 * scale);
    canvas.drawPath(bottomPath, paint);

    // Text lines
    final linePaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(8 * scale, 7 * scale),
      Offset(16 * scale, 7 * scale),
      linePaint,
    );
    canvas.drawLine(
      Offset(8 * scale, 11 * scale),
      Offset(14 * scale, 11 * scale),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}