#!/usr/bin/env python3
"""Add 81-city HD-photo priority without rewriting existing city, levels, save keys."""
import re,sys
from pathlib import Path
ROOT=Path.cwd()
province=ROOT/'lib/src/data/provinces.dart'
pubspec=ROOT/'pubspec.yaml'
if not province.is_file() or not pubspec.is_file():sys.exit('V313: provinces.dart/pubspec.yaml eksik')
base=ROOT/'assets/images/v313_photos'
slugs=sorted({p.stem for p in (base/'cards').glob('*.webp') if (base/'scenes'/p.name).is_file()})
if not slugs:sys.exit('V313: Onaylı tam HD fotoğraf çifti bulunamadı; oyun koduna dokunulmadı.')
old=province.read_text()
if '_v313PhotoSlugs' in old:
    print('V313: Daha önce kuruldu; fotoğraf listesi güncelleniyor.')
    # This field is regenerated, but existing loader logic remains intact.
    s=re.sub(r'const Set<String> _v313PhotoSlugs = <String>\{[^}]*\};',"const Set<String> _v313PhotoSlugs = <String>{"+','.join(repr(x) for x in slugs)+"};",old,count=1)
else:
    marker='ImageProvider _cityImageProvider(String city) {'
    if old.count(marker)!=1:sys.exit('V313: Oyun resmi yükleyicisi bulunamadı; dosya değiştirilmedi.')
    s=old.replace(marker, "const Set<String> _v313PhotoSlugs = <String>{"+','.join(repr(x) for x in slugs)+"};\n\n"+marker,1)
    # Highest priority, even for the six early-city MemoryImage fallbacks.
    head='ImageProvider _cityImageProvider(String city) {'
    s=s.replace(head,head+"\n  final v313p = _provinces.firstWhere((p) => p.city == city);\n  if (_v313PhotoSlugs.contains(v313p.slug)) {\n    return AssetImage('assets/images/v313_photos/scenes/${v313p.slug}.webp');\n  }",1)
    card_marker='ImageProvider _citySelectionImageProvider(ProvinceInfo province) {'
    if s.count(card_marker)!=1:sys.exit('V313: Kart şehir seçicisi değişmiş; dosya değiştirilmedi.')
    s=s.replace(card_marker,card_marker+"\n  if (_v313PhotoSlugs.contains(province.slug)) {\n    return AssetImage('assets/images/v313_photos/cards/${province.slug}.webp');\n  }",1)
# all edits prepared in memory before writing
pub=pubspec.read_text()
for kind in ('cards','scenes'):
    asset=f'    - assets/images/v313_photos/{kind}/'
    if asset not in pub:
        if '  assets:\n' not in pub:sys.exit('V313: pubspec assets bölümü bulunamadı; dosya değiştirilmedi.')
        pub=pub.replace('  assets:\n','  assets:\n'+asset+'\n',1)
province.write_text(s);pubspec.write_text(pub)
print('V313: Fotograflar oyunda ve şehir haritasında en yüksek önceliğe bağlandı:',len(slugs))
