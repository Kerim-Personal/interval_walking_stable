import 'package:flutter/material.dart';
import 'package:interval_walking/screens/walking_screen.dart';

void main() {
  runApp(const IntervalWalkingApp());
}

class IntervalWalkingApp extends StatelessWidget {
  const IntervalWalkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Modern, canlı ve koyu bir tema.
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0A7C7E), // Canlı Teal
      scaffoldBackgroundColor: const Color(0xFF121212), // Klasik Koyu Arka Plan
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0A7C7E),      // Ana Eylem Rengi (Teal)
        secondary: Color(0xFFE57373),   // İkincil Eylem Rengi (Hızlı Tempo için Kırmızımsı)
        onPrimary: Colors.white,        // Ana Rengin Üzerindeki Yazı
        onSecondary: Colors.white,      // İkincil Rengin Üzerindeki Yazı
        surface: Color(0xFF1E1E1E),     // Kart gibi yüzeylerin rengi
        onSurface: Colors.white,        // Yüzeylerin üzerindeki yazı
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212), // Arka planla aynı, bütünleşik bir görünüm
        elevation: 0, // Gölge yok
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'sans-serif', // Daha modern bir sistem fontu
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        // Büyük başlıklar (Antrenman Seviyenizi Seçin)
        headlineSmall: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.white),
        // Faz metni (Normal Tempo)
        displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
        // Zamanlayıcı
        displayMedium: TextStyle(fontSize: 85.0, fontWeight: FontWeight.w200, color: Colors.white),
        // Tekrar Sayısı
        bodyLarge: TextStyle(fontSize: 20.0, color: Colors.white70),
        // Buton Yazıları
        labelLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A7C7E), // Ana Eylem Rengi
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Tamamen yuvarlak kenarlar
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: Colors.white70,
          )),
      // ************************************
      // ******** İŞTE DOĞRU KOD! *********
      // ************************************
      cardTheme: CardThemeData( // 'CardTheme' -> 'CardThemeData' OLARAK DÜZELTİLDİ
        color: const Color(0xFF1E1E1E), // Yüzey rengi
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withAlpha(26)) // İnce bir kenarlık
        ),
      ),
    );

    return MaterialApp(
      title: 'Aralıklı Yürüyüş',
      theme: darkTheme, // Varsayılan olarak koyu temayı kullanıyoruz
      darkTheme: darkTheme, // Sistem koyu moda geçtiğinde de bu tema geçerli
      themeMode: ThemeMode.dark, // Her zaman koyu modu zorunlu kıl
      debugShowCheckedModeBanner: false,
      home: const WalkingScreen(),
    );
  }
}