# Kelime Şehirleri V8 – Çok Dosyalı Flutter

**Çalışan V7 üzerinden ayrıştırıldı.** 18 bulmaca, 6 şehir, dokunmatik harf çemberi, şehir haritası, ödüller, ayarlar, profil, yerel kayıt ve çıkış onayı korunur.

- `kelime_main.dart`: mevcut GitHub Actions iş akışına uyumlu giriş dosyası (derleme sırasında `lib/main.dart` üstüne kopyalanır).
- `lib/main.dart`: Flutter giriş noktası.
- `lib/src/data/puzzles.dart`: bulmaca modelleri ve seviyeler.
- `lib/src/screens/game_screen.dart`: oyun durumu ve gerçek, dokunulabilir ekranlar.
- `lib/src/screens/premium_page.dart` ve `lib/src/screens/journey_map.dart`: gerçek ekran bileşenleri.
- `lib/src/widgets/painters.dart`: harf çemberi, yol ve konfeti çizimleri.
- `lib/src/theme/premium_theme.dart`: ortak lacivert-altın bileşenleri.
- `assets/images/cities/`: dikey şehir arka planları.
- `assets/images/cards/`: şehir haritası görsel kartları.
- `assets/audio/`: özgün oyun müziği ve efekt.

## GitHub'da mevcut iş akışı ile

`flutter create --org com.fatih --project-name kelime_cemberi .` mevcut dosyaları korur; `cp kelime_main.dart lib/main.dart` ve `flutter pub add shared_preferences audioplayers` adımlarıyla kaynak kod derlenir. `.github/workflows/build.yml` değiştirilmemiştir.

## Önemli

- Bu ZIP bir kod kaynak paketidir; APK değildir.
- Orijinal V7 oyun kayıt anahtarları korunur; cihazın uygulama verilerini temizlemeyin.
- `shared_preferences` cihaz içi kayıt yapar, bulut eşitlemesi yapmaz.
- Oyun ekranları koddan üretilir; örnek tanıtım görsellerinin ekran görüntüleri değildir.
- Gerçek cihazda APK derleme ve dokunmatik testleri GitHub Actions ile yapılmalıdır.
