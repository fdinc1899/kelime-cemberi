# Şehir Hikâyeleri V22 — Doğu Anadolu HD görsel düzeltmesi

V21 üzerine uygulanır. **66–71. şehirler** için yüksek çözünürlüklü ayrı kart (1200×650) ve oyun sahnesi (900×1600) kaynakları vardır.

| Sıra | İl | Sanatsal tema |
|--:|--|--|
| 66 | Malatya | Dağ eteklerinde şehir ve gün batımı |
| 67 | Elazığ | Harput kalesini çağrıştıran kayalık hisar |
| 68 | Tunceli | Munzur manzarasını çağrıştıran dağ gölü |
| 69 | Bingöl | Yeşil tepeler ve nehir vadisi |
| 70 | Muş | Muş ovasını andıran geniş vadi |
| 71 | Bitlis | Taş evler ve dağlık yerleşim |

Görseller daha önce bu sohbette oluşturulan özgün yüksek çözünürlüklü manzara çalışmalarından uyarlanmıştır. **Bunlar doğrulanmış gerçek il fotoğrafları değildir**; şehirlerin doğasından ve mimarisinden esinlenen illüstratif sahnelerdir.

Kilit düzeni, şehir sırası, kelime cevapları, 243 ana + 12 eski bonus bölüm ve SharedPreferences kayıt anahtarları değiştirilmemiştir.

Şehir görseli her il için `cityCatalog` üzerinden çağrılır: `cardAsset` şehir seçimi ve harita için, `sceneAsset` oyun içi manzara için kullanılır.

## GitHub / Termux

Dosyayı telefonun Downloads klasörüne indir ve şunu tek seferde çalıştır:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-sehirleri-v22-dogu-anadolu.zip -d . && git add lib/src/data/city_catalog.dart pubspec.yaml assets/images/hd_provinces/cards assets/images/hd_provinces/scenes V22_DOGU_ANADOLU_GORSELLER.md && git commit -m "V22 Dogu Anadolu 6 sehir HD gorsel" && git push origin main
```

Yalnızca görsel yolları ve varlıklar değişir; diğer ekranların mantığına dokunulmaz. Flutter/Android SDK bu ortamda olmadığı için APK build testi GitHub Actions'ta doğrulanmalıdır.
