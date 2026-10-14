# Kelime Çemberi / Şehir Hikâyeleri — V29 Büyük Güncelleme

## Dahil edilenler

- Türkiye altın rota: 81 il, 3'er ana bölüm, eski seviyeleri koruma, kilitli/açık şehir etkileşimi (mevcut harita + yeni rota sekmesi).
- Şehir pasaportu ve manzara keşfi: 81 koleksiyon kartı, mühür, tarihî/kültürel şehir bilgisi.
- Kutlama: oyunun mevcut V19/V28 konfeti, tebrik ve ses sistemi korunur; V29 altın ödülleri onu da çağırır.
- Her gün çözülebilen gerçek bir yeni anagram ve 45 altın; kalıcı günlük ödül kaydı.
- Şehir hikâyeleri: 81 ilin tamamı için metin ve görsel kartlar.
- Günlük çark, sandık ve mevcut altın ödülleri **ÖDÜLLER** sekmesinde. Çark artık 1,75 saniyelik gerçek döndürme animasyonuyla çalışır.
- Haftalık puan bazlı 5 kademeli çevrimdışı lig; mevcut haftalık puan anahtarlarına bağlı.
- Oyunun mevcut güçleri: harf açma, kelime açma, karıştırma ve ücretsiz ipucu.
- Profil: kalıcı takma ad, 8 avatar, XP seviyelerine göre ünvan.
- Mevsimsel oyun etkinliği: 250 XP ile ayda bir 75 altın; mevsime göre isim.
- V28 görsel düzeltmesi: 50 manzarayı kartların gerçek fonksiyonuna uygular.

## Özellikle dahil olmayanlar

- Gerçek çok oyunculu yarışma/sıralama (sunucu ve oturum açma gerekir).
- 81 şehrin tamamına doğrulanmış profesyonel fotoğraf; V28'deki 50 konsept görsel ve depodaki diğer görseller kullanılır.
- Yeni 243 ana bölüm eklenmesi (var olan 243 seviye korunur; günlük yeni anagram eklenir).

## Güvenlik

V29 yalnızca yeni `v29_` kayıt anahtarları oluşturur. V3 ilerleme/kasa/altın anahtarlarının adını veya bölüm kimliklerini değiştirmez. Eski ana bölümler, bonuslar ve satın alımlar (varsa) olduğu gibi kalır. Uygulamanın paket kimliği değiştirilmez.

Kod betiği `kelime_main.dart`, `lib/main.dart`, `game_screen.dart`, `provinces.dart` ve `pubspec.yaml` dosyalarını yedekler; beklenmeyen imza görürse durur. `.github/workflows` dosyaları değiştirilmez.

## Tek komut / Termux

```sh
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v29-buyuk-guncelleme.zip -d . && (command -v python >/dev/null || pkg install -y python) && bash V29_GITHUB.sh
```

Sonra GitHub Actions'i kontrol edin. Bu çalışma ortamında Flutter/Dart SDK olmadığı için `flutter build apk` çalıştırılmadı; kodun Flutter derleme sonucu kesinleştirilmedi.
