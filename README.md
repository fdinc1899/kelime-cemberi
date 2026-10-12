# Kelime Şehirleri — V12 Yeniden Tasarım

Bu paket, V11'in çalışan oyun mantığını koruyarak ekranları referans kolajdaki
lacivert–altın görsel diline göre yeniden düzenler.

## Yapılanlar

- Oyun ekranı: daha dengeli ve sabit bulmaca/harf çemberi oranları.
- Harita: büyük sütun kartları yerine fotoğraflı yatay şehir kartları; altın
  kıvrımlı yol, kilitler, bölüm işaretleri, ilerleme ve tıklanabilir şehirler.
- Harita zemini: ayrı, daha renkli yüksek çözünürlüklü arka plan.
- Ödül: mevcut altın sandığı + yeni ışık/parıltı katmanı.
- Bonus: kırmızı kurdele, ayrılmış harf kutuları ve altın ödülü.
- Profil: kompakt profil kartı, sayılar ve şehir rozetleri.
- İstatistikler: kupa ve bölüm ilerlemesi.
- Çıkış onayı: parlak mavi Hayır / kırmızı Evet-Çık düğmeleri.
- Ayarlar: müzik, ses efekti, titreşim, yerel kayıt.
- Bölüm sonu: yıldızlar, bölüm resmi, ödül ve Sonraki Bölüm.

## Veri koruma

Kayıt anahtarları (`solved_v3_*`, `bonuses_v3_*`, `hints_v3_*`,
`finished_levels_v3`, `coins`, `unlocked_v3`) değiştirilmedi.
18 bulmaca, bölüm kilitleri, müzik ve harf sürükleme korunmuştur.

## Kurulum (Termux)

1. ZIP dosyasını telefonunun Downloads klasörüne indir.
2. Terminale şunu tek seferde yapıştır:

```sh
cd ~/kelime-cemberi && cp kelime_main.dart kelime_main_v11_yedek.dart && unzip -o ~/storage/downloads/kelime-sehirleri-v12-tasarim.zip -d . && git add kelime_main.dart lib pubspec.yaml assets README.md && git commit -m "V12 referans arayuz tasarimi" && git push origin main
```

3. GitHub Actions'dan derleme sonucunu kontrol et.

`.github/workflows/build.yml` değiştirilmedi; önceki yetki sorunu tekrarlanmaz.

## Sınırlar

Tasarım ekranları gerçek Flutter widget'larıdır, dokunulabilir. Görseldeki AI
mockup ile piksel piksel birebir olduğu garanti edilmez. Antalya, Mardin, İzmir
ve Ankara manzaralarında eski görsel kaynağın ayrıntı sınırı hâlâ vardır.
Flutter SDK burada olmadığı için APK derlenerek cihaz testi yapılamadı.
