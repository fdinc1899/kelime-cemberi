# Kelime Çemberi V27 – GitHub Android uygulama ikonu

Bu dosyalar telefonun ana ekranında görünen uygulama ikonunu değiştirir.
Kullanıcının seçtiği İstanbul manzaralı, altın harfli Kelime Çemberi tasarımına göre üretildi.
Mevcut oyun Dart kodları, şehirler, bulmacalar, puanlar ve kayıtlar değiştirilmez.

## Kurulum – Tek komut (Termux)
Önce ZIP'i telefonun Downloads klasörüne indir.

```sh
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v27-github-ikon.zip -d . && git add -f assets/icons/app_icon.png android/app/src/main/res/mipmap-*/ic_launcher.png android/app/src/main/res/mipmap-*/ic_launcher_round.png android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml android/app/src/main/res/drawable-nodpi/kc_icon_foreground.png android/app/src/main/res/values/kc_icon_colors.xml scripts/apply_kc_icon.sh && git commit -m 'V27 Kelime Cemberi uygulama ikonu' && git push origin main
```

`git commit` hata verirse `git status` ile kontrol et. GitHub Actions mevcut build.yml dosyanı değiştirmeden APK üretecek.

## Neden workflow dosyasını değiştirmedik?
Önceki GitHub PAT'in `workflow` izni nedeniyle güncelleme reddedilmişti. Bu pakette Android kaynakları doğrudan repoya eklenir ve `flutter create` standart modda mevcut dosyaların üzerine yazmaz.
**Dikkat:** Mevcut `build.yml`, `flutter create --overwrite` veya `rm -rf android` çalıştırıyorsa ikonlar derleme sırasında kaybolabilir. Bu durumda Actions dosyası içeriğini gönder; daha güvenli bir derleme adımı hazırlayabiliriz.

APK henüz derlenmedi. Önceki uygulamayı silme: aynı paket kimliği ve imzayla yeni APK kurulduğunda kayıtlar korunabilir; imza farklıysa üzerine güncelleme yapılamaz.
