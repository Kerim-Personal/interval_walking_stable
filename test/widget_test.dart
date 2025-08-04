// Bu, bizim yürüyüş uygulamamız için yazılmış özel bir widget testidir.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test edilecek olan main.dart dosyasını import ediyoruz.
// Proje adınız 'interval_walking' ise bu satır doğrudur.
// Farklı bir isim verdiyseniz 'interval_walking' kısmını kendi proje adınızla değiştirin.
import 'package:interval_walking/main.dart';

void main() {
  // testWidgets, Flutter testleri yazmak için kullanılan ana fonksiyondur.
  testWidgets('Yürüyüş Uygulaması Akış Testi', (WidgetTester tester) async {
    // 1. Adım: Uygulamamızı build et ve bir frame çizdir.
    // Varsayılan 'MyApp' yerine kendi uygulamamız olan 'IntervalWalkingApp'i kullanıyoruz.
    await tester.pumpWidget(const IntervalWalkingApp());

    // 2. Adım: Başlangıç durumunu doğrula.
    // Uygulamanın seviye seçim ekranıyla açıldığını kontrol ediyoruz.
    expect(find.text('Antrenman Seviyenizi Seçin'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(3)); // 3 tane seviye butonu olmalı.
    expect(find.text('Başlangıç'), findsOneWidget);

    // Zamanlayıcı ekranının henüz görünür olmadığını kontrol et.
    expect(find.byIcon(Icons.play_arrow), findsNothing);

    // 3. Adım: Bir seviye seçme etkileşimini simüle et.
    // "Başlangıç" butonuna tıkla.
    await tester.tap(find.text('Başlangıç'));
    await tester.pump(); // Widget ağacının yeniden oluşması için frame'i ilerlet.

    // 4. Adım: Seviye seçildikten sonraki durumu doğrula.
    // Artık zamanlayıcı ekranında olmalıyız.
    // Seviye seçim ekranındaki metnin kaybolduğunu kontrol et.
    expect(find.text('Antrenman Seviyenizi Seçin'), findsNothing);

    // Zamanlayıcı ekranındaki widget'ların göründüğünü kontrol et.
    expect(find.text('Başlangıç Seviyesi Hazır'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget); // Başlat butonu görünür olmalı.
    expect(find.text('02:00'), findsOneWidget); // Başlangıç seviyesi 2 dakika ile başlar.

    // 5. Adım: Antrenmanı başlatma etkileşimini simüle et.
    // Başlat (play) ikonuna tıkla.
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(); // Durum değişikliği için frame'i ilerlet.

    // 6. Adım: Antrenman başladıktan sonraki durumu doğrula.
    // Faz metninin "Normal Tempo" olarak değiştiğini kontrol et.
    expect(find.text('Normal Tempo'), findsOneWidget);
    // Başlat butonunun artık Duraklat butonu olduğunu kontrol et.
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
  });
}