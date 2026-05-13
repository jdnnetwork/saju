import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/sound.dart';
import 'result_screen.dart';
import 'survey_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final int _respondentNumber;
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _respondentNumber = 1000 + math.Random().nextInt(9000);

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0.0, end: -16.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _onStart() {
    playClickSound();
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => SurveyScreen(
          respondentNumber: _respondentNumber,
          onComplete: (result) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (_, _, _) => ResultScreen(
                  respondentNumber: _respondentNumber,
                  answers: result.answers,
                  responseTimesMs: result.responseTimesMs,
                ),
                transitionsBuilder: (_, anim, _, child) =>
                    FadeTransition(opacity: anim, child: child),
              ),
            );
          },
        ),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final bp = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _bg(),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _topText(sh),
              _orbSection(sw, sh),
              _ctaButton(sw, bp),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // 배경 그라데이션
  // ────────────────────────────────────────────────────────────
  BoxDecoration _bg() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF5EEF8),
          Color(0xFFF2ECF5),
          Color(0xFFEDE5F0),
          Color(0xFFF0E8EF),
          Color(0xFFEDE8F0),
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // 상단 텍스트 영역
  // ────────────────────────────────────────────────────────────
  Widget _topText(double sh) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(height: sh * 0.07),
          Text(
            '생활 명리',
            style: GoogleFonts.notoSansKr(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF8B6CAF),
              letterSpacing: 4,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(
                begin: -0.3,
                end: 0,
                duration: 600.ms,
                delay: 200.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 20),
          Text(
            '나는 어떤\n사람일까?',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
              height: 1.25,
              letterSpacing: -0.5,
            ),
          )
              .animate()
              .fadeIn(duration: 700.ms, delay: 400.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 700.ms,
                delay: 400.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 24),
          Text(
            '2분 설문 조사로\n나의 현재와 미래를 파악하세요',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF555555),
              height: 1.6,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 600.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                delay: 600.ms,
                curve: Curves.easeOutCubic,
              ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // 중앙 구체 + 받침대
  // ────────────────────────────────────────────────────────────
  Widget _orbSection(double sw, double sh) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 반짝이는 점 4개
          Positioned(
            left: sw * 0.12,
            top: 30,
            child: _sparkle(5.0, const Color(0x50FFFFFF), 0),
          ),
          Positioned(
            right: sw * 0.15,
            top: 50,
            child: _sparkle(4.0, const Color(0x40FFFFFF), 800),
          ),
          Positioned(
            left: sw * 0.08,
            bottom: 100,
            child: _sparkle(3.0, const Color(0x35FFFFFF), 1600),
          ),
          Positioned(
            right: sw * 0.10,
            bottom: 80,
            child: _sparkle(6.0, const Color(0x45FFFFFF), 2400),
          ),

          // 구체 + 받침대
          GestureDetector(
            onTap: () => playClickSound(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'asset/image/gu.png',
                    width: sw * 0.58,
                    fit: BoxFit.contain,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 500.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.0, 1.0),
                      duration: 800.ms,
                      delay: 500.ms,
                      curve: Curves.easeOutBack,
                    ),
                Transform.translate(
                  offset: const Offset(0, -25),
                  child: Image.asset(
                    'asset/image/bat.png',
                    width: sw * 0.65,
                    fit: BoxFit.contain,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 700.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sparkle(double size, Color color, int delayMs) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: size * 3,
            spreadRadius: size * 0.5,
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(duration: 2000.ms, delay: delayMs.ms)
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.3, 1.3),
          duration: 4000.ms,
          delay: delayMs.ms,
        );
  }

  // ────────────────────────────────────────────────────────────
  // 하단 CTA
  // ────────────────────────────────────────────────────────────
  Widget _ctaButton(double sw, double bp) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, bp + 36),
      child: GestureDetector(
        onTap: _onStart,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFA78BBF),
                    Color(0xFFCC95A8),
                    Color(0xFFD4A0B0),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40A78BBF),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '2분 설문 조사 해보기',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(color: Colors.transparent)
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(
                      duration: 2500.ms,
                      delay: 1500.ms,
                      color: Colors.white.withOpacity(0.12),
                    ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 600.ms, delay: 900.ms)
          .slideY(
            begin: 0.3,
            end: 0,
            duration: 600.ms,
            delay: 900.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}
