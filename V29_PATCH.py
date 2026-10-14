#!/usr/bin/env python3
"""V29 idempotent source patch. Raises instead of silently missing hooks."""
import re, sys
from pathlib import Path

root = Path.cwd()
source = root/'kelime_main.dart'
main = root/'lib/main.dart'
game = root/'lib/src/screens/game_screen.dart'
provinces = root/'lib/src/data/provinces.dart'
pubspec = root/'pubspec.yaml'
feature = root/'lib/src/features/v29_experience.dart'
adventure = root/'lib/src/features/adventure_features.dart'
for path in [source,game,provinces,pubspec,feature,adventure]:
    if not path.exists():
        raise SystemExit(f'V29 HATA: dosya eksik {path}')

src = source.read_text()
assert 'library kelime_sehirleri;' in src, 'V29 HATA: ana library yapisi degismis.'
part = "part 'src/features/v29_experience.dart';"
if part not in src:
    pos = src.find("part 'src/features/adventure_features.dart';")
    if pos < 0:
        raise SystemExit('V29 HATA: adventure_features part bulunamadi')
    pos += len("part 'src/features/adventure_features.dart';")
    src = src[:pos] + '\n' + part + src[pos:]
    source.write_text(src)
if main.exists():
    main_src = main.read_text()
    if 'library kelime_sehirleri;' in main_src and part not in main_src:
        needle = "part 'src/features/adventure_features.dart';"
        if needle in main_src:
            main.write_text(main_src.replace(needle,needle+'\n'+part,1))

text = game.read_text()
head = '  void _showAdventureHub() {'
tail = '\n  void _revealFirstLetter() {'
if head not in text or tail not in text:
    raise SystemExit('V29 HATA: Macera Merkezi kodunun konumu farkli; kod degistirilmedi.')
start = text.index(head)
end = text.index(tail,start)
section = text[start:end]
if 'V29AdventureDashboard(' not in section:
    orig_start = '      AdventureCenterView('
    orig_end = '      ),\n    ));'
    if section.count(orig_start) != 1 or section.count(orig_end) != 1:
        raise SystemExit('V29 HATA: Macera Merkezi beklenenden farkli. Guvenlik icin durdu.')
    pre = '''      V29AdventureDashboard(
        progress: _adventure,
        prefs: _prefs,
        completed: _completedLevels,
        unlocked: _unlocked,
        coins: _coins,
        onAwardCoins: (amount, label) {
          setState(() => _coins += amount);
          refresh(() {});
          _saveProgress();
          _celebrate(label, '+$amount ALTIN');
        },
        onOpenLevel: (index) {
          Navigator.pop(pageContext);
          _openLevel(index);
          setState(() { _showWelcome = false; _showCityChoice = false; });
        },
        classicCenter: AdventureCenterView('''
    # parenthesized call to old AdventureCenterView remains intact
    section = section.replace(orig_start,pre,1)
    section = section.replace(orig_end,'      ),\n      ),\n    ));',1)
    text = text[:start]+section+text[end:]
    game.write_text(text)

# Turn existing functional daily reward into a visible animated spin.
original_adventure = adventure.read_text()
spin_hook = 'progress.canSpin ? onSpin : null,'
if 'V29SpinDialog(onComplete: onSpin)' not in original_adventure:
    if original_adventure.count(spin_hook) != 1:
        raise SystemExit('V29 HATA: gunluk cark kodu degismis; otomatik duzeltemedim.')
    original_adventure = original_adventure.replace(
        spin_hook,
        'progress.canSpin ? () => showDialog<void>(context: context, '
        'barrierDismissible: false, builder: (ctx) => V29SpinDialog(onComplete: onSpin)) : null,',
        1)
    adventure.write_text(original_adventure)

p = pubspec.read_text()
m = re.search(r'^version:\s*(\S+)\+(\d+)\s*$',p,re.M)
if m and int(m.group(2)) < 29:
    p=p[:m.start()]+'version: 2.9.0+29'+p[m.end():]
# Asset V28 is inserted by original patch. Do not add duplicate.
pubspec.write_text(p)

# Strict verification: edits must affect the real game entrypoint.
updated = source.read_text()
new_game = game.read_text()
assert part in updated
assert 'V29AdventureDashboard(' in new_game
assert 'classicCenter: AdventureCenterView(' in new_game
assert 'V29SpinDialog(onComplete: onSpin)' in adventure.read_text()
assert 'V28_CARD_OVERRIDE' in provinces.read_text(), 'V28 resim saglayicisi eksik'
assert "assets/images/v28_city_cards/" in pubspec.read_text(), 'V28 asset yolu eksik'
assert all((root/'assets/images/v28_city_cards'/f'{s}.webp').is_file()
           for s in ('osmaniye','hatay','kahramanmaras','konya','karaman','kilis','sirnak'))
print('V29 OK: Macera Merkezi, gunluk oyun, 81 il pasaportu, rota, yerel lig,')
print('oduller, oyuncu profili, sezon ve V28 sehir kartlari baglandi.')
print('V3 kayit anahtarlari ve seviye kimlikleri DEGISTIRILMEDI.')
