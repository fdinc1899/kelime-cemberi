#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
command -v python >/dev/null || { echo 'Python eksik: pkg install -y python'; exit 2; }
for required in kelime_main.dart pubspec.yaml lib/src/screens/game_screen.dart lib/src/data/provinces.dart; do
  test -s "$required" || { echo "HATA: mevcut Flutter projesi eksik: $required"; exit 3; }
done
if ! git diff --cached --quiet; then
  echo 'HATA: Daha önce stage edilmiş değişiklikler var. Git status kontrol edilmeli.'; exit 4
fi
backup=$(mktemp -d)
files=(kelime_main.dart lib/main.dart lib/src/data/provinces.dart lib/src/screens/game_screen.dart \
  lib/src/features/adventure_features.dart lib/src/features/v29_experience.dart pubspec.yaml)
for f in "${files[@]}"; do
  if [ -f "$f" ]; then mkdir -p "$backup/$(dirname "$f")"; cp "$f" "$backup/$f"; fi
done
rollback() {
  echo 'V31 KURULUM HATASI: Mevcut kodu önceki haline geri getiriyorum.'
  for f in "${files[@]}"; do
    if [ -f "$backup/$f" ]; then cp "$backup/$f" "$f"; fi
  done
}
trap rollback ERR
# Existing installs are accepted: V29 and V30 installers are idempotent.
bash V29_UYGULA.sh
bash V30_MUZIK_UYGULA.sh
python V31_PATCH.py
python V29_KONTROL.py
python V31_CHECK.py
trap - ERR
rm -rf "$backup"
git add kelime_main.dart lib/src/data/provinces.dart lib/src/screens/game_screen.dart \
  lib/src/features/adventure_features.dart lib/src/features/v29_experience.dart \
  lib/src/features/v31_world.dart pubspec.yaml \
  V28_UYGULA.sh V28_PROVIDER_EKLEME.txt V29_PATCH.py V29_KONTROL.py V29_UYGULA.sh \
  V30_MUZIK_UYGULA.sh V31_PATCH.py V31_CHECK.py V31_GITHUB.sh V31_KURULUM.md
[ ! -f lib/main.dart ] || git add lib/main.dart
[ ! -f lib/src/data/city_catalog.dart ] || git add lib/src/data/city_catalog.dart
# Gitignore may ignore binary art / sounds: explicit force is deliberate.
git add -f assets/images/v28_city_cards/*.webp assets/images/hd_provinces/cards/*.webp \
  assets/images/hd_provinces/scenes/*.webp assets/audio/ambient.mp3 \
  assets/audio/success.wav assets/audio/v31_*.mp3
if git diff --cached --quiet; then
  echo 'V31 zaten GitHub deposunda; yeni commit gerekmiyor.'
else
  git commit -m 'V31 macera, 1053 gorev, manzaralar, 7 muzik ve yedek'
fi
if [ "${V31_DRY_RUN:-0}" = '1' ]; then
  echo 'DRY RUN: GitHub push bu testte atlandi.'
else
  git push origin main
fi
