# Şehir Hikâyeleri — uygulama ve yayın planı

## Tamamlanan V15 kodu (çevrimdışı ilk sürüm)

| Özellik | Uygulama | Kayıt |
|---|---|---|
| Günlük görev | 3 hedef ve tek seferlik altın ödülü | `adv15_*` |
| Şehir pasaportu | 6 mühür; 3 ana bölüm bitince açılır | Eski bitirilen bölüm verisinden |
| Manzara keşfi | Tamamlanan kelime oranına göre karartma azalır | Eski çözülmüş kelimelerden |
| Yeni bölümler | Mevcut 18 + 12 yeni bulmaca | Orijinal indeksler korunur |
| Haftalık mücadele | Yerel haftalık puan, 3 ödül hedefi | `adv15_*` |
| Üç yıldız | İpucu sayısına dayalı 1–3 yıldız | `adv15_stars_<index>` |
| Günlük çark | Günde bir yerel çevirme | `adv15_spin_day` |
| Yardımcı güçler | 15 / 80 altın harcaması, ücretsiz karıştırma | Eski altınlar, yeni bedava ipucu |
| Sürpriz sandık | Sandık biriktirme, 30–80 altın açma ödülü | `adv15_chests` |
| Şehir hikâyeleri | 6 şehir için çevrimdışı kısa tanıtım | Bölüm kilidinden türetilir |

## Yayın öncesi (zorunlu)

1. GitHub Actions üzerinde `flutter build apk --release` çalışsın.
2. APK eski sürümün **üzerine** kurulsun. Eski altınlar, kayıt ve ilerlemeler karşılaştırılsın.
3. Eski 18 bölümü bitirmiş kullanıcı ek bölüm 19'a erişebilsin.
4. Görev ve çark ödüllerinin aynı gün iki kez verilemediği test edilsin.
5. Arayüz 360×800, 412×915 ve daha büyük telefonlarda taşmasın.
6. Gün dönümü ve pazartesi sıfırlama testleri yapılsın.

## İkinci aşama — yüksek kalite ve içerik

- Yeni bulmacaları 30'dan en az 100'e artır; kelime sözlüğünü Türkçe için gözden geçir.
- 6 şehir için özgün HD manzara kaynaklarını bağımsız üret, boyutlandır ve test et.
- Manzara keşfi için animasyonlu parçacık ve açılış geçişi.
- Tekrar oynama moduyla üç yıldızı güvenli şekilde geliştirme (altın çift ödemesi olmayacak).
- Çark, sandık ve yıldız ödüllerine ses, titreşim ve detaylı kutlama.

## Üçüncü aşama — gerçek çevrim içi yarışmalar

- Oyuncu kimlik doğrulama ve izinli veri senkronizasyonu.
- Sunucu tarafında haftalık yarışma takvimi, puan doğrulaması ve hile denetimi.
- Arkadaş sıralamaları, gizlilik ayarları ve sunucu kontrollü ödül.
- Sunucu olmadıkça gerçek oyuncu sıralaması vaat edilmez.
