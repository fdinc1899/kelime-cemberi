#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# Do not mix somebody's unrelated staged edits into this release.
if ! git diff --cached --quiet; then
  echo 'HATA: Git deposunda daha once stage edilmis degisiklikler var. Once git status kontrol et.'
  exit 5
fi
bash V29_UYGULA.sh
files=(kelime_main.dart lib/src/screens/game_screen.dart lib/src/data/provinces.dart
  lib/src/features/adventure_features.dart lib/src/features/v29_experience.dart
  pubspec.yaml V28_UYGULA.sh V28_PROVIDER_EKLEME.txt
  V29_GITHUB.sh V29_UYGULA.sh V29_PATCH.py V29_KONTROL.py V29_KURULUM.md V29_2_DUZELTME.md)
if [ -f lib/main.dart ]; then files+=(lib/main.dart); fi
if [ -f lib/src/data/city_catalog.dart ]; then files+=(lib/src/data/city_catalog.dart); fi
git add "${files[@]}"
git add -f assets/images/v28_city_cards/*.webp
if git diff --cached --quiet; then
  echo 'V29 zaten Git depoda; yeni commit gerekmiyor.'
else
  git commit -m 'V29.2 buyuk oyun guncellemesi - iki katalog destekli'
fi
if [ "${V29_DRY_RUN:-0}" = '1' ]; then
  echo 'TEST: push adimi bilerek atlandi.'
else
  git push origin main
fi
