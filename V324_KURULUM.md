# Kelime Çemberi V32.4 — Müze, Rahatlama, Harf Çemberi Temaları

## Kurulum (Android Termux)

**Ön koşul:** V32.3 yüklü, GitHub'a gönderilmiş ve Flutter projesi `~/kelime-cemberi` altında olmalı.

1. `kelime-cemberi-v32-4-muze-rahatlama-temalar.zip` dosyasını telefonun İndirilenler klasörüne kaydet.
2. Termux'a şunu **tek seferde** yapıştır:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v32-4-muze-rahatlama-temalar.zip -d . && bash V324_GITHUB.sh
```

3. GitHub Actions'ta en son `build` yeşil olursa `kelime-cemberi-apk` dosyasını indir. Mevcut uygulamayı kaldırmadan aynı imzalı APK'yı üzerine kur.

## Ekranlar

**Macera Merkezi → V31 → MÜZE & ZEN**

- **MÜZE:** 81 il. Birinci ana seviye bitince şehir manzarası, ikinci seviye bitince kültür notu, üçüncü seviye bitince şehir mührü açılır. Her şehirde 3 koleksiyon maddesi, toplam 243. Müze ekstra altın vermez.
- **RAHATLAMA:** Süresiz, rakipsiz, cezasız sonsuz kelime sırası. Harfleri dokunarak sırala, 'Geri Al', 'Sil', 'Ücretsiz İpucu'. Tamamlanan sayı yalnız `v324_zen_solved` olarak saklanır; altın kazanılmaz.
- **TEMALAR:** Klasik Altın, Zümrüt, Gece Moru. `v324_ring_theme` anahtarıyla saklanır. Seçim, hem Rahatlama çemberine hem **ana oyunun sürüklenerek harf birleştirilen** gerçek çemberine uygulanır. Eski çember kuralları ve merkez karıştır butonu korunur.

## Kayıt güvenliği

Eski bölüm/ses/altın anahtarları değiştirilmez. `v324_*` yedek filtrelerine eklenir. Bu paket APK derlemesi değil; komutun sonunda kaynak denetimi çalışır. APK'yı yalnız GitHub Actions başarıyla oluşturabilir.

Kurulum sırasında bir hata mesajı çıkarsa ekran görüntüsünü gönder; betik kaynak kontrolü başarısız olursa GitHub push yapmaz.
