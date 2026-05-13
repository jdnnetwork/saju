import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/theme.dart';
import '../services/supabase_service.dart';
import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _connStatus = '';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final svc = SupabaseService(Supabase.instance.client);
    final res = await svc.ping();
    if (!mounted) return;
    setState(() => _connStatus = res.message);

    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, _, _) => const IntroScreen(),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.splash),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '생활명리',
                  style: AppText.title(size: 48, color: Colors.white),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1.0, 1.0),
                      duration: 800.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .fadeIn(duration: 800.ms),
                const SizedBox(height: 12),
                Text(
                  'LIVING MYEONGLI',
                  style: AppText.body(
                    size: 14,
                    color: Colors.white.withOpacity(0.85),
                  ).copyWith(letterSpacing: 4, fontWeight: FontWeight.w500),
                ).animate().fadeIn(delay: 500.ms, duration: 700.ms),
                const SizedBox(height: 48),
                if (_connStatus.isNotEmpty)
                  Text(
                    _connStatus,
                    style: AppText.caption(
                      size: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
