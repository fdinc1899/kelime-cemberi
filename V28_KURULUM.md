# V28 — Şehir Haritası için 50 il görsel düzeltmesi

Bu paket **doğrudan haritada görünen kartı** düzeltir. Önceki paketlerde yalnızca görsel dosyaları ve city_catalog.dart değiştirilince şehir haritasındaki `_cityMapCard` fonksiyonu eski `_cityImageWidget` üzerinde kalıyordu.

V28'in yaptığı değişiklikler:

- `lib/src/screens/game_screen.dart` içindeki `_cityMapCard` kart resmi, `_citySelectionImageProvider(province)` kullanır.
- `lib/src/data/provinces.dart` içinde `_citySelectionImageProvider`, listelenen 50 il için benzersiz `assets/images/v28_city_cards/<slug>.webp` dosyasını döndürür; bölgesel çizimli placeholder'a düşmez.
- Aynı görsel klasörü `pubspec.yaml` altına eklenir.
- `city_catalog.dart` varsa 50 il için `cardAsset` alanı da eşitlenir.
- 81 ilin bölümleri, kayıtlar, altınlar, uygulama ikonu ve tam ekran oyun arka planları aynı kalır.

**Önemli:** Görseller 1000×520 çözünürlüklü, şehirlerden esinlenen konsept manzaralardır. Ekran kartında yeterli detaylıdır ama gerçek şehir fotoğrafı veya 1920×1080 Full HD dosyası değildir.

## Tek seferde Termux komutu

ZIP dosyasını Android Downloads klasörüne indir, sonra:

```sh
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v28-harita-hd-duzeltme.zip -d . && bash V28_UYGULA.sh && git add lib/src/data/provinces.dart lib/src/screens/game_screen.dart pubspec.yaml V28_UYGULA.sh V28_PROVIDER_EKLEME.txt V28_KURULUM.md && if [ -f lib/src/data/city_catalog.dart ]; then git add lib/src/data/city_catalog.dart; fi && git add -f assets/images/v28_city_cards/*.webp && git commit -m "V28 harita gercek gorsel baglanti duzeltmesi" && git push origin main
```

**Uyarı:** GitHub Actions'da `flutter build apk --release` başarıyla tamamlanana dek APK'nın çalıştığı kesinleşmez. Aynı imzayla güncellenmiyorsa, uygulama verilerini silmeden önce yedek al.
