part of kelime_sehirleri;
// V326_THEME_EXT: persistent palette for optional gameplay modes.

// V32.1: three offline word modes + one optional boss for each of 81 cities.
// Saves are isolated from all V3/V29/V31 chapter, coin and achievement keys.
const List<String> _v321Words = <String>[
  'KELİME', 'HARİTA', 'KERVAN', 'SEYAHAT', 'GÖKYÜZÜ', 'MACERA',
  'ÇEMBER', 'KÖPRÜ', 'YILDIZ', 'BAŞKENT', 'DENİZCİ', 'BULMACA',
  'KÜLTÜR', 'HİKÂYE', 'GEZGİN', 'GÜNEŞ', 'ŞELALE', 'TARİH',
  'KAPLICA', 'KÜTÜPHANE', 'İPEKYOLU', 'YOLCULUK', 'MANZARA',
  'EFSANE', 'MEYDAN', 'KAŞİF', 'KERVANSARAY', 'PUSULA',
];

class V321Arcade extends StatefulWidget {
  const V321Arcade({super.key, required this.prefs, required this.completed,
    required this.onReward});
  final SharedPreferences? prefs;
  final Set<int> completed;
  final void Function(int, String) onReward;
  @override State<V321Arcade> createState() => _V321ArcadeState();
}

class _V321ArcadeState extends State<V321Arcade> {
  int _city = 0;
  int _mode = 0; // 0 reorder, 1 missing letter, 2 special tiles, 3 boss
  bool _busy = false;
  bool _thawed = false;
  bool _joker = false;
  List<int> _chosen = <int>[];
  Set<String> _finished = <String>{};
  Set<String> _bossFinished = <String>{};
  final TextEditingController _bossEntry = TextEditingController();

  @override void initState() { super.initState(); _refresh(); }
  void _refresh() {
    _finished = widget.prefs?.getStringList('v321_arcade_finished')?.toSet() ?? <String>{};
    _bossFinished = widget.prefs?.getStringList('v321_boss_finished')?.toSet() ?? <String>{};
  }
  @override void dispose() { _bossEntry.dispose(); super.dispose(); }
  void _resetRound() { _chosen = <int>[]; _thawed = false; _joker = false; _bossEntry.clear(); }
  void _notice(String text) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Deterministic puzzles per city/mode so a reload does not change answers.
  String get _target => _v321Words[(_city * 13 + _mode * 7) % _v321Words.length]
      .replaceAll(' ', '');
  String get _key => '${_city}_$_mode';
  bool get _done => _mode == 3
    ? _bossFinished.contains('$_city') : _finished.contains(_key);
  bool get _bossOpen => _provinces[_city].levels.every(widget.completed.contains);
  List<int> get _tileOrder {
    final tiles = List<int>.generate(_target.length, (i) => i);
    tiles.shuffle(math.Random(321001 + _city * 103 + _mode * 727));
    if (tiles.length > 2 && List.generate(tiles.length, (i) => tiles[i] == i).every((x) => x)) {
      final temp = tiles[0]; tiles[0] = tiles[1]; tiles[1] = temp;
    }
    return tiles;
  }
  String get _typed {
    final letters = _target.split('');
    final shuffled = _tileOrder;
    return _chosen.map((index) => letters[shuffled[index]]).join();
  }
  int get _missingIndex => (_city * 7 + 2) % _target.length;
  List<String> get _missingChoices {
    const alphabet = <String>['A', 'B', 'E', 'F', 'G', 'İ', 'K', 'L', 'M', 'N', 'O', 'Ö', 'R', 'S', 'T', 'U', 'Ü', 'Y', 'Z'];
    final correct = _target.split('')[_missingIndex];
    final result = <String>[correct];
    var cursor = (_city * 11 + _mode * 17) % alphabet.length;
    while (result.length < 4) {
      final ch = alphabet[cursor % alphabet.length];
      if (!result.contains(ch)) result.add(ch);
      cursor += 3;
    }
    result.shuffle(math.Random(9017 + _city * 43));
    return result;
  }

  Future<void> _finish(bool correct) async {
    if (_busy || _done) return;
    if (!correct) { _notice('Henüz doğru değil. Tekrar deneyebilirsin.'); return; }
    final prefs = widget.prefs;
    if (prefs == null) { _notice('Kayıt henüz hazır değil.'); return; }
    if (_mode == 3 && !_bossOpen) { _notice('Önce şehrin 3 ana bölümünü tamamla.'); return; }
    setState(() => _busy = true);
    final boss = _mode == 3;
    final key = boss ? 'v321_boss_finished' : 'v321_arcade_finished';
    final stored = boss ? '$_city' : _key;
    final updated = <String>{...(prefs.getStringList(key) ?? <String>[]), stored};
    bool ok = false;
    try { ok = await prefs.setStringList(key, (updated.toList()..sort())); }
    catch (_) { ok = false; }
    if (!mounted) return;
    if (!ok) { setState(() => _busy = false); _notice('Kayıt başarısız; ödül verilmedi.'); return; }
    setState(() {
      if (boss) { _bossFinished = updated; } else { _finished = updated; }
      _busy = false; _chosen.clear(); _bossEntry.clear();
    });
    final reward = boss ? 30 : _mode == 2 ? (_joker ? 5 : 7) : _mode == 1 ? 4 : 5;
    widget.onReward(reward, boss ? 'ŞEHİR FİNALİ' : 'V32 KELİME MODU');
    _notice('Tebrikler! +$reward altın. Ödül bu görev için bir kez verilir.');
  }

  Widget _panel(String title, Widget body) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: _v326Panel,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _v326Gold, width: 1.2)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(title, style:  TextStyle(color: _v326Gold, fontSize: 19,
        fontWeight: FontWeight.w900)),
      const SizedBox(height: 11), body,
    ]));
  Widget _label(String text, {Color? color, double size = 14}) =>
    Text(text, textAlign: TextAlign.center, style: TextStyle(color: color ?? _v326Cream, fontSize: size));
  Widget _button(String text, VoidCallback? tap, {IconData icon = Icons.check}) =>
    Padding(padding: const EdgeInsets.only(top: 11), child: ElevatedButton.icon(
      onPressed: tap, icon: Icon(icon, size: 19), label: Text(text, textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(backgroundColor: _v326Gold,
        foregroundColor: _v326Navy, disabledBackgroundColor: const Color(0xFF43536A),
        disabledForegroundColor: Colors.white70,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)))));

  Widget _cityStrip() => SizedBox(height: 53, child: ListView.builder(
    scrollDirection: Axis.horizontal, itemCount: _provinces.length,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(label: Text('${index + 1} · ${_provinces[index].province}',
          style:  TextStyle(color: _v326Navy, fontWeight: FontWeight.w700)),
        selected: _city == index, selectedColor: _v326Gold,
        onSelected: _busy ? null : (_) => setState(() { _city = index; _resetRound(); })))));

  Widget _reorderGame({required bool special}) {
    final letters = _target.split('');
    final order = _tileOrder;
    final frozenTile = order.length ~/ 2;
    final chosenSet = _chosen.toSet();
    return Column(children: [
      _label(special
        ? 'Kilitli harfi çöz, altın harfi kullan ve kelimeyi oluştur.'
        : 'Karışık harflere doğru sırayla dokunarak kelimeyi oluştur.'),
      const SizedBox(height: 12),
      Container(width: double.infinity, constraints: const BoxConstraints(minHeight: 52),
        alignment: Alignment.center, padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: _v326Surface,
          borderRadius: BorderRadius.circular(12), border: Border.all(color: _v326Gold)),
        child: _label(_typed.isEmpty ? 'Harfleri seç…' : _typed,
          size: 24, color: _v326Gold)),
      const SizedBox(height: 14),
      Wrap(alignment: WrapAlignment.center, spacing: 9, runSpacing: 9,
        children: List.generate(order.length, (index) {
          final taken = chosenSet.contains(index);
          final frozen = special && index == frozenTile && !_thawed;
          final golden = special && index == 0;
          return SizedBox(width: 51, height: 59, child: OutlinedButton(
            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero,
              backgroundColor: taken ? const Color(0xFF223750) :
                golden ? _v326Gold : const Color(0xFFFFF7E7),
              foregroundColor: _v326Navy,
              side: BorderSide(color: taken ? Colors.white24 : _v326Gold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: taken || frozen || _done || _busy ? null
              : () => setState(() => _chosen.add(index)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(frozen ? '🔒' : taken ? '✓' : letters[order[index]],
                style: TextStyle(color: taken ? Colors.white70 : _v326Navy,
                  fontSize: frozen ? 19 : 23, fontWeight: FontWeight.bold)),
              if (golden && !taken)  Text('✦ ALTIN', style: TextStyle(
                fontSize: 8, fontWeight: FontWeight.bold, color: _v326Navy)),
            ])));
        })),
      if (special) ...[
        const SizedBox(height: 11),
        _label('✦ Altın harf: +2 bonus · ❄ Kilidi açmak ücretsiz.'),
        if (!_thawed) _button('KİLİTLİ HARFİ AÇ', _done || _busy ? null
          : () => setState(() => _thawed = true), icon: Icons.lock_open),
        _button(_joker ? 'JOKER: ${letters.first}' : 'JOKER: İLK HARFİ GÖSTER (−2 ALTIN)',
          _joker || _done || _busy ? null : () => setState(() => _joker = true),
          icon: Icons.lightbulb_outline),
      ],
      Row(children: [
        Expanded(child: _button('GERİ AL', _chosen.isEmpty || _done || _busy ? null
          : () => setState(() => _chosen.removeLast()), icon: Icons.undo)),
        const SizedBox(width: 8),
        Expanded(child: _button('TEMİZLE', _chosen.isEmpty || _done || _busy ? null
          : () => setState(() => _chosen.clear()), icon: Icons.refresh)),
      ]),
      _button(_done ? 'TAMAMLANDI ✓' : 'KELİMEYİ ONAYLA',
        _done || _busy ? null : () => _finish(_typed == _target),
        icon: Icons.spellcheck),
    ]);
  }

  Widget _missingLetterGame() {
    final letters = _target.split('');
    final shown = List<String>.of(letters);
    shown[_missingIndex] = '□';
    return Column(children: [
      _label('Eksik harfi seçerek kelimeyi tamamla.'),
      const SizedBox(height: 13),
      _label(shown.join('  '), size: 27, color: _v326Gold),
      const SizedBox(height: 14),
      Wrap(alignment: WrapAlignment.center, spacing: 9, runSpacing: 9,
        children: _missingChoices.map((letter) => SizedBox(width: 64, height: 55,
          child: ElevatedButton(onPressed: _done || _busy ? null
            : () => _finish(letter == letters[_missingIndex]),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFF6E7),
              foregroundColor: _v326Navy, padding: EdgeInsets.zero),
            child: Text(letter, style: const TextStyle(fontSize: 22,
              fontWeight: FontWeight.w900))))).toList()),
      const SizedBox(height: 10),
      _label('Doğru cevaba +4 altın · Her şehir için bir ödül.', size: 12),
    ]);
  }

  Widget _bossGame() {
    final p = _provinces[_city];
    if (!_bossOpen) {
      final finished = p.levels.where(widget.completed.contains).length;
      return Column(children: [
         Icon(Icons.lock, color: _v326Gold, size: 56),
        _label('${p.province} finalini açmak için 3 ana bölüm gerekiyor.'),
        _label('$finished / ${p.levels.length} ana bölüm tamamlandı', color: _v326Gold),
        const SizedBox(height: 8),
        _label('Mevcut bölümlerin kaydı değiştirilmez. Final ayrı bir ödüldür.', size: 12),
      ]);
    }
    final mixed = _tileOrder.map((index) => _target.split('')[index]).join('  ');
    return Column(children: [
       Icon(Icons.emoji_events, color: _v326Gold, size: 50),
      _label('${p.province} Şehir Finali · ZOR'),
      const SizedBox(height: 14),
      _label(mixed, color: _v326Gold, size: 23),
      const SizedBox(height: 8),
      _label('${_target.length} harfli gizli kelimeyi bul. +30 altın.'),
      const SizedBox(height: 11),
      TextField(controller: _bossEntry, enabled: !_busy && !_done,
        textCapitalization: TextCapitalization.characters,
        style:  TextStyle(color: _v326Cream),
        decoration:  InputDecoration(labelText: 'Final kelimesi',
          labelStyle: TextStyle(color: _v326Gold),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: _v326Gold)),
          border: OutlineInputBorder())),
      _button(_done ? 'FİNAL KAZANILDI ✓' : 'FİNALİ TAMAMLA',
        _done || _busy ? null : () => _finish(
          v31TurkishUpper(_bossEntry.text.trim()).replaceAll(' ', '') == _target),
        icon: Icons.emoji_events),
    ]);
  }

  @override Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: V325AdventureTheme.selected,
    builder: (context, _, __) => _v326Build(context),
  );

  Widget _v326Build(BuildContext context) {
    const modeNames = <String>['KARIŞIK HARFLER', 'EKSİK HARF', 'ÖZEL HARFLER', 'ŞEHİR FİNALİ'];
    const modeIcons = <IconData>[Icons.shuffle, Icons.edit, Icons.auto_awesome,
      Icons.emoji_events];
    final count = _finished.length + _bossFinished.length;
    return ListView(children: [
      const V327ModeTip(mode: 'arcade'),
      _panel('V32.1 · YENİ OYUN MODLARI', Column(children: [
        _label('81 şehir × 4 yeni görev = 324 isteğe bağlı meydan okuma.'),
        const SizedBox(height: 10),
        LinearProgressIndicator(value: (count / 324).clamp(0.0, 1.0).toDouble(),
          backgroundColor: const Color(0xFF29425B),
          valueColor:  AlwaysStoppedAnimation<Color>(_v326Gold), minHeight: 7),
        const SizedBox(height: 7), _label('$count / 324 tamamlandı', color: _v326Gold),
        const SizedBox(height: 12), _cityStrip(),
        const SizedBox(height: 12),
        Wrap(alignment: WrapAlignment.center, spacing: 7, runSpacing: 9,
          children: List.generate(modeNames.length, (i) => ChoiceChip(
            selected: _mode == i, selectedColor: _v326Gold,
            label: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(modeIcons[i], size: 15, color: _v326Navy),
              const SizedBox(width: 5),
              Text(modeNames[i], style:  TextStyle(color: _v326Navy,
                fontSize: 11, fontWeight: FontWeight.bold)),
            ]),
            onSelected: _busy ? null : (_) => setState(() { _mode = i; _resetRound(); }),
          ))),
      ])),
      _panel('${_provinces[_city].province.toUpperCase()} · ${modeNames[_mode]}',
        Column(children: [
          if (_done) ...[
             Icon(Icons.verified, color: _v326Gold, size: 44),
            _label('Bu görevin ödülü daha önce kazanıldı.', color: _v326Gold),
            const SizedBox(height: 9),
          ],
          if (_mode == 0 || _mode == 2) _reorderGame(special: _mode == 2),
          if (_mode == 1) _missingLetterGame(),
          if (_mode == 3) _bossGame(),
        ])),
      _panel('NASIL ÇALIŞIR?', _label('Bu modlar internetsiz oynanır. Başarılar '
        'v321_ ile başlayan ayrı anahtarlara kaydedilir. Şehir finali yalnızca '
        'o şehrin üç eski ana bölümü bitince açılır. Her görevde altın bir kez verilir.',
        size: 12)),
    ]);
  }
}
