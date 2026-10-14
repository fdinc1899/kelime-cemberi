#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
PROVINCES=lib/src/data/provinces.dart
GAME=lib/src/screens/game_screen.dart
PUBSPEC=pubspec.yaml
ASSETS=assets/images/v28_city_cards
[ -s "$PROVINCES" ] || { echo 'HATA: provinces.dart bulunamadi'; exit 2; }
[ -s "$GAME" ] || { echo 'HATA: game_screen.dart bulunamadi'; exit 2; }
[ -s "$PUBSPEC" ] || { echo 'HATA: pubspec.yaml bulunamadi'; exit 2; }
[ -s V28_PROVIDER_EKLEME.txt ] || { echo 'HATA: V28 patch eksik'; exit 2; }
for image in aydin mugla manisa usak burdur mersin adana osmaniye hatay kahramanmaras konya karaman nigde kirsehir kirikkale cankiri yozgat kayseri duzce zonguldak bartin kastamonu sinop samsun ordu giresun trabzon rize artvin gumushane bayburt tokat amasya corum erzincan erzurum agri igdir kars ardahan van hakkri diyarbakir sanliurfa gaziantep kilis adiyaman batman siirt sirnak; do
  [ -s "$ASSETS/$image.webp" ] || { echo "HATA: $image.webp yok. Paket eksik."; exit 3; }
done
# A patch must target the actual game card, not just the unused catalog.
grep -q 'ImageProvider _citySelectionImageProvider(ProvinceInfo province)' "$PROVINCES" || {
  echo 'HATA: Sehir secimi fonksiyonu farkli; kodu otomatik degistirmedim.'; exit 4;
}
grep -q 'Widget _cityMapCard(' "$GAME" || {
  echo 'HATA: Harita karti fonksiyonu farkli; kodu otomatik degistirmedim.'; exit 4;
}
if ! grep -Fq 'child: _cityImageWidget(city)),' "$GAME" && ! grep -Fq 'child: Image(image: _citySelectionImageProvider(province), fit: BoxFit.cover)),' "$GAME"; then
  echo 'HATA: Harita kartinin resim satiri beklenenden farkli; kodu degistirmedim.'; exit 4
fi
backup=$(mktemp -d)
cp "$PROVINCES" "$backup/provinces.dart"
cp "$GAME" "$backup/game_screen.dart"
cp "$PUBSPEC" "$backup/pubspec.yaml"
if [ -f lib/src/data/city_catalog.dart ]; then cp lib/src/data/city_catalog.dart "$backup/city_catalog.dart"; fi
rollback() {
  echo 'Kurulumda hata oldu; yedek kodlar geri getiriliyor.'
  cp "$backup/provinces.dart" "$PROVINCES"
  cp "$backup/game_screen.dart" "$GAME"
  cp "$backup/pubspec.yaml" "$PUBSPEC"
  if [ -f "$backup/city_catalog.dart" ]; then cp "$backup/city_catalog.dart" lib/src/data/city_catalog.dart; fi
}
trap rollback ERR
# Override must be inserted into the function the actual UI uses.
if ! grep -q 'V28_CARD_OVERRIDE' "$PROVINCES"; then
  sed -i '/^ImageProvider _citySelectionImageProvider(ProvinceInfo province) {$/r V28_PROVIDER_EKLEME.txt' "$PROVINCES"
fi
if grep -Fq 'child: _cityImageWidget(city)),' "$GAME"; then
  sed -i 's|child: _cityImageWidget(city)),|child: Image(image: _citySelectionImageProvider(province), fit: BoxFit.cover)),|' "$GAME"
fi
# Add asset directory to flutter assets list (does not modify dependencies).
if ! grep -Fq 'assets/images/v28_city_cards/' "$PUBSPEC"; then
  grep -q '^  assets:' "$PUBSPEC" || { echo 'HATA: pubspec assets basligi yok'; false; }
  sed -i '/^  assets:$/a\    - assets/images/v28_city_cards/' "$PUBSPEC"
fi
# Align later V21+ catalog when present; never change level IDs or ordering.
CATALOG=lib/src/data/city_catalog.dart
if [ -f "$CATALOG" ]; then
  for image in aydin mugla manisa usak burdur mersin adana osmaniye hatay kahramanmaras konya karaman nigde kirsehir kirikkale cankiri yozgat kayseri duzce zonguldak bartin kastamonu sinop samsun ordu giresun trabzon rize artvin gumushane bayburt tokat amasya corum erzincan erzurum agri igdir kars ardahan van hakkri diyarbakir sanliurfa gaziantep kilis adiyaman batman siirt sirnak; do
    # Single-line CityInfo entries in the V21–V26 catalog.
    sed -i "/slug: '$image',/s|cardAsset: '[^']*'|cardAsset: 'assets/images/v28_city_cards/$image.webp'|" "$CATALOG"
  done
fi
grep -q 'V28_CARD_OVERRIDE' "$PROVINCES"
grep -Fq 'child: Image(image: _citySelectionImageProvider(province), fit: BoxFit.cover)),' "$GAME"
grep -Fq 'assets/images/v28_city_cards/' "$PUBSPEC"
echo 'BASARILI: 50 sehir harita karti dogru kaynaklara baglandi.'
echo 'Islem kayitlari, level kimliklerini veya ikon dosyalarini degistirmedi.'
trap - ERR
rm -rf "$backup"
