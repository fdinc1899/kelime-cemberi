part of kelime_sehirleri;

/// V32.7 — isolated, interactive training. No game currency or progress writes.
class V327TutorialScreen extends StatefulWidget {
  const V327TutorialScreen({super.key});

  static Future<void> open(BuildContext context) async {
    await Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (_) => const V327TutorialScreen(),
    ));
  }

  @override
  State<V327TutorialScreen> createState() => _V327TutorialScreenState();
}

class _V327TutorialScreenState extends State<V327TutorialScreen> {
  static const _navy = Color(0xFF081B33);
  static const _panel = Color(0xFF102B4D);
  static const _gold = Color(0xFFFFD475);
  static const _white = Color(0xFFFFF7E9);
  static const _lime = Color(0xFF7BE6B1);
  static const _letters = <String>['K', 'A', 'L', 'E'];
  static const _positions = <Offset>[
    Offset(120, 36), Offset(204, 120),
    Offset(120, 204), Offset(36, 120),
  ];
  final List<int> _path = [];
  int _step = 0;
  bool _shuffled = false;
  bool _hintUsed = false;
  String _feedback = 'Parmağını K harfinden A, L ve E harflerine sürükle.';

  void _pick(Offset p, {bool tap = false}) {
    if (_step != 0) return;
    for (int i = 0; i < _positions.length; i++) {
      if ((p - _positions[i]).distance > 39) continue;
      if (_path.contains(i)) return;
      if (tap && _path.isNotEmpty && i != _path.last + 1) {
        setState(() {
          _path.clear();
          _feedback = 'K → A → L → E sırasıyla seç.';
        });
        return;
      }
      setState(() {
        _path.add(i);
        _feedback = _path.map((j) => _letters[j]).join('');
      });
      if (tap && _path.length == 4) _finishWord();
      return;
    }
  }

  void _finishWord() {
    if (_step != 0) return;
    final word = _path.map((i) => _letters[i]).join();
    if (word == 'KALE') {
      setState(() { _step = 1; _feedback = 'BRAVO!'; });
      HapticFeedback.lightImpact();
    } else {
      setState(() {
        _path.clear();
        _feedback = 'Bir daha dene: K → A → L → E';
      });
    }
  }

  void _next() {
    if (_step == 4) { Navigator.of(context).pop(); return; }
    setState(() => _step++);
  }

  Widget _pill(String label, VoidCallback? action,
      {bool primary = false, IconData? icon}) => ElevatedButton.icon(
    onPressed: action,
    icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 20),
    label: Text(label, textAlign: TextAlign.center),
    style: ElevatedButton.styleFrom(
      foregroundColor: _navy,
      backgroundColor: primary ? _lime : _gold,
      disabledBackgroundColor: const Color(0xFF55657A),
      disabledForegroundColor: Colors.white70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );

  Widget _wheel() => SizedBox(width: 240, height: 240, child: GestureDetector(
    behavior: HitTestBehavior.opaque,
    onPanStart: (d) => _pick(d.localPosition),
    onPanUpdate: (d) => _pick(d.localPosition),
    onPanEnd: (_) => _finishWord(),
    onTapUp: (d) => _pick(d.localPosition, tap: true),
    child: Stack(children: [
      Positioned.fill(child: CustomPaint(painter: _V327WheelPainter(
        selected: List<int>.of(_path), positions: _positions))),
      for (var i = 0; i < _letters.length; i++)
        Positioned(left: _positions[i].dx - 28, top: _positions[i].dy - 28,
          child: IgnorePointer(child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 56, height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _path.contains(i) ? _lime : _gold,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 9)]),
            child: Text(_letters[i], style: const TextStyle(color: _navy,
              fontSize: 25, fontWeight: FontWeight.w900)),
          ))),
      const Positioned(left: 78, top: 104, width: 84,
        child: IgnorePointer(child: Center(child: Text('KARIŞTIR',
          style: TextStyle(color: _gold, fontWeight: FontWeight.bold,
            fontSize: 12))))),
    ]),
  ));

  Widget _stepContent() {
    if (_step == 0) return Column(children: [
      const Text('HARFLERİ BİRLEŞTİR', style: TextStyle(
        color: _gold, fontWeight: FontWeight.w900, fontSize: 21)),
      const SizedBox(height: 8),
      const Text('KALE kelimesini parmağını kaldırmadan çiz. '
        'İstersen harflere sırayla dokunabilirsin.',
        textAlign: TextAlign.center, style: TextStyle(color: _white, fontSize: 14)),
      const SizedBox(height: 14), _wheel(),
      const SizedBox(height: 10),
      Text(_feedback, textAlign: TextAlign.center,
        style: const TextStyle(color: _lime, fontWeight: FontWeight.w800)),
      const SizedBox(height: 9),
      TextButton(onPressed: () => setState(() { _path.clear();
        _feedback = 'K → A → L → E'; }),
        child: const Text('TEKRAR DENE', style: TextStyle(color: _gold))),
    ]);
    if (_step == 1) return Column(children: [
      const Icon(Icons.auto_awesome_rounded, color: _gold, size: 54),
      const SizedBox(height: 12),
      const Text('BULMACAYI DOLDUR', style: TextStyle(
        color: _gold, fontSize: 22, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      const Text('Doğru kelime yukarıdaki kutulara yerleşir.',
        textAlign: TextAlign.center, style: TextStyle(color: _white)),
      const SizedBox(height: 22),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (final c in _letters) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Container(width: 48, height: 51, alignment: Alignment.center,
            decoration: BoxDecoration(color: _lime, borderRadius: BorderRadius.circular(9)),
            child: Text(c, style: const TextStyle(color: _navy,
              fontSize: 26, fontWeight: FontWeight.w900))),
        ),
      ]),
      const SizedBox(height: 18),
      const Text('BRAVO! ✓', style: TextStyle(color: _lime,
        fontSize: 21, fontWeight: FontWeight.w900)),
      const SizedBox(height: 22), _pill('DEVAM ET', _next),
    ]);
    if (_step == 2) return Column(children: [
      const Icon(Icons.lightbulb_rounded, color: _gold, size: 50),
      const SizedBox(height: 10),
      const Text('YARDIMCI BUTONLAR', style: TextStyle(
        color: _gold, fontSize: 21, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      const Text('Karıştır harflerin yerini değiştirir. '
        'İpucu bir harfi açar.',
        textAlign: TextAlign.center, style: TextStyle(color: _white)),
      const SizedBox(height: 20),
      Text(_shuffled ? 'A   K   E   L' : 'K   A   L   E',
        style: const TextStyle(color: _gold, fontSize: 29,
          fontWeight: FontWeight.w900, letterSpacing: 7)),
      const SizedBox(height: 20),
      Wrap(alignment: WrapAlignment.center, spacing: 9, runSpacing: 9, children: [
        _pill(_shuffled ? 'KARIŞTIR ✓' : 'KARIŞTIR',
          () => setState(() => _shuffled = true), icon: Icons.shuffle_rounded),
        _pill(_hintUsed ? 'İPUCU ✓' : 'İPUCU',
          () => setState(() => _hintUsed = true), icon: Icons.lightbulb_rounded),
      ]),
      if (_hintUsed) const Padding(padding: EdgeInsets.only(top: 10),
        child: Text('İlk harf: K', style: TextStyle(color: _lime, fontSize: 18))),
      const SizedBox(height: 20),
      _pill('DEVAM ET', _shuffled && _hintUsed ? _next : null, primary: true),
      const SizedBox(height: 9),
      const Text('Bu eğitimde altın harcanmaz. Asıl oyundaki bazı ipuçları ücretlidir.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 12)),
    ]);
    if (_step == 3) return Column(children: [
      const Icon(Icons.emoji_events_rounded, color: _gold, size: 62),
      const SizedBox(height: 13),
      const Text('BÖLÜMÜ TAMAMLA', style: TextStyle(color: _gold,
        fontSize: 23, fontWeight: FontWeight.w900)),
      const SizedBox(height: 13),
      const Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.star_rounded, color: _gold, size: 43),
          Icon(Icons.star_rounded, color: _gold, size: 51),
          Icon(Icons.star_rounded, color: _gold, size: 43)]),
      const SizedBox(height: 15),
      const Text('Bulmacaları çözerek yıldız ve altın kazanırsın. '
        'Bu sadece örnek bir kutlamadır, ödül eklenmez.',
        textAlign: TextAlign.center, style: TextStyle(color: _white)),
      const SizedBox(height: 22), _pill('DEVAM ET', _next),
    ]);
    return Column(children: [
      const Icon(Icons.map_rounded, color: _gold, size: 65),
      const SizedBox(height: 12),
      const Text('ŞEHİRLERİ KEŞFET', style: TextStyle(color: _gold,
        fontSize: 23, fontWeight: FontWeight.w900)),
      const SizedBox(height: 15),
      const Text('İstanbul’un üç ana bölümünü tamamla. '
        'Sonra haritadaki yeni şehrin kilidi açılır. '
        'Macera Merkezi’nde de özel oyun modları seni bekler!',
        textAlign: TextAlign.center, style: TextStyle(color: _white)),
      const SizedBox(height: 22),
      _pill('OYUNA DÖN', _next, primary: true, icon: Icons.check_circle_rounded),
    ]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _navy,
    body: SafeArea(child: Stack(children: [
      Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF133D5E), _navy])))),
      SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 18, 15, 32),
        child: Column(children: [
          Row(children: [
            const Expanded(child: Text('NASIL OYNANIR?',
              style: TextStyle(color: _gold, fontSize: 22,
                fontWeight: FontWeight.w900))),
            TextButton(onPressed: () => Navigator.of(context).pop(),
              child: const Text('ATLA', style: TextStyle(color: _white))),
          ]),
          const SizedBox(height: 15),
          LinearProgressIndicator(value: (_step + 1) / 5,
            minHeight: 6, backgroundColor: const Color(0xFF345069),
            valueColor: const AlwaysStoppedAnimation<Color>(_gold)),
          const SizedBox(height: 8),
          Text('ADIM ${_step + 1} / 5',
            style: const TextStyle(color: _white, fontSize: 13)),
          const SizedBox(height: 23),
          Container(width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 22, 15, 24),
            decoration: BoxDecoration(color: _panel,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: _gold, width: 1.8),
              boxShadow: const [BoxShadow(color: Color(0x99000000), blurRadius: 15)]),
            child: _stepContent()),
          const SizedBox(height: 18),
          const Text('Daha sonra Ayarlar → Nasıl Oynanır? bölümünden '
            'tekrar açabilirsin.', textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12)),
        ]))),
    ])),
  );
}

class _V327WheelPainter extends CustomPainter {
  const _V327WheelPainter({required this.selected, required this.positions});
  final List<int> selected;
  final List<Offset> positions;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 102, Paint()..color = const Color(0xFF193C5C));
    canvas.drawCircle(center, 102, Paint()..style = PaintingStyle.stroke
      ..strokeWidth = 2 ..color = const Color(0xFFFFD475));
    if (selected.isNotEmpty) {
      final line = Path()..moveTo(positions[selected.first].dx,
        positions[selected.first].dy);
      for (final i in selected.skip(1)) { line.lineTo(positions[i].dx, positions[i].dy); }
      canvas.drawPath(line, Paint()..color = const Color(0xFF7BE6B1)
        ..strokeWidth = 6 ..strokeCap = StrokeCap.round ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _V327WheelPainter oldDelegate) =>
    oldDelegate.selected.length != selected.length ||
    oldDelegate.selected.join(',') != selected.join(',');
}

/// One-time tips, plus an always-present question-mark button per game mode.
class V327ModeTip extends StatefulWidget {
  const V327ModeTip({super.key, required this.mode});
  final String mode;
  @override
  State<V327ModeTip> createState() => _V327ModeTipState();
}

class _V327ModeTipState extends State<V327ModeTip> {
  static const String _prefix = 'v327_mode_seen_';
  bool _shown = false;
  static const Map<String, List<String>> _tips = {
    'adventure': ['MACERA MERKEZİ',
      'Günlük görevleri, pasaportu ve ödülleri üst sekmelerden seç. '
      'Altınların ve ilerlemen otomatik kaydedilir.'],
    'v31': ['EK KELİME GÖREVLERİ',
      'Bir şehir seçip ek kelime görevini çöz. '
      'Ödüller görev başına yalnızca bir kez alınır.'],
    'arcade': ['ÖZEL BULMACALAR',
      'Karışık harfleri sırala, eksik harfi bul, özel harfleri aç. '
      'Şehir finali için o şehrin üç ana bölümünü tamamla.'],
    'journey': ['KELİME DEDEKTİFİ VE KEŞİF',
      'Dedektif ipuçlarını sırayla çöz; manzarada doğru kelimelerle '
      'parçaları aç; rotada şehir duraklarını keşfet.'],
    'challenges': ['YARIŞMA MODLARI',
      'Süreli oyunda zamana karşı kelime çöz; düelloda bilgisayarla '
      'yarış; kulede on katı sırayla geç.'],
    'museum': ['MÜZE VE RAHATLAMA',
      'Ana bölümleri bitirdikçe müze eserleri açılır. '
      'Rahatlama Modu’nda süre baskısı yoktur. TEMALAR ile harf çemberini değiştir.'],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _firstTime());
  }

  Future<void> _firstTime() async {
    if (!mounted || _shown) return;
    _shown = true;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final key = _prefix + widget.mode;
    if (prefs.getBool(key) == true) return;
    await prefs.setBool(key, true);
    if (mounted) _showTip();
  }

  void _showTip() {
    if (!mounted) return;
    final content = _tips[widget.mode];
    if (content == null) return;
    showDialog<void>(context: context, builder: (d) => AlertDialog(
      backgroundColor: const Color(0xFF102B4D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFFFD475), width: 1.6)),
      title: Text(content[0], style: const TextStyle(
        color: Color(0xFFFFD475), fontSize: 18, fontWeight: FontWeight.w900)),
      content: Text(content[1], style: const TextStyle(
        color: Colors.white, fontSize: 15, height: 1.4)),
      actions: [TextButton(onPressed: () => Navigator.pop(d),
        child: const Text('ANLADIM', style: TextStyle(color: Color(0xFFFFD475))))],
    ));
  }

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: TextButton.icon(onPressed: _showTip,
      icon: const Icon(Icons.help_outline_rounded, size: 18),
      label: const Text('NASIL OYNANIR?'),
      style: TextButton.styleFrom(foregroundColor: const Color(0xFFFFD475),
        minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 10))),
  );
}
