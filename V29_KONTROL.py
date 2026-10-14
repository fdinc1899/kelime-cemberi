#!/usr/bin/env python3
"""V29.2 source checks for BOTH V19 literal and V21+ cityCatalog province models.
This validates actual province identity and saved level mapping rather than
mistaking a dynamically-built ProvinceInfo list for an empty catalog.
"""
from pathlib import Path
import hashlib, re, json, sys

root=Path.cwd()
files=['lib/src/data/provinces.dart','kelime_main.dart','lib/src/screens/game_screen.dart',
       'lib/src/features/adventure_features.dart','lib/src/features/v29_experience.dart','pubspec.yaml']
for path in files:
    if not (root/path).is_file():
        sys.exit(f'KONTROL HATASI: {path} eksik.')

src=(root/files[0]).read_text(encoding='utf-8')
main=(root/files[1]).read_text(encoding='utf-8')
game=(root/files[2]).read_text(encoding='utf-8')
adventure=(root/files[3]).read_text(encoding='utf-8')
fx=(root/files[4]).read_text(encoding='utf-8')
pubspec=(root/files[5]).read_text(encoding='utf-8')

# Expected 81 province names, game-city names, regions, slugs and historical
# level indices from the original game, independently recorded at release time.
EXPECTED_SHA='dbc9c781dec1a2c96585294d686141731099b1c36ffa0ed9ee0a56b10e3da89e'


def extract_calls(source, prefix):
    # Consume each call with balanced parentheses, respecting string quoting.
    for m in re.finditer(r'\b'+re.escape(prefix)+r'\s*\(', source):
        pos=m.end()
        depth=1
        quote=None
        escaped=False
        while pos<len(source) and depth:
            ch=source[pos]
            if quote:
                if escaped: escaped=False
                elif ch=='\\': escaped=True
                elif ch==quote: quote=None
            elif ch in ("'", '"'): quote=ch
            elif ch=='(': depth+=1
            elif ch==')': depth-=1
            pos+=1
        if depth: raise ValueError(f'{prefix} icinde kapanmayan parantez')
        yield source[m.end():pos-1]


def get_strings(args):
    return [x if x else y for x,y in re.findall(r"'((?:\\.|[^'\\])*)'|\"((?:\\.|[^\"\\])*)\"",args)]


def get_levels(args):
    m=re.search(r'<\s*int\s*>\s*\[\s*([\d,\s]+)\]',args)
    if not m: raise ValueError('3 bolumluk <int>[...] listesi eksik')
    return [int(x) for x in re.findall(r'\d+',m.group(1))]


def verify_records(records):
    if len(records)!=81:
        raise ValueError(f'81 il yerine {len(records)} il okundu')
    levels=[i for r in records for i in r[4]]
    expected_levels=set(range(18))|set(range(30,255))
    if len(levels)!=243 or len(set(levels))!=243 or set(levels)!=expected_levels:
        raise ValueError('243 bolumun eski IDleriyle eslesmesi bozulmus')
    if any(len(r[4])!=3 for r in records):
        raise ValueError('Bir ilin bolum sayisi 3 degil')
    digest=hashlib.sha256(json.dumps(records,ensure_ascii=False,separators=(',',':')).encode('utf-8')).hexdigest()
    if digest!=EXPECTED_SHA:
        raise ValueError('Il sirasi, adi veya bolum kimlikleri eski oyunla eslesmiyor')


def read_catalog(source):
    marker=re.search(r'\b(?:const|final)\s+List\s*<\s*CityInfo\s*>\s+cityCatalog\s*=',source)
    if marker is None: raise ValueError('cityCatalog listesi bulunamadi')
    part=source[marker.end():]
    end=part.find('];')
    if end<0: raise ValueError('cityCatalog listesi kapanmiyor')
    part=part[:end]
    out=[]
    for args in extract_calls(part,'CityInfo'):
        idmatch=re.search(r'\bid\s*:\s*(\d+)',args)
        if not idmatch: raise ValueError('CityInfo id alani eksik')
        city_id=int(idmatch.group(1))
        props={k:v for k,delim,v in re.findall(r"\b(name|gameCity|region|slug)\s*:\s*(['\"])(.*?)\2",args)}
        if len(props)!=4: raise ValueError(f'CityInfo #{city_id}: il adi/bölge/slug alanlari eksik')
        m=re.search(r'\blevelIds\s*:\s*(<\s*int\s*>\s*\[\s*[\d,\s]+\])',args)
        if not m: raise ValueError(f'CityInfo #{city_id}: levelIds eksik')
        out.append((city_id,[props['name'],props['gameCity'],props['region'],props['slug'],get_levels(m.group(1))]))
    if [i for i,r in out]!=list(range(1,82)):
        raise ValueError('cityCatalog id sirasi 1..81 degil')
    return [r for i,r in out]


def read_legacy(source):
    m=re.search(r'\b_provinces\s*=\s*<\s*ProvinceInfo\s*>\s*\[',source)
    if m is None: raise ValueError('Eski ProvinceInfo listesi tanimi okunamadi')
    section=source[m.end():]
    end=section.find('];')
    if end<0: raise ValueError('Eski ProvinceInfo listesi kapanmiyor')
    rows=[]
    for args in extract_calls(section[:end],'ProvinceInfo'):
        strs=get_strings(args)
        if len(strs)!=4: raise ValueError('Eski ProvinceInfo satirinda 4 metin alani yok')
        rows.append(strs+ [get_levels(args)])
    return rows

try:
    if re.search(r'\bcityCatalog\s*\.\s*map\s*\(\s*\(\s*city\s*\)\s*=>\s*ProvinceInfo\s*\(',src):
        # Verify the dynamic conversion actually preserves all five fields.
        call=next(extract_calls(src[src.index('cityCatalog.map'):], 'ProvinceInfo'))
        compact=re.sub(r'\s+','',call).rstrip(',')
        if compact!='city.name,city.gameCity,city.region,city.slug,city.levelIds':
            raise ValueError('cityCatalog -> ProvinceInfo alan eslesmesi degismis')
        catalog_path=root/'lib/src/data/city_catalog.dart'
        if not catalog_path.is_file(): raise ValueError('city_catalog.dart eksik')
        if "part 'src/data/city_catalog.dart';" not in main:
            raise ValueError('city_catalog.dart oyun girisinde part olarak ekli degil')
        verify_records(read_catalog(catalog_path.read_text(encoding='utf-8')))
        mode='V21+ dinamik katalog'
    else:
        verify_records(read_legacy(src))
        mode='V19 sabit katalog'
except (ValueError, StopIteration) as e:
    sys.exit('V29.2 KONTROL HATASI: '+str(e))

required={
  'V29 ana kodu':("part 'src/features/v29_experience.dart';",main),
  'Macera Merkezi':('V29AdventureDashboard(',game),
  'Dondurulen cark':('V29SpinDialog(onComplete: onSpin)',adventure),
  'Harita karti kaynagi':('V28_CARD_OVERRIDE',src),
  'Harita asset yolu':('assets/images/v28_city_cards/',pubspec),
  'Gunluk gorev kaydi':('v29_daily_challenge_date',fx),
  'Sezon kaydi':('v29_season_claim_month',fx),
}
for desc,(needle,text) in required.items():
    if needle not in text:
        sys.exit(f'V29.2 KONTROL HATASI: {desc} bulunamadi')

folder=root/'assets/images/v28_city_cards'
images=sorted(folder.glob('*.webp'))
if len(images)!=50:
    sys.exit(f'V29.2 KONTROL HATASI: 50 kart yerine {len(images)} kart var')
if len({hashlib.sha256(p.read_bytes()).hexdigest() for p in images})!=50:
    sys.exit('V29.2 KONTROL HATASI: Ayrı il görsellerinden bazilari ayni dosya')
print(f'V29.2 KONTROL BASARILI: {mode}; 81 il, 243 ana bölüm, 50 farkli şehir görseli, V29 baglantilari.')
print('NOT: Kaynak doğrulaması başarılı; APK derlemesi GitHub Actions ile kontrol edilmeli.')
