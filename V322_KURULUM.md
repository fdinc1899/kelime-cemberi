# Kelime Çemberi V32.2 — Keşif+ (12 özellik yol haritası, ikinci paket)

V32.1'in üstüne **eklenen** çevrimdışı modlar:

- **Kelime Dedektifi:** 81 şehirde, şifreli 3 ipucundan oluşan dosyalar (243 ipucu); şehir başına bir kez +15 altın.
- **Manzara Tamamlama:** Her şehrin **mevcut** görselindeki 6 kapalı parçayı kelimelerle aç (486 parça); şehir başına bir kez +12 altın.
- **Keşif Rotaları:** Türkiye'nin 7 coğrafi bölgesi için 4'er şehir durağı (28 durak); rota başına bir kez +18 altın.

Toplam 243 + 486 + 28 = **757 küçük görev adımı**. Bu sayı eşsiz kelime veya farklı gerçek şehir fotoğrafı sayısı değildir; ipucu bankası şehirler arasında tekrar eder.

## Kurulum (Termux, telefon)

Önce ZIP'i **İndirilenler** klasörüne kaydet, sonra:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v32-2-kesif-paketi.zip -d . && bash V322_GITHUB.sh
```

GitHub Actions yeşilse APK'yı **mevcut uygulamanın üzerine** yükle; eski uygulamayı silme. Yeni menü: **Macera Merkezi → V31 → KEŞİF+**.

## Kayıt güvenliği ve sınırlar

- Ana bölümlerin 243 oyun aşaması ve seviye kimlikleri değiştirilmez. Altın ve mevcut ilerleme anahtarları değiştirilmez.
- Yeni kayıtlar `v322_detective_steps`, `v322_scenery_tiles`, `v322_route_stops` anahtarlarında tutulur.
- Yerel yedek izin listesine `v322_` eklendi. Aynı ZIP'in tekrar kurulması modları çoğaltmaz.
- Ödüller tamamlanan şehir veya rota başına **tek kez** verilir; tekrar oynayan oyuncu yeniden altın alamaz.
- **Yeni şehir fotoğrafı veya bulut senkronizasyonu içermez.**
- Kaynak denetimi paketle gelir; gerçek Flutter APK derlemesi bu ortamda yapılamaz. GitHub Actions sonucunu kontrol et.

## Sonraki paketler

V32.3: süreli yarışma, çevrimdışı kelime düellosu, ustalık kuleleri.
V32.4: şehir müzesi, rahatlama modu, kişiselleştirme.
