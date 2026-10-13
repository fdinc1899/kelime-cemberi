# Şehir Hikâyeleri V20 — 7–16. İllerin HD Arka Planları

Bu sürüm **V19** kaynaklarını temel alır. Oyun kayıtları, 81 il, 243 ana bölüm ve 12 ek bulmaca korunur.

## Güncellenen şehir manzaraları

Edirne, Kırklareli, Tekirdağ, Çanakkale, Balıkesir, Bursa, Yalova, Kocaeli, Sakarya, Bilecik.
Ayrıca son oluşturulan görselleri şu şehirlere bağladık:
Denizli (Pamukkale), Bolu, Eskişehir, Isparta, Afyonkarahisar, Sivas,
Aksaray, Kütahya ve Karabük (Safranbolu).

Toplam **19** il için ayrı görsel dosyaları.

Her il için `assets/images/hd_provinces/cards/*.webp` (1200×650) ile
`assets/images/hd_provinces/scenes/*.webp` (900×1600) vardır.
Yatay panorama kaynaklarında tam ekran için görüntüyü çok büyütmek yerine
üst/alt alana tematik renk geçişi uygulanmıştır. Bu yüzden oyun ekranı
fotoğrafın tamamını kaplamaz ama pikselleşmiş büyütme de yapılmaz.
Bu görseller AI üretimi şehir temalı tasvirlerdir; resmi veya doğrulanmış
fotoğraf belgesi olarak sunulmaz.

`lib/src/data/provinces.dart`: HD görsel listesi eklendi. Hem harita ve
şehir seçimi hem de bulmaca ekranı aynı ilin uygun oranlı görselini kullanır.

## GitHub'a tek komutla yükleme (Termux)

ZIP'i cihazının Downloads/İndirilenler klasörüne indirip:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-sehirleri-v20-github.zip -d . && git add lib kelime_main.dart pubspec.yaml assets README.md V20_GORSELLER.md && git commit -m "V20 19 il icin HD manzaralar" && git push origin main
```

Bu paket mevcut `build.yml` dosyanızı değiştirmez. Mevcut uygulamayı silmeden
aynı uygulama kimliği ve imza ile kurun, önce verilerinizin yedeğini alın.

Gerçek Flutter APK derlemesi burada yapılamadı (Flutter SDK kurulu değil);
GitHub Actions derleme sonucunu kontrol edin.
