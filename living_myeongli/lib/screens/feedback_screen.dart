import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/theme.dart';
import '../models/character.dart';
import '../services/supabase_service.dart';
import '../utils/sound.dart';
import '../widgets/glass_card.dart';
import 'thankyou_screen.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({
    super.key,
    required this.userId,
    required this.topCharacter,
  });

  final String? userId;
  final Character topCharacter;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  static const _questions = <(String, String)>[
    ('naturalness', '설문이 전반적으로 자연스러웠나요?'),
    ('accuracy', '결과가 나와 잘 맞는다고 느꼈나요?'),
    ('clarity', '문항 중 이해하기 어려운 것이 있었나요?'),
    ('length', '설문 길이는 적당했나요?'),
  ];

  final Map<String, int> _stars = {};
  final TextEditingController _commentCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  bool get _canSubmit =>
      !_submitting && _stars.length == _questions.length;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    playClickSound();
    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      if (widget.userId != null) {
        final svc = SupabaseService(Supabase.instance.client);
        await svc.saveFeedback(
          userId: widget.userId!,
          naturalness: _stars['naturalness'],
          accuracy: _stars['accuracy'],
          clarity: _stars['clarity'],
          length: _stars['length'],
          comment: _commentCtrl.text.trim().isEmpty
              ? null
              : _commentCtrl.text.trim(),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, _, _) => ThankYouScreen(topCharacter: widget.topCharacter),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = '제출 실패: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pastelAlt),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('생활명리'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              playClickSound();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '피드백 남기기',
                  style: AppText.title(size: 26),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 8),
                Text(
                  '솔직한 의견이 다음 설문을 더 잘 만듭니다',
                  style: AppText.caption(size: 13),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                const SizedBox(height: 20),
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < _questions.length; i++) ...[
                        if (i > 0) ...[
                          const SizedBox(height: 18),
                          Container(
                            height: 1,
                            color: AppColors.textSecondary.withOpacity(0.15),
                          ),
                          const SizedBox(height: 18),
                        ],
                        _StarRow(
                          label: _questions[i].$2,
                          value: _stars[_questions[i].$1],
                          onChanged: (v) => setState(
                            () => _stars[_questions[i].$1] = v,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: (200 + 80 * i).ms, duration: 400.ms)
                            .slideY(begin: 0.1, end: 0),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '자유의견 (선택)',
                        style: AppText.body(size: 14)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _commentCtrl,
                        maxLines: 4,
                        maxLength: 500,
                        style: AppText.body(size: 14),
                        decoration: InputDecoration(
                          hintText: '결과·문항·UI 등 무엇이든 좋아요',
                          hintStyle: AppText.caption(size: 13),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.55),
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _error!,
                      style: AppText.caption(size: 12, color: AppColors.fire),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _SubmitButton(
                  enabled: _canSubmit,
                  submitting: _submitting,
                  onTap: _submit,
                ),
                if (!_canSubmit && !_submitting)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '4개 별점을 모두 선택해주세요',
                      style: AppText.caption(size: 11),
                      textAlign: TextAlign.center,
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

class _StarRow extends StatelessWidget {
  const _StarRow({required this.label, required this.value, required this.onChanged});
  final String label;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.body(size: 14)
              .copyWith(fontWeight: FontWeight.w700, height: 1.4),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (var i = 1; i <= 5; i++)
              GestureDetector(
                onTap: () {
                  playClickSound();
                  onChanged(i);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedScale(
                    scale: (value ?? 0) >= i ? 1.0 : 0.92,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      (value ?? 0) >= i ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 34,
                      color: (value ?? 0) >= i
                          ? AppColors.accent
                          : AppColors.textSecondary.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SubmitButton extends StatefulWidget {
  const _SubmitButton({
    required this.enabled,
    required this.submitting,
    required this.onTap,
  });
  final bool enabled;
  final bool submitting;
  final VoidCallback onTap;

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled;
    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      onTap: disabled ? null : widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedOpacity(
          opacity: disabled ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF2D5A8B)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(disabled ? 0.1 : 0.3),
                  blurRadius: 20,
                  spreadRadius: -2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: widget.submitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    '제출하기',
                    style: AppText.body(size: 16, color: Colors.white)
                        .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                  ),
          ),
        ),
      ),
    );
  }
}
