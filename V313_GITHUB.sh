#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [ ! -f kelime_main.dart ] || [ ! -f lib/src/data/provinces.dart ]; then
  echo 'V313 HATA: ~/kelime-cemberi kökünde değilsin ya da proje eksik.';exit 2
fi
if ! git diff --cached --quiet; then echo 'V313: staged dosyaların var, önce git status kontrol et.';exit 3;fi
python tools/V313_ANDROID_BACKUP.py
# Photo installation must be reviewed first; no fake HD photo substitutions.
if compgen -G 'assets/images/v313_photos/cards/*.webp' > /dev/null; then
  python tools/V313_PATCH.py
fi
python - <<'PY'
from pathlib import Path
from xml.etree import ElementTree as ET
p=Path('android/app/src/main/AndroidManifest.xml')
r=ET.parse(p).getroot(); app=r.find('application');ns='{http://schemas.android.com/apk/res/android}'
assert app.get(ns+'allowBackup')=='true'
assert app.get(ns+'dataExtractionRules')=='@xml/v313_data_extraction_rules'
assert app.get(ns+'fullBackupContent')=='@xml/v313_backup_rules'
assert Path('tools/v313_places.json').is_file()
import json
x=json.loads(Path('tools/v313_places.json').read_text());assert len(x)==81 and len(set(i['slug'] for i in x))==81
print('V313 KONTROL: 81 il manifesti ve Android yedekleme yapılandırması geçerli.')
PY
# Do not stage unrelated local edits or push workflow files requiring special authorization.
git add android/app/src/main/AndroidManifest.xml \
  android/app/src/main/res/xml/v313_backup_rules.xml \
  android/app/src/main/res/xml/v313_data_extraction_rules.xml \
  tools/v313_places.json tools/v313_photo_pipeline.py \
  tools/V313_PATCH.py tools/V313_ANDROID_BACKUP.py \
  V313_GITHUB.sh V313_KURULUM.md
if [ -f V313_FOTOGRAF_KAYNAKLARI.csv ]; then git add V313_FOTOGRAF_KAYNAKLARI.csv;fi
if [ -d assets/images/v313_photos ]; then
  git add -f assets/images/v313_photos/cards/*.webp assets/images/v313_photos/scenes/*.webp
  git add lib/src/data/provinces.dart pubspec.yaml
fi
if git diff --cached --quiet;then echo 'V313: Gönderilecek değişiklik yok.';exit 0;fi
git commit -m 'V31.3 city photo pipeline and Android automatic progress backup'
if [ "${V313_DRY_RUN:-0}" = '1' ];then echo 'V313: test modu, push atlandı'; else git push origin main;fi
