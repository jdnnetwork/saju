import 'package:flutter/material.dart';

import '../config/theme.dart';

/// 수평 바 차트 한 줄. 화면에 그려질 때 0 → value 까지 애니메이션.
class ScoreBar extends StatefulWidget {
  const ScoreBar({
    super.key,
    required this.label,
    required this.value, // 0.0 ~ 1.0 (clamp 처리)
    required this.color,
    this.delay = Duration.zero,
    this.showPercent = true,
  });

  final String label;
  final double value;
  final Color color;
  final Duration delay;
  final bool showPercent;

  @override
  State<ScoreBar> createState() => _ScoreBarState();
}

class _ScoreBarState extends State<ScoreBar> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    final clamped = widget.value.clamp(0.0, 1.0);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)
        .drive(Tween(begin: 0.0, end: clamped));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: AppText.body(size: 13).copyWith(fontWeight: FontWeight.w700),
              ),
              if (widget.showPercent)
                AnimatedBuilder(
                  animation: _anim,
                  builder: (context, _) => Text(
                    '${(_anim.value * 100).round()}%',
                    style: AppText.caption(size: 12, color: widget.color)
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(height: 10, color: Colors.white.withOpacity(0.5)),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (context, _) => FractionallySizedBox(
                    widthFactor: _anim.value,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color,
                            widget.color.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
