import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/question.dart';

class ImageOption extends StatefulWidget {
  const ImageOption({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final Option option;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<ImageOption> createState() => _ImageOptionState();
}

class _ImageOptionState extends State<ImageOption> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.selected
        ? AppColors.primary
        : Colors.white.withOpacity(0.55);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          decoration: BoxDecoration(
            color: widget.selected
                ? Colors.white.withOpacity(0.55)
                : Colors.white.withOpacity(0.32),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: widget.selected ? 2.2 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(widget.selected ? 0.10 : 0.05),
                blurRadius: 18,
                spreadRadius: -4,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.option.emoji, style: const TextStyle(fontSize: 38)),
              const SizedBox(height: 10),
              Text(
                widget.option.text,
                textAlign: TextAlign.center,
                style: AppText.body(size: 13)
                    .copyWith(fontWeight: FontWeight.w600, height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
