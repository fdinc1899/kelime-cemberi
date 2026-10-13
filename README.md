# Şehir Hikâyeleri V16 — Türkiye’nin 81 İli

**Kayıt koruması:** V15’in ilk 30 bölüm indeksi değiştirilmedi. 0–17 klasik, 18–29 eski ek bölümlerdir. Yeni iller 30–254 indekslerine eklendi. `chapter_schema` 3 olarak kalır; eski `solved_v3_*`, `finished_levels_v3`, `coins`, `unlocked_v3`, `current_level_v3` anahtarları korunur.

## Kapsam

- 81 il × 3 ana bölüm = **243 ana bölüm**.
- Eski 12 ek bölüm ayrıca korunur, **255 kayıtlı bulmaca** toplamı.
- Nevşehir oyunun eski Kapadokya bölümleriyle eşleştirilir.
- 7 coğrafi bölge için şehir listesi filtresi.
- 75 yeni il için özgün, 900 × 1600 piksel, tam ekran manzara **illüstrasyonları**.
- İlk 6 şehrin mevcut görüntüleri ve bölümleri korunur.
- Mevcut altın, üç yıldız, pasaport, günlük görevler ve kayıt sisteminin temel mantığı korunur.

## Önemli sınırlamalar

- Yeni 75 manzara **fotoğraf değildir**; yüksek çözünürlüklü, şehirden şehre değişen manzara çizimleridir. Bunlar piksellenmiş küçük fotoğraf kırpımlarından farklıdır ancak şehrin gerçek fotoğrafını birebir göstermez.
- Yeni 225 bulmaca, mevcut denetlenmiş kelime kümelerinin **farklı illerde yeniden kullanılmasıyla** oluşturuldu. Tamamen 225 yeni, benzersiz kelime havuzu hazırlama ve editoryal sözlük denetimi sonraki aşamadır.
- Diğer şehirlerin gerçek fotoğrafları ve tüm 81 ile özel hikâye metinleri henüz tamamlanmış değildir.
- Projeyi burada Flutter SDK ile derleyemedim; GitHub Actions sonucu nihai derleme doğrulamasıdır.

## GitHub Termux kurulumu

ZIP dosyasını Android indirmelerine kaydettikten sonra:

```bash
cd ~/kelime-cemberi && cp kelime_main.dart kelime_main_v15_yedek.dart && unzip -o ~/storage/downloads/kelime-sehirleri-v16-81-il.zip -d . && git add kelime_main.dart lib pubspec.yaml assets README.md V16_ILLER.md V16_KONTROL.md && git commit -m "V16 Turkiyenin 81 ili 243 ana bolum" && git push origin main
```

Mevcut GitHub `.github/workflows/build.yml` değiştirilmez; eski PAT izin hatası oluşmaz.

### Telefon testi

1. GitHub Actions yeşil tik almalı, APK indirilir.
2. Eski APK uygulama silinmeden üzerine kurulur.
3. Mevcut altın ve açılan bölüm kaydı karşılaştırılır.
4. Şehir seçimi > bölge filtrelerini açıp 81 ili kontrol et.
5. İlk 6 şehrin eski bölümleri değişmemiş olmalı.
6. 6. şehrin (Ankara) 3. bölümünden sonra Edirne açılmalı.
7. Bonus bölüm 18–29, Macera Merkezi üzerinden ayrı erişilebilir olmalı.
8. Rastgele yeni ilde üç bulmaca çözülebilmeli.
9. Yeni şehrin illüstrasyonu internetsiz açılmalı.
10. Uygulamadan çıkıp yeniden açtığında seviyeler ve altınlar korunmalı.

### Kısıtlılık

İlk 18 ana bölüm ve 12 eski ek bölümün geçişleri/indeksleri korunarak 81 il haritası eklendi. Dart/Flutter derleyicisi bu ortamda bulunmadığı için cihaz üstü doğrulama gereklidir.
