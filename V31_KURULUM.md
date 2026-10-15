# Kelime Çemberi V31 — Tek GitHub ZIP

## Kurulum

1. `kelime-cemberi-v31-1-hd-kontrol-duzeltme.zip` dosyasını telefonda **Downloads** klasörüne indir.
2. Termux'ta `cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v31-1-hd-kontrol-duzeltme.zip -d . && bash V31_GITHUB.sh` komutunu çalıştır.
3. GitHub Actions üzerinde **APK derlemesini** bekle; yeşil tik olmadan başarılı APK iddia etme.
4. APK'yı aynı uygulama kimliği ve aynı imza anahtarıyla eski uygulamanın üzerine yükle. Önce uygulamayı silme.

## V31 içerikleri

- **81 il haritası:** 50 farklı V28 şehir manzarası, 19 farklı HD V21 manzarası, kalan şehirler için ayrı mevcut şehir dosyası. Eski ortak bölge arka planları yerine şehir dosyaları. Tüm 81 şehir için yeni fotoğraf çekimi/yüklemesi yapılmış DEĞİLDİR.
- **Sinematik geçiş:** Arka planda yavaş hareket ve gece modu; mevcut kutlama efektleri kullanılır.
- **Daha akıcı harf seçme:** dokunulan harflerde hafif titreşim, kelime/doğru cevaptaki V29 kutlamaları.
- **Ödüller:** Eski çark, sandık, 3-yıldız ve bonus; V31'de tamamlanan şehir başına bir kez +25 altın hatıra ödülü.
- **Görünüm:** gece/gündüz anahtarı ve yeni parallax efekti.
- **7 müzik:** yöresel geleneksel ezgilerin kopyası olmayan, 7 bölge için özgün algoritmik enstrümantal döngüler. V30 stereo ana müziği varsayılan; bölgesel müzik tercihle açılır.
- **Zorluk:** 81 il × 13 = **1053 ek kelime görevi**. Kelimeler tekrar edebilir; 1053 farklı sözlük kelimesi iddia edilmez.
- **Gizli hazineler:** 3 şehir bölümünü bitirince bir kez +25 altın kazanılır.
- **Kayıt:** Eski V3 ana bölüm kimlikleri, altın ve ilerleme korunur. V31 maraton/hatıra için yeni `v31_` anahtarları kullanılır.
- **Yedek:** V31 panelinden kayıt kodu kopyalanır, başka telefonda yapıştırılıp **elle içe aktarılabilir**. Bu işlem uçtan uca şifreli ya da otomatik bulut senkronizasyonu değildir. Yedek kodunda takma ad gibi bilgiler bulunabilir, kamuya açık paylaşmayın.

## Kullanım

Oyuna gir → **MACERA** → üstteki **V31** sekmesi. V31 altında **MARATON / HATIRALAR / GÖRÜNÜM / YEDEK**.

## Teknik ve dürüst kapsam

- GitHub Actions iş akışına dokunulmadı (GitHub token `workflow` scope hatası önlenir).
- `kelime_main.dart` ve `lib/main.dart` part bildirimi güncellendi, eski V3 ilerleme anahtarları değiştirilmedi.
- V29 ve V30 bileşenleri paket içinde olduğu için tek ZIP yeterli, installer tekrar çalıştırılabilir.
- Kontrol kodu statik doğrulama yapar; **Flutter derlemesi ve cihaz üzerinde açılış henüz bu ortamda yapılmadı**.
- 243 orijinal ana bölüm korunuyor, ek 1053 görev ayrı maraton modunda. Gerçek online yarışma, gerçek bulut oturumu ve 81 ayrı yeni HD fotoğraf mevcut değil.

# V31.1 — HD sahne kontrolü düzeltmesi

### Hata
`AssertionError: 19 HD kart/sahne eksik`

### Neden
Önceki `V31_CHECK.py` kodu HD klasörlerinde **tam 19** `.webp` bekliyordu.
Önceki V22 güncellemesinin 6 ayrı şehir görseli de aynı klasörde bulunabiliyor.
Bu yüzden 19'dan fazla görsel, yanlışlıkla "eksik" olarak yorumlanabiliyordu.

### Düzeltme
- Zorunlu 19 HD kart ve 19 HD sahne dosyası **isimlerine göre** doğrulanır.
- İlave HD görseller korunur; silinmez.
- Oyun yalnızca kartı ve sahnesi birlikte bulunan HD illeri seçer.
- V28'in 50 farklı manzarası, V30 stereo sesleri, V31 kodları korunur.
- Eski 81 il / 243 bölüm ve kayıt anahtarları değiştirilmez.
- Test geçmeden `git commit` / `git push` adımlarına geçilmez.

### Kurulum (Termux)
1. `kelime-cemberi-v31-1-hd-kontrol-duzeltme.zip` dosyasını Downloads'a indirin.
2. Proje kökünde çalıştırın:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v31-1-hd-kontrol-duzeltme.zip -d . && bash V31_GITHUB.sh
```

Başarı mesajı: `V31.1 HD KONTROL: ...` ve `V31 KAYNAK KONTROLU GECTI`.
GitHub Actions yeşil olmadan APK derlemesinin başarılı olduğu iddia edilmez.
