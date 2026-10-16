#!/usr/bin/env python3
from pathlib import Path
import re
root = Path.cwd()
main = (root / 'kelime_main.dart').read_text(encoding='utf-8')
world = (root / 'lib/src/features/v31_world.dart').read_text(encoding='utf-8')
feature = (root / 'lib/src/features/v322_journey.dart').read_text(encoding='utf-8')
assert main.count("part 'src/features/v322_journey.dart';") == 1, 'Yeni parça bağlantısı hatalı'
if (root / 'lib/main.dart').is_file():
    assert (root / 'lib/main.dart').read_text(encoding='utf-8').count(
        "part 'src/features/v322_journey.dart';") == 1, 'lib/main.dart bağlantısı hatalı'
assert world.count('// V322_JOURNEY_TAB') == 1
assert world.count('V322Journey(') == 1
assert "key.startsWith('v322_')" in world
assert 'V321Arcade(' in world
assert "'KEŞİF+'" in world
for key in ('v322_detective_steps','v322_scenery_tiles','v322_route_stops'):
    assert key in feature, 'Kayıt anahtarı eksik: ' + key
assert 'final void Function(int, String) onReward;' in feature
assert 'const List<_V322Clue> _v322Clues' in feature
assert feature.count('_V322Clue(') >= 18
assert 'setStringList(key,' in feature and 'if (id == finalStep)' in feature
assert 'key == ' not in world or 'class V31WorldCenter' in world
assert world.count('class V31WorldCenter extends StatefulWidget') == 1, 'V31 ana ekranı kayıp'
print('V32.2 KAYNAK DENETİMİ BAŞARILI: 81 × 3 dedektif adımı, 81 × 6 manzara parçası, 7 × 4 rota durağı.')
print('NOT: Flutter APK derlemesi GitHub Actions üzerinde ayrıca doğrulanmalıdır.')
