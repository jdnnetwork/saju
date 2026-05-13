import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/theme.dart';
import '../models/character.dart';
import '../utils/sound.dart';
import '../widgets/glass_card.dart';
import 'intro_screen.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key, required this.topCharacter});

  final Character topCharacter;

  void _toStart(BuildContext context) {
    playClickSound();
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => const IntroScreen(),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.elementColor(topCharacter.group);

    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pastel),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('생활명리'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🙏',
                      style: TextStyle(
                        fontSize: 64,
                        color: Colors.black.withOpacity(0.85),
                      ),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.6, 0.6),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(duration: 500.ms),
                    const SizedBox(height: 16),
                    Text(
                      '감사합니다!',
                      style: AppText.title(size: 30),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 12),
                    Text(
                      '소중한 의견은 더 나은 설문으로\n돌아오겠습니다',
                      style: AppText.body(size: 14, color: AppColors.textSecondary)
                          .copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 350.ms, duration: 500.ms),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color.withOpacity(0.25)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '오늘의 결과',
                            style: AppText.caption(size: 11, color: color)
                                .copyWith(fontWeight: FontWeight.w800, letterSpacing: 1),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            topCharacter.name,
                            style: AppText.title(size: 20, color: color),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            topCharacter.code,
                            style: AppText.caption(size: 11, color: color)
                                .copyWith(letterSpacing: 2),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
                    const SizedBox(height: 32),
                    _RestartButton(onTap: () => _toStart(context))
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 500.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RestartButton extends StatefulWidget {
  const _RestartButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_RestartButton> createState() => _RestartButtonState();
}

class _RestartButtonState extends State<_RestartButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF2D5A8B)],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: -2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                '처음으로',
                style: AppText.body(size: 16, color: Colors.white)
                    .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
