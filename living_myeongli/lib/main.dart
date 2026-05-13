import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jqkebgymwmphgtydojhm.supabase.co',
    anonKey: 'sb_publishable_af3Z5XKAzYRpxUxaW38Z8Q_O2Q1ztM3',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '생활명리',
      home: const ConnectionTestScreen(),
    );
  }
}

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  String status = '연결 확인 중...';

  @override
  void initState() {
    super.initState();
    testConnection();
  }

  Future<void> testConnection() async {
    try {
      await supabase.from('_test_ping').select().limit(1);
      setState(() => status = '✅ Supabase 연결 성공!');
    } catch (e) {
      if (e.toString().contains('relation') || e.toString().contains('does not exist')) {
        setState(() => status = '✅ Supabase 연결 성공! (테이블만 아직 없음)');
      } else {
        setState(() => status = '❌ 연결 실패: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('생활명리', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF1B3A6B))),
              const SizedBox(height: 24),
              Text(status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
