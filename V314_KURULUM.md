# Kelime Çemberi V31.4 — Şehir Rehberi ve İstatistikler

Bu küçük ZIP V31.2 ve V31.3 üzerine uygulanmak üzere tasarlandı. **V31 Macera Merkezi** ekranına iki yeni sekme ekler:

- **ŞEHİRLER:** 81 il içinde arama; yedi coğrafi bölge filtresi; favorilere ekleme/çıkarma; yalnız favorileri gösterme; şehir ilerlemesi; kilidi açık bölümlere geçiş; kaldığın ilk açık, çözülmemiş bölüme dönüş.
- **İSTATİSTİK:** 243 ana bulmaca, 1.053 ek görev, tamamlanan iller ve hatıralar; son ilerlenen şehirlerin özetleri; altın/favori göstergeleri.

Bu özellikler tamamen çevrimdışı çalışır. Yalnızca yeni bir `SharedPreferences` anahtarı oluşturulur: `v31_favorite_city_slugs`.

## Kurulum

Telefonundan ZIP dosyasını Downloads'a indir. Termux içinde:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v31-4-sehir-rehberi.zip -d . && bash V314_GITHUB.sh
```

`V314_GITHUB.sh` yalnızca ilgili Dart dosyasını ve V31.4 kurulum dosyalarını commit eder. `.github/workflows/` veya eski kayıt dosyalarını değiştirmez. Hedef kod beklenen sürüme uymuyorsa işlemi durdurur; ayrıca `~/kelime_cemberi_v314_yedekler/` altına kaynak dosyanın yedeğini alır.

## Teknik sınırlar

- Derleme GitHub Actions'ta **ayrıca** doğrulanmalıdır. Bu ortamda Flutter SDK kurulu değildir.
- Şehir ve kayıt verileri var olan `V31WorldCenter` içinde görüntülenir; ana oyun ilerlemesi ve altın değerleri değiştirilmez.
- Yeni fotoğraf/bulut senkronizasyonu içermez. Onlar V31.3'ün ayrıca sürdürülmesi gereken işleridir.
- Geri alma: `git revert <V31.4 commit hash>` (GitHub'ta istenirse). Bu kod geri alınsa bile favori kayıt anahtarı oyuna zarar vermez.
