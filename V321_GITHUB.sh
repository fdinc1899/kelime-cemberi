#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[ -f kelime_main.dart ] && [ -f lib/src/features/v31_world.dart ] || {
  echo 'HATA: Önce V31 kurulu oyun projesine gir: cd ~/kelime-cemberi'; exit 1;
}
command -v python >/dev/null || { echo 'HATA: Termux için pkg install python'; exit 1; }
command -v git >/dev/null || { echo 'HATA: Termux için pkg install git'; exit 1; }
python tools/V321_PATCH.py
python tools/V321_VERIFY.py
python -m py_compile tools/V321_PATCH.py tools/V321_VERIFY.py
# Only stage this version's exact source files, never unrelated user changes.
git add kelime_main.dart lib/src/features/v31_world.dart lib/src/features/v321_arcade.dart \
  tools/V321_PATCH.py tools/V321_VERIFY.py V321_GITHUB.sh V321_KURULUM.md
if [ -f lib/main.dart ]; then git add lib/main.dart; fi
git diff --cached --check
if git diff --cached --quiet; then
  echo 'V32.1 zaten GitHub hesabına eklenmiş, yeni commit yok.'
else
  git commit -m 'V32.1 city boss rounds and new offline word modes'
  git push origin HEAD
fi
echo 'BİTTİ: GitHub Actions → APK derlemesini kontrol et.'
