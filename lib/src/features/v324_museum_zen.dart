part of kelime_sehirleri;
// V326_THEME_EXT: persistent palette for optional gameplay modes.

// V32.4: offline museum, endless zen puzzles and persistent ring themes.
// Separate storage; no changes to chapter ids, progression, coins or awards.
final ValueNotifier<int> v324RingTheme = ValueNotifier<int>(0);

const List<String> _v324ThemeLabels = <String>[
  'KLASİK ALTIN', 'ZÜMRÜT', 'GECE MORU',
];
const List<Color> _v324ThemeColors = <Color>[
  Color(0xFFFFD479), Color(0xFF52DDC2), Color(0xFFC2A8FF),
];

class V324MuseumZen extends StatefulWidget {
  const V324MuseumZen({super.key, required this.prefs,
    required this.completed});
  final SharedPreferences? prefs;
  final Set<int> completed;

  @override
  State<V324MuseumZen> createState() => _V324MuseumZenState();
}

class _V324MuseumZenState extends State<V324MuseumZen> {
  int _mode = 0; // 0 museum, 1 zen, 2 ring themes
  int _city = 0;
  int _solvedZen = 0;
  bool _hintVisible = false;
  bool _saving = false;
  List<int> _chosen = <int>[];

  @override
  void initState() {
    super.initState();
    _readSettings();
  }

  @override
  void didUpdateWidget(covariant V324MuseumZen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.prefs != widget.prefs) _readSettings();
  }

  void _readSettings() {
    final p = widget.prefs;
    _solvedZen = p?.getInt('v324_zen_solved') ?? 0;
    final selected = p?.getInt('v324_ring_theme') ?? 0;
    v324RingTheme.value = selected.clamp(0, 2).toInt();
  }

  Color get _theme => _v324ThemeColors[v324RingTheme.value.clamp(0, 2).toInt()];
  _V322Clue get _clue => _v322Clues[_solvedZen % _v322Clues.length];

  List<String> get _scrambled {
    final result = _clue.answer.split('');
    result.shuffle(math.Random(324000 + _solvedZen * 17));
    if (result.join() == _clue.answer && result.length > 2) {
      final old = result[0];
      result[0] = result[1];
      result[1] = old;
    }
    return result;
  }

  String get _entry => _chosen.map((i) => _scrambled[i]).join();

  void _notice(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  Widget _card(String title, Widget child) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: _v326Panel,
      border: Border.all(color: _v326Gold, width: 1.3),
      borderRadius: BorderRadius.circular(18)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(title, style:  TextStyle(color: _v326Gold,
        fontSize: 19, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12), child,
    ]));

  Widget _label(String value, {Color? color, double size = 14}) =>
    Text(value, textAlign: TextAlign.center,
      style: TextStyle(color: color ?? _v326Cream, fontSize: size));

  Widget _action(String value, VoidCallback? tap, {IconData icon = Icons.check}) =>
    Padding(padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton.icon(
        onPressed: tap,
        icon: Icon(icon, size: 18),
        label: Text(value, textAlign: TextAlign.center),
        style: ElevatedButton.styleFrom(
          backgroundColor: _v326Gold, foregroundColor: _v326Navy,
          disabledBackgroundColor: const Color(0xFF34445A),
          disabledForegroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)))));

  Widget _cityPicker() => SizedBox(height: 52, child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: _provinces.length,
    itemBuilder: (context, i) => Padding(
      padding: const EdgeInsets.only(right: 7),
      child: ChoiceChip(
        selected: i == _city,
        selectedColor: _v326Gold,
        backgroundColor: _v326Cream,
        label: Text('${i + 1} · ${_provinces[i].province}',
          style:  TextStyle(color: _v326Navy, fontWeight: FontWeight.w800)),
        onSelected: (_) => setState(() => _city = i)))));

  Widget _museumTile({required IconData icon, required String title,
    required String detail, required bool unlocked}) =>
    Padding(padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: unlocked ? _v326Surface : const Color(0xFF28364A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: unlocked ? _v326Gold : Colors.white24)),
        child: Row(children: [
          Icon(unlocked ? icon : Icons.lock_outline,
            color: unlocked ? _v326Gold : Colors.white54, size: 26),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                color: unlocked ? _v326Gold : Colors.white70,
                fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(unlocked ? detail : 'Ana şehir bölümlerini oynayarak aç.',
                style:  TextStyle(color: _v326Cream, fontSize: 12)),
            ])),
        ])));

  Widget _museumView() {
    final count = _provinces[_city].levels
        .where(widget.completed.contains).length;
    final collected = _provinces.fold<int>(0, (sum, p) {
      final done = p.levels.where(widget.completed.contains).length;
      return sum + done.clamp(0, 3).toInt();
    });
    final city = _provinces[_city];
    return ListView(children: [
      _card('ŞEHİR MÜZESİ · 81 İL', Column(children: [
        _label('Üç ana bölümü tamamlayarak o şehrin koleksiyonunu aç. '
          'Müze keşif amaçlıdır; tekrar altın dağıtmaz.'),
        const SizedBox(height: 8),
        _label('$collected / 243 koleksiyon eseri', color: _v326Gold, size: 17),
        const SizedBox(height: 12),
        LinearProgressIndicator(value: collected / 243,
          minHeight: 7, backgroundColor: Colors.white12,
          valueColor:  AlwaysStoppedAnimation<Color>(_v326Gold)),
        const SizedBox(height: 12),
        _cityPicker(),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(14),
          child: AspectRatio(aspectRatio: 16 / 9,
            child: Image(image: _citySelectionImageProvider(city),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>  ColoredBox(
                color: _v326Navy,
                child: Icon(Icons.landscape, color: _v326Gold, size: 60))))),
        const SizedBox(height: 8),
        _label('${city.province} · $count / 3 eser', color: _v326Gold),
        _museumTile(icon: Icons.photo_library_outlined,
          title: '1 · Şehir manzarası',
          detail: '${city.province} manzarası koleksiyona eklendi.',
          unlocked: count >= 1),
        _museumTile(icon: Icons.menu_book_outlined,
          title: '2 · Kültür defteri',
          detail: v29CityFacts[city.province] ??
            '${city.province}, ${city.region} bölgesinde yer alır.',
          unlocked: count >= 2),
        _museumTile(icon: Icons.workspace_premium_outlined,
          title: '3 · Şehir mührü',
          detail: '${city.province} ana bölümleri tamamlandı.',
          unlocked: count >= 3),
      ])),
    ]);
  }

  Widget _zenWheel() {
    final letters = _scrambled;
    const size = 282.0;
    const radius = 103.0;
    final tileSize = letters.length >= 8 ? 43.0 : 49.0;
    return Center(child: SizedBox(width: size, height: size,
      child: Stack(children: [
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [
            const Color(0xFF102943), _theme.withOpacity(.24),
            const Color(0xFF061B33)]),
          border: Border.all(color: _theme, width: 3)))),
        ...List.generate(letters.length, (i) {
          final angle = -math.pi / 2 + i * 2 * math.pi / letters.length;
          final x = size / 2 + radius * math.cos(angle) - tileSize / 2;
          final y = size / 2 + radius * math.sin(angle) - tileSize / 2;
          final selected = _chosen.contains(i);
          return Positioned(left: x, top: y,
            child: Material(
              color: selected ? const Color(0xFFE2E8F0) : _v326Cream,
              shape: CircleBorder(side: BorderSide(color: _theme, width: 2)),
              child: InkWell(customBorder: const CircleBorder(),
                onTap: selected ? null : () => setState(() => _chosen.add(i)),
                child: SizedBox(width: tileSize, height: tileSize,
                  child: Center(child: Text(letters[i],
                    style:  TextStyle(color: _v326Navy,
                      fontSize: 22, fontWeight: FontWeight.w900)))))));
        }),
        Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.spa_outlined, size: 27, color: _theme),
          const SizedBox(height: 5),
          SizedBox(width: 145, child: Text(
            _entry.isEmpty ? 'HARFLERİ SEÇ' : _entry,
            textAlign: TextAlign.center,
            style: TextStyle(color: _theme, fontSize: 15,
              fontWeight: FontWeight.w900))),
        ])),
      ])));
  }

  Future<void> _checkZen() async {
    if (_saving) return;
    if (_entry != _clue.answer) {
      _notice('Kelimeyi yeniden dene. Süre sınırı yok.');
      return;
    }
    setState(() => _saving = true);
    final next = _solvedZen + 1;
    try {
      final p = widget.prefs;
      if (p == null || !await p.setInt('v324_zen_solved', next)) {
        if (mounted) _notice('Rahatlama ilerlemesi kaydedilemedi.');
        return;
      }
      if (!mounted) return;
      setState(() {
        _solvedZen = next;
        _chosen = <int>[];
        _hintVisible = false;
      });
      _notice('Tebrikler! Yeni bir sakin kelime açıldı.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _zenView() => ListView(children: [
    _card('RAHATLAMA MODU · SÜRESİZ', Column(children: [
      _label('Süre yok, rakip yok, yanlış cevap cezası yok. '
        'İstediğin kadar kelime çöz. Ödül altını verilmez.'),
      const SizedBox(height: 7),
      _label('Tamamladığın sakin kelime: $_solvedZen',
        color: _theme, size: 17),
      const SizedBox(height: 14),
      _zenWheel(),
      const SizedBox(height: 6),
      _label('${_clue.answer.length} harf · Üzerine dokunarak birleştir.'),
      if (_hintVisible) Padding(padding: const EdgeInsets.only(top: 9),
        child: _label(_clue.hint, color: _v326Gold)),
      Row(children: [
        Expanded(child: _action('GERİ AL', _chosen.isEmpty || _saving ? null :
          () => setState(() => _chosen.removeLast()), icon: Icons.undo)),
        const SizedBox(width: 7),
        Expanded(child: _action('SİL', _chosen.isEmpty || _saving ? null :
          () => setState(() => _chosen.clear()), icon: Icons.refresh)),
      ]),
      _action('ÜCRETSİZ İPUCU', () => setState(() => _hintVisible = true),
        icon: Icons.lightbulb_outline),
      _action('KELİMEYİ KONTROL ET', _saving ? null : _checkZen,
        icon: Icons.check_circle_outline),
    ])),
  ]);

  Future<void> _selectTheme(int index) async {
    final p = widget.prefs;
    if (p == null) {
      _notice('Oyun kaydı hazır olunca tekrar dene.');
      return;
    }
    if (!await p.setInt('v324_ring_theme', index)) {
      _notice('Tema seçimi kaydedilemedi.');
      return;
    }
    v324RingTheme.value = index;
    if (mounted) setState(() {});
    _notice('${_v324ThemeLabels[index]} teması kaydedildi.');
  }

  Widget _themesView() => ListView(children: [
    _card('HARF ÇEMBERİ GÖRÜNÜMÜ', Column(children: [
      _label('Tema ana oyunun gerçek harf çemberinde ve Rahatlama Modu’nda '
        'kullanılır. Bulmaca kuralları ve kayıtlar değişmez.'),
      const SizedBox(height: 10),
      ...List.generate(_v324ThemeLabels.length, (i) {
        final active = v324RingTheme.value == i;
        final c = _v324ThemeColors[i];
        return Padding(padding: const EdgeInsets.symmetric(vertical: 5),
          child: OutlinedButton(
            onPressed: () => _selectTheme(i),
            style: OutlinedButton.styleFrom(
              backgroundColor: active ? c : const Color(0xFF173550),
              foregroundColor: active ? _v326Navy : _v326Cream,
              side: BorderSide(color: c, width: active ? 2.4 : 1.2),
              padding: const EdgeInsets.symmetric(vertical: 17)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 12, backgroundColor: c,
                  child: Text('A', style:  TextStyle(
                    color: _v326Navy, fontSize: 13, fontWeight: FontWeight.w900))),
                const SizedBox(width: 10),
                Text(_v324ThemeLabels[i], style: const TextStyle(
                  fontWeight: FontWeight.w800)),
                if (active) const Padding(padding: EdgeInsets.only(left: 12),
                  child: Icon(Icons.check_circle)),
              ])));
      }),
      const SizedBox(height: 12),
      _label('Seçimini görmek için Rahatlama Modu’na geçebilir '
        'veya ana bulmacaya dönebilirsin.', color: Colors.white70),
    ])),
  ]);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: V325AdventureTheme.selected,
    builder: (context, _, __) => _v326Build(context),
  );

  Widget _v326Build(BuildContext context) {
    const sections = <String>['MÜZE', 'RAHATLAMA', 'TEMALAR'];
    const icons = <IconData>[
      Icons.museum_outlined, Icons.spa_outlined, Icons.palette_outlined,
    ];
    final views = <Widget>[_museumView(), _zenView(), _themesView()];
    return Column(children: [
      SizedBox(height: 54, child: ListView.builder(
        scrollDirection: Axis.horizontal, itemCount: sections.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.all(4),
          child: ChoiceChip(selected: i == _mode, selectedColor: _v326Gold,
            backgroundColor: _v326Surface,
            label: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icons[i], size: 18,
                color: i == _mode ? _v326Navy : _v326Gold),
              const SizedBox(width: 5),
              Text(sections[i], style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800,
                color: i == _mode ? _v326Navy : _v326Cream)),
            ]), onSelected: (_) => setState(() => _mode = i))))),
      Expanded(child: views[_mode]),
    ]);
  }
}
