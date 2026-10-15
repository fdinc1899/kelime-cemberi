# Kelime Çemberi V31.2 — çalışan özellik tamamlama

Bu küçük güncelleme V31'in üstüne uygulanır. Büyük görsel/müzik dosyalarını tekrar indirmez.

## Gerçekten eklenen iyileştirmeler

1. Şehir değiştiğinde fotoğraflı ve animasyonlu **Yeni Şehir** açılışı.
2. Oyun arka planında yumuşak, çapraz solma (fade) ve yakınlaştırma geçişi.
3. Bölüm bittiğinde 1–3 yıldızın sırayla büyüyerek görünmesi. Eski yıldız hesabı ve altın miktarı değişmez.
4. 1.053 ek görevin 13 adımı 1–4 kolay, 5–9 orta, 10–13 zor şeklinde işaretlenir. İlk cevaplar aynı kalır; yeni doğru cevap ödülleri sırasıyla 3, 5, 8 altındır.
5. Yanlış deneme yaptıkça kademeli harf ipucu görünür. Zorluk seçimi ana oyunun ilerleme kimliklerine dokunmaz.
6. Şehir görselleri `FilterQuality.high` ile örneklenir; mevcut 81 ayrı varlığın yolu kontrol edilir. Görüntü çözünürlüğü sihirli biçimde artırılmaz.
7. Daha önce karşılaşılan V31 `Object?` derleme hatası, dosyada hâlâ bulunuyorsa güvenle düzeltilir.

## Henüz tamamlanmayanlar

- 81 il için **yeni fotoğraf çözünürlüklü görseller** bu pakette üretilmedi; mevcut kaynaklar kullanılır. Gerekirse gerçek manzara fotoğrafları ayrı lisanslı resim paketi ile yüklenmelidir.
- Cihazlar arasında **otomatik bulut senkronizasyonu** için Firebase ya da başka sunucu, oturum açma ve güvenlik kuralları gerekir. V31'deki elle yedek kopyalama/geri yükleme korunur.
- APK derlemesi GitHub Actions'ta henüz doğrulanmadı. Sadece kaynak yapısı ve değişiklik noktaları kontrol edildi.

## Tek komut (Termux)

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v31-2-kalan-ozellikler.zip -d . && bash V312_GITHUB.sh
```

Komut, kaynakları değiştirmeden önce `~/kelime_v312_kod_yedegi_*` klasörüne yedek alır, 81 ili/243 bölümü doğrular, sadece üç Dart dosyasını ve kurulum dosyalarını commit ederek GitHub'a gönderir. APK testinde eski uygulamayı kaldırmayın.
