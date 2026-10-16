#!/usr/bin/env python3
"""V32.4: additive and repeat-safe integration. Saves untouched until app runs."""
from pathlib import Path
import re

root = Path.cwd()
main = root / 'kelime_main.dart'
libmain = root / 'lib/main.dart'
world = root / 'lib/src/features/v31_world.dart'
feature = root / 'lib/src/features/v324_museum_zen.dart'
game = root / 'lib/src/screens/game_screen.dart'
painter = root / 'lib/src/widgets/painters.dart'
PART = "part 'src/features/v324_museum_zen.dart';"
MARK = '// V324_MUSEUM_ZEN_TAB'


def stop(m):
    raise SystemExit('V32.4 KURULUM DURDU: ' + m + '\nÖnceki dosyalar değiştirilmedi.')


for p in (main, world, feature, game, painter):
    if not p.is_file():
        stop('Eksik dosya: ' + str(p))
f = feature.read_text(encoding='utf-8')
for string in ('part of kelime_sehirleri;', 'class V324MuseumZen extends StatefulWidget',
               'v324_zen_solved', 'v324_ring_theme', 'class _V324MuseumZenState',
               'v29CityFacts', 'v324RingTheme'):
    if string not in f:
        stop('Müze/Rahatlama dosyası eksik: ' + string)

planned = {}
for p in (main, libmain):
    if not p.exists():
        continue
    s = p.read_text(encoding='utf-8')
    if s.count(PART) > 1:
        stop(f'{p}: birden fazla V32.4 part var.')
    if PART not in s:
        anchor = "part 'src/features/v323_challenges.dart';"
        if s.count(anchor) != 1:
            stop(f'{p}: V32.3 part bağlantısı bulunamadı.')
        s = s.replace(anchor, anchor + '\n' + PART, 1)
    planned[p] = s

w = world.read_text(encoding='utf-8')
if w.count(MARK) > 1 or w.count('V324MuseumZen(') > 1:
    stop('Yeni sekme birden çok kez eklenmiş.')
for anchor in ("'YARIŞ+'", 'V323Challenges(', "key.startsWith('v323_')"):
    if anchor not in w:
        stop('V32.3 eksik: ' + anchor)


def append_item(src, pattern, value, name):
    matches = list(re.finditer(pattern, src, flags=re.MULTILINE | re.DOTALL))
    if len(matches) != 1:
        stop(name + ' listesi bulunamadı veya çift.')
    m = matches[0]
    ins = m.group('middle').rstrip()
    delim = '' if ins.endswith(',') else ','
    return src[:m.start()] + m.group('prefix') + ins + delim + '\n      ' + value + m.group('suffix') + src[m.end():]


if MARK not in w:
    w = append_item(w,
        r'(?P<prefix>^\s*const titles\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
        "'MÜZE & ZEN',", 'V31 sekme başlık')
    w = append_item(w,
        r'(?P<prefix>^\s*const icons\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
        'Icons.museum_outlined,', 'V31 sekme simge')
    w = append_item(w,
        r'(?P<prefix>^\s*final views\s*=\s*\[)(?P<middle>[^\]]+)(?P<suffix>\];)',
        'V324MuseumZen(prefs: widget.prefs, completed: widget.completed),',
        'V31 sekme ekran')
    mt = re.search(r'(?m)^\s*const titles\s*=', w)
    if not mt:
        stop('V31 sekme başlığı eksik.')
    w = w[:mt.start()] + '    ' + MARK + '\n' + w[mt.start():]
else:
    if w.count('V324MuseumZen(') != 1:
        stop('V32.4 yarım kurulmuş, güvenli değil.')
if "key.startsWith('v324_')" not in w:
    anchor = "key.startsWith('v323_')"
    if w.count(anchor) != 1:
        stop('V32.3 yedek kayıt filtresi uyuşmuyor.')
    w = w.replace(anchor, anchor + " || key.startsWith('v324_')", 1)
# Theme preference can go backwards when a backup is restored.
if "final restoredTheme = v.clamp(0, 2).toInt();" not in w:
    marker = '      if (v is int) {'
    if w.count(marker) != 1:
        stop('Yedek sayısal değer işleme kodu bulunamadı.')
    w = w.replace(marker, """      if (k == 'v324_ring_theme' && v is int) {
        final restoredTheme = v.clamp(0, 2).toInt();
        await prefs.setInt(k, restoredTheme);
        v324RingTheme.value = restoredTheme;
        continue;
      }
""" + marker, 1)
planned[world] = w

g = game.read_text(encoding='utf-8')
if g.count('v324RingTheme.value') > 3:
    stop('Oyun ekranında birden çok V32.4 tema bağlantısı var.')
if 'valueListenable: v324RingTheme' not in g:
    anchor = 'LetterWheelPainter(_wheelLetters, _dragged)'
    if g.count(anchor) != 1:
        stop('Harf çemberi çizici çağrısı bulunamadı.')
    g = g.replace(anchor, 'LetterWheelPainter(_wheelLetters, _dragged, themeIndex: v324RingTheme.value)', 1)
    # Existing CustomPaint must subscribe to live theme changes, without
    # resetting puzzle state. Only the painter widget rebuilds, not the game.
    anchor = '''              child: CustomPaint(
                size: Size.square(size),
                painter: LetterWheelPainter(_wheelLetters, _dragged, themeIndex: v324RingTheme.value),
              ),'''
    replacement = '''              child: ValueListenableBuilder<int>(
                valueListenable: v324RingTheme,
                builder: (_, themeIndex, __) => CustomPaint(
                  size: Size.square(size),
                  painter: LetterWheelPainter(_wheelLetters, _dragged,
                    themeIndex: themeIndex),
                ),
              ),'''
    if g.count(anchor) != 1:
        stop('Harf çemberi görseli beklenenden farklı. Güvenli değişiklik yapılamadı.')
    g = g.replace(anchor, replacement, 1)
if "v324RingTheme.value = (prefs.getInt('v324_ring_theme') ?? 0)" not in g:
    anchor = '    _prefs = prefs;'
    if g.count(anchor) != 1:
        stop('Oyun yükleme fonksiyonu bulunamadı.')
    g = g.replace(anchor, anchor + "\n    v324RingTheme.value = (prefs.getInt('v324_ring_theme') ?? 0).clamp(0, 2).toInt();", 1)
planned[game] = g

p = painter.read_text(encoding='utf-8')
head, sep, rest = p.partition('class LetterWheelPainter extends CustomPainter {')
if not sep:
    stop('LetterWheelPainter sınıfı bulunamadı.')
body, sep2, tail = rest.partition('class ScenicCityPainter extends CustomPainter {')
if not sep2:
    stop('Çember sınıfının bitişi bulunamadı.')
if 'final int themeIndex;' not in body:
    old = '''  final List<int> selected;
  LetterWheelPainter(this.letters, this.selected);'''
    new = '''  final List<int> selected;
  final int themeIndex;
  LetterWheelPainter(this.letters, this.selected, {this.themeIndex = 0});'''
    if body.count(old) != 1:
        stop('Harf çemberi kurucusu değişmiş.')
    body = body.replace(old, new, 1)
    old = '''    final midpoint = Offset(s / 2, s / 2);'''
    new = '''    final midpoint = Offset(s / 2, s / 2);
    final rimColors = themeIndex == 1
      ? const [Color(0xFFAAF8EB), Color(0xFF26A98F),
          Color(0xFFBDFFF2), Color(0xFF137967)]
      : themeIndex == 2
      ? const [Color(0xFFD9C8FF), Color(0xFF8662D3),
          Color(0xFFE8DEFF), Color(0xFF5C419E)]
      : const [Color(0xFFFFF1B6), Color(0xFFD99A22),
          Color(0xFFFFE7A0), Color(0xFFBE7E13)];
    final baseColor = themeIndex == 1 ? const Color(0xFFDDFCF6) :
      themeIndex == 2 ? const Color(0xFFF3EDFF) : const Color(0xFFFFEFD7);
    final accentColor = themeIndex == 1 ? const Color(0xFF148876) :
      themeIndex == 2 ? const Color(0xFF7955BF) : const Color(0xFFC88E22);'''
    if body.count(old) != 1:
        stop('Harf çemberi boyama metodu bulunamadı.')
    body = body.replace(old, new, 1)
    old = '''      ..shader = const LinearGradient(begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF1B6), Color(0xFFD99A22),
            Color(0xFFFFE7A0), Color(0xFFBE7E13)])'''
    new = '''      ..shader = LinearGradient(begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: rimColors)'''
    if body.count(old) != 1:
        stop('Çember kenarı renkleri uyuşmuyor.')
    body = body.replace(old, new, 1)
    # Inner disc and connecting stroke both follow the selected theme.
    for old, new in [
        ('Paint()..color = const Color(0xFFFFEFD7)', 'Paint()..color = baseColor'),
        ('..color = const Color(0xC7C88E22)', '..color = accentColor.withOpacity(.83)'),
        ('..strokeWidth = 1.7..color = const Color(0xFFB88639)',
         '..strokeWidth = 1.7..color = accentColor'),
        ('? const [Color(0xFFFFDA75), Color(0xFFE0A53C)]',
         '? [rimColors.first, rimColors[1]]'),
    ]:
        if body.count(old) != 1:
            stop('Çember renk parçası bulunamadı: ' + old[:24])
        body = body.replace(old, new, 1)
    old = "      old.selected.join(',') != selected.join(',');"
    if body.count(old) != 1:
        stop('Harf çemberi yeniden çizim kontrolü bulunamadı.')
    body = body.replace(old, "      old.selected.join(',') != selected.join(',') ||\n      old.themeIndex != themeIndex;", 1)
p = head + sep + body + sep2 + tail
planned[painter] = p

# Preflight all edited sources before touching the user's files.
if w.count(MARK) != 1 or w.count('V324MuseumZen(') != 1:
    stop('V32.4 sekme tekilliği sağlanamadı.')
if planned[game].count('valueListenable: v324RingTheme') != 1:
    stop('Ana oyun tema dinleyicisi eksik.')
if planned[painter].count('final int themeIndex;') != 1:
    stop('Harf çemberi tema seçeneği eksik.')
for path, new_src in planned.items():
    if path.read_text(encoding='utf-8') != new_src:
        path.write_text(new_src, encoding='utf-8')
print('V32.4 TAMAM: 81 şehir müzesi, sınırsız Rahatlama ve 3 canlı harf çemberi teması.')
print('Eski kayıt anahtarları / bölüm IDleri değiştirilmedi. Gerçek APK GitHub Actions ile kontrol edilmeli.')
