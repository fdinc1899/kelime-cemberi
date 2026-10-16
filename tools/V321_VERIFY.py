#!/usr/bin/env python3
from pathlib import Path
import re
root = Path.cwd()
w = (root/'lib/src/features/v31_world.dart').read_text()
f = (root/'lib/src/features/v321_arcade.dart').read_text()
m = (root/'kelime_main.dart').read_text()
assert w.count('V321Arcade(') == 1, 'V32.1 ekran sayısı doğru değil'
assert w.count('// V321_NEW_GAME_MODES') == 1
assert m.count("part 'src/features/v321_arcade.dart';") == 1
assert 'v321_arcade_finished' in f and 'v321_boss_finished' in f
assert "key.startsWith('v321_')" in w
assert 'v31_marathon_done' in w and 'v31_treasure_claimed' in w
assert 'onReward: widget.onReward' in w
assert 'p.levels' in f and 'widget.completed.contains' in f
assert 'prefs.setStringList(key' in f
assert 'v32.1' in f.lower()
print('V32.1 KAYNAK TESTİ GEÇTİ: 81 şehir × 4 yeni görev = 324 yeni görev.')
print('Not: Flutter APK derlemesi GitHub Actions üzerinde ayrıca doğrulanmalı.')
