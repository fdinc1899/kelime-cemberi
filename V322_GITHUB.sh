#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[ -f kelime_main.dart ] && [ -f lib/src/features/v321_arcade.dart ] || {
  echo 'HATA: Termux projesinde V32.1 kurulu olmalı.'; exit 1;
}
command -v python >/dev/null || { echo 'HATA: Python gerekli (pkg install python)'; exit 1; }
command -v git >/dev/null || { echo 'HATA: Git gerekli (pkg install git)'; exit 1; }
python tools/V322_PATCH.py
python tools/V322_VERIFY.py
python -m py_compile tools/V322_PATCH.py tools/V322_VERIFY.py
git add kelime_main.dart lib/src/features/v31_world.dart lib/src/features/v322_journey.dart \
  tools/V322_PATCH.py tools/V322_VERIFY.py V322_GITHUB.sh V322_KURULUM.md
if [ -f lib/main.dart ]; then git add lib/main.dart; fi
git diff --cached --check
if git diff --cached --quiet; then
  echo 'V32.2 zaten GitHub hesabında; yeni commit yok.'
else
  git commit -m 'V32.2 offline detective scenery and discovery routes'
  git push origin HEAD
fi
echo 'BİTTİ: GitHub Actions sayfasından APK derleme sonucunu kontrol et.'
