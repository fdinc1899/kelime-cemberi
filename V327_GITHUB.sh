#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"
if ! command -v python >/dev/null 2>&1; then echo 'Python Termux ortaminda gerekli.'; exit 1; fi
if ! command -v git >/dev/null 2>&1; then echo 'Git Termux ortaminda gerekli.'; exit 1; fi
if [[ ! -d .git ]]; then echo 'HATA: GitHub oyun projesi klasoru bulunamadi.'; exit 1; fi
python tools/V327_PATCH.py
python tools/V327_VERIFY.py
# Stage only intentional V32.7 files; do not auto-commit unrelated work.
git add -- kelime_main.dart lib/src/screens/game_screen.dart \
  lib/src/features/v29_experience.dart lib/src/features/v31_world.dart \
  lib/src/features/v321_arcade.dart lib/src/features/v322_journey.dart \
  lib/src/features/v323_challenges.dart lib/src/features/v324_museum_zen.dart \
  lib/src/features/v327_tutorial.dart tools/V327_PATCH.py tools/V327_VERIFY.py \
  V327_GITHUB.sh V327_KURULUM.md
if [[ -f lib/main.dart ]]; then git add -- lib/main.dart; fi
git diff --cached --quiet && { echo 'V32.7 zaten GitHub kaynaklarinda, yeni commit yok.'; exit 0; }
git commit -m 'V32.7 interaktif nasil oynanir ogreticisi'
git push origin HEAD
printf '\nBITTI: GitHub Actions ile APK derlemesini kontrol et.\n'
