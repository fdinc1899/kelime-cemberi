#!/usr/bin/env python3
"""V32.5: persistent Macera Merkezi palettes; source-only, preflight, idempotent."""
from pathlib import Path
import sys
ROOT = Path.cwd()
MAIN = ROOT/'kelime_main.dart'
OTHER_MAIN = ROOT/'lib/main.dart'
PAGE = ROOT/'lib/src/screens/premium_page.dart'
EXP = ROOT/'lib/src/features/v29_experience.dart'
GAME = ROOT/'lib/src/screens/game_screen.dart'
FEATURE = ROOT/'lib/src/features/v325_adventure_theme.dart'
PART = "part 'src/features/v325_adventure_theme.dart';"
MARK = 'V325_ADVENTURE_THEME'

def stop(msg):
    sys.exit('V32.5 GUVENLI KURULUM DURDU: '+ msg + '\nMevcut kaynak dosyalari degistirilmedi.')

for p in (MAIN, PAGE, EXP, GAME, FEATURE):
    if not p.is_file(): stop(f'Dosya eksik: {p}')
feature = FEATURE.read_text(encoding='utf-8')
for needed in ('part of kelime_sehirleri;', 'class V325AdventureTheme',
               'class V325AdventureShell', 'v325_adventure_palette',
               'showModalBottomSheet', 'ValueListenableBuilder<int>'):
    if needed not in feature: stop('Tema modulu eksik: '+needed)

planned = {}
for p in (MAIN, OTHER_MAIN):
    if not p.is_file(): continue
    s = p.read_text(encoding='utf-8')
    if s.count(PART)>1: stop('Birden fazla tema part baglantisi: '+str(p))
    if PART not in s:
        anchor = "part 'src/features/v29_experience.dart';"
        if s.count(anchor)!=1: stop('V29 part baglantisi bulunamadi: '+str(p))
        s = s.replace(anchor, anchor+'\n'+PART, 1)
    planned[p] = s

page = PAGE.read_text(encoding='utf-8')
if page.count('V325AdventureShell(')>1: stop('Tekrarlanan Macera Merkezi tema baglantisi')
if 'V325AdventureShell(' not in page:
    anchor = 'return _V318AdventurePage(background: background,'
    if page.count(anchor)!=1: stop('V31.8 Macera Merkezi ekran baglantisi bulunamadi')
    page = page.replace(anchor,
                        'return V325AdventureShell(background: background,', 1)
if "title == 'MACERA MERKEZİ'" not in page: stop('Macera Merkezi rotasi eksik')
planned[PAGE]=page

game = GAME.read_text(encoding='utf-8')
if 'V325AdventureTheme.load(prefs);' not in game:
    anchor = '    _prefs = prefs;'
    if game.count(anchor)!=1: stop('Oyun tercihleri yukleme noktasi bulunamadi')
    game = game.replace(anchor, anchor+'\n    V325AdventureTheme.load(prefs);',1)
if 'music_enabled_v3' not in game: stop('Mevcut muzik kontrolu beklenenden farkli')
planned[GAME]=game

exp = EXP.read_text(encoding='utf-8')
if exp.count('V325AdventureTheme.selected')>1: stop('Macera merkezi tema tekrar baglantisi')
if 'V325AdventureTheme.selected' not in exp:
    start = exp.find('class _V29AdventureDashboardState')
    end = exp.find('/// The original V15 daily wheel', start)
    if start<0 or end<start: stop('V29 Macera Merkezi bolum sinirlari bulunamadi')
    before, mid, after = exp[:start], exp[start:end], exp[end:]
    expected = {
        'static const _navy = Color(0xFF061B34);':'Color get _navy => V325AdventureTheme.background;',
        'static const _navyLight = Color(0xFF123655);':'Color get _navyLight => V325AdventureTheme.surface;',
        'static const _gold = Color(0xFFFFD473);':'Color get _gold => V325AdventureTheme.accent;',
        'static const _cream = Color(0xFFFFF6E6);':'Color get _cream => V325AdventureTheme.text;',
        'static const _muted = Color(0xFFD6C5A6);':'Color get _muted => V325AdventureTheme.secondaryText;',
        'Widget build(BuildContext context) {':'Widget build(BuildContext context) => ValueListenableBuilder<int>(\n'
                 '    valueListenable: V325AdventureTheme.selected,\n'
                 '    builder: (context, _, __) => _v325Build(context),\n'
                 '  );\n\n  Widget _v325Build(BuildContext context) {',
        'color: const Color(0xEF071E36),':'color: V325AdventureTheme.panel.withOpacity(.94),',
    }
    for old,new in expected.items():
        if mid.count(old)!=1: stop('V29 eski renk/yapi eslesmedi: '+old[:50])
        mid = mid.replace(old,new,1)
    # Dynamic colors cannot be used in const Flutter widgets. Only change
    # the 440-line dashboard state, not the static game data or V29 wheel.
    mid = mid.replace('static const _answers', 'static final _answers')
    mid = mid.replace('static const _avatars', 'static final _avatars')
    mid = mid.replace('const ', '')
    if 'const ' in mid: stop('V29 const temizligi yarim kaldi')
    exp = before+mid+after
    if exp.count('V325AdventureTheme.selected')!=1: stop('Tema widgeti birden cok eklendi')
planned[EXP]=exp

# Write ONLY after validating all targets and legacy IDs, never edit prefs/saves.
assert PART in planned[MAIN]
assert 'V325AdventureShell(' in planned[PAGE]
assert 'V325AdventureTheme.load(prefs);' in planned[GAME]
assert 'v29_daily_challenge_date' in planned[EXP]
assert 'V325AdventureTheme.selected' in planned[EXP]
for path, content in planned.items():
    if path.read_text(encoding='utf-8')!=content:
        path.write_text(content, encoding='utf-8')
print('V32.5 OK: 5 Macera Merkezi paleti, canli secim, kalici ayar.')
print('V29 altin/bolum anahtarlari ve V32.4 harf cemberi temasi degismedi.')
