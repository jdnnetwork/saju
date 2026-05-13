import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../utils/sound.dart';

class HomeDashboardScreen extends StatelessWidget {
  final Map<String, double> elementScores;
  final String characterName;
  final String characterCode;

  const HomeDashboardScreen({
    super.key,
    required this.elementScores,
    required this.characterName,
    required this.characterCode,
  });

  // ─────────────────────────────────────────────
  //  build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF3EBF9),
              Color(0xFFEBF0F9),
              Color(0xFFF9EBF3),
              Color(0xFFF5F0FA),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // ────── 레이어 1: 스크롤 콘텐츠 ──────
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(),
                    _buildHero(),
                    _buildFortuneCard(),
                    _buildTwoColumnGrid(),
                    _buildJourney(),
                    _buildRecordSpace(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // ────── 레이어 2: 하단 네비바 ──────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  1. 상단 앱바
  // ─────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF9C7CB8),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 18,
              color: Color(0xFF9C7CB8),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            '생활 명리',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9C7CB8),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => playClickSound(),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFE8C4D8), Color(0xFFD4B8E0)],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '마음 님',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '나의 여정 32일째',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFFBBBBBB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  2. 히어로 — 좌측 텍스트 + 우측 장식
  //     (예외적으로 내부 Stack 허용)
  // ─────────────────────────────────────────────
  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            // 우측 장식 — 큰 원
            Positioned(
              right: -20,
              top: 10,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0x40E8D5F5),
                      Color(0x20D5E8F5),
                      Color(0x10F5D5E8),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
            // 우측 장식 — 중간 원
            Positioned(
              right: 10,
              top: 60,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0x30E8D5F5),
                      Color(0x18D5E8F5),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1,
                  ),
                ),
              ),
            ),
            // 좌측 텍스트 + CTA
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘의 나',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9C7CB8),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 400.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                const Text(
                  '나는 어떤\n사람일까?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 150.ms, duration: 400.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                const Text(
                  '명리는 나를 이해하는\n또 하나의 따뜻한 언어입니다.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888888),
                    height: 1.6,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => playClickSound(),
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA78BBF), Color(0xFFD4A0B0)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33A78BBF),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('✨', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 6),
                        Text(
                          '나의 명리 보기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 250.ms, duration: 400.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  3. 오늘의 운세 요약 카드
  // ─────────────────────────────────────────────
  Widget _buildFortuneCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('✦', style: TextStyle(fontSize: 14, color: Color(0xFF9C7CB8))),
                SizedBox(width: 6),
                Text(
                  '오늘의 운세 요약',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9C7CB8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Text(
              '흐름을 믿고, 한 걸음 더 나아가세요.',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D2D2D),
                height: 1.4,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '작은 선택이 내일을 바꿉니다.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: 300.ms, duration: 400.ms)
          .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic),
    );
  }

  // ─────────────────────────────────────────────
  //  4. 2열 그리드 — 키워드 + 오행
  // ─────────────────────────────────────────────
  Widget _buildTwoColumnGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(child: _keywordCard()),
          const SizedBox(width: 12),
          Expanded(child: _elementsCard()),
        ],
      ),
    );
  }

  Widget _keywordCard() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '오늘의 키워드',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              Spacer(),
              Icon(Icons.info_outline, size: 14, color: Color(0xFFCCCCCC)),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '성장',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2D2D),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '균형',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2D2D),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '표현',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2D2D),
            ),
          ),
          SizedBox(height: 16),
          Text(
            '오늘 따라가야 할 흐름',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _elementsCard() {
    const items = [
      ('목', 'WO', Color(0xFF4CAF50)),
      ('화', 'FI', Color(0xFFE57373)),
      ('토', 'EA', Color(0xFFE0A050)),
      ('금', 'ME', Color(0xFF757575)),
      ('수', 'AQ', Color(0xFF5C9CE6)),
    ];

    final values = items.map((e) => elementScores[e.$2] ?? 0.0).toList();
    final maxRaw = values.fold<double>(0, (a, b) => math.max(a, b));
    final maxVal = maxRaw > 0 ? maxRaw : 1.0;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '나의 사주 오행',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              Spacer(),
              Icon(Icons.info_outline, size: 14, color: Color(0xFFCCCCCC)),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < items.length; i++)
            _ElementBar(
              label: items[i].$1,
              color: items[i].$3,
              widthFactor: (values[i] / maxVal).clamp(0.0, 1.0),
              delay: Duration(milliseconds: 500 + 100 * i),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  5. 명리 여정 (4개 아이콘 카드)
  // ─────────────────────────────────────────────
  Widget _buildJourney() {
    const items = [
      (Icons.person_outline, Color(0xFFEDE7F6), Color(0xFF7E57C2), '나의 성향\n분석'),
      (Icons.people_outline, Color(0xFFFCE4EC), Color(0xFFE57373), '관계의\n흐름'),
      (Icons.calendar_today_outlined, Color(0xFFE8F5E9), Color(0xFF66BB6A), '올해의\n운세'),
      (Icons.assessment_outlined, Color(0xFFE3F2FD), Color(0xFF42A5F5), '운세\n리포트'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '명리 여정',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: _journeyCard(
                    icon: items[i].$1,
                    bgColor: items[i].$2,
                    iconColor: items[i].$3,
                    label: items[i].$4,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _journeyCard({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required String label,
  }) {
    return GestureDetector(
      onTap: () => playClickSound(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 110,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  6. 나만의 기록 공간
  // ─────────────────────────────────────────────
  Widget _buildRecordSpace() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white.withOpacity(0.5),
              const Color(0xFFF0EAFA).withOpacity(0.5),
            ],
          ),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나만의 기록 공간',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '내가 느낀 감정과 순간을 기록해보세요.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => playClickSound(),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF9C7CB8),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x339C7CB8),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  7. 하단 네비게이션
  // ─────────────────────────────────────────────
  Widget _buildBottomNav() {
    const tabs = [
      (Icons.home_rounded, '홈', true),
      (Icons.auto_awesome, '명리', false),
      (Icons.edit_note_rounded, '기록', false),
      (Icons.bar_chart_rounded, '리포트', false),
      (Icons.more_horiz_rounded, '더보기', false),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final t in tabs)
                Expanded(
                  child: GestureDetector(
                    onTap: () => playClickSound(),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          t.$1,
                          size: 24,
                          color: t.$3
                              ? const Color(0xFF9C7CB8)
                              : const Color(0xFFBBBBBB),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          t.$2,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: t.$3
                                ? const Color(0xFF9C7CB8)
                                : const Color(0xFFBBBBBB),
                          ),
                        ),
                      ],
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

// ─────────────────────────────────────────────
//  오행 막대 위젯 (애니메이션)
// ─────────────────────────────────────────────
class _ElementBar extends StatefulWidget {
  final String label;
  final Color color;
  final double widthFactor;
  final Duration delay;

  const _ElementBar({
    required this.label,
    required this.color,
    required this.widthFactor,
    required this.delay,
  });

  @override
  State<_ElementBar> createState() => _ElementBarState();
}

class _ElementBarState extends State<_ElementBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)
        .drive(Tween(begin: 0.0, end: widget.widthFactor.clamp(0.0, 1.0)));
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
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: widget.color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(4),
              ),
              child: AnimatedBuilder(
                animation: _anim,
                builder: (context, _) => FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _anim.value,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, _) => Text(
                '${(_anim.value * 100).round()}%',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
