#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
for x in kelime_main.dart lib/src/features/v31_world.dart lib/src/features/v323_challenges.dart \
  lib/src/screens/game_screen.dart lib/src/widgets/painters.dart lib/src/features/v324_museum_zen.dart; do
  test -s "$x" || { echo "Eksik kaynak: $x. V32.3 önce yüklenmiş olmalı."; exit 1; }
done
command -v python >/dev/null || { echo 'Python gerekli: pkg install python'; exit 1; }
command -v git >/dev/null || { echo 'Git gerekli: pkg install git'; exit 1; }
python -m py_compile tools/V324_PATCH.py tools/V324_VERIFY.py
python tools/V324_PATCH.py
python tools/V324_VERIFY.py
# Stage only files owned by this update; never stage assets, private files or saves.
git add kelime_main.dart lib/src/features/v31_world.dart lib/src/screens/game_screen.dart \
  lib/src/widgets/painters.dart lib/src/features/v324_museum_zen.dart \
  tools/V324_PATCH.py tools/V324_VERIFY.py V324_GITHUB.sh V324_KURULUM.md
if [ -f lib/main.dart ]; then git add lib/main.dart; fi
git diff --cached --check
if git diff --cached --quiet; then
  echo 'V32.4 zaten GitHub reposuna yüklenmiş, yeniden commit gerekmiyor.'
else
  git commit -m 'V32.4 offline museum, zen mode and ring themes'
  git push origin HEAD
fi
echo 'BİTTİ: GitHub Actions derlemesini kontrol et. Eski APK yi silme.'
