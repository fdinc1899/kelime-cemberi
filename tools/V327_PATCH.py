#!/usr/bin/env python3
"""V32.7 additive tutorial integration, atomic preflight, idempotent, no saved data touched."""
from pathlib import Path
import sys
import re

ROOT = Path.cwd()
MAIN = ROOT / 'kelime_main.dart'
LIB = ROOT / 'lib/main.dart'
GAME = ROOT / 'lib/src/screens/game_screen.dart'
EXPERIENCE = ROOT / 'lib/src/features/v29_experience.dart'
FEATURE = ROOT / 'lib/src/features/v327_tutorial.dart'
MODES = {
    'v31': ROOT / 'lib/src/features/v31_world.dart',
    'arcade': ROOT / 'lib/src/features/v321_arcade.dart',
    'journey': ROOT / 'lib/src/features/v322_journey.dart',
    'challenges': ROOT / 'lib/src/features/v323_challenges.dart',
    'museum': ROOT / 'lib/src/features/v324_museum_zen.dart',
}
PART = "part 'src/features/v327_tutorial.dart';"
MARKER = '// V327_TUTORIAL'

def stop(msg):
    sys.exit('V32.7 GUVENLI DURDURMA: '+msg+'\nOnceki oyun kodu ve kayitlar degistirilmedi.')

def swap(s, a, b, title):
    if b in s:
        return s
    if s.count(a) != 1:
        stop('%s eslesmedi (bulunan: %s): %r' % (title, s.count(a), a[:80]))
    return s.replace(a,b,1)

for f in [MAIN, GAME, EXPERIENCE, FEATURE, *MODES.values()]:
    if not f.is_file(): stop('Eksik dosya: '+str(f))
if 'class V327TutorialScreen' not in FEATURE.read_text(encoding='utf-8'):
    stop('V32.7 ogretici kaynak dosyasi bozuk')

writes = {}
for f in (MAIN, LIB):
    if not f.is_file(): continue
    s=f.read_text(encoding='utf-8')
    if s.count(PART)>1: stop('Iki kere V32.7 part: '+str(f))
    s=swap(s,"part 'src/features/v29_experience.dart';",
       "part 'src/features/v29_experience.dart';\n"+PART, 'ana modul') if PART not in s else s
    writes[f]=s

g=GAME.read_text(encoding='utf-8')
if '_v327FirstRunCheck' not in g:
    anchor = '''    _startMusic();
  }

  void _openLevel(int index) {'''
    replacement = '''    _startMusic();
    _v327FirstRunCheck(prefs);
  }

  // V327_TUTORIAL: first launch only; never edits gameplay progress or coins.
  Future<void> _v327FirstRunCheck(SharedPreferences prefs) async {
    if (_completedLevels.isNotEmpty || _unlocked != 0 ||
        prefs.getBool('v327_intro_seen') == true) return;
    await prefs.setBool('v327_intro_seen', true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) V327TutorialScreen.open(context);
    });
  }

  void _openLevel(int index) {'''
    g=swap(g,anchor,replacement,'ilk acilis')
settings_anchor = '''        _premiumMenuItem(Icons.palette_outlined, 'Tema', () {'''
settings_replacement = '''        _premiumMenuItem(Icons.school_outlined, 'Nasıl Oynanır?', () {
          V327TutorialScreen.open(context);
        }, detail: 'Etkileşimli 5 adım'),
''' + settings_anchor
g=swap(g,settings_anchor,settings_replacement,'ayarlar menusu')
menu_anchor = '''            _premiumMenuItem(Icons.settings_rounded, 'Ayarlar', () {'''
menu_replacement = '''            _premiumMenuItem(Icons.help_outline_rounded, 'Nasıl Oynanır?', () {
              Navigator.pop(menuContext);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) V327TutorialScreen.open(context);
              });
            }),
''' + menu_anchor
g=swap(g,menu_anchor,menu_replacement,'oyun menusu')
writes[GAME]=g

exp=EXPERIENCE.read_text(encoding='utf-8')
if "V327ModeTip(mode: 'adventure')" not in exp:
    start = exp.find('class _V29AdventureDashboardState')
    end = exp.find('/// The original V15 daily wheel',start)
    if start<0 or end<start: stop('V29 macera widget bolumu bulunamadi')
    before,mid,after=exp[:start],exp[start:end],exp[end:]
    anchor='''      Expanded(child: KeyedSubtree(key: ValueKey<int>(_page), child: views[_page])),'''
    # Insert before the tab bar, keeping the existing V29 routing and reward code.
    needle='''      SizedBox(height: 55, child: ListView.builder('''
    mid=swap(mid,needle,
        "      const V327ModeTip(mode: 'adventure'),\n"+needle,'macera ogretici')
    if anchor not in mid:stop('Macera tab yapisi beklenenden farkli')
    exp=before+mid+after
writes[EXPERIENCE]=exp

for mode,f in MODES.items():
    s=f.read_text(encoding='utf-8')
    label=f"const V327ModeTip(mode: '{mode}'),"
    if label in s:
        writes[f]=s;continue
    if mode=='v31':
        anchor='''    return Column(children: [
      SizedBox(height: 54, child: ListView.builder('''
    elif mode=='arcade':
        anchor='''    return ListView(children: [
      _panel('V32.1'''
    elif mode=='journey':
        prefix = 'Widget _v326Build(BuildContext context)' if 'Widget _v326Build(BuildContext context)' in s else 'Widget build(BuildContext context)'
        anchor = prefix + ''' => Column(children: [
    Padding(padding: const EdgeInsets.symmetric(horizontal: 9'''
    elif mode=='challenges':
        prefix = 'Widget _v326Build(BuildContext context)' if 'Widget _v326Build(BuildContext context)' in s else 'Widget build(BuildContext context)'
        anchor = prefix + ''' => Column(children: [
    Padding(padding: const EdgeInsets.fromLTRB(6'''
    else:
        anchor='''    final views = <Widget>[_museumView(), _zenView(), _themesView()];
    return Column(children: [
      SizedBox(height: 54'''
    if mode=='v31':
        repl=anchor.replace('      SizedBox',f"      {label}\n      SizedBox",1)
    elif mode=='arcade':
        repl=anchor.replace("      _panel",f"      {label}\n      _panel",1)
    elif mode in ('journey','challenges'):
        repl=anchor.replace('    Padding(',f'    {label}\n    Padding(',1)
    else:
        repl=anchor.replace('      SizedBox',f'      {label}\n      SizedBox',1)
    s=swap(s,anchor,repl,'mini ogretici '+mode)
    writes[f]=s

if PART not in writes[MAIN]:stop('Ana part eksik')
if "prefs.getBool('v327_intro_seen')" not in writes[GAME]:stop('Tek-sefer kontrolu eksik')
for mode,f in MODES.items():
    if f"V327ModeTip(mode: '{mode}')" not in writes[f]:stop('Mod baglantisi eksik '+mode)

# All source checks are done before any file modification.
for path,value in writes.items():
    if path.read_text(encoding='utf-8') != value:
        path.write_text(value,encoding='utf-8')
print('V32.7 TAMAM: 5 adimlik suruklemeli ogretici + 6 oyun modu mini rehberi.')
print('Ayarlar ve Oyun Menusu: NASIL OYNANIR? baglandi.')
print('Var olan 243 bolum, 1053+ ek gorev, altin ve save anahtarlari degismedi.')
