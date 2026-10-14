# V29.2 — V29.1 kurulum hatası düzeltmesi

Termux hata: `ProvinceInfo okunamadi: city.name, city.gameCity, city.region, city.slug, city.levelIds`

Neden: eski şehir listesini okumak için yazılan test, V21/V26'da bulunan **dinamik** `cityCatalog.map(...)` sürümünü desteklemiyordu.
V29.2 iki yapıyı ayrı okuyor. 81 il adı/sırası, bölge/slug ve 243 tarihi seviye kimliğini eski proje ile karşılaştırır.
Kartların 50 ayrı dosyasını ve V29 arayüz bağlantılarını da kontrol eder. Test geçmeden commit/push yapılmaz.

## Tek komut

```sh
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v29-2-github-duzeltme.zip -d . && bash V29_GITHUB.sh
```

Telefon uygulamasını **silip yeniden yükleme**: Android SharedPreferences kayıtları silinebilir.
İlk defa APK build edilirse Actions sayfasında yeşil tik bekle; bu paket tek başına APK'nın başarıyla derleneceği garantisi değildir.
