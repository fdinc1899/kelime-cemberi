# Kelime Şehirleri V11 — Görsel iyileştirme

- V10 + Kapadokya kelime/sayaç ilerleme düzeltmesini temel alır.
- Kapadokya bağımsız, yüksek çözünürlüklü yeni dikey manzara kullanır.
- Diğer beş şehir varlığı 1080×1920, şehir haritası kartları 960×520.
- Şehir haritası için bulanık kolaj kesiti yerine yeni vektörel stil arka plan.
- Ödül, menü, profil ve bölüm sonu canlı Flutter bileşenleri olarak korunur.
- Yerel kayıt, 18 bulmaca, bölüm kilidi, müzik ve çıkış onayı korunur.

Not: Antalya/Mardin/İzmir/Ankara kaynakları düşük çözünürlüklü olduğu için yalnızca
kayıpsız bir gerçek ayrıntı restorasyonu mümkün değildir; sıradaki görsel değişimlerinde
bağımsız yüksek çözünürlüklü şehir görselleri gerekir.

## GitHub
Var olan `.github/workflows/build.yml` dosyanız `flutter create` yapıyorsa
mevcut haliyle çalışmaya devam eder. V11 bu dosyayı değiştirmez.

Termux: \n`cd ~/kelime-cemberi && unzip -o ~/storage/downloads/kelime-sehirleri-v11.zip -d . && git add kelime_main.dart lib pubspec.yaml assets README.md GORSel_NOTLARI.txt && git commit -m "V11 daha net sehirler harita ve ilerleme" && git push origin main`
