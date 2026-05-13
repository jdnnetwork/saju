import 'dart:math' as math;

import '../models/character.dart';
import '../models/question.dart';

class CharacterMatch {
  final String code;
  final Character character;
  final double score;

  const CharacterMatch({
    required this.code,
    required this.character,
    required this.score,
  });
}

enum Confidence { sharp, moderate, similar }

extension ConfidenceLabel on Confidence {
  String get label {
    switch (this) {
      case Confidence.sharp:
        return '선명';
      case Confidence.moderate:
        return '보통';
      case Confidence.similar:
        return '유사';
    }
  }
}

class ScoringResult {
  /// 원점수 — 오행 (WO/FI/EA/ME/AQ)
  final Map<String, double> elementScores;

  /// 원점수 — 계절 (SP/SM/AT/WT)
  final Map<String, double> seasonScores;

  /// 정규화 점수 — 오행
  final Map<String, double> elementNorm;

  /// 정규화 점수 — 계절
  final Map<String, double> seasonNorm;

  /// 상위 3개 캐릭터 (점수 내림차순)
  final List<CharacterMatch> top3;

  /// 1위 캐릭터
  CharacterMatch get top => top3.first;

  /// 신뢰도 판정
  final Confidence confidence;

  const ScoringResult({
    required this.elementScores,
    required this.seasonScores,
    required this.elementNorm,
    required this.seasonNorm,
    required this.top3,
    required this.confidence,
  });
}

class ScoringService {
  /// [answers] — questionId 를 key 로 하는 응답 맵
  ///   - QuestionType.image: 선택한 옵션 인덱스 (int)
  ///   - QuestionType.forced: 선택한 옵션 인덱스 (int, 0 또는 1)
  ///   - QuestionType.scale: 슬라이더 값 (int, 0~4)
  ScoringResult score(List<Question> questions, Map<String, int> answers) {
    final element = <String, double>{
      for (final k in elementOrder) k: 0.0,
    };
    final season = <String, double>{
      for (final k in seasonOrder) k: 0.0,
    };

    void apply(Map<String, double>? scores, double weight) {
      if (scores == null) return;
      for (final entry in scores.entries) {
        final delta = entry.value * weight;
        if (element.containsKey(entry.key)) {
          element[entry.key] = element[entry.key]! + delta;
        } else if (season.containsKey(entry.key)) {
          season[entry.key] = season[entry.key]! + delta;
        }
      }
    }

    for (final q in questions) {
      final raw = answers[q.id];
      if (raw == null) continue;

      switch (q.type) {
        case QuestionType.image:
        case QuestionType.forced:
          if (raw < 0 || raw >= q.options.length) break;
          apply(q.options[raw].scores, 1.0);
          break;

        case QuestionType.scale:
          final norm = (raw - 2) / 2.0; // 0~4 → -1~+1
          if (norm >= 0) {
            // high 점수 적용 — delta = |norm| * |값| * sign(값)
            final src = q.scaleHigh;
            if (src == null) break;
            for (final e in src.entries) {
              final mag = norm.abs() * e.value.abs();
              final signed = mag * (e.value.isNegative ? -1 : 1);
              apply({e.key: signed}, 1.0);
            }
          } else {
            final src = q.scaleLow;
            if (src == null) break;
            for (final e in src.entries) {
              final mag = norm.abs() * e.value.abs();
              final signed = mag * (e.value.isNegative ? -1 : 1);
              apply({e.key: signed}, 1.0);
            }
          }
          break;
      }
    }

    final elementNorm = _normalize(element);
    final seasonNorm = _normalize(season);

    // 20캐릭터 점수
    final matches = <CharacterMatch>[];
    for (final c in characters.values) {
      final eScore = elementNorm[c.group] ?? 0;
      final sScore = seasonNorm[c.season] ?? 0;
      matches.add(CharacterMatch(
        code: c.code,
        character: c,
        score: 0.5 * eScore + 0.5 * sScore,
      ));
    }
    matches.sort((a, b) => b.score.compareTo(a.score));
    final top3 = matches.take(3).toList();

    // 신뢰도
    final delta = (top3[0].score - top3[1].score).abs();
    final Confidence confidence;
    if (delta >= 0.15) {
      confidence = Confidence.sharp;
    } else if (delta >= 0.05) {
      confidence = Confidence.moderate;
    } else {
      confidence = Confidence.similar;
    }

    return ScoringResult(
      elementScores: element,
      seasonScores: season,
      elementNorm: elementNorm,
      seasonNorm: seasonNorm,
      top3: top3,
      confidence: confidence,
    );
  }

  /// max-normalize. max가 0 이하이면 0으로 채운다.
  Map<String, double> _normalize(Map<String, double> raw) {
    if (raw.isEmpty) return {};
    final maxVal = raw.values.fold<double>(
      double.negativeInfinity,
      (a, b) => math.max(a, b),
    );
    if (maxVal <= 0) {
      return {for (final k in raw.keys) k: 0.0};
    }
    return {for (final e in raw.entries) e.key: e.value / maxVal};
  }
}
