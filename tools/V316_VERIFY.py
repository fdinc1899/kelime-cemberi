#!/usr/bin/env python3
"""Fast static installation checks, not a substitute for Flutter build."""
from pathlib import Path
root = Path.cwd()
w = (root/'lib/src/features/v31_world.dart').read_text(encoding='utf-8')
d = (root/'lib/src/features/v316_expedition.dart').read_text(encoding='utf-8')
assert w.count('// V316_EXPEDITION_TAB:') == 1
assert w.count('V316Expedition(') == 1
assert w.count("'GÜNLÜK+'") == 1
assert 'v31_marathon_done' in w and 'v31_treasure_claimed' in w
assert 'v316_daily_solved' in d and 'v316_city_quiz_done' in d
assert 'v316_medals_claimed' in d and 'widget.onReward(7,' in d
assert "widget.onReward(5," in d and 'widget.onReward(medal.reward,' in d
assert 'v31ChallengeCount' in d and '_provinces.length' in d
for f in ('kelime_main.dart', 'lib/main.dart'):
    p = root/f
    if p.exists():
        s = p.read_text(encoding='utf-8')
        assert s.count("part 'src/features/v316_expedition.dart';") == 1, f
print('V31.6 KAYNAK KONTROLÜ GEÇTİ. Gerçek Flutter APK derlemesi GitHub Actions ile doğrulanmalı.')
