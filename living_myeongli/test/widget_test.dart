import 'package:flutter_test/flutter_test.dart';

import 'package:living_myeongli/data/questions.dart';
import 'package:living_myeongli/models/character.dart';
import 'package:living_myeongli/services/scoring_service.dart';

void main() {
  group('ScoringService', () {
    final svc = ScoringService();

    test('20 캐릭터 데이터가 모두 정의되어 있다', () {
      expect(characters.length, 20);
      for (final code in characters.keys) {
        expect(code.length, 4);
        final c = characters[code]!;
        expect(elementOrder.contains(c.group), isTrue);
        expect(seasonOrder.contains(c.season), isTrue);
      }
    });

    test('18문항이 모두 정의되어 있다', () {
      expect(questions.length, 18);
    });

    test('빈 응답 → 모든 점수 0, top3 결정 가능', () {
      final result = svc.score(questions, const {});
      expect(result.elementScores.values.every((v) => v == 0.0), isTrue);
      expect(result.seasonScores.values.every((v) => v == 0.0), isTrue);
      expect(result.top3.length, 3);
    });

    test('WO + SP 일관 응답 → 최상위는 WOSP 계열', () {
      // Q1: 새싹(0번) → WO+SP
      // Q2~Q9 중 WO 가산 문항 위주 + Q10~Q14 중 SP 가산 문항 위주
      final answers = <String, int>{
        'Q1': 0, // WO + SP
        'Q2': 0, // WO
        'Q3': 0, // WO
        'Q4': 0, // WO
        'Q10': 0, // SP
        'Q11': 0, // SP
        'Q12': 0, // SP
      };
      final result = svc.score(questions, answers);
      expect(result.top.character.group, 'WO');
      expect(result.top.character.season, 'SP');
      expect(result.top.code, 'WOSP');
    });

    test('신뢰도 라벨이 한글로 매핑된다', () {
      expect(Confidence.sharp.label, '선명');
      expect(Confidence.moderate.label, '보통');
      expect(Confidence.similar.label, '유사');
    });

    test('scale 응답: 중간값(2)은 점수 변화 없음', () {
      final answers = {'Q15': 2, 'Q16': 2, 'Q17': 2, 'Q18': 2};
      final result = svc.score(questions, answers);
      // Q15~Q18은 norm=0이므로 어느 쪽도 적용 안 됨
      expect(result.elementScores.values.every((v) => v == 0.0), isTrue);
      expect(result.seasonScores.values.every((v) => v == 0.0), isTrue);
    });

    test('scale 응답: 최댓값(4)은 high 점수가 가산된다', () {
      final answers = {'Q15': 4}; // high: WO +0.5, SM +0.5, |norm|=1
      final result = svc.score(questions, answers);
      expect(result.elementScores['WO'], closeTo(0.5, 1e-9));
      expect(result.seasonScores['SM'], closeTo(0.5, 1e-9));
    });

    test('scale 응답: 최솟값(0)은 low 점수가 감산된다', () {
      final answers = {'Q15': 0}; // low: WO -0.5, SM -0.5
      final result = svc.score(questions, answers);
      expect(result.elementScores['WO'], closeTo(-0.5, 1e-9));
      expect(result.seasonScores['SM'], closeTo(-0.5, 1e-9));
    });
  });
}
