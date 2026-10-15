#!/usr/bin/env python3
"""Offline V31.6 gameplay extension, additive + repeat-safe."""
from pathlib import Path
import re
import sys

ROOT = Path.cwd()
WORLD = ROOT / 'lib/src/features/v31_world.dart'
DART = ROOT / 'lib/src/features/v316_expedition.dart'
MAIN = ROOT / 'kelime_main.dart'
MARK = '// V316_EXPEDITION_TAB: offline daily, 81 questions and achievement medals.'
PART = "part 'src/features/v316_expedition.dart';"


def stop(msg):
    raise SystemExit('V31.6 HATA: ' + msg + ' (Mevcut oyun dosyaları değiştirilmedi.)')

if not WORLD.is_file() or not MAIN.is_file() or not DART.is_file():
    stop('V31 yüklü değil veya ZIP proje köküne tam açılmadı')

world = WORLD.read_text(encoding='utf-8')
dart = DART.read_text(encoding='utf-8')
if not dart.startswith('part of kelime_sehirleri;') or 'class V316Expedition extends StatefulWidget' not in dart:
    stop('V31.6 yeni oyun dosyası eksik veya farklı')

main_paths = [MAIN]
lib_main = ROOT / 'lib/main.dart'
if lib_main.is_file():
    main_paths.append(lib_main)
main_changes = {}
for p in main_paths:
    txt = p.read_text(encoding='utf-8')
    anchor = "part 'src/features/v31_world.dart';"
    if PART in txt:
        if txt.count(PART) != 1:
            stop(str(p) + ' içinde aynı part birden çok kez tanımlı')
        main_changes[p] = txt
        continue
    if txt.count(anchor) != 1:
        stop(str(p) + ' içinde V31 part tanımı bulunamadı')
    main_changes[p] = txt.replace(anchor, anchor + '\n' + PART, 1)

if MARK in world:
    if world.count(MARK) != 1 or world.count('V316Expedition(') != 1:
        stop('daha önce yarım kurulmuş V31.6 tespit edildi')
    print('V31.6 oyun sekmesi zaten kurulmuş; tekrar eklenmedi.')
else:
    if 'class V31WorldCenter extends StatefulWidget' not in world:
        stop('V31 Macera ekranı bulunamadı')

    def extend(pattern, addition, label):
        global world
        hits = list(re.finditer(pattern, world, flags=re.DOTALL | re.MULTILINE))
        if len(hits) != 1:
            stop(label + ': kaynak düzeni uyuşmuyor; ' + str(len(hits)) + ' eşleşme')
        m = hits[0]
        before = m.group('opening')
        values = m.group('content').rstrip()
        if not values or 'V316Expedition' in values or "'GÜNLÜK+'" in values:
            stop(label + ': beklenmedik içerik')
        separator = '' if values.endswith(',') else ','
        updated = before + values + separator + '\n      ' + addition + m.group('ending')
        world = world[:m.start()] + updated + world[m.end():]

    extend(r'(?P<opening>^\s*const titles\s*=\s*\[)(?P<content>[^\]]+)(?P<ending>\];)',
           "'GÜNLÜK+'", 'Sekme isimleri')
    extend(r'(?P<opening>^\s*const icons\s*=\s*\[)(?P<content>[^\]]+)(?P<ending>\];)',
           'Icons.emoji_events_outlined', 'Sekme simgeleri')
    extend(r'(?P<opening>^\s*final views\s*=\s*\[)(?P<content>[^\]]+)(?P<ending>\];)',
           '''V316Expedition(prefs: widget.prefs,
        mainCompleted: widget.completed, marathonCompleted: _marathonDone,
        treasures: _treasures, coins: widget.coins, onReward: widget.onReward)''',
           'Sekme ekranları')
    marker_anchor = '  @override Widget build(BuildContext context) {\n    const titles = '
    # Preserve compatibility with V31 variants that keep build on one line.
    title_pat = re.search(r'(?m)^\s*const titles\s*=\s*\[', world)
    if not title_pat:
        stop('Başlık satırı son kontrolde bulunamadı')
    world = world[:title_pat.start()] + '    ' + MARK + '\n' + world[title_pat.start():]

# All guards above run before touching files.
if MARK not in world or world.count('V316Expedition(') != 1:
    stop('V31.6 ekran sayısı kontrolü başarısız')
for required in ('v31_marathon_done', 'v31_treasure_claimed', 'v31_favorite_city_slugs'):
    # Favorite may be absent in pre-V31.4 sources; only enforce saved legacy keys.
    if required != 'v31_favorite_city_slugs' and required not in world:
        stop('Önceki oyun kaydı anahtarları kaybolmuş')

# Atomic individual writes (in-memory preflight completed). All writes are additive.
for path, txt in main_changes.items():
    if path.read_text(encoding='utf-8') != txt:
        path.write_text(txt, encoding='utf-8')
if WORLD.read_text(encoding='utf-8') != world:
    WORLD.write_text(world, encoding='utf-8')
print('V31.6 hazır: günlük bulmaca + 81 il coğrafya testi + 11 başarı rozeti.')
