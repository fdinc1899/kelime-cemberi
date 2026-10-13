# V23 — 81 il şehir kartları düzeltmesi

**Tek uygulama yaması.** `lib/src/data/city_catalog.dart` içindeki yalnızca görsel yolları değişmiştir; şehir sırası, 243 ana bölüm, 12 ek bölüm, oyun kilitleri, yıldızlar ve kayıt anahtarları değiştirilmez.

- 54 ayrı şehir için yeni kart manzaraları bu sohbetin onaylanan şehir görsellerinden veya önceki özel manzara çalışmalarından alındı.
- 1–16, 19, 22–24, 42 ve 66–71 için önceki ayrı şehir görselleri korunur.
- Her il farklı kart dosyasına bağlanır. Ortak/tekrarlanan bölge görseli kullanılmaz.
- Kart yazıları, altın rozetler, kilitler ve yıldızlar Flutter widget olarak kalır; görsele gömülü değildir.
- 66–71 için V22'deki dosyalar ZIP'e yeniden dahil edildi; V21 üzerine de uygulanabilir.
- **Önemli:** Yeni kartlar bağımsız doğrulanmış gerçek şehir fotoğrafları değildir; oyun için oluşturulmuş şehirlerden esinlenen görsel tasarımlardan kırpıldı. Ayrıca eski oyun içi tam ekran manzaraları bu yamada değiştirilmez.
- Dosyadaki büyük görsel piksel sayısı, kaynak görüntünün optik ayrıntısının o kadar yüksek olduğu anlamına gelmez.

## Kullanım

ZIP'i indirdikten sonra Android Termux içine tek satır olarak yapıştır:

```sh
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-sehirleri-v23-81-il-kart-duzeltmesi.zip -d . && git add lib/src/data/city_catalog.dart pubspec.yaml assets/images/v23_city_cards assets/images/hd_provinces V23_KART_DUZELTMESI.md && git commit -m "V23 81 il sehir kartlari" && git push origin main
```

Yeni derleme GitHub Actions'ta kontrol edilmeli. Bu ortamda Flutter SDK bulunmadığından APK derlemesi doğrulanmamıştır. Güncelleme öncesinde mevcut oyunun kayıtlarının yedeğini alın; kurulu oyunu kaldırmayın.
