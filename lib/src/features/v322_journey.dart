part of kelime_sehirleri;
// V326_THEME_EXT: persistent palette for optional gameplay modes.

// V32.2. Offline optional adventures; nothing here changes legacy level IDs.
// The hand-written clue bank intentionally rotates across different cities.
class _V322Clue {
  const _V322Clue(this.answer, this.hint);
  final String answer;
  final String hint;
}

const List<_V322Clue> _v322Clues = <_V322Clue>[
  _V322Clue('PUSULA', 'Kuzeyi bulmak için kullanılan yön aracı.'),
  _V322Clue('HARİTA', 'Yolların ve şehirlerin çizildiği kâğıt.'),
  _V322Clue('ANAHTAR', 'Kilitli bir kapıyı açmaya yarar.'),
  _V322Clue('FENER', 'Karanlık bir geçidi aydınlatır.'),
  _V322Clue('KERVAN', 'Geçmişte birlikte yolculuk eden ticaret kafilesi.'),
  _V322Clue('KÖPRÜ', 'Bir nehrin iki yakasını birbirine bağlar.'),
  _V322Clue('KULE', 'Şehir siluetinde yükselen dar yapı.'),
  _V322Clue('MÜZE', 'Tarihî eserlerin korunduğu ve sergilendiği yer.'),
  _V322Clue('YILDIZ', 'Gece gökyüzünde görülen ışıklı gök cismi.'),
  _V322Clue('KİTAP', 'Sayfalarından hikâyeler okunan eser.'),
  _V322Clue('NEHİR', 'Yatağında sürekli akan büyük su.'),
  _V322Clue('KALE', 'Savunma için yapılmış yüksek surlu yapı.'),
  _V322Clue('ÇEMBER', 'Bir dairenin çevresi boyunca uzanan şekil.'),
  _V322Clue('MEYDAN', 'Şehrin ortasındaki geniş buluşma alanı.'),
  _V322Clue('BAHÇE', 'Çiçek ve ağaç yetiştirilen açık alan.'),
  _V322Clue('GEZGİN', 'Yeni yerler keşfetmek için yolculuk eden kişi.'),
  _V322Clue('DEFTER', 'Notların ve ipuçlarının yazıldığı sayfalar.'),
  _V322Clue('SANDIK', 'Değerli eşyaları saklamaya yarayan kutu.'),
];

class V322Journey extends StatefulWidget {
  const V322Journey({super.key, required this.prefs, required this.onReward});
  final SharedPreferences? prefs;
  final void Function(int, String) onReward;
  @override State<V322Journey> createState() => _V322JourneyState();
}

class _V322JourneyState extends State<V322Journey> {
  int _section = 0; // 0 detective, 1 scenery, 2 travel routes
  int _city = 0;
  int _route = 0;
  bool _busy = false;
  final TextEditingController _entry = TextEditingController();
  Set<int> _detective = <int>{};
  Set<int> _scenery = <int>{};
  Set<int> _routes = <int>{};
  static const List<String> _regionNames = <String>[
    'Marmara', 'Ege', 'Akdeniz', 'İç Anadolu', 'Karadeniz',
    'Doğu Anadolu', 'Güneydoğu Anadolu'
  ];
  static const List<String> _chapters = <String>[
    'Kayıp notun peşinde', 'Gizli geçidin şifresi', 'Son sandık'
  ];

  @override
  void initState() { super.initState(); _restore(); }
  @override
  void didUpdateWidget(covariant V322Journey oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.prefs != widget.prefs) _restore();
  }
  void _restore() {
    _detective = _read('v322_detective_steps', 81 * 3);
    _scenery = _read('v322_scenery_tiles', 81 * 6);
    _routes = _read('v322_route_stops', 7 * 4);
  }
  Set<int> _read(String key, int max) => widget.prefs?.getStringList(key)
    ?.map(int.tryParse).whereType<int>().where((n) => n >= 0 && n < max).toSet()
      ?? <int>{};
  @override void dispose() { _entry.dispose(); super.dispose(); }

  void _message(String m) { if (mounted) ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(m))); }
  _V322Clue _clue(int city, int slot, int variant) =>
    _v322Clues[(city * 7 + slot * 5 + variant * 3) % _v322Clues.length];
  String _shuffle(String word, int seed) {
    final letters = word.split('');
    letters.shuffle(math.Random(32022 + seed));
    if (letters.join() == word && letters.length > 1) {
      final a = letters[0]; letters[0] = letters[1]; letters[1] = a;
    }
    return letters.join('  ');
  }
  int _nextCityStep(Set<int> done, int city, int count) {
    for (int i = 0; i < count; i++) {
      if (!done.contains(city * count + i)) return i;
    }
    return count;
  }
  int _nextRouteStep(int route) {
    for (int i = 0; i < 4; i++) {
      if (!_routes.contains(route * 4 + i)) return i;
    }
    return 4;
  }
  List<ProvinceInfo> _regionCities(int region) => _provinces
    .where((p) => p.region == _regionNames[region]).toList();

  Future<void> _complete(String key, Set<int> done, int id,
      int finalStep, int reward, String label) async {
    if (_busy || done.contains(id)) return;
    final prefs = widget.prefs;
    if (prefs == null) { _message('Kayıt henüz hazır değil.'); return; }
    setState(() => _busy = true);
    final updated = <int>{...done, id};
    bool saved = false;
    try {
      saved = await prefs.setStringList(key,
        (updated.toList()..sort()).map((n) => '$n').toList());
    } catch (_) { saved = false; }
    if (!mounted) return;
    if (!saved) {
      setState(() => _busy = false);
      _message('Kayıt yapılamadı, ödül verilmedi.');
      return;
    }
    setState(() {
      if (key == 'v322_detective_steps') _detective = updated;
      if (key == 'v322_scenery_tiles') _scenery = updated;
      if (key == 'v322_route_stops') _routes = updated;
      _busy = false;
      _entry.clear();
    });
    if (id == finalStep) {
      widget.onReward(reward, label);
      _message('Bölüm tamamlandı! +$reward altın. Ödül bir defalıktır.');
    } else {
      _message('İpucu çözüldü! Sonraki adıma geçebilirsin.');
    }
  }

  Widget _card(String title, Widget child) => Container(
    margin: const EdgeInsets.fromLTRB(9, 9, 9, 5),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: _v326Panel,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: _v326Gold, width: 1.2)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(title, style:  TextStyle(color: _v326Gold, fontSize: 19,
        fontWeight: FontWeight.w800)),
      const SizedBox(height: 12), child,
    ]));
  Widget _label(String text, {Color? color,
      double size = 14, TextAlign align = TextAlign.center}) => Text(text,
    textAlign: align, style: TextStyle(color: color ?? _v326Cream, fontSize: size));
  Widget _action(String text, VoidCallback? onPressed,
      {IconData icon = Icons.check_circle_outline}) => Padding(
    padding: const EdgeInsets.only(top: 11), child: ElevatedButton.icon(
      onPressed: onPressed, icon: Icon(icon), label: Text(text,
        textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(
        backgroundColor: _v326Gold, foregroundColor: _v326Navy,
        disabledBackgroundColor: const Color(0xFF34465A),
        disabledForegroundColor: Colors.white70,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))));
  Widget _cityPicker() => SizedBox(height: 51, child: ListView.builder(
    scrollDirection: Axis.horizontal, itemCount: _provinces.length,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(selected: _city == index,
        selectedColor: _v326Gold,
        label: Text('${index + 1} · ${_provinces[index].province}',
          style:  TextStyle(color: _v326Navy, fontWeight: FontWeight.w700)),
        onSelected: _busy ? null : (_) => setState(() {
          _city = index; _entry.clear();
        })))));
  Widget _field() => Padding(padding: const EdgeInsets.only(top: 13),
    child: TextField(controller: _entry, enabled: !_busy,
      textCapitalization: TextCapitalization.characters,
      style:  TextStyle(color: _v326Cream, fontSize: 17),
      decoration:  InputDecoration(labelText: 'Şifre kelimesi',
        labelStyle: TextStyle(color: _v326Gold),
        hintText: 'Buraya cevabı yaz', hintStyle: TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _v326Gold)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _v326Gold, width: 2)))));

  Widget _detectiveView() {
    final step = _nextCityStep(_detective, _city, 3);
    final clue = _clue(_city, (step == 3 ? 2 : step), 0);
    return ListView(children: [
      _card('KELİME DEDEKTİFİ · 81 ŞEHİR', Column(children: [
        _label('Her şehirde kayıp seyahat defterini bulmak için 3 şifre çöz. '
          'Tamamlayan oyuncuya +15 altın.'),
        const SizedBox(height: 10), _cityPicker(),
        const SizedBox(height: 11),
        _label('${_provinces[_city].province} · $step / 3 ipucu çözüldü',
          color: _v326Gold, size: 17),
        const SizedBox(height: 9),
        LinearProgressIndicator(value: step / 3, minHeight: 8,
          backgroundColor: Colors.white12,
          valueColor:  AlwaysStoppedAnimation<Color>(_v326Gold)),
      ])),
      _card(step == 3 ? 'DOSYA KAPANDI ✓' : _chapters[step],
        step == 3 ? Column(children: [
           Icon(Icons.verified, color: _v326Gold, size: 58),
          _label('Bu şehrin kayıp seyahat defterini buldun. Ödül kaydedildi.'),
        ]) : Column(children: [
           Icon(Icons.travel_explore, color: _v326Gold, size: 52),
          const SizedBox(height: 6),
          _label(clue.hint, size: 17),
          const SizedBox(height: 10),
          _label(_shuffle(clue.answer, _city * 41 + step * 97),
            color: _v326Gold, size: 23),
          _field(),
          _action('ŞİFREYİ ÇÖZ', _busy ? null : () {
            if (v31TurkishUpper(_entry.text.trim()) == clue.answer) {
              _complete('v322_detective_steps', _detective,
                _city * 3 + step, _city * 3 + 2, 15, 'KELİME DEDEKTİFİ');
            } else { _message('Şifre yanlış. İpucunu tekrar incele.'); }
          }, icon: Icons.search),
        ])),
      _card('GİZLİ DOSYALAR', _label('${_detective.length} / 243 ipucu çözüldü. '
        'Hikâyeler ve kelime havuzu bazı şehirlerde yeniden kullanılır.', size: 12)),
    ]);
  }

  Widget _sceneryGrid(int step) => ClipRRect(
    borderRadius: BorderRadius.circular(13),
    child: SizedBox(height: 209, child: LayoutBuilder(
      builder: (context, box) => Stack(fit: StackFit.expand, children: [
        Image(image: _citySelectionImageProvider(_provinces[_city]),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>  ColoredBox(color: _v326Navy,
            child: Icon(Icons.landscape, color: _v326Gold, size: 60))),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero, itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: (box.maxWidth / 3) / (box.maxHeight / 2)),
          itemBuilder: (context, i) => DecoratedBox(
            decoration: BoxDecoration(
              color: i < step ? Colors.transparent : _v326Panel,
              border: Border.all(color: const Color(0x77FFD479), width: 0.8)),
            child: i < step ? const SizedBox.shrink() : Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                 Icon(Icons.lock_outline, color: _v326Gold, size: 20),
                Text('${i + 1}', style:  TextStyle(color: _v326Gold)),
              ]))),
        ),
      ]))));
  Widget _sceneryView() {
    final step = _nextCityStep(_scenery, _city, 6);
    final clue = _clue(_city, (step == 6 ? 5 : step), 1);
    return ListView(children: [
      _card('MANZARA TAMAMLAMA', Column(children: [
        _label('Her doğru cevap, manzaranın bir parçasını açar. '
          '6 parçayı bitir, +12 altın kazan.'),
        const SizedBox(height: 12), _cityPicker(),
        const SizedBox(height: 13), _sceneryGrid(step),
        const SizedBox(height: 12),
        _label('${_provinces[_city].province} · $step / 6 parça açık',
          color: _v326Gold, size: 17),
      ])),
      _card(step == 6 ? 'MANZARA KEŞFEDİLDİ ✓' : 'PARÇA ${step + 1} · KELİME BUL',
        step == 6 ? Column(children: [
           Icon(Icons.landscape, color: _v326Gold, size: 46),
          _label('Şehrin manzarası tamamen açıldı. Tek seferlik ödül verildi.'),
        ]) : Column(children: [
          _label(clue.hint, size: 17),
          const SizedBox(height: 9),
          _label(_shuffle(clue.answer, _city * 59 + step * 71),
            size: 23, color: _v326Gold),
          _field(),
          _action('PARÇAYI AÇ', _busy ? null : () {
            if (v31TurkishUpper(_entry.text.trim()) == clue.answer) {
              _complete('v322_scenery_tiles', _scenery,
                _city * 6 + step, _city * 6 + 5, 12, 'MANZARA KEŞFİ');
            } else { _message('Kelime doğru değil, tekrar dene.'); }
          }, icon: Icons.image_search),
        ])),
      _card('MANZARA KOLEKSİYONU', _label(
        '${_scenery.length} / 486 parça açıldı. Şu anki şehir görselleri kullanılır; '
        'yeni HD fotoğraf indirilmez.', size: 12)),
    ]);
  }

  Widget _routeView() {
    final cities = _regionCities(_route);
    final step = _nextRouteStep(_route);
    final city = cities[(step == 4 ? 3 : step)];
    final options = <ProvinceInfo>[city];
    for (final p in cities) {
      if (options.length >= 4) break;
      if (p.slug != city.slug) options.add(p);
    }
    options.shuffle(math.Random(32230 + _route * 11 + step * 19));
    return ListView(children: [
      _card('TÜRKİYE KEŞİF ROTALARI', Column(children: [
        _label('7 coğrafi bölgede dörder şehir durağını doğru seç. '
          'Her tamamlanan rota +18 altın kazandırır.'),
        const SizedBox(height: 13),
        SizedBox(height: 52, child: ListView.builder(
          scrollDirection: Axis.horizontal, itemCount: _regionNames.length,
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.only(right: 7),
            child: ChoiceChip(selected: _route == i,
              selectedColor: _v326Gold,
              label: Text(_regionNames[i],
                style:  TextStyle(color: _v326Navy, fontSize: 12,
                  fontWeight: FontWeight.w700)),
              onSelected: _busy ? null : (_) => setState(() => _route = i))))),
        const SizedBox(height: 12),
        _label('${_regionNames[_route]} · $step / 4 durak bulundu',
          color: _v326Gold, size: 17),
        const SizedBox(height: 9),
        LinearProgressIndicator(value: step / 4, minHeight: 8,
          backgroundColor: Colors.white12,
          valueColor:  AlwaysStoppedAnimation<Color>(_v326Gold)),
        const SizedBox(height: 15),
        Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8,
          children: List.generate(4, (i) => Chip(
            backgroundColor: i < step ? _v326Gold : const Color(0xFF243D57),
            label: Text(i < step ? cities[i].province : 'Durak ${i + 1} 🔒',
              style: TextStyle(color: i < step ? _v326Navy : _v326Cream,
                fontWeight: FontWeight.bold))))),
      ])),
      _card(step == 4 ? 'ROTA TAMAMLANDI ✓' : 'SIRADAKİ DURAĞI BUL',
        step == 4 ? Column(children: [
           Icon(Icons.map_rounded, color: _v326Gold, size: 58),
          _label('Bu bölgenin dört durağını tamamladın. Ödül kaydedildi.'),
        ]) : Column(children: [
           Icon(Icons.route, color: _v326Gold, size: 45),
          _label('Bu bölgedeki sıradaki şehir ${city.province.length} karakterli '
            've "${city.province.substring(0, 1)}" harfi ile başlıyor.'),
          const SizedBox(height: 11),
          ...options.map((option) => _action(option.province, _busy ? null : () {
            if (option.slug == city.slug) {
              _complete('v322_route_stops', _routes,
                _route * 4 + step, _route * 4 + 3, 18,
                'TÜRKİYE KEŞİF ROTASI');
            } else { _message('Bu durak değil, yeniden dene.'); }
          }, icon: Icons.place)),
        ])),
      _card('KEŞİF PASAPORTU', _label('${_routes.length} / 28 durak ziyaret edildi. '
        'Rota durakları mevcut şehir kataloğundan seçilir.', size: 12)),
    ]);
  }

  @override Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: V325AdventureTheme.selected,
    builder: (context, _, __) => _v326Build(context),
  );

  Widget _v326Build(BuildContext context) => Column(children: [
    const V327ModeTip(mode: 'journey'),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      child: Row(children: [
        Expanded(child: _menu('DEDEKTİF', Icons.search, 0)),
        const SizedBox(width: 5),
        Expanded(child: _menu('MANZARA', Icons.landscape, 1)),
        const SizedBox(width: 5),
        Expanded(child: _menu('ROTALAR', Icons.route, 2)),
      ])),
    Expanded(child: _section == 0 ? _detectiveView() :
      _section == 1 ? _sceneryView() : _routeView()),
  ]);
  Widget _menu(String text, IconData icon, int index) => ElevatedButton(
    onPressed: _busy ? null : () => setState(() {
      _section = index; _entry.clear();
    }),
    style: ElevatedButton.styleFrom(
      backgroundColor: _section == index ? _v326Gold : _v326Surface,
      foregroundColor: _section == index ? _v326Navy : _v326Cream,
      minimumSize: const Size(0, 45), padding: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11),
        side:  BorderSide(color: _v326Gold))),
    child: FittedBox(fit: BoxFit.scaleDown, child: Row(mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 14), const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800))])));
}
