#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if ! git diff --cached --quiet; then
  echo 'V31.2: Git stage alaninda mevcut degisiklik var. Once git status kontrol et.'
  exit 3
fi
python V312_PATCH.py
python - <<'PY'
from pathlib import Path
s=Path('lib/src/features/v31_world.dart').read_text()
g=Path('lib/src/screens/game_screen.dart').read_text()
p=Path('lib/src/data/provinces.dart').read_text()
assert 'V312_ADAPTIVE' in s and 'V312_CINEMATIC' in s
assert 'V312RewardStars(stars: stars)' in g and '_v312RevealCity(entering)' in g
assert 'final data = <String, Object?>{};' in s
assert 'filterQuality: FilterQuality.high' in p
print('V31.2 KAYNAK KONTROLU GECTI')
PY
git add lib/src/features/v31_world.dart lib/src/screens/game_screen.dart lib/src/data/provinces.dart V312_PATCH.py V312_GITHUB.sh V312_KURULUM.md
if git diff --cached --quiet; then
  echo 'V31.2 degisiklikleri GitHub icin zaten gonderilmis.'
else
  git commit -m 'V31.2 sehir gecisleri, odul animasyonlari ve uyarlamali bulmacalar'
fi
git push origin main
