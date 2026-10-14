#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
command -v python >/dev/null || { echo 'HATA: Termux icin once pkg install python calistirin'; exit 2; }
for file in kelime_main.dart lib/src/screens/game_screen.dart lib/src/data/provinces.dart lib/src/features/adventure_features.dart pubspec.yaml; do
  test -s "$file" || { echo "HATA: $file eksik. Mevcut proje klasorunde misin?"; exit 3; }
done
# One all-or-nothing source snapshot. V28 script also has its own safety checks.
backup=$(mktemp -d)
for file in kelime_main.dart lib/main.dart lib/src/screens/game_screen.dart lib/src/data/provinces.dart lib/src/data/city_catalog.dart lib/src/features/adventure_features.dart pubspec.yaml; do
  if [ -f "$file" ]; then mkdir -p "$backup/$(dirname "$file")"; cp "$file" "$backup/$file"; fi
done
rollback() {
  echo 'V29 KURULAMADI: Kodlari onceki durumuna geri getiriyorum.'
  for file in kelime_main.dart lib/main.dart lib/src/screens/game_screen.dart lib/src/data/provinces.dart lib/src/data/city_catalog.dart lib/src/features/adventure_features.dart pubspec.yaml; do
    if [ -f "$backup/$file" ]; then cp "$backup/$file" "$file"; fi
  done
}
trap rollback ERR
bash V28_UYGULA.sh
python V29_PATCH.py
python V29_KONTROL.py
trap - ERR
rm -rf "$backup"
echo 'TAMAM: V29 kod degisiklikleri uygulandi. Simdi git push yapilabilir.'
