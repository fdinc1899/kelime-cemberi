# V24 · Şehir haritası manzara güncellemesi

Bu paket V23 üzerine uygulanır. **36 şehir kartına**, bu sohbette üretilen ve onaylanan şehir haritası örneklerinden ayrılmış özgün görseller eklendi.

- 17–21, 25–39, 43–56 ve 58–62 aralıklarında görsel kaynağı olan tüm şehirler değerlendirildi.
- Denizli (19), Aksaray (33) ve Karabük (46) için önceden mevcut daha ayrıntılı HD kartlar aynen korundu.
- Diğer tüm şehir görselleri, 81 il sırası, 243 bölüm, 12 bonus bölüm ve kaydetme anahtarları korundu.
- Oyun içi tam ekran arka planlara dokunulmadı; bu sadece şehir seçimi ve şehir haritası *kartlarını* günceller.
- Şehir adları, yıldızlar, kilitler ve tıklamalar hâlâ çalışan Flutter kontrolüdür.

**Görsel doğruluğu:** Bu dosyalar AI ile oluşturulmuş görsel konseptlerden çıkarılmış şehir temalı manzaralardır, doğrulanmış gerçek fotoğraflar değildir. Görüntülerin kaynak detay çözünürlüğü kart için sınırlıdır. Ölçeklendirme bunu gerçek yüksek çözünürlüklü fotoğrafa dönüştürmez.

## Termux: Tek komut

```bash
cd ~/kelime-cemberi && cp lib/src/data/city_catalog.dart ~/city_catalog_v23_yedek.dart && unzip -o ~/storage/downloads/kelime-sehirleri-v24-harita-kartlari.zip -d . && git add lib/src/data/city_catalog.dart assets/images/v24_city_cards pubspec.yaml V24_HARITA.md && git commit -m "V24 il bazli harita manzaralari" && git push origin main
```

Yeni APK, GitHub Actions ile derlenmelidir. Flutter SDK bu ortamda olmadığından build çalıştırılmadı.

## Değişen şehirler

- 17. Aydın — `assets/images/v24_city_cards/aydin.webp`
- 18. Muğla — `assets/images/v24_city_cards/mugla.webp`
- 20. Manisa — `assets/images/v24_city_cards/manisa.webp`
- 21. Uşak — `assets/images/v24_city_cards/usak.webp`
- 25. Burdur — `assets/images/v24_city_cards/burdur.webp`
- 26. Mersin — `assets/images/v24_city_cards/mersin.webp`
- 27. Adana — `assets/images/v24_city_cards/adana.webp`
- 28. Osmaniye — `assets/images/v24_city_cards/osmaniye.webp`
- 29. Hatay — `assets/images/v24_city_cards/hatay.webp`
- 30. Kahramanmaraş — `assets/images/v24_city_cards/kahramanmaras.webp`
- 31. Konya — `assets/images/v24_city_cards/konya.webp`
- 32. Karaman — `assets/images/v24_city_cards/karaman.webp`
- 34. Niğde — `assets/images/v24_city_cards/nigde.webp`
- 35. Kırşehir — `assets/images/v24_city_cards/kirsehir.webp`
- 36. Kırıkkale — `assets/images/v24_city_cards/kirikkale.webp`
- 37. Çankırı — `assets/images/v24_city_cards/cankiri.webp`
- 38. Yozgat — `assets/images/v24_city_cards/yozgat.webp`
- 39. Kayseri — `assets/images/v24_city_cards/kayseri.webp`
- 43. Düzce — `assets/images/v24_city_cards/duzce.webp`
- 44. Zonguldak — `assets/images/v24_city_cards/zonguldak.webp`
- 45. Bartın — `assets/images/v24_city_cards/bartin.webp`
- 47. Kastamonu — `assets/images/v24_city_cards/kastamonu.webp`
- 48. Sinop — `assets/images/v24_city_cards/sinop.webp`
- 49. Samsun — `assets/images/v24_city_cards/samsun.webp`
- 50. Ordu — `assets/images/v24_city_cards/ordu.webp`
- 51. Giresun — `assets/images/v24_city_cards/giresun.webp`
- 52. Trabzon — `assets/images/v24_city_cards/trabzon.webp`
- 53. Rize — `assets/images/v24_city_cards/rize.webp`
- 54. Artvin — `assets/images/v24_city_cards/artvin.webp`
- 55. Gümüşhane — `assets/images/v24_city_cards/gumushane.webp`
- 56. Bayburt — `assets/images/v24_city_cards/bayburt.webp`
- 58. Amasya — `assets/images/v24_city_cards/amasya.webp`
- 59. Çorum — `assets/images/v24_city_cards/corum.webp`
- 60. Erzincan — `assets/images/v24_city_cards/erzincan.webp`
- 61. Erzurum — `assets/images/v24_city_cards/erzurum.webp`
- 62. Ağrı — `assets/images/v24_city_cards/agri.webp`
