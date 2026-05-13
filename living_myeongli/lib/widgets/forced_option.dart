import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/question.dart';

class ForcedOption extends StatefulWidget {
  const ForcedOption({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final Option option;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<ForcedOption> createState() => _ForcedOptionState();
}

class _ForcedOptionState extends State<ForcedOption> {
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
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
          child: Row(
            children: [
              Text(widget.option.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.option.text,
                  style: AppText.body(size: 15).copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
