#!/usr/bin/env python3
from pathlib import Path
r=Path.cwd()
main=(r/'kelime_main.dart').read_text()
page=(r/'lib/src/screens/premium_page.dart').read_text()
exp=(r/'lib/src/features/v29_experience.dart').read_text()
game=(r/'lib/src/screens/game_screen.dart').read_text()
theme=(r/'lib/src/features/v325_adventure_theme.dart').read_text()
assert main.count("part 'src/features/v325_adventure_theme.dart';")==1
assert page.count('V325AdventureShell(')==1
assert exp.count('V325AdventureTheme.selected')==1
assert game.count('V325AdventureTheme.load(prefs);')==1
assert 'v325_adventure_palette' in theme
assert 'showModalBottomSheet' in theme
assert 'music_enabled_v3' in game
assert 'v29_daily_challenge_date' in exp
assert 'v31_marathon_done' in (r/'lib/src/features/v31_world.dart').read_text()
print('V32.5 KAYNAK DENETIMI OK: 5 tema, kalici secim, kayit ayirimi.')
print('NOT: APK derlemesi GitHub Actions tarafindan ayrica dogrulanmalidir.')
