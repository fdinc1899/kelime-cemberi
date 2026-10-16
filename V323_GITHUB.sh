#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[ -f kelime_main.dart ] && [ -f lib/src/features/v322_journey.dart ] || {
  echo 'HATA: Önce V32.2 kurulmuş olmalı; proje kökünde çalıştır.'; exit 1;
}
command -v python >/dev/null || { echo 'HATA: Termux Python gerekli (pkg install python)'; exit 1; }
command -v git >/dev/null || { echo 'HATA: Termux Git gerekli (pkg install git)'; exit 1; }
python -m py_compile tools/V323_PATCH.py tools/V323_VERIFY.py
python tools/V323_PATCH.py
python tools/V323_VERIFY.py
git add kelime_main.dart lib/src/features/v31_world.dart lib/src/features/v323_challenges.dart \
  tools/V323_PATCH.py tools/V323_VERIFY.py V323_GITHUB.sh V323_KURULUM.md
if [ -f lib/main.dart ]; then git add lib/main.dart; fi
git diff --cached --check
if git diff --cached --quiet; then
  echo 'V32.3 zaten GitHub’da, yeni commit yok.'
else
  git commit -m 'V32.3 offline sprint duels and mastery tower'
  git push origin HEAD
fi
echo 'BİTTİ: GitHub Actions sayfasında yeni APK derlemesini kontrol et.'
