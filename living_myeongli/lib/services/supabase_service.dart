import 'dart:math' as math;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/character.dart';
import 'scoring_service.dart';

/// Supabase 테이블 스키마와 1:1 대응되는 저장/조회 헬퍼.
class SupabaseService {
  SupabaseService(this._client);

  final SupabaseClient _client;

  /// 응답자 생성. respondent_number는 1000~9999 랜덤 4자리.
  /// 반환값: 생성된 user_id (uuid)
  Future<String> createUser({int? respondentNumber}) async {
    final number = respondentNumber ?? _randomRespondentNumber();
    final res = await _client
        .from('users')
        .insert({'respondent_number': number})
        .select('id')
        .single();
    return res['id'] as String;
  }

  /// 설문 결과 저장
  Future<void> saveResult({
    required String userId,
    required Map<String, int> answers,
    required ScoringResult result,
    Map<String, int>? responseTimes, // questionId -> ms
  }) async {
    await _client.from('survey_results').insert({
      'user_id': userId,
      'answers': answers,
      'element_scores': result.elementScores,
      'season_scores': result.seasonScores,
      'top_character': result.top.code,
      'top3': result.top3
          .map((m) => {'code': m.code, 'score': m.score})
          .toList(),
      'confidence': result.confidence.label,
      if (responseTimes != null) 'response_times': responseTimes,
    });
  }

  /// 피드백 저장
  Future<void> saveFeedback({
    required String userId,
    int? naturalness,
    int? accuracy,
    int? clarity,
    int? length,
    String? comment,
  }) async {
    await _client.from('feedback').insert({
      'user_id': userId,
      'star_naturalness': naturalness,
      'star_accuracy': accuracy,
      'star_clarity': clarity,
      'star_length': length,
      'comment': comment,
    });
  }

  /// 연결 테스트 — 가벼운 ping. 실패해도 예외를 던지지 않고 메시지만 돌려준다.
  Future<({bool ok, String message})> ping() async {
    try {
      await _client.from('_test_ping').select().limit(1);
      return (ok: true, message: 'Supabase 연결 성공');
    } on PostgrestException catch (e) {
      // 테이블 없음 (PGRST205 등) → 연결은 정상
      final msg = e.message.toLowerCase();
      if (msg.contains('relation') ||
          msg.contains('does not exist') ||
          msg.contains('not found') ||
          msg.contains('schema cache')) {
        return (ok: true, message: 'Supabase 연결 성공 (테이블 미생성)');
      }
      return (ok: false, message: 'Supabase 오류: ${e.message}');
    } catch (e) {
      final s = e.toString();
      if (s.contains('relation') || s.contains('does not exist')) {
        return (ok: true, message: 'Supabase 연결 성공 (테이블 미생성)');
      }
      return (ok: false, message: '연결 실패: $e');
    }
  }

  static int _randomRespondentNumber() {
    final r = math.Random();
    return 1000 + r.nextInt(9000); // 1000~9999
  }
}

/// 캐릭터 코드 → Character 조회용 헬퍼 (서비스 외부에서도 사용).
Character? characterFor(String code) => characters[code];
