#!/usr/bin/env python3
"""Source-level checks only. Flutter APK must be built by GitHub Actions."""
from pathlib import Path
root = Path.cwd()
main = (root/'kelime_main.dart').read_text(encoding='utf-8')
world = (root/'lib/src/features/v31_world.dart').read_text(encoding='utf-8')
feature = (root/'lib/src/features/v323_challenges.dart').read_text(encoding='utf-8')
assert main.count("part 'src/features/v323_challenges.dart';") == 1
assert main.count("import 'dart:async';") == 1
libmain = root/'lib/main.dart'
if libmain.is_file():
    s=libmain.read_text(encoding='utf-8')
    assert s.count("part 'src/features/v323_challenges.dart';") == 1
    assert s.count("import 'dart:async';") == 1
assert world.count('// V323_CHALLENGES_TAB') == 1
assert world.count('V323Challenges(') == 1
assert world.count("'YARIŞ+'") == 1
assert "key.startsWith('v322_') || key.startsWith('v323_')" in world
assert 'V321Arcade(' in world and 'V322Journey(' in world
for old in ['v31_marathon_done', 'v31_treasure_claimed']:
    assert old in world
for k in ['v323_sprint_reward_days','v323_duel_rewarded','v323_tower_completed','v323_sprint_best']:
    assert k in feature, k
assert 'Timer.periodic(' in feature
assert 'WidgetsBindingObserver' in feature
assert 'stopwatch' in feature
assert 'widget.onReward(' in feature
assert 'if (saved)' in feature
print('V32.3 KAYNAK TESTİ GEÇTİ: 3 yeni oynanış, ayrı kayıt anahtarları, tek seferlik ödül.')
print('NOT: Dart/Flutter derlemesi ve telefon oynanışı GitHub Actions ile ayrıca doğrulanmalı.')
