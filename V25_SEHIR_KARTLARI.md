# V25 — 50 şehir manzarası, şehir haritası ve şehir seçimi kartları

Bu yama mevcut V24 Flutter projesine uygulanır. **Tam proje değildir**: yalnızca katalog, `pubspec.yaml` ve 50 kart görseli yenilenir.

- 50 belirtilen şehir numarasına yeni görsel bağlanmıştır.
- İsimler ve numaralar mevcut Flutter arayüzünde ayrı çizilmeye devam eder.
- İl sırası, 81 il, 243 şehir seviyesi + 12 bonus seviyesi, oyun içi manzara yolları, bulmaca ve kayıt anahtarları değiştirilmemiştir.
- Görseller daha önce bu sohbette oluşturulan referans ekranlardan ayrılmıştır. **AI üretimi şehir temalı konseptlerdir; doğrulanmış gerçek fotoğraf değildir.**
- Resmin kaynağındaki küçük kart görüntüsünü büyütmek gerçek Full HD ayrıntı eklemez.
- Yalnızca şehir haritası ve şehir seçimi kartları değişir; oyun içi tam ekran manzaralar aynı kalır.

## Tek komut

İndirdiğiniz ZIP'i Android Downloads klasörüne kaydedip Termux'ta çalıştırın:

```bash
cd ~/kelime-cemberi && cp lib/src/data/city_catalog.dart ~/city_catalog_v24_yedek.dart && unzip -o ~/storage/downloads/kelime-sehirleri-v25-50-il-github.zip -d . && git add lib/src/data/city_catalog.dart pubspec.yaml assets/images/v25_city_cards V25_SEHIR_KARTLARI.md && git commit -m "V25 50 sehir harita gorseli" && git push origin main
```

**APK derlemesi bu çalışma ortamında çalıştırılmadı.** GitHub Actions sonuç ekranından kontrol edin.

## Güncellenen iller
- 17: Aydın — `assets/images/v25_city_cards/aydin.webp`
- 18: Muğla — `assets/images/v25_city_cards/mugla.webp`
- 20: Manisa — `assets/images/v25_city_cards/manisa.webp`
- 21: Uşak — `assets/images/v25_city_cards/usak.webp`
- 25: Burdur — `assets/images/v25_city_cards/burdur.webp`
- 26: Mersin — `assets/images/v25_city_cards/mersin.webp`
- 27: Adana — `assets/images/v25_city_cards/adana.webp`
- 28: Osmaniye — `assets/images/v25_city_cards/osmaniye.webp`
- 29: Hatay — `assets/images/v25_city_cards/hatay.webp`
- 30: Kahramanmaraş — `assets/images/v25_city_cards/kahramanmaras.webp`
- 31: Konya — `assets/images/v25_city_cards/konya.webp`
- 32: Karaman — `assets/images/v25_city_cards/karaman.webp`
- 34: Niğde — `assets/images/v25_city_cards/nigde.webp`
- 35: Kırşehir — `assets/images/v25_city_cards/kirsehir.webp`
- 36: Kırıkkale — `assets/images/v25_city_cards/kirikkale.webp`
- 37: Çankırı — `assets/images/v25_city_cards/cankiri.webp`
- 38: Yozgat — `assets/images/v25_city_cards/yozgat.webp`
- 39: Kayseri — `assets/images/v25_city_cards/kayseri.webp`
- 43: Düzce — `assets/images/v25_city_cards/duzce.webp`
- 44: Zonguldak — `assets/images/v25_city_cards/zonguldak.webp`
- 45: Bartın — `assets/images/v25_city_cards/bartin.webp`
- 47: Kastamonu — `assets/images/v25_city_cards/kastamonu.webp`
- 48: Sinop — `assets/images/v25_city_cards/sinop.webp`
- 49: Samsun — `assets/images/v25_city_cards/samsun.webp`
- 50: Ordu — `assets/images/v25_city_cards/ordu.webp`
- 51: Giresun — `assets/images/v25_city_cards/giresun.webp`
- 52: Trabzon — `assets/images/v25_city_cards/trabzon.webp`
- 53: Rize — `assets/images/v25_city_cards/rize.webp`
- 54: Artvin — `assets/images/v25_city_cards/artvin.webp`
- 55: Gümüşhane — `assets/images/v25_city_cards/gumushane.webp`
- 56: Bayburt — `assets/images/v25_city_cards/bayburt.webp`
- 57: Tokat — `assets/images/v25_city_cards/tokat.webp`
- 58: Amasya — `assets/images/v25_city_cards/amasya.webp`
- 59: Çorum — `assets/images/v25_city_cards/corum.webp`
- 60: Erzincan — `assets/images/v25_city_cards/erzincan.webp`
- 61: Erzurum — `assets/images/v25_city_cards/erzurum.webp`
- 62: Ağrı — `assets/images/v25_city_cards/agri.webp`
- 63: Iğdır — `assets/images/v25_city_cards/igdir.webp`
- 64: Kars — `assets/images/v25_city_cards/kars.webp`
- 65: Ardahan — `assets/images/v25_city_cards/ardahan.webp`
- 72: Van — `assets/images/v25_city_cards/van.webp`
- 73: Hakkâri — `assets/images/v25_city_cards/hakkri.webp`
- 74: Diyarbakır — `assets/images/v25_city_cards/diyarbakir.webp`
- 75: Şanlıurfa — `assets/images/v25_city_cards/sanliurfa.webp`
- 76: Gaziantep — `assets/images/v25_city_cards/gaziantep.webp`
- 77: Kilis — `assets/images/v25_city_cards/kilis.webp`
- 78: Adıyaman — `assets/images/v25_city_cards/adiyaman.webp`
- 79: Batman — `assets/images/v25_city_cards/batman.webp`
- 80: Siirt — `assets/images/v25_city_cards/siirt.webp`
- 81: Şırnak — `assets/images/v25_city_cards/sirnak.webp`
