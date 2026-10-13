# V17 — Net şehir kartları

Bu paket, Şehir Hikâyeleri V16'nın üzerine uygulanacak **küçük bir görsel güncellemedir**.

- Şehir seçimindeki ilk yedi il için yeni kart çizimleri: İstanbul, Nevşehir/Kapadokya, Antalya, Mardin, İzmir, Ankara, Edirne.
- Kart fotoğrafının yanındaki metinler, kilit ve yıldızlar gerçek Flutter bileşenleridir; resim içine gömülü değildir.
- Sağ bölümdeki lacivert geçiş metinlerin okunmasını sağlar. Sol şehir sahnesi önceki sürüme göre netleştirilmiştir.
- Nevşehir adının kesilmemesi için kart başlığı sadeleştirilmiştir.
- Diğer 74 ilin mevcut arka planları V16'da olduğu gibi kalır. Bu paket onları fotoğraf gerçekçiliğine taşımıyor.
- Oyun ekranındaki tam boyutlu şehir arka planları bu güncellemede **değişmiyor**; sadece şehir seçimi kartları değişiyor.
- 81 il / 243 ana bölüm ve önceki 12 ek bölüm aynen kalır. İlerleme ve altın kayıtlarına dokunulmaz.

Görsel kaynakları: Kullanıcının beğendiği, bu sohbet içinde üretilmiş özgün şehir seçimi konseptindeki manzara parçaları; menü etiketleri ve butonları çıkarılıp kart görüntüsü olarak düzenlenmiştir. Kaynak görsel küçük olduğu için elde edilen görseller native büyük fotoğrafların yerini tutmaz, ancak eski bulanık kartlara göre daha nettir.

## Termux komutu

```sh
cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-sehirleri-v17-net-kartlar.zip -d . && git add lib/src/screens/intro_screens.dart lib/src/data/provinces.dart pubspec.yaml assets/images/city_cards_hd/ V17_KART_GUNCELLEMESI.md && git commit -m "V17 net sehir kartlari" && git push origin main
```

> Yeni APK derlemesini GitHub Actions'tan kontrol edin. Uygulamayı kaldırmadan üzerine kurun; önce mevcut dosyalarınızın yedeğini alın.
