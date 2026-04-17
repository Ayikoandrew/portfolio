import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../providers/scroll_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/articles_list_screen.dart';

class NavBar extends ConsumerStatefulWidget {
  const NavBar({super.key});

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: theme.scaffoldBackgroundColor.withValues(alpha: 0.85),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 40,
            vertical: 14,
          ),
          child: Row(
            children: [
              // Logo
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: AppColors.gradientColors,
                ).createShader(bounds),
                child: Text(
                  'AA',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),

              if (isMobile)
                _MobileMenuButton(ref: ref)
              else
                _DesktopNavLinks(ref: ref),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopNavLinks extends StatelessWidget {
  final WidgetRef ref;
  const _DesktopNavLinks({required this.ref});

  @override
  Widget build(BuildContext context) {
    final sectionKeys = ref.read(sectionKeysProvider);
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in AppConstants.navItems)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              onPressed: () {
                if (item == 'Articles') {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const ArticlesListScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                  return;
                }
                final key = sectionKeys[item];
                if (key != null) scrollToSection(key);
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.textTheme.bodyMedium?.color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              child: Text(item),
            ),
          ),
        const SizedBox(width: 8),
        _ThemeToggle(ref: ref),
      ],
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final WidgetRef ref;
  const _MobileMenuButton({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ThemeToggle(ref: ref),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _showMobileMenu(context),
        ),
      ],
    );
  }

  void _showMobileMenu(BuildContext context) {
    final sectionKeys = ref.read(sectionKeysProvider);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              for (final item in AppConstants.navItems)
                ListTile(
                  title: Text(item, textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                    if (item == 'Articles') {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const ArticlesListScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  ),
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                      return;
                    }
                    final key = sectionKeys[item];
                    if (key != null) scrollToSection(key);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final WidgetRef ref;
  const _ThemeToggle({required this.ref});

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => RotationTransition(
          turns: Tween(begin: 0.75, end: 1.0).animate(anim),
          child: child,
        ),
        child: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          key: ValueKey(isDark),
          size: 22,
        ),
      ),
      onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
    );
  }
}
