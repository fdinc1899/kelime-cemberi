#!/usr/bin/env python3
from pathlib import Path
r=Path.cwd()
required = {
 'kelime_main.dart':["part 'src/features/v327_tutorial.dart';"],
 'lib/src/screens/game_screen.dart':["_v327FirstRunCheck(prefs);", "prefs.getBool('v327_intro_seen')", "'Nasıl Oynanır?'"],
 'lib/src/features/v327_tutorial.dart':['class V327TutorialScreen','class V327ModeTip', 'onPanUpdate', 'v327_mode_seen_'],
 'lib/src/features/v29_experience.dart':["V327ModeTip(mode: 'adventure')"],
 'lib/src/features/v31_world.dart':["V327ModeTip(mode: 'v31')"],
 'lib/src/features/v321_arcade.dart':["V327ModeTip(mode: 'arcade')"],
 'lib/src/features/v322_journey.dart':["V327ModeTip(mode: 'journey')"],
 'lib/src/features/v323_challenges.dart':["V327ModeTip(mode: 'challenges')"],
 'lib/src/features/v324_museum_zen.dart':["V327ModeTip(mode: 'museum')"],
}
for f,needles in required.items():
 p=r/f
 if not p.exists():raise SystemExit('V32.7 TEST HATA: '+f+' dosyasi yok')
 s=p.read_text(encoding='utf-8')
 for needle in needles:
  if needle not in s:raise SystemExit('V32.7 TEST HATA: '+f+': '+needle)
 if 'V327ModeTip(' in s and s.count("const V327ModeTip(mode:") > 1:
  # V31 world may have separate areas but exactly 1 in this version.
  raise SystemExit('V32.7 birden cok ogretici: '+f)
for k in ('current_level_v3','unlocked_v3','coins'):
 if k not in (r/'lib/src/screens/game_screen.dart').read_text():
  raise SystemExit('Eski kayit anahtari beklenen dosyada yok: '+k)
print('V32.7 TEST BASARILI: ana oyun, ayarlar, macera merkezi, 5 alt mod, korunan ilerleme.')
