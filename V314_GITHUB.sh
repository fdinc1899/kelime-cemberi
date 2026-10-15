#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
for x in kelime_main.dart lib/src/features/v31_world.dart lib/src/data/provinces.dart;do
  if [ ! -s "$x" ];then echo "V31.4 HATA: Eksik $x";exit 2;fi
done
if ! git diff --cached --quiet;then echo 'V31.4: Önceden stage edilmiş değişiklikler var; önce git status kontrol et.';exit 3;fi
python V314_PATCH.py
python - <<'PY'
from pathlib import Path
s=Path('lib/src/features/v31_world.dart').read_text()
assert 'V314_CITY_GUIDE' in s
assert '_v314CityGuide()' in s and '_v314Statistics()' in s
assert s.count('v31_favorite_city_slugs')>=2
assert "final data = <String, Object>{};" not in s
print('V31.4 KONTROL BASARILI: Sekmeler ve null-safety düzeltmesi yerinde.')
PY
git add lib/src/features/v31_world.dart V314_GITHUB.sh V314_PATCH.py V314_KURULUM.md
git diff --cached --check
if git diff --cached --quiet;then echo 'V31.4 zaten GitHub deposunda; yeni commit gerekmiyor.';exit 0;fi
git commit -m "V31.4 city guide favorites and progress statistics"
if [ "${V314_DRY_RUN:-0}" = '1' ];then echo 'TEST MODU: GitHub push atlandı';else git push origin main;fi
