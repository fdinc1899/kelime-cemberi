#!/usr/bin/env python3
"""V32.3: additive, idempotent Flutter source integration. Never changes old keys."""
from pathlib import Path
import re

ROOT = Path.cwd()
MAIN = ROOT / 'kelime_main.dart'
LIBMAIN = ROOT / 'lib/main.dart'
WORLD = ROOT / 'lib/src/features/v31_world.dart'
FEATURE = ROOT / 'lib/src/features/v323_challenges.dart'
PART = "part 'src/features/v323_challenges.dart';"
MARK = '// V323_CHALLENGES_TAB'

def stop(msg):
    raise SystemExit('V32.3 KURULUM DURDU: ' + msg + '\nKayıtlara dokunulmadı; eski bölüm kimlikleri değişmedi.')

for path in (MAIN, WORLD, FEATURE):
    if not path.is_file():
        stop(f'{path} bulunamadı. Önce V32.2 ve bu ZIP dosyası gerekir.')
feature = FEATURE.read_text(encoding='utf-8')
for needle in ('part of kelime_sehirleri;', 'class V323Challenges extends StatefulWidget',
               'v323_sprint_reward_days', 'v323_duel_rewarded', 'v323_tower_completed',
               'Timer.periodic(', 'widget.onReward'):
    if needle not in feature:
        stop('V32.3 oyun dosyası beklenenden farklı: ' + needle)

mains = {}
for path in (MAIN, LIBMAIN):
    if not path.is_file():
        continue
    src = path.read_text(encoding='utf-8')
    if src.count(PART) > 1:
        stop(f'{path}: yinelenen V32.3 part bulundu')
    if src.count(PART) == 0:
        anchor = "part 'src/features/v322_journey.dart';"
        if src.count(anchor) != 1:
            stop(f'{path}: V32.2 parça bağlantısı bulunamadı')
        src = src.replace(anchor, anchor + '\n' + PART, 1)
    if "import 'dart:async';" not in src:
        anchor = "import 'dart:io';"
        if src.count(anchor) != 1:
            stop(f'{path}: dart:io import bağlantısı yok')
        src = src.replace(anchor, "import 'dart:async';\n" + anchor, 1)
    mains[path] = src

world = WORLD.read_text(encoding='utf-8')
for needle in ('class V31WorldCenter extends StatefulWidget',
               'V321Arcade(', 'V322Journey(', '// V322_JOURNEY_TAB'):
    if needle not in world:
        stop('V32.2 kurulu değil: ' + needle)
if world.count(MARK) > 1 or world.count('V323Challenges(') > 1:
    stop('V32.3 bağlantıları yinelenmiş')

if MARK not in world:
    def append_entry(src, pattern, addition, name):
        results = list(re.finditer(pattern, src, flags=re.MULTILINE | re.DOTALL))
        if len(results) != 1:
            stop(name + ' listesi bulunamadı veya birden fazla eşleşti')
        m = results[0]
        inside = m.group('middle').rstrip()
        if not inside or 'V323Challenges(' in inside:
            stop(name + ' listesi beklenenden farklı')
        comma = '' if inside.endswith(',') else ','
        new = m.group('prefix') + inside + comma + '\n      ' + addition + m.group('suffix')
        return src[:m.start()] + new + src[m.end():]
    world = append_entry(world,
        r'(?P<prefix>^\s*const titles\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
        "'YARIŞ+',", 'Sekme başlığı')
    world = append_entry(world,
        r'(?P<prefix>^\s*const icons\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
        'Icons.timer_outlined,', 'Sekme simgesi')
    world = append_entry(world,
        r'(?P<prefix>^\s*final views\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
        'V323Challenges(prefs: widget.prefs, onReward: widget.onReward),', 'Sekme ekranı')
    title = re.search(r'(?m)^\s*const titles\s*=', world)
    if not title:
        stop('Sekme başlıkları bulunamadı')
    world = world[:title.start()] + '    ' + MARK + '\n' + world[title.start():]
else:
    if world.count('V323Challenges(') != 1:
        stop('Yarım V32.3 bağlantısı mevcut')
    print('V32.3 zaten kurulu; sekme bir kez bağlı.')

if "key.startsWith('v323_')" not in world:
    anchor = "key.startsWith('v322_')"
    if world.count(anchor) != 1:
        stop('V32.2 yerel yedek anahtar filtresi bulunamadı')
    world = world.replace(anchor, anchor + " || key.startsWith('v323_')", 1)

if world.count(MARK) != 1 or world.count('V323Challenges(') != 1:
    stop('Yeni sekme tekillik testi geçmedi')
if 'v31_marathon_done' not in world or 'v31_treasure_claimed' not in world:
    stop('Önceki kayıt anahtarları bulunamadı')
# Validate all source files before writing to avoid partial modifications.
for path, src in [*mains.items(), (WORLD, world)]:
    if path.read_text(encoding='utf-8') != src:
        path.write_text(src, encoding='utf-8')
print('V32.3 BAŞARILI: 60 saniyelik sürat, 3 zorluk düellosu ve 10 kat kule bağlandı.')
print('Mevcut 243 bölüm, V31 / V32.1 / V32.2 ilerleme ve altın anahtarları korunur.')
