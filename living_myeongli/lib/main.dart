import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/theme.dart';
import 'screens/intro_screen.dart';

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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const IntroScreen(),
    );
  }
}
