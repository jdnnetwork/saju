class Character {
  final String code; // 예: 'WOSP'
  final String name;
  final String shadow;
  final String identity;
  final String group; // 오행: WO/FI/EA/ME/AQ
  final String season; // 계절: SP/SM/AT/WT
  final List<String> strengths;

  const Character({
    required this.code,
    required this.name,
    required this.shadow,
    required this.identity,
    required this.group,
    required this.season,
    required this.strengths,
  });
}

const Map<String, Character> characters = {
  'WOSP': Character(
    code: 'WOSP',
    name: '너그러운 개척자',
    shadow: '유약한 개척자',
    identity: '누구보다 먼저 길을 열고, 따르는 이를 넉넉하게 품는 자',
    group: 'WO',
    season: 'SP',
    strengths: ['개척력', '포용력', '도덕성'],
  ),
  'WOSM': Character(
    code: 'WOSM',
    name: '용기있는 개척자',
    shadow: '무모한 개척자',
    identity: '재능을 불꽃처럼 태우며 앞으로 나아가는 열정의 선구자',
    group: 'WO',
    season: 'SM',
    strengths: ['표현력', '추진력', '매력'],
  ),
  'WOAT': Character(
    code: 'WOAT',
    name: '자신있는 개척자',
    shadow: '오만한 개척자',
    identity: '꺾일지언정 굽히지 않는, 단련으로 더 강해지는 의지의 선구자',
    group: 'WO',
    season: 'AT',
    strengths: ['인내력', '책임감', '원칙'],
  ),
  'WOWT': Character(
    code: 'WOWT',
    name: '지혜로운 개척자',
    shadow: '예민한 개척자',
    identity: '눈 속에서 봄을 준비하는, 깊이 사유하는 대기만성의 개척자',
    group: 'WO',
    season: 'WT',
    strengths: ['내공', '학식', '통찰력'],
  ),
  'FISP': Character(
    code: 'FISP',
    name: '너그러운 연출자',
    shadow: '유약한 연출자',
    identity: '따뜻한 봄빛처럼 사람을 모으고 세상을 밝히는 안내자',
    group: 'FI',
    season: 'SP',
    strengths: ['따뜻함', '교육력', '리더십'],
  ),
  'FISM': Character(
    code: 'FISM',
    name: '용기있는 연출자',
    shadow: '무모한 연출자',
    identity: '정점의 태양처럼 압도적 존재감으로 세상을 물들이는 자',
    group: 'FI',
    season: 'SM',
    strengths: ['카리스마', '실행력', '존재감'],
  ),
  'FIAT': Character(
    code: 'FIAT',
    name: '자신있는 연출자',
    shadow: '오만한 연출자',
    identity: '결실의 빛으로 가치를 만들어내는, 노련한 실용주의자',
    group: 'FI',
    season: 'AT',
    strengths: ['실용성', '사업감각', '결단력'],
  ),
  'FIWT': Character(
    code: 'FIWT',
    name: '지혜로운 연출자',
    shadow: '예민한 연출자',
    identity: '어둠 속에서 깊은 통찰로 길을 비추는 사색하는 등불',
    group: 'FI',
    season: 'WT',
    strengths: ['통찰', '신념', '공감력'],
  ),
  'EASP': Character(
    code: 'EASP',
    name: '너그러운 중재자',
    shadow: '유약한 중재자',
    identity: '자라나는 모든 것을 받쳐주는, 다툼을 키우지 않는 든든한 토대',
    group: 'EA',
    season: 'SP',
    strengths: ['포용력', '신뢰감', '안정감'],
  ),
  'EASM': Character(
    code: 'EASM',
    name: '용기있는 중재자',
    shadow: '무모한 중재자',
    identity: '뜨거운 갈등 한복판에 뛰어들어 신뢰로 식히는 열정적 화합가',
    group: 'EA',
    season: 'SM',
    strengths: ['담대함', '문제해결력', '지속성'],
  ),
  'EAAT': Character(
    code: 'EAAT',
    name: '자신있는 중재자',
    shadow: '오만한 중재자',
    identity: '결실을 공정하게 나눌 줄 아는, 성숙한 조율자',
    group: 'EA',
    season: 'AT',
    strengths: ['공정성', '균형감각', '성숙함'],
  ),
  'EAWT': Character(
    code: 'EAWT',
    name: '지혜로운 중재자',
    shadow: '예민한 중재자',
    identity: '갈등의 뿌리를 깊이 읽어내는, 차분하고 신뢰받는 외교가',
    group: 'EA',
    season: 'WT',
    strengths: ['통찰력', '신중함', '이해력'],
  ),
  'MESP': Character(
    code: 'MESP',
    name: '너그러운 기술자',
    shadow: '유약한 기술자',
    identity: '자라나는 것을 다듬어 형태를 부여하는, 자비로운 손의 장인',
    group: 'ME',
    season: 'SP',
    strengths: ['세심함', '성장잠재력', '배려'],
  ),
  'MESM': Character(
    code: 'MESM',
    name: '용기있는 기술자',
    shadow: '무모한 기술자',
    identity: '가장 뜨거운 시련 속에서 단련되어 그릇이 되는 자',
    group: 'ME',
    season: 'SM',
    strengths: ['강인함', '인내력', '큰그릇'],
  ),
  'MEAT': Character(
    code: 'MEAT',
    name: '자신있는 기술자',
    shadow: '오만한 기술자',
    identity: '칼날처럼 정확하고 단호한, 결단의 정점에 선 명장',
    group: 'ME',
    season: 'AT',
    strengths: ['정확성', '결단력', '전문성'],
  ),
  'MEWT': Character(
    code: 'MEWT',
    name: '지혜로운 기술자',
    shadow: '예민한 기술자',
    identity: '차고 맑은 물에 씻긴 보석처럼, 침잠 속에서 완성도를 높이는 자',
    group: 'ME',
    season: 'WT',
    strengths: ['정밀함', '완성도', '독자적세계관'],
  ),
  'AQSP': Character(
    code: 'AQSP',
    name: '너그러운 수호자',
    shadow: '유약한 수호자',
    identity: '만물을 적시며 성장을 이끄는, 양육하는 보호자',
    group: 'AQ',
    season: 'SP',
    strengths: ['양육력', '공감력', '헌신'],
  ),
  'AQSM': Character(
    code: 'AQSM',
    name: '용기있는 수호자',
    shadow: '무모한 수호자',
    identity: '불 같은 세상에 맞서 자기를 내어주는, 소진을 각오한 헌신가',
    group: 'AQ',
    season: 'SM',
    strengths: ['헌신', '위기대응력', '사명감'],
  ),
  'AQAT': Character(
    code: 'AQAT',
    name: '자신있는 수호자',
    shadow: '오만한 수호자',
    identity: '청명한 통찰로 세상을 맑게 비추는, 현자형 보호자',
    group: 'AQ',
    season: 'AT',
    strengths: ['통찰력', '분석력', '냉철한판단'],
  ),
  'AQWT': Character(
    code: 'AQWT',
    name: '지혜로운 수호자',
    shadow: '예민한 수호자',
    identity: '깊은 바다처럼 모든 것을 품고 기억하는, 지혜의 정점에 선 수문장',
    group: 'AQ',
    season: 'WT',
    strengths: ['깊은통찰', '포용력', '전략적사고'],
  ),
};

const List<String> elementOrder = ['WO', 'FI', 'EA', 'ME', 'AQ'];
const List<String> seasonOrder = ['SP', 'SM', 'AT', 'WT'];

const Map<String, String> elementNames = {
  'WO': '木 (목)',
  'FI': '火 (화)',
  'EA': '土 (토)',
  'ME': '金 (금)',
  'AQ': '水 (수)',
};

const Map<String, String> seasonNames = {
  'SP': '봄',
  'SM': '여름',
  'AT': '가을',
  'WT': '겨울',
};
