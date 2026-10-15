# Kelime Çemberi V31.6 — Günlük Keşif (bulutsuz)

Bu paket **V31+** oyuna yeni bir **GÜNLÜK+** sekmesi ekler. V31.4 / V31.5 üzerine de kurulabilir. Firebase, hesap, sunucu, fotoğraf lisansı veya internet gerektiren yeni bir özellik içermez. Önceden eklenmiş BULUT sekmesini değiştirmez veya etkinleştirmez.

## Gerçekten eklenen özellikler

1. **Günün Kelimesi:** Tarihe göre günlük yeni karışık kelime, isteğe bağlı ilk harf ipucu, tamamlandığında bir kez **7 altın**.
2. **Günlük seri:** Önceki gün dahil tamamlanan ardışık günler sayılır; ilerleme yerel olarak kaydedilir.
3. **Günün Şehri:** Her gün farklı bir şehir manzarası ve onun coğrafya testine hızlı geçiş.
4. **81 İl Bilgi Testi:** 81 il için birer bölge sorusu, dört seçenek, ilk doğru cevapta il başına bir defa **5 altın**.
5. **11 başarı rozeti:** Ana bölüm, şehir, ek görev, hatıra, bilgi testi ve günlük seri eşiklerine bağlı rozetler; her ödül sadece bir defa alınabilir.

Yeni kayıt anahtarları: `v316_daily_solved`, `v316_city_quiz_done`, `v316_medals_claimed`. Önceki V3/V29/V31 ilerleme ve altın anahtarlarına dokunulmaz. Eski 81 il, 243 ana bölüm ve 1.053 ek görev kimliği aynı kalır. Altınları oyunun mevcut `onReward` fonksiyonu verir. Telefon tarihi elle değiştirilirse çevrimdışı günlük ödül düzeni manipüle edilebilir; sunucu doğrulaması yoktur.

## Kurulum — tek Termux komutu

1. `kelime-cemberi-v31-6-gunluk-kesif.zip` dosyasını Android Download/İndirilenler klasörüne kaydedin.
2. Termux'ta:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v31-6-gunluk-kesif.zip -d . && bash V316_GITHUB.sh
```

3. GitHub Actions ekranında yeni `flutter build apk --release` çalışmasını kontrol edin. Yeşil tik olmadan APK'nın derlendiği iddia edilemez.
4. APK'yı cihazdaki oyunun **üzerine** aynı paket kimliği ve imza ile yükleyin; oyunu silmeyin.
5. Oyunda **Macera → V31 → GÜNLÜK+** yolunu açıp Günlük / İl Testi / Rozetler sekmelerini deneyin.

## İleri test kontrol listesi

- Günün kelimesi ilk çözümde +7; aynı gün tekrar 0.
- İl testi ilk doğru cevapta +5; yeniden açınca aynı il 0.
- Rozet kilitli/ödüle hazır/alındı halleri; aynı rozeti ikinci kez alma 0.
- V31 ana bulmaca ilerlemesi, hatıralar, favoriler ve altınları değişmeden açılıyor.
- Dar telefon ekranlarında sekme ve kartlar kaymıyor.

**Doğrulama sınırı:** Python statik testleri ve Git kurulum testleri Flutter derleme veya gerçek Android cihaz testinin yerine geçmez.
