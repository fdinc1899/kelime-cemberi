# Şehir Hikâyeleri V18 — Premium arayüz yenilemesi

Bu paket V17 üzerindeki orijinal Flutter projesini günceller. Önceki 81 il,
243 ana bölüm, 12 ek bölüm ve kayıt anahtarları aynen korunmuştur.

## Yapılanlar

- **81 ilin şehir seçim kartı**: Tek bir dokunulabilir `V18ProvinceCard` tasarımı,
  tam kart boyunca kaliteli mevcut şehir kaynak görseli, solda numara,
  sağda lacivert zemin üzerinde isim/ilerleme/yıldız/kilit.
- Şehir seçimi üst bölümüne altın ilerleme işareti ve dekoratif ayraç.
- Günlük ödül penceresine referans tasarımdan ayrıştırılmış altın sandık
  görseli, parıltı, kırmızı kurdele, yeşil etkileşimli ödül düğmesi.
- Bölüm bitirme penceresinde altın yıldız vurguları, yeşil sonraki bölüm
  ve mavi haritaya dönüş butonu.
- Ayarlar, profil, oyun menüsü ve çıkış penceresinde ortak lacivert-altın
  gölgeli etkileşimli bileşenler. Geri tuşunda Hayır/Evet, Çık.
- V18 kodu ayrı bir Flutter `part` dosyasında.

## Sınırlar ve test

Referans görseller statik tasarım hedefidir. Bu pakette görselleri
screenshot olarak buton yapmadık; çalışan Flutter öğeleri ile yeniden
oluşturduk. Tasarım referansıyla piksel piksel aynı değildir. Kalan 74
ilin geçmiş sürümden kalan manzara çizimleri bu pakette değiştirilmemiştir.

Flutter APK derlemesi bu ortamda çalıştırılamamıştır. GitHub Actions
sonucu kontrol edilmeli, APK'yi kurmadan önce mümkünse uygulama
verilerinin yedeği alınmalıdır. Mevcut uygulamayı silmeden güncelleyiniz.

## Korunan kayıt anahtarları

`coins`, `current_level_v3`, `unlocked_v3`, `finished_levels_v3`,
`solved_v3_<index>`, `bonuses_v3_<index>`, `hints_v3_<index>`.
