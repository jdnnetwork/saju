import 'package:flutter/material.dart';

import '../config/theme.dart';

class ScaleSlider extends StatefulWidget {
  const ScaleSlider({
    super.key,
    required this.labels,
    required this.value,
    required this.onChanged,
  });

  /// 0 ~ labels.length-1
  final int? value;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  State<ScaleSlider> createState() => _ScaleSliderState();
}

class _ScaleSliderState extends State<ScaleSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounce;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void didUpdateWidget(covariant ScaleSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != null) {
      _bounce.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.value;
    final selectedLabel =
        (v != null) ? widget.labels[v.clamp(0, widget.labels.length - 1)] : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _bounce,
          builder: (context, _) {
            final t = _bounce.value;
            // bounce: 1 → 1.18 → 1
            final scale = 1.0 + (t < 0.5 ? t * 0.36 : (1 - t) * 0.36);
            return Transform.scale(
              scale: v == null ? 1 : scale,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  v == null ? '값을 선택해주세요' : selectedLabel,
                  style: AppText.body(size: 16, color: AppColors.primary)
                      .copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 28),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.primary.withOpacity(0.18),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.18),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            value: (v ?? 2).toDouble(),
            min: 0,
            max: (widget.labels.length - 1).toDouble(),
            divisions: widget.labels.length - 1,
            onChanged: (val) => widget.onChanged(val.round()),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.labels.first,
                  style: AppText.caption(size: 11, color: AppColors.textSecondary)),
              Text(widget.labels.last,
                  style: AppText.caption(size: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
