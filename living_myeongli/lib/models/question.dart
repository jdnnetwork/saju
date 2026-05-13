enum QuestionType { image, forced, scale }

class Option {
  final String text;
  final String emoji;
  final Map<String, double> scores;

  const Option({
    required this.text,
    required this.emoji,
    required this.scores,
  });
}

class Question {
  final String id;
  final QuestionType type;
  final String text;
  final String sub;

  /// image, forced 유형용
  final List<Option> options;

  /// scale 유형용 — 5단계 라벨 (예: ["거의 없음", ...])
  final List<String>? scaleLabels;

  /// scale 유형용 — 낮은값(1~2)에 적용할 점수
  final Map<String, double>? scaleLow;

  /// scale 유형용 — 높은값(4~5)에 적용할 점수
  final Map<String, double>? scaleHigh;

  const Question({
    required this.id,
    required this.type,
    required this.text,
    this.sub = '',
    this.options = const [],
    this.scaleLabels,
    this.scaleLow,
    this.scaleHigh,
  });
}
