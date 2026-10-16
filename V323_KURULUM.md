# Kelime Çemberi V32.3 – Sürat, Düello ve Ustalık Kulesi

V32.2 üzerine eklenir. Ana seviye kayıtları / kimlikleri değiştirilmez.

## Kurulum (Termux – tek komut)

`cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v32-3-yaris-paketi.zip -d . && bash V323_GITHUB.sh`

GitHub Actions > en son build > yeşil tik > `kelime-cemberi-apk` artifact > ZIP içinden APK.
Eski uygulamayı kaldırmadan aynı paket kimliği ve imzayla üzerine yükleyin.

## Nasıl oynanır

**Macera Merkezi → V31 → YARIŞ+** bölümüne girin.

- **SÜRELİ:** 60 saniyede 5 kelime çöz. Günde yalnızca bir kez 12 altın. Yarış gün içinde tekrar oynanabilir, ikinci ödül verilmez.
- **DÜELLO:** 90 saniyede 5 kelime çözerek üç farklı hızdaki çevrimdışı **simüle rakibi** yen. Seviye başına yalnızca bir kez 10/15/20 altın. Gerçek oyuncu, internet veya öğrenen AI değildir.
- **KULE:** 10 kelime katını sırayla geç. Kat başına 4–13 altın, yalnızca ilk çözümde.

Tüm yeni anahtarlar `v323_` ile başlar. Mevcut V31 yerel yedek ekranı bu anahtarları da içerir. Firebase veya harici bağlantı gerekmez.

## Kurulum ve test

Kurulum betiği ön koşulları, part referanslarını, ana ekran sekmesini ve ödül anahtarlarını doğrular; eski ana ekran bağlantılarını silmez. Tekrar çalıştırılınca eklemeleri çoğaltmaz. **Bu denetim Flutter derleme testi değildir.** GitHub Actions başarısız olursa kırmızı adımın ilk `Error:` satırını gönderin.
