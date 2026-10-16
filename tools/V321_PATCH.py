#!/usr/bin/env python3
"""Additive, repeat-safe V32.1 offline modes + 81 locked city bosses.

No V3/V29/V31 saved values or chapter IDs are read/written by installer.
Existing scripts, workflow and game files are not overwritten.
"""
from pathlib import Path
import re
import sys
ROOT = Path.cwd()
MAIN = ROOT / 'kelime_main.dart'
WORLD = ROOT / 'lib/src/features/v31_world.dart'
FEATURE = ROOT / 'lib/src/features/v321_arcade.dart'
LIBMAIN = ROOT / 'lib/main.dart'
PART = "part 'src/features/v321_arcade.dart';"
MARKER = '// V321_NEW_GAME_MODES'


def stop(msg):
    raise SystemExit('V32.1 DURDU: ' + msg + '\nEski oyun kodu değiştirilmedi.')

if not all(p.is_file() for p in (MAIN, WORLD, FEATURE)):
    stop('kelime_main.dart, V31 Macera Merkezi veya yeni oyun dosyası bulunamadı.')
feature = FEATURE.read_text(encoding='utf-8')
if not feature.startswith('part of kelime_sehirleri;') or 'class V321Arcade extends StatefulWidget' not in feature:
    stop('V32.1 yeni oyun dosyası bozuk.')
if 'v321_arcade_finished' not in feature or 'v321_boss_finished' not in feature:
    stop('V32.1 ödül kaydı kodu eksik.')
world = WORLD.read_text(encoding='utf-8')
if 'class V31WorldCenter extends StatefulWidget' not in world:
    stop('V31 Macera Merkezi kaynak kodu beklenenden farklı.')

mains = {}
for path in (MAIN, LIBMAIN):
    if not path.is_file():
        continue
    s = path.read_text(encoding='utf-8')
    if s.count(PART) == 1:
        mains[path] = s
        continue
    if s.count(PART) != 0:
        stop(str(path) + ' içinde yinelenen V32.1 part bulundu.')
    anchor = "part 'src/features/v31_world.dart';"
    if s.count(anchor) != 1:
        stop(str(path) + ' içinde V31 part bağlantısı yok.')
    mains[path] = s.replace(anchor, anchor + '\n' + PART, 1)

if MARKER in world:
    if world.count(MARKER) != 1 or world.count('V321Arcade(') != 1:
        stop('V32.1 daha önce yarım uygulanmış.')
    print('V32.1 zaten kurulu, kod tekrarlanmadı.')
else:
    def add_to_list(source, pattern, item, label):
        matches = list(re.finditer(pattern, source, flags=re.MULTILINE | re.DOTALL))
        if len(matches) != 1:
            stop(label + ' listesi bulunamadı veya birden çok kopyası var.')
        m = matches[0]
        inside = m.group('middle').rstrip()
        if not inside.strip() or 'V321Arcade' in inside:
            stop(label + ' listesi güvenli değil.')
        separator = '' if inside.endswith(',') else ','
        replacement = m.group('prefix') + inside + separator + '\n      ' + item + m.group('suffix')
        return source[:m.start()] + replacement + source[m.end():]

    world = add_to_list(world,
      r'(?P<prefix>^\s*const titles\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
      "'OYUN MODLARI'", 'Başlık')
    world = add_to_list(world,
      r'(?P<prefix>^\s*const icons\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
      'Icons.extension_rounded', 'Simge')
    world = add_to_list(world,
      r'(?P<prefix>^\s*final views\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
      '''V321Arcade(prefs: widget.prefs, completed: widget.completed,
        onReward: widget.onReward)''', 'Ekran')
    first_title = re.search(r'(?m)^\s*const titles\s*=', world)
    if not first_title:
        stop('V31 sekme başlıkları bulunamadı.')
    world = (world[:first_title.start()] + '    ' + MARKER + '\n' +
             world[first_title.start():])
    # V31 offline export supports new mode keys without changing old data.
    if "key.startsWith('v321_')" not in world:
        original = "key.startsWith('v31_');"
        if world.count(original) == 1:
            world = world.replace(original,
                "key.startsWith('v31_') || key.startsWith('v321_');", 1)
        else:
            stop('Yerel yedek anahtar listesi uyuşmuyor; kayıtlar için güncelleme yapılmadı.')

if world.count('V321Arcade(') != 1:
    stop('V32.1 sekmesi tek değil.')
if 'v31_marathon_done' not in world or 'v31_treasure_claimed' not in world:
    stop('Önceki V31 kayıt bağlantıları eksik.')

# Plan all modifications before touching any file.
for p, s in list(mains.items()) + [(WORLD, world)]:
    if p.read_text(encoding='utf-8') != s:
        p.write_text(s, encoding='utf-8')
print('V32.1 BAŞARILI: OYUN MODLARI sekmesi ve 81 şehir finali bağlandı.')
print('Mevcut altın, ana seviyeler ve V31 anahtarları değiştirilmedi.')
