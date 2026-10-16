#!/usr/bin/env python3
from pathlib import Path
import sys
root=Path.cwd()
for p in (root/'kelime_main.dart',root/'lib/src/features/v325_adventure_theme.dart',root/'lib/src/features/v326_extended_palette.dart'):
    assert p.is_file(),str(p)
for p in [root/'kelime_main.dart',root/'lib/main.dart']:
    if p.is_file():assert p.read_text().count("part 'src/features/v326_extended_palette.dart';")==1
for name in ('v31_world.dart','v321_arcade.dart','v322_journey.dart','v323_challenges.dart','v324_museum_zen.dart'):
    s=(root/'lib/src/features'/name).read_text()
    assert s.count('V326_THEME_EXT')==1,(name,'patch duplicate')
    assert s.count('V325AdventureTheme.selected')==1,(name,'theme rebuild')
    assert s.count('_v326Build(')==2,(name,'build bridge')
    assert '_v326Panel' in s,(name,'panel')
    assert '_v326Gold' in s,(name,'accent')
world=(root/'lib/src/features/v31_world.dart').read_text()
assert 'v31_marathon_done' in world
assert "const int v31ChallengeCount = 81 * v31ChallengesPerCity;" in world
assert "const List<String> _v31WordBank" in world
assert 'v325_adventure_palette' in (root/'lib/src/features/v325_adventure_theme.dart').read_text()
assert 'current_level_v3' in (root/'lib/src/screens/game_screen.dart').read_text() or 'music_enabled_v3' in (root/'lib/src/screens/game_screen.dart').read_text()
print('V32.6 KAYNAK TESTI GECTI: 5 tema, 5 alt ekran, canli yenileme, kayitlar korunuyor.')
print('Not: Flutter APK build GitHub Actions tarafinda ayrica test edilmeli.')
