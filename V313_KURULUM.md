# Kelime Çemberi V31.3 — HD fotoğraf hazırlığı + Android otomatik yedek

## Gerçek kapsam

Bu pakette **81 özgün şehir fotoğrafı yok**: Fotoğraflar telefonda/konteynerde kaynakları ve lisansları doğrulanmadan eklenemez. 81 şehrin tanımlı, farklı **turistik nokta araması** vardır. Wikimedia Commons'tan gerçek fotoğraflar için arama/indirme ve 1920×1080 şehir kartı + 1080×1920 dikey sahne hazırlayan bir araç sunulur. **Yanlış yer veya lisans seçilme riskine karşı manzaralar otomatik devreye girmez.** Yalnızca kaynak ve fotoğrafı bizzat kontrol ederek onayladığın kart+sahne çiftleri yüklenir; kalan şehirlerde oyunun mevcut görselleri görünmeye devam eder. Gerçek HD için görüntü *büyütülmez*; çözünürlük yetersizse sahne boş bırakılır.

Android tarafında Google hesabına bağlı **Android Auto Backup** etkinleşecek şekilde `shared_preferences` yedek kuralları eklenir. Telefon ayarlarındaki Google otomatik yedeğinin açık olması gerekir. Servis yedeklemeyi Android'in koşullarına göre yapar. **Bu özellik anlık bulut senkronizasyonu, iPhone desteği veya Firebase ile hesap bağlantısı değildir**; silme/yeniden yükleme öncesi elle V31 yedeği de saklanmalıdır.

## 1 — Tek komutla GitHub'a güvenli altyapıyı yükle

Önce ZIP'i telefonun Download klasörüne indir. Sonra Termux:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v31-3-hd-ve-android-yedek.zip -d . && bash V313_GITHUB.sh
```

Android XML dosyaları, mevcut proje `AndroidManifest.xml` korunarak düzenlenir. Android klasörü yoksa Flutter embedding V2 için standart başlangıç manifesti oluşturulur; GitHub Actions'ın kullandığı `flutter create` komutunun tamamlaması ve APK derlemesi gerekiyor.

## 2 — Wikimedia Commons fotoğraf adaylarını indir

Termux'ta şunları çalıştır:

```bash
cd ~/kelime-cemberi
python -m pip install pillow
python tools/v313_photo_pipeline.py prepare
```

Bu komut 81 il için otomatik kaynak arar; Wikimedia Commons sunucusuna bağlantı ve zaman gerekir. 81 ilin tamamı için uygun açık lisanslı, doğru çözünürlüklü fotoğraf bulacağını garanti etmez. Sonuçları şu dosyalarda gör:

- `v313_review/81_IL_ON_INCELEME.jpg` — tüm bulunan resimleri toplu gör
- `v313_review/LISANS_VE_INCELEME.csv` — asıl dosya sayfası, sanatçı ve lisans
- `v313_review/cards/*.webp` — fotoğraf adayları
- `v313_review/scenes/*.webp` — **büyütülmeden oluşturulabilen** dikey sahneler

Bunlar adaydır, yanlış il/tarihî eser olabilir. İlk aşamada tek şehirle denemek için `--city istanbul` parametresi kullanılabilir.

## 3 — İncelediğin eşleşmeleri oyuna uygula

Fotoğrafları ve lisansları gözünle doğrula. Hatalı eşleşmeleri ilgili `v313_review/cards` ve `v313_review/scenes` klasörlerinden sil. Sonra:

```bash
python tools/v313_photo_pipeline.py install --reviewed
python tools/V313_PATCH.py
bash V313_GITHUB.sh
```

Bu işlem yalnızca **1920×1080 kart + 1080×1920 sahne** çifti bulunup onaylanan illerde V31.3 fotoğrafını kullanır. Oyun verileri, bölüm kimlikleri ve kayıt anahtarları değişmez. Kullandığın CC BY / CC BY-SA fotoğrafların kaynakları `V313_FOTOGRAF_KAYNAKLARI.csv` içinde tutulur. Google Play'de dağıtımdan önce oyun içi açık bir **Fotoğraf Telif / Atıflar** sayfası eklenmesi ve kaynak sayfası koşullarının kontrolü gerekir.

## Test ve sınırlar

- Statik Python sözdizimi, manifest XML yapısı ve 81 il arama listesi yerel olarak kontrol edilir.
- İnternet erişimi olmadığı için Wikimedia Commons'ın gerçek arama sonuçları ve görselleri burada indirilemedi.
- Flutter SDK bu ortamda olmadığı için gerçek APK derlemesi yapılamadı. GitHub Actions sonucuyla doğrulanmalı.
- Android Google yedeği: Google otomatik yedek ayarları açık olmalı; aynı uygulama kimliği ve imza ile geri yükleme koşulları sağlanmalı. Anlık eşitleme **yapmaz**. Ayrıntı: https://developer.android.com/identity/data/autobackup

## Kayıt güvenliği

* Uygulamayı silme. Önce V31 > YEDEK ekranından manuel kayıt kodunu güvenli yerde sakla.
* Mevcut `shared_preferences` değerleri **silinmez, taşınmaz veya yeniden adlandırılmaz**.
* Yeni sürümde henüz görsel adaylarını onaylamadıysan, şehir görselleri bilinçli olarak eski halinde kalır.
