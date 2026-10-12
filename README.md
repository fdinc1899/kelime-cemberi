# Kelime Şehirleri V9 — Görsel Arayüz Güncellemesi

V8 üzerinde geliştirilmiştir. Mevcut 6 şehir, 18 bölüm, kelime seçimi, ses ayarları, oyuncu profili, çıkış onayı ve cihaz içi ilerleme kayıtları korunur.

## Bu sürümde
- Şehir haritasında altın renkli kıvrımlı noktalı rota, dönüşümlü gerçek şehir görselleri ve kilitli / tamamlanan kartlar
- Günlük ödül için özgün vektör tarzında altın sandık görseli ve yenilenmiş lacivert-altın pencere
- Oyun ekranında daha dengeli harf çemberi boyutu, bulmaca alanına daha fazla yer ve sabit ekran düzeni
- Ödül alınca daha önceki konfeti ve ses animasyonlarının devam etmesi

## Yapı
`kelime_main.dart` GitHub Actions'ın kullandığı giriş dosyasıdır.
`lib/main.dart`, `lib/src/screens/`, `lib/src/widgets/`, `lib/src/theme/`, `lib/src/data/` kodları ayrı dosyalardır.
`assets/images/ui/reward_chest.png` yeni ödül illüstrasyonudur.
`pubspec.yaml` bütün görsellerin, seslerin ve yeni illüstrasyonun varlık kayıtlarını tutar.

## GitHub üzerinden güncelleme
Önce ZIP'i telefonunun Download/İndirilenler klasörüne kaydet. Termux:

```bash
cd ~/kelime-cemberi && cp kelime_main.dart kelime_main_v8_yedek.dart && unzip -o ~/storage/downloads/kelime-sehirleri-v9-gorsel.zip -d . && git add kelime_main.dart lib pubspec.yaml assets README.md && git commit -m "V9 sehir haritasi odul sandigi oyun ekrani" && git push origin main
```

GitHub Actions derlemesi başarılı ise Artifacts altından APK'yi indirebilirsin.

**Önemli:** Uygulamayı kaldırıp yeniden yükleme; mevcut APK'nın üstüne kurarak yerel ilerlemeyi koru. ZIP gerçek APK değildir. Flutter SDK bu çalışma ortamında olmadığı için Dart kaynaklarının yapısal kontrolleri yapıldı, tam APK derlemesi yapılmadı. Tanıtım görsellerinin birebir piksel kopyası değildir.
