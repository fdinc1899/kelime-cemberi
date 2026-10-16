# Kelime Çemberi V32.6 — Tüm Macera modlarına tema renkleri

## Kurulum
ZIP dosyasını telefonun Downloads/İndirilenler klasörüne indir. Termux'ta:

```bash
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-cemberi-v32-6-tum-macera-temalari.zip -d . && bash V326_GITHUB.sh
```

## Değişiklikler
- V32.5'in 5 renk paletini korur; önceden seçilen tema bozulmaz.
- V31 ek kelime görevleri, V32.1 oyun modları, V32.2 keşif, V32.3 yarış, V32.4 müze/rahatlama ekranlarının panelleri ve vurguları palete uyar.
- Temayı Macera Merkezi sağ üst palet simgesinden seç; açık ekranlar anında yenilenir.
- Açık renkli butonlarda ve kutularda koyu kontrastlı yazı korunur.
- Harf çemberinin V32.4'e ait 3 bağımsız teması etkilenmez.
- Eski bölüm numaraları, altın ve günlük ödül anahtarları değiştirilmez.
- V32.5 kurulu değilse aynı paketten önce güvenle uygulanır.

## Not
- Bu bir Flutter kaynak yamasıdır; APK dosyası değildir.
- Kurulum öncesinde V32.1–V32.4 özellikleri projede bulunmalıdır.
- Dart/Flutter SDK bu ortamda olmadığı için gerçek APK derlemesi GitHub Actions üzerinden doğrulanmalıdır.
- Oyunu telefondan silme; önceki kayıtlar uygulamanın üzerine güncellemeyle korunur (aynı uygulama kimliği ve imza şartıyla).
