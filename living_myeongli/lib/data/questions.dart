import '../models/question.dart';

const List<String> scaleLabels = [
  '거의 없음',
  '가끔',
  '보통',
  '자주',
  '거의 매주',
];

const List<Question> questions = [
  // ─────────────────────────────────────────────
  // Q1: 이미지 5택
  // ─────────────────────────────────────────────
  Question(
    id: 'Q1',
    type: QuestionType.image,
    text: '지금 마음이 가장 끌리는 풍경은?',
    sub: '직관적으로 골라주세요',
    options: [
      Option(text: '새싹 돋는 봄의 들판', emoji: '🌱', scores: {'WO': 1, 'SP': 1}),
      Option(text: '정오의 햇살 가득한 해변', emoji: '☀️', scores: {'FI': 1, 'SM': 1}),
      Option(text: '안개 낀 산속 고요한 마당', emoji: '🏔️', scores: {'EA': 1, 'SP': 0.5, 'AT': 0.5}),
      Option(text: '단풍 가득한 가을 산', emoji: '🍂', scores: {'ME': 1, 'AT': 1}),
      Option(text: '눈 덮인 고요한 호수', emoji: '❄️', scores: {'AQ': 1, 'WT': 1}),
    ],
  ),

  // ─────────────────────────────────────────────
  // Q2~Q9: 오행 강제선택 8문항
  // ─────────────────────────────────────────────
  Question(
    id: 'Q2',
    type: QuestionType.forced,
    text: '새 프로젝트가 시작될 때 더 신나는 쪽은?',
    options: [
      Option(text: '0에서 1을 만드는 시작 단계', emoji: '🚀', scores: {'WO': 1}),
      Option(text: '결과를 사람들 앞에 보여주는 발표 단계', emoji: '🎤', scores: {'FI': 1}),
    ],
  ),
  Question(
    id: 'Q3',
    type: QuestionType.forced,
    text: '팀에서 더 자주 듣는 말은?',
    options: [
      Option(text: '넌 진짜 뚝심 있어, 끝까지 가더라', emoji: '💪', scores: {'WO': 1}),
      Option(text: '넌 디테일 진짜 꼼꼼해', emoji: '🔍', scores: {'ME': 1}),
    ],
  ),
  Question(
    id: 'Q4',
    type: QuestionType.forced,
    text: '중요한 결정 앞에서 내 모습은?',
    options: [
      Option(text: '일단 부딪쳐 보고 길을 낸다', emoji: '⚡', scores: {'WO': 1}),
      Option(text: '조용히 가능성을 끝까지 헤아린다', emoji: '🌊', scores: {'AQ': 1}),
    ],
  ),
  Question(
    id: 'Q5',
    type: QuestionType.forced,
    text: '오랜만의 모임에서 내 위치는?',
    options: [
      Option(text: '분위기를 끌어올리는 사람', emoji: '🔥', scores: {'FI': 1}),
      Option(text: '사람들 사이를 부드럽게 잇는 사람', emoji: '🤝', scores: {'EA': 1}),
    ],
  ),
  Question(
    id: 'Q6',
    type: QuestionType.forced,
    text: '갈등 상황이 생기면 더 가까운 행동은?',
    options: [
      Option(text: '할 말은 한다, 분위기 깨져도 OK', emoji: '💬', scores: {'FI': 1}),
      Option(text: '한 발 떨어져 본질을 본다', emoji: '🔭', scores: {'AQ': 1}),
    ],
  ),
  Question(
    id: 'Q7',
    type: QuestionType.forced,
    text: '마감 직전 야근, 내가 더 집중하는 건?',
    options: [
      Option(text: '결과물 디테일을 1mm 더 다듬기', emoji: '✂️', scores: {'ME': 1}),
      Option(text: '모두가 잘 마무리하도록 챙기기', emoji: '🧡', scores: {'EA': 1}),
    ],
  ),
  Question(
    id: 'Q8',
    type: QuestionType.forced,
    text: '내가 더 못 참는 것은?',
    options: [
      Option(text: '약속·원칙이 흐트러질 때', emoji: '⚖️', scores: {'ME': 1}),
      Option(text: '누가 깊이 상처받았는데 아무도 모를 때', emoji: '💙', scores: {'AQ': 1}),
    ],
  ),
  Question(
    id: 'Q9',
    type: QuestionType.forced,
    text: '처음 보는 사람이 나에게 던지는 말, 더 그럴듯한 건?',
    options: [
      Option(text: '되게 차분하고 깊어 보여요', emoji: '🌙', scores: {'AQ': 1}),
      Option(text: '되게 듬직하고 편해 보여요', emoji: '🌳', scores: {'EA': 1}),
    ],
  ),

  // ─────────────────────────────────────────────
  // Q10~Q14: 계절 강제선택 5문항
  // ─────────────────────────────────────────────
  Question(
    id: 'Q10',
    type: QuestionType.forced,
    text: '새 팀에 들어갔을 때 나는?',
    options: [
      Option(text: '사람들과 빠르게 친해진다', emoji: '🌸', scores: {'SP': 1}),
      Option(text: '분위기 한바탕 띄우고 본다', emoji: '🎆', scores: {'SM': 1}),
    ],
  ),
  Question(
    id: 'Q11',
    type: QuestionType.forced,
    text: '낯선 자리에서 더 자연스러운 나는?',
    options: [
      Option(text: '누구든 일단 받아들이는 편', emoji: '🤗', scores: {'SP': 1}),
      Option(text: '살펴보고 천천히 다가가는 편', emoji: '🦉', scores: {'WT': 1}),
    ],
  ),
  Question(
    id: 'Q12',
    type: QuestionType.forced,
    text: '결정의 순간, 더 가까운 건?',
    options: [
      Option(text: '가능성을 넓게 본다, 일단 열어둔다', emoji: '🌿', scores: {'SP': 1}),
      Option(text: '끊을 건 끊는다, 미련 없다', emoji: '🍂', scores: {'AT': 1}),
    ],
  ),
  Question(
    id: 'Q13',
    type: QuestionType.forced,
    text: '기회가 왔을 때 내 반응은?',
    options: [
      Option(text: '지금 아니면 언제! 즉시 점프', emoji: '⚡', scores: {'SM': 1}),
      Option(text: '한 번 더 따져보고 가자', emoji: '🌊', scores: {'WT': 1}),
    ],
  ),
  Question(
    id: 'Q14',
    type: QuestionType.forced,
    text: '일을 끝낼 때 더 만족스러운 순간은?',
    options: [
      Option(text: '끝까지 에너지 뽑아내고 박수받을 때', emoji: '🎉', scores: {'SM': 1}),
      Option(text: '깔끔하게 정리되어 마침표 찍을 때', emoji: '✅', scores: {'AT': 1}),
    ],
  ),

  // ─────────────────────────────────────────────
  // Q15~Q18: 행동회상 5점 척도
  // ─────────────────────────────────────────────
  Question(
    id: 'Q15',
    type: QuestionType.scale,
    text: '지난 한 달, 새로운 걸 먼저 시도해본 적은?',
    sub: '솔직하게 답해주세요',
    scaleLabels: scaleLabels,
    scaleLow: {'WO': -0.5, 'SM': -0.5},
    scaleHigh: {'WO': 0.5, 'SM': 0.5},
  ),
  Question(
    id: 'Q16',
    type: QuestionType.scale,
    text: '지난 한 달, 부탁을 단호하게 거절한 적은?',
    sub: '솔직하게 답해주세요',
    scaleLabels: scaleLabels,
    scaleLow: {'ME': -0.5, 'AT': -0.5},
    scaleHigh: {'ME': 0.5, 'AT': 0.5},
  ),
  Question(
    id: 'Q17',
    type: QuestionType.scale,
    text: '최근 누군가가 힘들어할 때 내가 먼저 알아챈 적은?',
    sub: '솔직하게 답해주세요',
    scaleLabels: scaleLabels,
    scaleLow: {'AQ': -0.5, 'EA': -0.5},
    scaleHigh: {'AQ': 0.5, 'EA': 0.5},
  ),
  Question(
    id: 'Q18',
    type: QuestionType.scale,
    text: '지난 한 달, 모임 분위기를 내가 주도해 만든 적은?',
    sub: '솔직하게 답해주세요',
    scaleLabels: scaleLabels,
    scaleLow: {'FI': -0.5, 'SM': -0.5},
    scaleHigh: {'FI': 0.5, 'SM': 0.5},
  ),
];
