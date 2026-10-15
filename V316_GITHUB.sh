#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[ -f kelime_main.dart ] && [ -f lib/src/features/v31_world.dart ] || {
  echo 'HATA: V31 kurulu Flutter projesini ~/kelime-cemberi içinde aç.'; exit 1;
}
command -v python >/dev/null || { echo 'HATA: Python eksik. Termux: pkg install python'; exit 1; }
command -v git >/dev/null || { echo 'HATA: Git eksik. Termux: pkg install git'; exit 1; }
python tools/V316_PATCH.py
python tools/V316_VERIFY.py
python -m py_compile tools/V316_PATCH.py tools/V316_VERIFY.py
git diff --check
# Never stage, overwrite or commit unrelated user edits.
git add kelime_main.dart lib/src/features/v31_world.dart lib/src/features/v316_expedition.dart \
  tools/V316_PATCH.py tools/V316_VERIFY.py V316_GITHUB.sh V316_KURULUM.md
if [ -f lib/main.dart ]; then git add lib/main.dart; fi
if git diff --cached --quiet; then
  echo 'V31.6 zaten kurulmuş. Yeni commit gerekmiyor.'
else
  git commit -m 'V31.6 offline daily quests geography quiz and medals'
  git push origin main
fi
