#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
bash V30_MUZIK_UYGULA.sh
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo 'HATA: Bu dizin bir GitHub deposu degil.' >&2; exit 1
fi
git add assets/audio/ambient.mp3 assets/audio/success.wav V30_MUZIK_UYGULA.sh V30_GITHUB.sh V30_ACIKLAMA.txt
for p in lib/src/screens/game_screen.dart kelime_main.dart lib/main.dart; do
  if [ -f "$p" ]; then git add "$p"; fi
done
if git diff --cached --quiet; then
  echo 'V30 zaten yuklu; gonderilecek yeni degisiklik yok.'
  exit 0
fi
git commit -m 'V30 premium sehir muzigi ve kutlama sesleri'
git push origin main
echo 'V30 GITHUB PUSH TAMAMLANDI. GitHub Actions sonucunu kontrol et.'
