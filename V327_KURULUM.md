# Kelime Çemberi V32.7 — Akıllı Öğretici

## İçerik
- İlk defa oyuna giren ve henüz ilk bölümü geçmemiş oyuncu için 5 adımda ayrı, etkileşimli öğretici.
- K/A/L/E harflerini parmakla sürükleyerek veya sırayla dokunarak **KALE** oluşturma.
- Bulmaca kutuları, ücretsiz eğitim karıştır/ipucu denemesi, örnek kutlama ve şehir açılış bilgisi.
- **Ayarlar → Nasıl Oynanır?** ve oyun menüsü → **Nasıl Oynanır?** üzerinden tekrar açma.
- Macera Merkezi, V31 ve V32.1–V32.4 modlarında bir kez görünen kısa ipuçları; `NASIL OYNANIR?` ile istediğin zaman tekrarı.
- Yeni anahtarlar: `v327_intro_seen` ve `v327_mode_seen_*`; eski altın ve bölüm anahtarları değiştirilmez.
- Eğitim ekranı **ödül kazandırmaz ve altın harcamaz**. Gerçek ödüller normal oyun modlarında alınır.

## Kurulum
ZIP dosyasını telefonun Downloads klasörüne indirip Termux'ta bir kez çalıştır:

```sh
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v32-7-akilli-ogretici.zip -d . && bash V327_GITHUB.sh
```

## Koruma
Eski APK'yı kaldırma: Aynı paket kimliği ve imzayla üretilen yeni APK'yı üzerine kur. Kurulum betiği kod eşleşmeleri beklenenden farklıysa **yazmadan durur**. Tekrar çalıştırma güvenlidir.

## Test
Kaynak bağlantı, tekrar çalıştırma ve Git komutları yerel ortamda test edilir. Flutter/Android derlemesi için GitHub Actions'ın yeşil tamamlanması gerekir.
