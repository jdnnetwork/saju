import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/theme.dart';
import '../data/questions.dart';
import '../models/character.dart';
import '../services/scoring_service.dart';
import '../services/supabase_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/score_bar.dart';
import 'feedback_screen.dart';
import 'home_dashboard_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.respondentNumber,
    required this.answers,
    required this.responseTimesMs,
  });

  final int respondentNumber;
  final Map<String, int> answers;
  final Map<String, int> responseTimesMs;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final ScoringResult _result;
  String? _userId;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _result = ScoringService().score(questions, widget.answers);
    _persist();
  }

  Future<void> _persist() async {
    try {
      final svc = SupabaseService(Supabase.instance.client);
      final id = await svc.createUser(respondentNumber: widget.respondentNumber);
      await svc.saveResult(
        userId: id,
        answers: widget.answers,
        result: _result,
        responseTimes: widget.responseTimesMs,
      );
      if (mounted) setState(() => _userId = id);
    } catch (e) {
      if (mounted) setState(() => _saveError = e.toString());
    }
  }

  void _onFeedback() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, _, _) => FeedbackScreen(
          userId: _userId,
          topCharacter: _result.top.character,
        ),
        transitionsBuilder: (_, anim, _, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
      ),
    );
  }

  void _onManageMyeongli() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => HomeDashboardScreen(
          elementScores: _result.elementScores,
          characterName: _result.top.character.name,
          characterCode: _result.top.code,
        ),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = _result.top.character;
    final groupColor = AppColors.elementColor(top.group);

    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pastel),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('생활명리'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroCard(character: top, color: groupColor, code: _result.top.code),
                const SizedBox(height: 16),
                _BadgesRow(
                  group: top.group,
                  season: top.season,
                  confidence: _result.confidence,
                ),
                const SizedBox(height: 20),
                _DistributionCard(
                  title: '오행 기질 분포',
                  entries: [
                    for (var i = 0; i < elementOrder.length; i++)
                      (
                        elementOrder[i],
                        elementNames[elementOrder[i]] ?? elementOrder[i],
                        _result.elementNorm[elementOrder[i]] ?? 0.0,
                        AppColors.elementColor(elementOrder[i]),
                        i,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _DistributionCard(
                  title: '계절 기질 분포',
                  entries: [
                    for (var i = 0; i < seasonOrder.length; i++)
                      (
                        seasonOrder[i],
                        seasonNames[seasonOrder[i]] ?? seasonOrder[i],
                        _result.seasonNorm[seasonOrder[i]] ?? 0.0,
                        AppColors.seasonColor(seasonOrder[i]),
                        i,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                _Top3Section(matches: _result.top3),
                const SizedBox(height: 20),
                _ShadowCard(shadow: top.shadow),
                const SizedBox(height: 24),
                if (_saveError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      '저장 실패: $_saveError',
                      style: AppText.caption(size: 11, color: AppColors.fire),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _PrimaryCTAButton(onTap: _onManageMyeongli),
                const SizedBox(height: 8),
                _SecondaryFeedbackButton(onTap: _onFeedback),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.character, required this.color, required this.code});
  final Character character;
  final Color color;
  final String code;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              code,
              style: AppText.caption(size: 12, color: color)
                  .copyWith(fontWeight: FontWeight.w800, letterSpacing: 2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            character.name,
            style: AppText.title(size: 30, color: color),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 14),
          Text(
            character.identity,
            style: AppText.body(size: 14, color: AppColors.textSecondary)
                .copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final s in character.strengths)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withOpacity(0.25)),
                  ),
                  child: Text(
                    s,
                    style: AppText.caption(size: 12, color: color)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ).animate().fadeIn(delay: 450.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({
    required this.group,
    required this.season,
    required this.confidence,
  });
  final String group;
  final String season;
  final Confidence confidence;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _badge(elementNames[group] ?? group, AppColors.elementColor(group)),
        const SizedBox(width: 8),
        _badge(seasonNames[season] ?? season, AppColors.seasonColor(season)),
        const SizedBox(width: 8),
        _badge('신뢰도 · ${confidence.label}', AppColors.accent),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: AppText.caption(size: 11, color: color)
            .copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.title, required this.entries});

  /// (key, label, value 0~1, color, index for stagger)
  final List<(String, String, double, Color, int)> entries;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppText.heading(size: 16, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          for (final e in entries)
            ScoreBar(
              label: e.$2,
              value: e.$3,
              color: e.$4,
              delay: Duration(milliseconds: 100 * e.$5),
            ),
        ],
      ),
    );
  }
}

class _Top3Section extends StatelessWidget {
  const _Top3Section({required this.matches});
  final List<CharacterMatch> matches;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'TOP 3 후보 캐릭터',
            style: AppText.heading(size: 16, color: AppColors.primary),
          ),
        ),
        for (var i = 0; i < matches.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.elementColor(matches[i].character.group)
                          .withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: AppText.body(
                        size: 14,
                        color: AppColors.elementColor(matches[i].character.group),
                      ).copyWith(fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          matches[i].character.name,
                          style: AppText.body(size: 15)
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          matches[i].character.code,
                          style: AppText.caption(size: 11)
                              .copyWith(letterSpacing: 1.5),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(matches[i].score.clamp(0, 1) * 100).round()}%',
                    style: AppText.body(
                      size: 14,
                      color: AppColors.elementColor(matches[i].character.group),
                    ).copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: (200 + 120 * i).ms, duration: 400.ms)
                .slideX(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
          ),
      ],
    );
  }
}

class _ShadowCard extends StatelessWidget {
  const _ShadowCard({required this.shadow});
  final String shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFE4B5).withOpacity(0.55),
            const Color(0xFFFFD0A0).withOpacity(0.45),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌑', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '그림자',
                  style: AppText.caption(size: 11, color: AppColors.accent)
                      .copyWith(fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                const SizedBox(height: 4),
                Text(
                  shadow,
                  style: AppText.body(size: 14)
                      .copyWith(fontWeight: FontWeight.w700, height: 1.4),
                ),
                const SizedBox(height: 4),
                Text(
                  '균형이 무너졌을 때 드러나는 모습입니다',
                  style: AppText.caption(size: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryCTAButton extends StatefulWidget {
  const _PrimaryCTAButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_PrimaryCTAButton> createState() => _PrimaryCTAButtonState();
}

class _PrimaryCTAButtonState extends State<_PrimaryCTAButton> {
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
          width: double.infinity,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9C7CB8), Color(0xFFD4A0B0)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x339C7CB8),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Text(
            '✨ 내 사주명리 관리하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(
              duration: 2000.ms,
              color: Colors.white.withOpacity(0.3),
            ),
      ),
    );
  }
}

class _SecondaryFeedbackButton extends StatelessWidget {
  const _SecondaryFeedbackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 44,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: const Text(
          '📝 베타 피드백 남기기',
          style: TextStyle(
            color: Color(0xFF888888),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
