import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const KelimeCemberiApp());

// Kelime listesi: yeni kelime ekledikçe seviye sayısı otomatik artar.
const String _dictText = '''
ABA ALT AMA ANA ARA ARI ATA BAK BAL BAR HAL HAN HAT KAL KAN KAP KAR KEL KİL
NAL NAR PAS SAL SAT SEL SOL SON TAK TAT TEL TİP TOP TAŞ ŞAL YAN YAR MAL DAR
ALAN ALEM ALIN ARAK ASIL ATAK ATIK ELEK ELMA HATA KABA KALE KALP KARA LEKE
MASA PLAN ROTA SALI YARI
ALTIN ARABA ASLAN BALIK ELMAS KALAN KALEM KALIN KANAL KANAT KARIN KİTAP
LAMBA MASAL MELEK NASIL ORTAK PASTA PATİK SALON SELAM TABAK TAHTA TARLA
TELAŞ YARIN
BARDAK KAPLAN KARTAL KELİME TOPRAK
''';

final List<String> kDict = _dictText
    .split(RegExp(r'\s+'))
    .where((w) => w.isNotEmpty)
    .toSet()
    .toList();

Map<String, int> _count(String w) {
  final m = <String, int>{};
  for (final ch in w.split('')) {
    m[ch] = (m[ch] ?? 0) + 1;
  }
  return m;
}

bool _canForm(String w, Map<String, int> avail) {
  final need = _count(w);
  for (final e in need.entries) {
    if ((avail[e.key] ?? 0) < e.value) return false;
  }
  return true;
}

class PlacedWord {
  final String word;
  final int r, c;
  final bool horiz;
  PlacedWord(this.word, this.r, this.c, this.horiz);
  List<String> get keys => List.generate(
      word.length, (i) => horiz ? '$r,${c + i}' : '${r + i},$c');
}

class Layout {
  final List<PlacedWord> placed;
  final int rows, cols;
  final Map<String, String> letters;
  Layout(this.placed, this.rows, this.cols, this.letters);
}

Layout buildLayout(List<String> words) {
  final grid = <String, String>{};
  final usedH = <String>{};
  final usedV = <String>{};
  final placed = <PlacedWord>[];

  void put(PlacedWord p) {
    for (int i = 0; i < p.word.length; i++) {
      final rr = p.horiz ? p.r : p.r + i;
      final cc = p.horiz ? p.c + i : p.c;
      grid['$rr,$cc'] = p.word[i];
      (p.horiz ? usedH : usedV).add('$rr,$cc');
    }
    placed.add(p);
  }

  bool canPlace(String w, int r, int c, bool h) {
    final br = h ? r : r - 1;
    final bc = h ? c - 1 : c;
    if (grid.containsKey('$br,$bc')) return false;
    final ar = h ? r : r + w.length;
    final ac = h ? c + w.length : c;
    if (grid.containsKey('$ar,$ac')) return false;
    bool crosses = false;
    for (int i = 0; i < w.length; i++) {
      final rr = h ? r : r + i;
      final cc = h ? c + i : c;
      final key = '$rr,$cc';
      final ex = grid[key];
      if (ex != null) {
        if (ex != w[i]) return false;
        if ((h ? usedH : usedV).contains(key)) return false;
        crosses = true;
      } else {
        final p1r = h ? rr - 1 : rr;
        final p1c = h ? cc : cc - 1;
        final p2r = h ? rr + 1 : rr;
        final p2c = h ? cc : cc + 1;
        if (grid.containsKey('$p1r,$p1c') || grid.containsKey('$p2r,$p2c')) {
          return false;
        }
      }
    }
    return crosses;
  }

  int area(String w, int r, int c, bool h) {
    int minR = r, minC = c;
    int maxR = h ? r : r + w.length - 1;
    int maxC = h ? c + w.length - 1 : c;
    for (final p in placed) {
      minR = min(minR, p.r);
      minC = min(minC, p.c);
      maxR = max(maxR, p.horiz ? p.r : p.r + p.word.length - 1);
      maxC = max(maxC, p.horiz ? p.c + p.word.length - 1 : p.c);
    }
    return (maxR - minR + 1) * (maxC - minC + 1);
  }

  put(PlacedWord(words.first, 0, 0, true));
  final pending = words.skip(1).toList();
  bool progress = true;
  while (progress && pending.isNotEmpty) {
    progress = false;
    for (final w in List<String>.from(pending)) {
      int bestArea = 1 << 30;
      PlacedWord? best;
      for (final p in placed) {
        for (int i = 0; i < w.length; i++) {
          for (int j = 0; j < p.word.length; j++) {
            if (w[i] != p.word[j]) continue;
            final nh = !p.horiz;
            final r = p.horiz ? p.r - i : p.r + j;
            final c = p.horiz ? p.c + j : p.c - i;
            if (canPlace(w, r, c, nh)) {
              final a = area(w, r, c, nh);
              if (a < bestArea) {
                bestArea = a;
                best = PlacedWord(w, r, c, nh);
              }
            }
          }
        }
      }
      if (best != null) {
        put(best);
        pending.remove(w);
        progress = true;
      }
    }
  }

  int minR = 1 << 30, minC = 1 << 30, maxR = -(1 << 30), maxC = -(1 << 30);
  for (final p in placed) {
    minR = min(minR, p.r);
    minC = min(minC, p.c);
    maxR = max(maxR, p.horiz ? p.r : p.r + p.word.length - 1);
    maxC = max(maxC, p.horiz ? p.c + p.word.length - 1 : p.c);
  }
  final norm = placed
      .map((p) => PlacedWord(p.word, p.r - minR, p.c - minC, p.horiz))
      .toList();
  final letters = <String, String>{};
  for (final p in norm) {
    final ks = p.keys;
    for (int i = 0; i < ks.length; i++) {
      letters[ks[i]] = p.word[i];
    }
  }
  return Layout(norm, maxR - minR + 1, maxC - minC + 1, letters);
}

class LevelData {
  final String root;
  final List<String> answers;
  final Layout layout;
  LevelData(this.root, this.answers, this.layout);
}

List<LevelData> buildLevels() {
  final seen = <String>{};
  final out = <LevelData>[];
  for (final root in kDict.where((w) => w.length >= 5)) {
    final key = (root.split('')..sort()).join();
    final avail = _count(root);
    final subs =
        kDict.where((w) => w.length >= 3 && _canForm(w, avail)).toList();
    if (subs.length < 4) continue;
    if (!seen.add(key)) continue;
    subs.sort((a, b) =>
        b.length != a.length ? b.length - a.length : a.compareTo(b));
    final layout = buildLayout(subs.take(8).toList());
    if (layout.placed.length < 3) continue;
    out.add(LevelData(root, subs, layout));
  }
  out.sort((a, b) {
    if (a.root.length != b.root.length) {
      return a.root.length - b.root.length;
    }
    return a.layout.placed.length - b.layout.placed.length;
  });
  return out;
}

class KelimeCemberiApp extends StatelessWidget {
  const KelimeCemberiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Kelime Çemberi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true, colorSchemeSeed: const Color(0xFF6A1B9A)),
        home: const GameScreen(),
      );
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const double wheelSize = 280;
  late List<LevelData> levels;
  SharedPreferences? prefs;
  bool ready = false;
  int levelIdx = 0;
  int coins = 20;
  List<String> wheel = [];
  final Set<String> found = {};
  final Set<String> bonusFound = {};
  final Set<String> revealed = {};
  List<int> sel = [];
  Offset? pointer;
  String message = '';

  @override
  void initState() {
    super.initState();
    levels = buildLevels();
    _load();
  }

  Future<void> _load() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      levelIdx = (prefs!.getInt('level') ?? 0) % levels.length;
      coins = prefs!.getInt('coins') ?? 20;
      _startLevel();
      ready = true;
    });
  }

  void _startLevel() {
    found.clear();
    bonusFound.clear();
    revealed.clear();
    sel = [];
    pointer = null;
    message = '';
    wheel = List<String>.from(levels[levelIdx].root.split(''))
      ..shuffle(Random());
  }

  void _save() {
    prefs?.setInt('coins', coins);
    prefs?.setInt('level', levelIdx);
  }

  Layout get _layout => levels[levelIdx].layout;

  Set<String> _visible() {
    final v = <String>{...revealed};
    for (final p in _layout.placed) {
      if (found.contains(p.word)) v.addAll(p.keys);
    }
    return v;
  }

  void _autoFound() {
    bool changed = true;
    while (changed) {
      changed = false;
      final v = _visible();
      for (final p in _layout.placed) {
        if (!found.contains(p.word) && p.keys.every(v.contains)) {
          found.add(p.word);
          changed = true;
        }
      }
    }
  }

  void _checkDone() {
    if (found.length != _layout.placed.length) return;
    setState(() => coins += 10);
    final next = (levelIdx + 1) % levels.length;
    prefs?.setInt('coins', coins);
    prefs?.setInt('level', next);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Tebrikler! 🎉'),
        content: const Text('Seviyeyi bitirdin. +10 altın kazandın.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                levelIdx = next;
                _startLevel();
              });
            },
            child: const Text('Sonraki seviye'),
          ),
        ],
      ),
    );
  }

  Offset _pos(int i, int n) {
    final a = -pi / 2 + 2 * pi * i / n;
    return Offset(wheelSize / 2 + 100 * cos(a), wheelSize / 2 + 100 * sin(a));
  }

  void _touch(Offset p) {
    final n = wheel.length;
    for (int i = 0; i < n; i++) {
      if ((_pos(i, n) - p).distance < 34) {
        if (sel.isNotEmpty && sel.last == i) return;
        if (sel.length >= 2 && sel[sel.length - 2] == i) {
          setState(() => sel.removeLast());
          return;
        }
        if (!sel.contains(i)) setState(() => sel.add(i));
        return;
      }
    }
  }

  void _submit() {
    final word = sel.map((i) => wheel[i]).join();
    final lv = levels[levelIdx];
    String msg = '';
    setState(() {
      if (word.length >= 3) {
        if (!lv.answers.contains(word)) {
          msg = 'Bu kelime listede yok';
        } else if (found.contains(word) || bonusFound.contains(word)) {
          msg = 'Bu kelimeyi zaten buldun';
        } else if (lv.layout.placed.any((p) => p.word == word)) {
          found.add(word);
          coins += 1;
          _autoFound();
          msg = 'Harika!';
        } else {
          bonusFound.add(word);
          coins += 2;
          msg = 'Bonus kelime! +2 altın';
        }
      }
      sel = [];
      pointer = null;
      message = msg;
    });
    _save();
    _checkDone();
  }

  void _hint() {
    if (coins < 10) {
      setState(() => message = 'Yetersiz altın (10 gerekli)');
      return;
    }
    final v = _visible();
    final cand = <String>[];
    for (final p in _layout.placed) {
      if (found.contains(p.word)) continue;
      for (final k in p.keys) {
        if (!v.contains(k)) cand.add(k);
      }
    }
    if (cand.isEmpty) return;
    cand.shuffle();
    setState(() {
      revealed.add(cand.first);
      coins -= 10;
      _autoFound();
      message = '';
    });
    _save();
    _checkDone();
  }

  Widget _grid() {
    final lay = _layout;
    final vis = _visible();
    const s = 42.0;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: lay.cols * s,
        height: lay.rows * s,
        child: Stack(
          children: [
            for (final e in lay.letters.entries)
              Builder(builder: (_) {
                final parts = e.key.split(',');
                final r = int.parse(parts[0]);
                final c = int.parse(parts[1]);
                final shown = vis.contains(e.key);
                return Positioned(
                  left: c * s + 2,
                  top: r * s + 2,
                  child: Container(
                    width: s - 4,
                    height: s - 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: shown
                          ? const Color(0xFFFFB300)
                          : const Color(0xFFEDE7F6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: shown
                        ? Text(e.value,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                        : null,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _wheel() {
    final n = wheel.length;
    final pts = [for (final i in sel) _pos(i, n)];
    return SizedBox(
      width: wheelSize,
      height: wheelSize,
      child: GestureDetector(
        onPanStart: (d) {
          setState(() {
            sel = [];
            pointer = d.localPosition;
          });
          _touch(d.localPosition);
        },
        onPanUpdate: (d) {
          _touch(d.localPosition);
          setState(() => pointer = d.localPosition);
        },
        onPanEnd: (_) => _submit(),
        onPanCancel: () => setState(() {
          sel = [];
          pointer = null;
        }),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xE6FFFFFF)),
            ),
            CustomPaint(
              size: const Size(wheelSize, wheelSize),
              painter: _LinePainter(pts, pointer),
            ),
            for (int i = 0; i < n; i++)
              Positioned(
                left: _pos(i, n).dx - 26,
                top: _pos(i, n).dy - 26,
                child: Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: sel.contains(i)
                        ? const Color(0xFF7E57C2)
                        : Colors.transparent,
                  ),
                  child: Text(
                    wheel[i],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: sel.contains(i)
                          ? Colors.white
                          : const Color(0xFF311B92),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cur = sel.map((i) => wheel[i]).join();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF311B92), Color(0xFF6A1B9A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text('Seviye ${levelIdx + 1}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: const Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('🪙 $coins',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(child: _grid()),
                ),
              ),
              SizedBox(
                height: 44,
                child: Center(
                  child: cur.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                              color: const Color(0xFF7E57C2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(cur,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        )
                      : Text(message,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16)),
                ),
              ),
              _wheel(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => setState(() {
                        wheel.shuffle(Random());
                        sel = [];
                      }),
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Karıştır'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _hint,
                      icon: const Icon(Icons.lightbulb),
                      label: const Text('İpucu (10)'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<Offset> pts;
  final Offset? tip;
  _LinePainter(this.pts, this.tip);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7E57C2)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < pts.length - 1; i++) {
      canvas.drawLine(pts[i], pts[i + 1], paint);
    }
    if (tip != null && pts.isNotEmpty) {
      canvas.drawLine(pts.last, tip!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) => true;
}
