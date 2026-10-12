# Kelime Şehirleri V13 — açılış ve şehir seçimi

Bu paket, mevcut V12 üzerinde çalışan **yeni bir açılış akışı** içerir.

## Yeni özellikler
- Açılışta animasyonlu başlık ve dört seçim: OYUNA BAŞLA, ŞEHİR SEÇ, BÖLÜM SEÇ, KALDIĞIM YERDEN DEVAM ET.
- 6 şehirlik fotoğraflı seçici; her şehir için ayrı 3 bölümlük seçici.
- Yalnızca açılmış bölümler seçilebilir. Tamamlanan bölümler yeniden oynanabilir.
- Ana oyun ekranı kaymaz; açılış/şehir seçimi listeleri gerektiğinde kaydırılabilir.
- Mevcut ilerleme, çözülen kelimeler, altın ve ayarlar için önceki SharedPreferences anahtarları korunmuştur.
- Oyun menüsüne **Ana menü / Şehir seç** seçeneği eklendi.
- Yeni, bağımsız ve ayrıntılı **Kapadokya** ve **Antalya** sahneleri kondu (1080×1920 WebP); kart önizlemeleri de yenilendi.
- İstanbul'un mevcut yüksek çözünürlüklü sahnesi korundu.

## Henüz tamamlanmayan görseller
Mardin, İzmir ve Ankara sahneleri önceki sürümden korunmuştur. Bu üç görselin kaynak keskinliği yetersizdir; yalnızca daha büyük piksel boyutuna sahip olmaları onları gerçek HD yapmaz. Sıfırdan yeni sahnelerle değiştirilmeleri gereklidir.

## GitHub / Termux yükleme
1. ZIP dosyasını Android telefonun Downloads klasörüne indir.
2. Termux'ta çalıştır:

cd ~/kelime-cemberi && cp kelime_main.dart kelime_main_v12_yedek.dart && unzip -o ~/storage/downloads/kelime-sehirleri-v13-secimli-acilis.zip -d . && git add kelime_main.dart lib pubspec.yaml assets README.md && git commit -m "V13 animasyonlu baslangic ve sehir secimi" && git push origin main

3. GitHub Actions sayfasından son çalışmayı incele.
4. Derleme başarılıysa artifact ZIP'inden APK'yı çıkar, mevcut uygulamanın üstüne kur.

NOT: Bu ortamda Flutter SDK bulunmadığından gerçek APK derlemesi ve cihaz testi yapılmadı. Üç sahne hâlâ düşük kaliteli.
GitHub Actions workflow dosyasına dokunulmadı.
