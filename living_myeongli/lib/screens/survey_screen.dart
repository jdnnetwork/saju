import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/theme.dart';
import '../data/questions.dart';
import '../models/question.dart';
import '../utils/sound.dart';
import '../widgets/forced_option.dart';
import '../widgets/glass_card.dart';
import '../widgets/image_option.dart';
import '../widgets/scale_slider.dart';

class SurveyResult {
  final Map<String, int> answers;
  final Map<String, int> responseTimesMs;
  const SurveyResult({required this.answers, required this.responseTimesMs});
}

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key, required this.respondentNumber, this.onComplete});

  final int respondentNumber;
  final void Function(SurveyResult result)? onComplete;

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int _index = 0;
  final Map<String, int> _answers = {};
  final Map<String, int> _times = {};
  final Map<String, List<int>> _shuffledOrder = {};
  late DateTime _questionStart;
  bool _backUsed = false;

  @override
  void initState() {
    super.initState();
    _shuffleForcedQuestions();
    _questionStart = DateTime.now();
  }

  void _shuffleForcedQuestions() {
    final r = math.Random(widget.respondentNumber);
    for (final q in questions) {
      if (q.type == QuestionType.forced) {
        final order = List<int>.generate(q.options.length, (i) => i)..shuffle(r);
        _shuffledOrder[q.id] = order;
      } else {
        _shuffledOrder[q.id] = List<int>.generate(q.options.length, (i) => i);
      }
    }
  }

  Question get _current => questions[_index];

  void _saveAnswer(int displayIdx) {
    final q = _current;
    final originalIndex = (q.type == QuestionType.forced)
        ? _shuffledOrder[q.id]![displayIdx]
        : displayIdx;
    setState(() {
      _answers[q.id] = originalIndex;
      _times[q.id] = DateTime.now().difference(_questionStart).inMilliseconds;
    });
  }

  Future<void> _advance() async {
    if (_index < questions.length - 1) {
      await Future.delayed(const Duration(milliseconds: 220));
      if (!mounted) return;
      setState(() {
        _index++;
        _questionStart = DateTime.now();
      });
    } else {
      _complete();
    }
  }

  Future<void> _selectAndAdvance(int displayIdx) async {
    _saveAnswer(displayIdx);
    await _advance();
  }

  void _complete() {
    final result = SurveyResult(
      answers: Map<String, int>.from(_answers),
      responseTimesMs: Map<String, int>.from(_times),
    );
    if (widget.onComplete != null) {
      widget.onComplete!(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('설문 완료 — 응답 ${result.answers.length}/18'),
          duration: const Duration(milliseconds: 2000),
        ),
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  void _onBack() {
    playClickSound();
    if (_index == 0) {
      Navigator.of(context).pop();
      return;
    }
    if (_backUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('뒤로가기는 1회만 가능합니다'),
          duration: Duration(milliseconds: 1500),
        ),
      );
      return;
    }
    setState(() {
      _backUsed = true;
      _index--;
      _questionStart = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _current;
    final progress = (_index + 1) / questions.length;
    final selectedDisplayIdx = _selectedDisplayIndex(q);

    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pastelAlt),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('생활명리'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: _backUsed && _index > 0
                  ? AppColors.textSecondary.withOpacity(0.4)
                  : AppColors.primary,
            ),
            onPressed: _onBack,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                _ProgressHeader(
                  progress: progress,
                  current: _index + 1,
                  total: questions.length,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 320),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.06, 0),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            ),
                            child: _QuestionCard(
                              key: ValueKey(q.id),
                              question: q,
                              selectedDisplayIndex: selectedDisplayIdx,
                              shuffledOrder: _shuffledOrder[q.id]!,
                              onTapOption: _selectAndAdvance,
                              onScaleChanged: _saveAnswer,
                              onScaleConfirm: _advance,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int? _selectedDisplayIndex(Question q) {
    final original = _answers[q.id];
    if (original == null) return null;
    if (q.type == QuestionType.forced) {
      final order = _shuffledOrder[q.id]!;
      return order.indexOf(original);
    }
    return original;
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.progress,
    required this.current,
    required this.total,
  });

  final double progress;
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  color: Colors.white.withOpacity(0.45),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$current/$total',
          style: AppText.caption(size: 13, color: AppColors.primary)
              .copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    super.key,
    required this.question,
    required this.selectedDisplayIndex,
    required this.shuffledOrder,
    required this.onTapOption,
    required this.onScaleChanged,
    required this.onScaleConfirm,
  });

  final Question question;
  final int? selectedDisplayIndex;
  final List<int> shuffledOrder;
  final ValueChanged<int> onTapOption;
  final ValueChanged<int> onScaleChanged;
  final VoidCallback onScaleConfirm;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.text,
            style: AppText.title(size: 21).copyWith(height: 1.4),
            textAlign: TextAlign.center,
          ),
          if (question.sub.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              question.sub,
              style: AppText.caption(size: 13),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (question.type) {
      case QuestionType.image:
        return _ImageGrid(
          question: question,
          selectedIndex: selectedDisplayIndex,
          onSelect: onTapOption,
        );
      case QuestionType.forced:
        return Column(
          children: [
            for (var i = 0; i < shuffledOrder.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              ForcedOption(
                option: question.options[shuffledOrder[i]],
                selected: selectedDisplayIndex == i,
                onTap: () => onTapOption(i),
              )
                  .animate()
                  .fadeIn(delay: (60 * i).ms, duration: 300.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
            ],
          ],
        );
      case QuestionType.scale:
        return Column(
          children: [
            ScaleSlider(
              labels: question.scaleLabels ?? const [],
              value: selectedDisplayIndex,
              onChanged: onScaleChanged,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedDisplayIndex == null
                    ? null
                    : () {
                        playClickSound();
                        onScaleConfirm();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      AppColors.textSecondary.withOpacity(0.25),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: AppText.body(size: 16, color: Colors.white)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                child: const Text('다음'),
              ),
            ),
          ],
        );
    }
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  final Question question;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final opts = question.options;
    final firstFour = opts.take(4).toList();
    final lastOne = opts.length > 4 ? opts[4] : null;

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: firstFour.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, i) => ImageOption(
            option: firstFour[i],
            selected: selectedIndex == i,
            onTap: () => onSelect(i),
          )
              .animate()
              .fadeIn(delay: (60 * i).ms, duration: 280.ms)
              .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1)),
        ),
        if (lastOne != null) ...[
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ImageOption(
                  option: lastOne,
                  selected: selectedIndex == 4,
                  onTap: () => onSelect(4),
                )
                    .animate()
                    .fadeIn(delay: 240.ms, duration: 280.ms)
                    .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1)),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
