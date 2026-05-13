import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // 브랜드
  static const Color primary = Color(0xFF1B3A6B);
  static const Color accent = Color(0xFFB8860B);

  // 오행
  static const Color wood = Color(0xFF2D6A2D);
  static const Color fire = Color(0xFFB22222);
  static const Color earth = Color(0xFF8B6914);
  static const Color metal = Color(0xFF4A4A8A);
  static const Color aqua = Color(0xFF1A5276);

  // 계절
  static const Color spring = Color(0xFF388E3C);
  static const Color summer = Color(0xFFE64A19);
  static const Color autumn = Color(0xFF795548);
  static const Color winter = Color(0xFF1565C0);

  // 파스텔 그라데이션 컬러
  static const Color pastelPurple = Color(0xFFE8D5F5);
  static const Color pastelBlue = Color(0xFFD5E8F5);
  static const Color pastelPink = Color(0xFFF5D5E8);

  // 텍스트
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF555555);

  static Color elementColor(String key) {
    switch (key) {
      case 'WO':
        return wood;
      case 'FI':
        return fire;
      case 'EA':
        return earth;
      case 'ME':
        return metal;
      case 'AQ':
        return aqua;
      default:
        return primary;
    }
  }

  static Color seasonColor(String key) {
    switch (key) {
      case 'SP':
        return spring;
      case 'SM':
        return summer;
      case 'AT':
        return autumn;
      case 'WT':
        return winter;
      default:
        return primary;
    }
  }
}

class AppGradients {
  static const LinearGradient pastel = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.pastelPurple, AppColors.pastelBlue, AppColors.pastelPink],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient pastelAlt = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [AppColors.pastelPink, AppColors.pastelPurple, AppColors.pastelBlue],
    stops: [0.0, 0.5, 1.0],
  );
}

class AppText {
  static TextStyle title({double size = 28, Color color = AppColors.primary}) =>
      GoogleFonts.notoSansKr(fontSize: size, fontWeight: FontWeight.w900, color: color);

  static TextStyle heading({double size = 22, Color color = AppColors.textPrimary}) =>
      GoogleFonts.notoSansKr(fontSize: size, fontWeight: FontWeight.w700, color: color);

  static TextStyle body({double size = 16, Color color = AppColors.textPrimary}) =>
      GoogleFonts.notoSansKr(fontSize: size, fontWeight: FontWeight.w500, color: color);

  static TextStyle caption({double size = 13, Color color = AppColors.textSecondary}) =>
      GoogleFonts.notoSansKr(fontSize: size, fontWeight: FontWeight.w400, color: color);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: GoogleFonts.notoSansKrTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.notoSansKr(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
    );
  }
}
