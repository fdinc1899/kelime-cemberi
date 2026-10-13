# Şehir Hikâyeleri V15 — Macera Merkezi

Bu paket, mevcut **V13 çok dosyalı proje + V14 tema değişiklikleri** temel alınarak hazırlandı. Ana 18 bölümün sırası ve kayıtları korunur. V15'in giriş dosyası `kelime_main.dart`, yeni modüller `lib/src/features/adventure_features.dart` ve `lib/src/data/extra_puzzles.dart` içindedir.

## Kullanıma hazır özellikler

1. **Günlük görevler:** 5 normal kelime / 2 bonus kelime / 1 bölüm. Tamamlanınca oyuncu ödülü Macera Merkezi'nden **bir kez** alır. Yeni gün yerel takvime göre başlar.
2. **Şehir pasaportu:** 6 şehrin 3'er ana bölümü tamamlanınca şehir mührü açılır. Mühürden şehir hikâyesi okunur.
3. **Manzara keşfi:** Bölüm ilerledikçe manzara üzerindeki karartma azalır. Kaynak şehir görselleri yeniden sıkıştırılmaz.
4. **12 ek bölüm:** Orijinal 18 bölüm aynen durur; arkasına 12 yeni kesişimli bulmaca eklendi (30 bölüm). Ek bulmacalar 18 ana bölüm bitince açılır.
5. **Haftalık mücadele (çevrimdışı):** Kelime +10 puan, bonus +25 puan, bölüm +100 puan. Pazartesi haftalık sayaç yenilenir. 200/500/1200 puan hedeflerinin altın ödülleri bir kez alınır. Gerçek çok oyunculu lig **yoktur**.
6. **Üç yıldız:** Bitirilen her yeni bölümde kullanılan ipucu sayısına göre 1–3 yıldız kalıcı kaydolur. V15'ten önce tamamlanan bölümlere belirsiz oldukları için 1 yıldız başlangıç değeri verilir; eski ödüller tekrarlanmaz.
7. **Günlük çark:** Her yerel takvim gününde bir çevirme, altın / ücretsiz ipucu / sandık ödülü.
8. **Yardımcı güçler:** İlk harfi aç (15 altın), kelime aç (80 altın), ücretsiz harf karıştır; çarktan ücretsiz ipucu kazanılabilir.
9. **Sürpriz sandık:** Uygun yeni bölüm tamamlama ödülleri veya çarktan kazanılır. Sandık açıldığında 30–80 altın eklenir.
10. **Şehir hikâyeleri:** İstanbul, Kapadokya, Antalya, Mardin, İzmir ve Ankara için çevrimdışı kısa bilgi kartları.

**Erişim:** Oyuna giriş ekranındaki **Macera Merkezi** düğmesi, oyun içi hamburger menüsündeki **Macera merkezi · 10 özellik** seçeneği veya oyun altındaki **Macera** düğmesi.

## Kayıt uyumluluğu

Önceki sürüme ait anahtarlar **değiştirilmez**:

- `coins`
- `chapter_schema`
- `current_level_v3`, `unlocked_v3`, `finished_levels_v3`
- `solved_v3_<index>`, `bonuses_v3_<index>`, `hints_v3_<index>`
- `gift_date`, `music_enabled_v3` ve ses ayarları

Yeni V15 verileri yalnızca `adv15_*` anahtarlarıyla kaydedilir. V15 eski oyunun üzerine kurulmalıdır. Uygulamayı kaldırmak veya uygulama verilerini temizlemek **yerel kayıtları silebilir**. GitHub ZIP dosyası, telefondaki kayıtların yedeği değildir.

## GitHub'a yükleme

**Önce** GitHub'daki proje kodunun yedeğini alın. Ardından `kelime-sehirleri-v15-macera.zip` dosyasını telefonun İndirilenler klasörüne indirin.

```bash
cd ~/kelime-cemberi && cp kelime_main.dart kelime_main_v14_yedek.dart && unzip -o ~/storage/downloads/kelime-sehirleri-v15-macera.zip -d . && git add kelime_main.dart lib pubspec.yaml README.md V15_PLAN.md V15_TEST_KONTROL.md && git commit -m "V15 macera merkezi 10 ozellik 12 yeni bolum" && git push origin main
```

İş akışı (`.github/workflows/build.yml`) değiştirilmedi. Böylece GitHub token'ının `workflow` izni sorunu yeniden tetiklenmez.

## Dürüst durum

- Kod, dosya yolları, 30 bulmacanın harf kümeleri ve hücre kesişimleri statik olarak doğrulandı.
- Bu ortamda Flutter SDK olmadığı için **gerçek APK derlemesi ve cihaz testi yapılmadı**.
- Çark, sandık, görev ve haftalık puan yerel olarak tutulur. Çevrim içi güvenilir sıralama, hesap senkronizasyonu, gerçek oyuncu rekabeti veya saat manipülasyonuna dayanıklı ödül sistemi yoktur.
- Bu paket kullanıcı tarafından beğenilen UI mockup'larının piksel-piksel aynısını içerdiğini iddia etmez; mevcut lacivert-altın görünümle entegre çalışır.
