#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# V32.5 may already be installed. Running it again is safe and idempotent.
for f in tools/V325_PATCH.py tools/V325_VERIFY.py; do
  [ -s "$f" ] || { echo "Eksik V32.5 kaynagi: $f"; exit 1; }
done
# Check all prerequisites BEFORE changing any project source.
for n in v31_world v321_arcade v322_journey v323_challenges v324_museum_zen; do
  [ -s "lib/src/features/${n}.dart" ] || { echo "Eksik mod: $n. Once V32.1-V32.4 yukle."; exit 1; }
done
python tools/V325_PATCH.py
python tools/V325_VERIFY.py
python tools/V326_PATCH.py
python tools/V326_VERIFY.py
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
 echo "HATA: Git deposu bulunamadi."; exit 1
fi
git add kelime_main.dart lib/src/features/v325_adventure_theme.dart \
 lib/src/features/v326_extended_palette.dart \
 lib/src/features/v29_experience.dart lib/src/screens/premium_page.dart \
 lib/src/screens/game_screen.dart \
 lib/src/features/v31_world.dart \
 lib/src/features/v321_arcade.dart lib/src/features/v322_journey.dart \
 lib/src/features/v323_challenges.dart lib/src/features/v324_museum_zen.dart \
 tools/V325_PATCH.py tools/V325_VERIFY.py \
 tools/V326_PATCH.py tools/V326_VERIFY.py \
 V325_GITHUB.sh V325_KURULUM.md V326_GITHUB.sh V326_KURULUM.md
if [ -f lib/main.dart ]; then git add lib/main.dart; fi
if ! git diff --cached --quiet; then
 git commit -m "V32.6 extend adventure themes to all gameplay modes"
else
 echo "V32.6 zaten kurulu, yeni degisiklik yok."
fi
BRANCH=$(git symbolic-ref --quiet --short HEAD || true)
[ -n "$BRANCH" ] || { echo "Git dal adi bulunamadi"; exit 1; }
git push origin "$BRANCH"
echo "TAMAM: GitHub Actions sayfasindan APK durumunu kontrol et."
