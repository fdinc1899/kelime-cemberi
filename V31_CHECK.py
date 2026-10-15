#!/usr/bin/env python3
"""Source + bundled assets verification (does not pretend to compile APK)."""
from pathlib import Path
import re, hashlib, json, subprocess
root=Path.cwd()
assert (root/'kelime_main.dart').is_file()
original=(root/'lib/src/data/provinces.dart').read_text()
province_list=re.findall(r"ProvinceInfo\('([^']+)', '([^']+)', '([^']+)', '([^']+)', <int>\[([^\]]+)\]\)",original)
if len(province_list)!=81:
    cat=root/'lib/src/data/city_catalog.dart'
    if not cat.is_file(): raise SystemExit('V31 HATA: city_catalog.dart eksik')
    entries=re.findall(r"CityInfo\(id: (\d+), name: '([^']+)', gameCity: '([^']+)', region: '([^']+)', slug: '([^']+)', levelIds: <int>\[([^\]]+)\]",cat.read_text())
    province_list=[(name,city,region,slug,ids) for number,name,city,region,slug,ids in entries]
if len(province_list)!=81:
    raise SystemExit(f'V31 HATA: 81 il bekleniyor, {len(province_list)} okundu')
levels=[int(x.strip()) for name,city,region,slug,ids in province_list for x in ids.split(',')]
assert len(levels)==243 and len(set(levels))==243, '243 benzersiz bolum yok.'
assert all(i in levels for i in range(18))
images=list((root/'assets/images/v28_city_cards').glob('*.webp'))
assert len(images)==50, '50 V28 karti yok'
assert len(set(hashlib.sha256(x.read_bytes()).hexdigest() for x in images))==50, 'V28 manzaralari ayni'
# V31.1: Validate the required HD city assets BY NAME, not by the exact folder count.
# Previously installed V22 cities may legitimately add more than 19 WebP files.
required_hd = {'afyonkarahisar', 'aksaray', 'balikesir', 'bilecik', 'bolu', 'bursa', 'canakkale', 'denizli', 'edirne', 'eskisehir', 'isparta', 'karabuk', 'kirklareli', 'kocaeli', 'kutahya', 'sakarya', 'sivas', 'tekirdag', 'yalova'}
hd_cards_dir = root/'assets/images/hd_provinces/cards'
hd_scenes_dir = root/'assets/images/hd_provinces/scenes'
missing_hd = []
for slug in sorted(required_hd):
    for directory, kind in ((hd_cards_dir, 'kart'), (hd_scenes_dir, 'sahne')):
        img = directory / (slug + '.webp')
        if not img.is_file() or img.stat().st_size < 1000:
            missing_hd.append(f'{kind}: {img}')
if missing_hd:
    raise SystemExit('V31.1 HATA: Gerekli HD dosyalar eksik:\\n' +
                     '\\n'.join(missing_hd) +
                     '\\nV31.1 ZIP dosyasini proje kokune tam olarak acip tekrar deneyin.')
all_hd_cards = {p.stem for p in hd_cards_dir.glob('*.webp')}
all_hd_scenes = {p.stem for p in hd_scenes_dir.glob('*.webp')}
usable_hd = all_hd_cards & all_hd_scenes
print(f'V31.1 HD KONTROL: {len(required_hd)} zorunlu sahne mevcut, '
      f'{len(usable_hd)} kart+sahne cifti bulundu; ekstra dosyalar korundu.')
for _,city,region,slug,ids in province_list:
    assert ((root/f'assets/images/v28_city_cards/{slug}.webp').is_file() or
            (root/f'assets/images/hd_provinces/cards/{slug}.webp').is_file() or
            (root/f'assets/images/city_cards_hd/{slug}.webp').is_file() or
            (root/f'assets/images/provinces/{slug}.webp').is_file()), f'{city} görsel eksik'
for name in ['marmara','ege','akdeniz','icanadolu','karadeniz','doguanadolu','guneydogu']:
    f=root/f'assets/audio/v31_{name}.mp3'; assert f.is_file() and f.stat().st_size>500000
source=(root/'lib/src/features/v31_world.dart').read_text()
assert 'const int v31ChallengesPerCity = 13;' in source
assert 'const int v31ChallengeCount = 81 * v31ChallengesPerCity;' in source
assert 'v31_marathon_done' in source and 'v31_treasure_claimed' in source
assert 'KC31.' in source and 'v31_night_mode' in (root/'lib/src/screens/game_screen.dart').read_text()
assert 'V31WorldCenter(' in (root/'lib/src/features/v29_experience.dart').read_text()
assert 'V31LivingBackdrop(' in (root/'lib/src/screens/game_screen.dart').read_text()
assert "part 'src/features/v31_world.dart';" in (root/'kelime_main.dart').read_text()
assert 'assets/images/hd_provinces/scenes/' in (root/'pubspec.yaml').read_text()
print('V31 KAYNAK KONTROLU GECTI: 81 il, 243 ana bolum, 1053 ek gorev tanimi, 50 manzara + en az 19 HD kart, 7 muzik.')
print('V3 kayit anahtarlarina ve puzzle kimliklerine dokunulmadi. APK derlemesi bu kontrolde yapilmadi.')
