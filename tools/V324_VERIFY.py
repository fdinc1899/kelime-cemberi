#!/usr/bin/env python3
"""Static install verification, NOT a Flutter compile or runtime test."""
from pathlib import Path
p=Path.cwd()
world=(p/'lib/src/features/v31_world.dart').read_text()
game=(p/'lib/src/screens/game_screen.dart').read_text()
painter=(p/'lib/src/widgets/painters.dart').read_text()
f=(p/'lib/src/features/v324_museum_zen.dart').read_text()
for m in ['kelime_main.dart', 'lib/main.dart']:
    if not (p/m).exists():
        if m=='lib/main.dart': continue
        raise AssertionError(m+' missing')
    src=(p/m).read_text()
    assert src.count("part 'src/features/v324_museum_zen.dart';")==1, m
    assert src.count("part 'src/features/v323_challenges.dart';")==1, m
assert world.count('V324MuseumZen(')==1
assert world.count('// V324_MUSEUM_ZEN_TAB')==1
assert world.count("'MÜZE & ZEN'")==1
assert world.count("key.startsWith('v324_')")==1
assert world.count('V323Challenges(')==1
assert world.count('V322Journey(')==1
assert world.count('V321Arcade(')==1
assert 'v31_marathon_done' in world
assert 'v31_treasure_claimed' in world
assert game.count('valueListenable: v324RingTheme')==1
assert game.count("v324RingTheme.value = (prefs.getInt('v324_ring_theme') ?? 0)")==1
assert painter.count('final int themeIndex;')==1
assert 'old.themeIndex != themeIndex' in painter
assert 'class V324MuseumZen extends StatefulWidget' in f
assert "v324_zen_solved" in f and "v324_ring_theme" in f
assert "_provinces[_city].levels" in f
assert "v29CityFacts[city.province]" in f
assert "_v322Clues[_solvedZen % _v322Clues.length]" in f
assert len([s for s in ['KLASİK ALTIN','ZÜMRÜT','GECE MORU'] if s in f]) ==3
print('V32.4 KAYNAK DENETİMİ GEÇTİ: Müze / Rahatlama / 3 tema / ana oyun çemberine bağlantı.')
print('NOT: APK derlemesi ve telefonda çalıştırma bu denetimde yapılmadı.')
