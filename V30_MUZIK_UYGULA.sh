#!/usr/bin/env bash
# Kelime Çemberi V30 — bu komutun çalıştığı dizin projenin köküdür.
set -euo pipefail
cd "$(dirname "$0")"
python - <<'PY'
from pathlib import Path
import re, wave

base=Path.cwd()
assets=base/'assets/audio'
mp3=assets/'ambient.mp3'
fx=assets/'success.wav'
pubspec=base/'pubspec.yaml'
if not mp3.is_file() or not fx.is_file():
    raise SystemExit('HATA: Muzik dosyalari eksik. ZIP dosyasini proje kokune acmalisin.')
if mp3.stat().st_size<500_000:
    raise SystemExit('HATA: Yuksek kaliteli ambient.mp3 dosyasi bulunamadi.')
if not (mp3.read_bytes()[:3]==b'ID3' or mp3.read_bytes()[:1]==b'\xff'):
    raise SystemExit('HATA: ambient.mp3 gecersiz gorunuyor.')
with wave.open(str(fx),'rb') as w:
    assert w.getnchannels()==2, 'HATA: Yeni kutlama sesi stereo degil.'
    assert w.getframerate()>=44100, 'HATA: Kutlama sesi ornekleme hizi dusuk.'
if not pubspec.exists() or not re.search(r'^\s*-\s*assets/audio/\s*$',pubspec.read_text(encoding='utf-8'),re.M):
    raise SystemExit('HATA: pubspec.yaml icinde assets/audio/ eksik. Yanlis proje surumu olabilir.')
# Eski sürümün önbellekteki müziği tutmasını önlemek için sadece geçici dosya adı değişir.
paths=[base/'lib/src/screens/game_screen.dart',base/'kelime_main.dart',base/'lib/main.dart']
counts=[0,0]
for path in paths:
    if not path.exists():
        continue
    before=path.read_text(encoding='utf-8')
    after,n1=re.subn(r'kelime_sehirleri_muzik(?:_v\d+)?\.mp3', 'kelime_sehirleri_muzik_v30.mp3',before)
    after,n2=re.subn(r'kelime_sehirleri_tebrik(?:_v\d+)?\.wav', 'kelime_sehirleri_tebrik_v30.wav',after)
    counts[0]+=n1;counts[1]+=n2
    if after!=before:
        path.write_text(after,encoding='utf-8')
if min(counts)==0:
    raise SystemExit('HATA: Muzik onbellek kodu bulunamadi. Projendeki ses kodu farkli; degisiklik gonderilmedi.')
print('V30 MUZIK KONTROL BASARILI: Stereo muzik, kutlama sesi ve onbellek yenilendi.')
print('Mevcut muzik ayari / ilerleme / altin kayitlari degistirilmedi.')
PY
