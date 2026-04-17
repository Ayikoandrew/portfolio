import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _floatController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  bool _showTypewriter = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _fadeController.forward();
    });

    // Start typewriter after fade-in completes
    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _showTypewriter = true);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final screenHeight = MediaQuery.sizeOf(context).height;

    return SizedBox(
      width: double.infinity,
      height: screenHeight,
      child: Stack(
        children: [
          // Background gradient
          _GradientBackground(
            isDark: isDark,
            floatController: _floatController,
          ),

          // Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 40),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.contentMaxWidth(context),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, I\'m',
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 18 : 22,
                            fontWeight: FontWeight.w400,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_showTypewriter)
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                AppConstants.name,
                                textStyle: theme.textTheme.displayLarge
                                    ?.copyWith(
                                      fontSize: isMobile ? 42 : 72,
                                      color: isDark
                                          ? AppColors.darkText
                                          : AppColors.lightText,
                                    ),
                                speed: const Duration(milliseconds: 120),
                              ),
                            ],
                            repeatForever: true,
                            pause: const Duration(milliseconds: 2000),
                            displayFullTextOnTap: true,
                          )
                        else
                          SizedBox(height: isMobile ? 50 : 86),
                        const SizedBox(height: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: AppColors.gradientColors,
                          ).createShader(bounds),
                          child: Text(
                            AppConstants.tagline,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: isMobile ? 22 : 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Text(
                            AppConstants.heroSubtitle,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: isMobile ? 15 : 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),

                        // CTA Buttons
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _launch(AppConstants.githubUrl),
                              icon: const Icon(Icons.code, size: 20),
                              label: const Text('View Projects'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () =>
                                  _launch('mailto:andrewayiko15@gmail.com'),
                              icon: const Icon(Icons.mail_outline, size: 20),
                              label: const Text('Email Me'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Social links
                        Row(
                          children: [
                            _SocialButton(
                              icon: Icons.code,
                              tooltip: 'GitHub',
                              onTap: () => _launch(AppConstants.githubUrl),
                            ),
                            const SizedBox(width: 12),
                            _SocialButton(
                              icon: Icons.person,
                              tooltip: 'LinkedIn',
                              onTap: () => _launch(AppConstants.linkedInUrl),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Scroll indicator
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Center(
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 8 * _floatController.value),
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 32,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

class _GradientBackground extends StatelessWidget {
  final bool isDark;
  final AnimationController floatController;

  const _GradientBackground({
    required this.isDark,
    required this.floatController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: floatController,
      builder: (context, _) {
        final t = floatController.value;
        return CustomPaint(
          size: size,
          painter: _BlobPainter(isDark: isDark, animationValue: t),
        );
      },
    );
  }
}

class _BlobPainter extends CustomPainter {
  final bool isDark;
  final double animationValue;

  _BlobPainter({required this.isDark, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()
      ..color = isDark ? AppColors.darkBg : AppColors.lightBg;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Gradient blobs
    final blob1 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.08),
              AppColors.primary.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(
                size.width * 0.7 + 30 * sin(animationValue * pi * 2),
                size.height * 0.3 + 20 * cos(animationValue * pi * 2),
              ),
              radius: size.width * 0.35,
            ),
          );

    final blob2 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.accent.withValues(alpha: isDark ? 0.1 : 0.06),
              AppColors.accent.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(
                size.width * 0.2 + 20 * cos(animationValue * pi * 2),
                size.height * 0.6 + 30 * sin(animationValue * pi * 2),
              ),
              radius: size.width * 0.3,
            ),
          );

    canvas.drawRect(Offset.zero & size, blob1);
    canvas.drawRect(Offset.zero & size, blob2);

    // Subtle grid dots
    final dotPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03);
    const spacing = 40.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_BlobPainter old) =>
      old.animationValue != animationValue || old.isDark != isDark;
}
