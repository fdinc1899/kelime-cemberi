#!/usr/bin/env python3
"""V32.2 additive and repeat-safe patch. Never rewrite legacy save IDs."""
from pathlib import Path
import re
ROOT = Path.cwd()
MAIN = ROOT / 'kelime_main.dart'
LIBMAIN = ROOT / 'lib/main.dart'
WORLD = ROOT / 'lib/src/features/v31_world.dart'
ARCADE = ROOT / 'lib/src/features/v321_arcade.dart'
NEW = ROOT / 'lib/src/features/v322_journey.dart'
PART = "part 'src/features/v322_journey.dart';"
MARK = '// V322_JOURNEY_TAB'

def fail(reason):
    raise SystemExit('V32.2 DURDU: ' + reason + '\nEski kayıt dosyalarına ve ana bölüm kimliklerine dokunulmadı.')

if not all(x.is_file() for x in [MAIN, WORLD, ARCADE, NEW]):
    fail('Önce V32.1 kurulmalı; ZIP de proje köküne açılmalı.')
source = NEW.read_text(encoding='utf-8')
if not source.startswith('part of kelime_sehirleri;') or 'class V322Journey extends StatefulWidget' not in source:
    fail('Yeni oyun kodu bulunamadı.')
for needle in ('v322_detective_steps','v322_scenery_tiles','v322_route_stops'):
    if needle not in source:
        fail('V32.2 ödül ve kayıt anahtarı eksik: ' + needle)
main_updates = {}
for path in [MAIN, LIBMAIN]:
    if not path.is_file():
        continue
    text = path.read_text(encoding='utf-8')
    anchor = "part 'src/features/v321_arcade.dart';"
    if text.count(PART) > 1:
        fail(path.as_posix() + ': part bağlantısı yinelenmiş.')
    if text.count(PART) == 0:
        if text.count(anchor) != 1:
            fail(path.as_posix() + ': V32.1 bağlantısı yok.')
        text = text.replace(anchor, anchor + '\n' + PART, 1)
    main_updates[path] = text
world = WORLD.read_text(encoding='utf-8')
if 'class V31WorldCenter extends StatefulWidget' not in world:
    fail('V31 Macera ekranı bulunamadı.')
if 'V321Arcade(' not in world:
    fail('Önce V32.1 Oyun Modları yüklenmeli.')

if MARK in world:
    if world.count(MARK) != 1 or world.count('V322Journey(') != 1:
        fail('V32.2 yarım yüklenmiş.')
    print('V32.2 zaten yüklü, sekme tekrar eklenmeyecek.')
else:
    def insert_entry(src, pattern, entry, label):
        matches = list(re.finditer(pattern, src, flags=re.MULTILINE | re.DOTALL))
        if len(matches) != 1:
            fail(label + ' listesi bulunamadı ya da birden çok eşleşti.')
        m = matches[0]
        middle = m.group('middle').rstrip()
        if not middle or 'V322Journey(' in middle:
            fail(label + ' listesi beklenenden farklı.')
        sep = '' if middle.endswith(',') else ','
        replacement = m.group('prefix') + middle + sep + '\n      ' + entry + m.group('suffix')
        return src[:m.start()] + replacement + src[m.end():]
    world = insert_entry(world, r'(?P<prefix>^\s*const titles\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
        "'KEŞİF+'", 'Sekme başlıkları')
    world = insert_entry(world, r'(?P<prefix>^\s*const icons\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
        'Icons.travel_explore', 'Sekme simgeleri')
    world = insert_entry(world, r'(?P<prefix>^\s*final views\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
        'V322Journey(prefs: widget.prefs, onReward: widget.onReward)', 'Sekme ekranları')
    title = re.search(r'(?m)^\s*const titles\s*=', world)
    if not title:
        fail('Sekme ana bağlantısı kayıp.')
    world = world[:title.start()] + '    ' + MARK + '\n' + world[title.start():]

# Include new keys in the existing offline manual backup, without touching old keys.
if "key.startsWith('v322_')" not in world:
    pat = r"key\.startsWith\('v321_'\)"
    if len(re.findall(pat, world)) != 1:
        fail('V32.1 yerel yedek anahtarı bulunamadı.')
    world = re.sub(pat,
        "key.startsWith('v321_') || key.startsWith('v322_')", world, count=1)

if world.count('V322Journey(') != 1 or world.count(MARK) != 1:
    fail('Yeni sekme tekilliği doğrulanamadı.')
if not all(x in world for x in ('v31_marathon_done','v31_treasure_claimed','V321Arcade(')):
    fail('Eski ilerleme ve sekme bağlantıları eksik.')

# Nothing gets written until all checks pass.
for path, data in list(main_updates.items()) + [(WORLD, world)]:
    if path.read_text(encoding='utf-8') != data:
        path.write_text(data, encoding='utf-8')
print('V32.2 TAMAM: 81 dedektif dosyası + 486 manzara parçası + 7 bölgesel rota.')
print('Eski 243 ana bölüm, V31 ve V32.1 kayıt anahtarları değişmedi.')
