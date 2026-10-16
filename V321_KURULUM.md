# Kelime Çemberi · V32.1 — Yeni Oyun Modları (1. aşama)

## İçerik
- **Şehir finali:** 81 ilde ayrı zor kelime; o ilin 3 mevcut ana bölümü bitmeden açılmaz. +30 altın, tek sefer.
- **Karışık harfler:** Ekrandaki harflere sırasıyla dokunup doğru kelimeyi kurma. +5 altın.
- **Eksik harf:** Gösterilen kelimenin boş harfini 4 seçenek arasından bulma. +4 altın.
- **Özel harfler:** Kilitli harfi ücretsiz çöz, altın harfi kullanarak +2 bonus kazan; joker kullanılırsa toplam ödül 7 yerine 5 altın. Ayrı görev.
- 81 il × 4 mod = **324 ayrı görev kimliği**. Sözcük havuzu tekrar eder, 324 benzersiz sözcük vaat edilmez.
- V32.1 eklentisi **Macera Merkezi → V31 → OYUN MODLARI** sekmesinden açılır.

## Kurulum
ZIP'i İndirilenler'e kaydet. Termux'a tek satır yapıştır:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v32-1-ilk-oyun-modlari.zip -d . && bash V321_GITHUB.sh
```

Yalnız `kelime_main.dart`, mevcutsa `lib/main.dart`, `lib/src/features/v31_world.dart` ve yeni `lib/src/features/v321_arcade.dart` kodlarına dokunulur. Eski seviyelerin kimlikleri, `assets` dosyaları, ana ses sistemi ve var olan kayıt değerleri değişmez. Eski `shared_preferences` anahtarları **sıfırlanmaz**. Yeni kayıt anahtarları: `v321_arcade_finished` / `v321_boss_finished`. Yerel V31 yedek kopyasına `v321_` kayıtları eklenir.

Kurulum testinin başarıyla bitmesi APK'nın başarıyla derlendiği anlamına gelmez. APK'yı GitHub Actions'da doğrulayın. Güncellemeyi **mevcut uygulamanın üzerine** aynı uygulama kimliği/imza ile yükleyin. Uygulamayı silmeyin.

## 12 Özelliğin yol haritası
- V32.1 (bu paket): şehir boss, 3 yeni bulmaca türü, özel harfler.
- V32.2 plan: kelime dedektifi, manzara tamamlama, keşif rotaları.
- V32.3 plan: süreli meydan okuma, yerel bilgisayar rakibi, ustalık kuleleri.
- V32.4 plan: şehir müzesi, rahatlama modu, özelleştirilebilir taş/tema.

Bunlar sonraki aşama planlarıdır; bu ZIP'e dahil değildir.
