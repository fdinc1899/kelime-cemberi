# Kelime Şehirleri V10 – Premium Arayüz

Referans: Sohbette paylaşılan lacivert/altın oyun arayüzü kolajı.

Bu sürüm önceki çalışan V9 üstüne kuruludur. Mevcut oyun mantığı, 6 şehir, 18 seviye,
oyun kayıt anahtarları (`*_v3`, `*_v5`) ve Android geri tuşuyla çıkış onayı korunur.

## Etkileşimli ekranlar

- Ana oyun: ayrı `OrnateTitlePlaque`, daha küçük harf tekerleği ve çözülen kelimelerde yeşil kutular
- Şehir haritası: kavisli altın yol, şehir fotoğraf kartları, 3 yıldız ve kilit durumu
- Günlük ödül: referans tarzında gösterişli hediye/altın kahraman görseli,
  kırmızı kurdele ve çalışan AL düğmesi
- Ayarlar: altın kaydırıcılar, müzik, ses efektleri, titreşim; telefon içinde kaydetme
- Oyuncu profili: altın, bölüm, bonus istatistikleri ve şehir fotoğraf rozetleri
- Bölüm sonu: 3 yıldız, ödül özeti ve sonraki bölüm
- Bonus kelime: kırmızı kurdeleli kelime kutusu, konfeti ve 5 altın
- İstatistikler: şehir bazlı ilerleme ve başarı verileri
- Oyun menüsü: harita / profil / ayarlar / istatistikler / kaydet / çık
- Android geri tuşu: hayır / evet çık, yerel kayıt ile birlikte

Bu ekranlar statik ekran görüntüsü değil, çalışan Flutter widget'larıdır.
Tasarım özgün görsel kolajı temel alır; küçük ekran farklılıkları veya
referanstaki illüstrasyonların birebir piksel görünümü garanti edilmez.

## Depo yapısı

```
kelime_main.dart                # GitHub workflow bunu lib/main.dart olarak kopyalar
lib/main.dart
lib/src/data/puzzles.dart
lib/src/screens/game_screen.dart
lib/src/screens/journey_map.dart
lib/src/screens/premium_page.dart
lib/src/theme/premium_theme.dart
lib/src/widgets/painters.dart
lib/src/widgets/v10_ornaments.dart
assets/images/{cities,cards,ui}/
assets/audio/
pubspec.yaml
```

## Termux ile GitHub'a tek seferde gönder

1. ZIP'i telefonun İndirilenler / Download klasörüne indir.
2. Önceki ZIP ile karışmaması için dosyanın adını değiştirme.
3. Şu komutu çalıştır:

```bash
cd ~/kelime-cemberi && cp kelime_main.dart kelime_main_v9_yedek.dart && unzip -o ~/storage/downloads/kelime-sehirleri-v10-premium.zip -d . && git add kelime_main.dart lib pubspec.yaml assets README.md && git commit -m "V10 premium arayuz tum ekranlar" && git push origin main
```

GitHub Actions: https://github.com/fdinc1899/kelime-cemberi/actions

Yalnızca kaynak kod ZIP'i içerir; APK GitHub Actions ile üretilecektir.
`.github/workflows/build.yml` değiştirilmemiştir.

**İlerlemenin korunması:** Yüklü uygulamayı kaldırmayın, yeni APK'yı aynı
uygulamanın üstüne kurun; uygulama verilerini silmeyin. Bulut senkronizasyonu yoktur.

**Test durumu:** Dart işaretleyici/dosya/varlık varlığı için yapısal kontrol yapıldı.
Bu ortamda Flutter SDK olmadığı için tam Dart derlemesi, APK ve gerçek cihaz testi yapılmadı.
