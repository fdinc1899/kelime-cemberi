#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
python tools/V325_PATCH.py
python tools/V325_VERIFY.py
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "HATA: Bu bir Git deposu degil."; exit 1
fi
# Only known source files — never stage unrelated files or user secrets.
git add kelime_main.dart lib/src/features/v325_adventure_theme.dart lib/src/features/v29_experience.dart lib/src/screens/premium_page.dart lib/src/screens/game_screen.dart tools/V325_PATCH.py tools/V325_VERIFY.py V325_GITHUB.sh V325_KURULUM.md
if [ -f lib/main.dart ]; then git add lib/main.dart; fi
if ! git diff --cached --quiet; then
  git commit -m "V32.5 adventure center color themes"
else
  echo "V32.5 daha once GitHub'a eklendi, yeni degisiklik yok."
fi
BRANCH=$(git symbolic-ref --quiet --short HEAD || true)
if [ -z "$BRANCH" ]; then echo "Git aktif dal (branch) tespit edilemedi."; exit 1; fi
git push origin "$BRANCH"
echo "TAMAM: GitHub Actions sayfasindan APK derlemesini kontrol et."
