part of kelime_sehirleri;

// V31.6: Offline daily word, 81 city-region questions, milestone medals.
// All new persistence keys start with v316_; legacy city IDs are untouched.
const List<String> _v316Regions = <String>[
  'Marmara', 'Ege', 'Akdeniz', 'İç Anadolu',
  'Karadeniz', 'Doğu Anadolu', 'Güneydoğu Anadolu',
];

String _v316DayKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

int _v316DailyWordId(DateTime day) =>
    (day.year * 37 + day.month * 59 + day.day * 113) % v31ChallengeCount;

class _V316Medal {
  const _V316Medal(this.id, this.title, this.detail, this.earned, this.reward, this.icon);
  final String id, title, detail;
  final bool earned;
  final int reward;
  final IconData icon;
}

class V316Expedition extends StatefulWidget {
  const V316Expedition({super.key, required this.prefs, required this.mainCompleted,
    required this.marathonCompleted, required this.treasures,
    required this.coins, required this.onReward});
  final SharedPreferences? prefs;
  final Set<int> mainCompleted;
  final Set<int> marathonCompleted;
  final Set<int> treasures;
  final int coins;
  final void Function(int, String) onReward;
  @override
  State<V316Expedition> createState() => _V316ExpeditionState();
}

class _V316ExpeditionState extends State<V316Expedition> {
  int _section = 0;
  int _city = 0;
  bool _saving = false;
  bool _hintShown = false;
  final TextEditingController _dailyAnswer = TextEditingController();
  Set<String> _dailyDone = <String>{};
  Set<String> _geoDone = <String>{};
  Set<String> _medals = <String>{};

  @override
  void initState() {
    super.initState();
    _refresh();
    final now = DateTime.now();
    _city = (now.year * 17 + now.month * 23 + now.day * 3) % _provinces.length;
  }

  void _refresh() {
    _dailyDone = widget.prefs?.getStringList('v316_daily_solved')?.toSet() ?? <String>{};
    _geoDone = widget.prefs?.getStringList('v316_city_quiz_done')?.toSet() ?? <String>{};
    _medals = widget.prefs?.getStringList('v316_medals_claimed')?.toSet() ?? <String>{};
  }

  @override
  void dispose() {
    _dailyAnswer.dispose();
    super.dispose();
  }

  void _message(String content) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
  }

  Widget _text(String s, {double size = 14, Color color = _v31Cream}) =>
      Text(s, style: TextStyle(color: color, fontSize: size));

  Widget _panel(String heading, List<Widget> children) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xEF0B2542),
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: const Color(0xBBFFD479))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(heading, style: const TextStyle(color: _v31Gold, fontSize: 18,
        fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...children,
    ]));

  Widget _button(String label, VoidCallback? action, IconData icon) =>
      Padding(padding: const EdgeInsets.only(top: 9),
        child: ElevatedButton.icon(
          onPressed: action, icon: Icon(icon, size: 18), label: Text(label),
          style: ElevatedButton.styleFrom(backgroundColor: _v31Gold,
            foregroundColor: _v31Navy, disabledBackgroundColor: Colors.blueGrey,
            padding: const EdgeInsets.symmetric(vertical: 12))));

  int get _streak {
    var day = DateTime.now();
    if (!_dailyDone.contains(_v316DayKey(day))) {
      day = day.subtract(const Duration(days: 1));
    }
    var count = 0;
    while (count < 3660 && _dailyDone.contains(_v316DayKey(day))) {
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }

  Future<bool> _saveSet(String key, Set<String> values) async {
    if (widget.prefs == null) {
      _message('Kayıt alanı henüz hazır değil.');
      return false;
    }
    try {
      return await widget.prefs!.setStringList(key, values.toList()..sort());
    } catch (_) {
      _message('Kayıt yapılamadı. Daha sonra tekrar dene.');
      return false;
    }
  }

  Future<void> _solveDaily() async {
    if (_saving) return;
    final day = DateTime.now();
    final key = _v316DayKey(day);
    if (_dailyDone.contains(key)) return;
    final correct = v31ChallengeAnswer(_v316DailyWordId(day));
    final entered = v31TurkishUpper(_dailyAnswer.text.trim()).replaceAll(' ', '');
    if (entered != correct) {
      _message('Kelime doğru değil, harfleri tekrar dene.');
      return;
    }
    setState(() => _saving = true);
    final next = <String>{..._dailyDone, key};
    final ok = await _saveSet('v316_daily_solved', next);
    if (!mounted) return;
    setState(() {
      if (ok) _dailyDone = next;
      _saving = false;
      if (ok) _dailyAnswer.clear();
    });
    if (ok) {
      widget.onReward(7, 'GÜNLÜK KEŞİF +7');
      _message('Günün kelimesi tamamlandı! +7 altın');
    }
  }

  Widget _dailyView() {
    final day = DateTime.now();
    final key = _v316DayKey(day);
    final solved = _dailyDone.contains(key);
    final id = _v316DailyWordId(day);
    final word = v31ChallengeAnswer(id);
    final shownHint = _hintShown ? 'İlk harf: ${word.substring(0, 1)}' : 'İlk harf gizli';
    final featured = _provinces[(day.year * 17 + day.month * 23 + day.day * 3) % _provinces.length];
    return ListView(children: [
      _panel('GÜNÜN KELİMESİ · $key', [
        _text('Her gün bir yeni karışık kelime. Doğru çözersen yalnızca bir kez +7 altın kazanırsın.'),
        const SizedBox(height: 9),
        Text(v31Scramble(id), textAlign: TextAlign.center,
          style: const TextStyle(color: _v31Gold, fontSize: 25,
            fontWeight: FontWeight.w800, letterSpacing: 2)),
        const SizedBox(height: 8),
        _text('${word.length} harf · $shownHint', color: _v31Gold),
        if (!solved) TextField(controller: _dailyAnswer,
          enabled: !_saving, textCapitalization: TextCapitalization.characters,
          style: const TextStyle(color: _v31Cream),
          decoration: const InputDecoration(labelText: 'Kelimeyi yaz',
            labelStyle: TextStyle(color: _v31Gold),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _v31Gold)))),
        if (!solved && !_hintShown) _button('İLK HARF İPUCU',
          () => setState(() => _hintShown = true), Icons.lightbulb_outline),
        _button(solved ? 'BUGÜN TAMAMLANDI ✓' : 'CEVABI KONTROL ET',
          solved || _saving ? null : _solveDaily, Icons.check_circle_outline),
        const SizedBox(height: 12),
        _text('Günlük seri: $_streak gün  ·  Toplam ${_dailyDone.length} gün',
          color: _v31Gold),
        LinearProgressIndicator(value: (_streak.clamp(0, 7) / 7),
          color: _v31Gold, backgroundColor: const Color(0xFF42516B), minHeight: 6),
        const SizedBox(height: 5),
        _text('7 günlük seri rozetine doğru ilerle!', size: 12),
      ]),
      _panel('BUGÜNÜN ŞEHRİ', [
        SizedBox(height: 165, child: ClipRRect(borderRadius: BorderRadius.circular(14),
          child: Image(image: _citySelectionImageProvider(featured), fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const ColoredBox(color: _v31Navy,
              child: Icon(Icons.landscape, color: _v31Gold, size: 45))))),
        const SizedBox(height: 8),
        _text('${featured.province} · ${featured.region}', color: _v31Gold, size: 17),
        _text('Bu şehri keşfetmek için İl Bilgi Testi bölümünü aç.'),
        _button('İL BİLGİ TESTİNE GİT', () => setState(() {
          _section = 1;
          _city = _provinces.indexOf(featured);
        }), Icons.public),
      ]),
    ]);
  }

  List<String> _options(int index) {
    final correct = _provinces[index].region;
    final choices = <String>[correct];
    for (var offset = 0; offset < _v316Regions.length && choices.length < 4; offset++) {
      final region = _v316Regions[(index + offset * 3) % _v316Regions.length];
      if (!choices.contains(region)) choices.add(region);
    }
    if (choices.length != 4) return choices;
    final offset = index % choices.length;
    return <String>[...choices.skip(offset), ...choices.take(offset)];
  }

  Future<void> _checkRegion(String selected) async {
    if (_saving) return;
    final province = _provinces[_city];
    if (_geoDone.contains(province.slug)) return;
    if (selected != province.region) {
      _message('Bu bölge değil. Yeniden deneyebilirsin.');
      return;
    }
    setState(() => _saving = true);
    final next = <String>{..._geoDone, province.slug};
    final ok = await _saveSet('v316_city_quiz_done', next);
    if (!mounted) return;
    setState(() {
      if (ok) _geoDone = next;
      _saving = false;
    });
    if (ok) {
      widget.onReward(5, 'İL BİLGİSİ +5');
      _message('${province.province} doğru! +5 altın');
    }
  }

  Widget _regionQuizView() {
    final province = _provinces[_city];
    final solved = _geoDone.contains(province.slug);
    return ListView(children: [
      _panel('81 İL BİLGİ YARIŞMASI', [
        _text('81 ilin hangi coğrafi bölgede bulunduğunu bul. Her il için ilk doğru cevap +5 altın.'),
        const SizedBox(height: 10),
        _text('${_geoDone.length} / ${_provinces.length} il tamamlandı', color: _v31Gold),
        LinearProgressIndicator(value: _geoDone.length / _provinces.length,
          color: _v31Gold, backgroundColor: const Color(0xFF42516B), minHeight: 6),
        const SizedBox(height: 11),
        DropdownButton<int>(value: _city, isExpanded: true,
          dropdownColor: const Color(0xFF152D49),
          style: const TextStyle(color: _v31Cream),
          items: List.generate(_provinces.length, (i) => DropdownMenuItem<int>(
            value: i, child: Text('${i + 1}. ${_provinces[i].province}'
              '${_geoDone.contains(_provinces[i].slug) ? ' ✓' : ''}'))),
          onChanged: _saving ? null : (value) {
            if (value != null) setState(() => _city = value);
          }),
        const SizedBox(height: 6),
        SizedBox(height: 190, child: ClipRRect(borderRadius: BorderRadius.circular(14),
          child: Image(image: _citySelectionImageProvider(province), fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const ColoredBox(color: _v31Navy,
              child: Icon(Icons.landscape, color: _v31Gold, size: 48))))),
        const SizedBox(height: 11),
        Text('${province.province} hangi bölgemizde?',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: _v31Gold,
            fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (solved) _text('Doğru cevap: ${province.region} ✓', color: _v31Gold)
        else ..._options(_city).map((choice) => _button(choice,
          _saving ? null : () => _checkRegion(choice), Icons.place_outlined)),
        _button('SONRAKİ İL', _saving ? null : () => setState(() {
          var next = (_city + 1) % _provinces.length;
          for (var i = 0; i < _provinces.length; i++) {
            if (!_geoDone.contains(_provinces[next].slug)) break;
            next = (next + 1) % _provinces.length;
          }
          _city = next;
        }), Icons.arrow_forward),
      ]),
    ]);
  }

  List<_V316Medal> _availableMedals() {
    final finishedCities = _provinces.where((p) =>
      p.levels.isNotEmpty && p.levels.every(widget.mainCompleted.contains)).length;
    return <_V316Medal>[
      _V316Medal('main1', 'İlk Kelime', '1 ana bölüm tamamla',
        widget.mainCompleted.isNotEmpty, 10, Icons.abc),
      _V316Medal('main25', 'Kelime Ustası', '25 ana bölüm tamamla',
        widget.mainCompleted.length >= 25, 15, Icons.workspace_premium),
      _V316Medal('city1', 'İlk Şehir', '1 şehrin tüm bölümlerini bitir',
        finishedCities >= 1, 15, Icons.location_city),
      _V316Medal('city10', 'Türkiye Gezgini', '10 şehri bitir',
        finishedCities >= 10, 25, Icons.explore),
      _V316Medal('marathon13', 'Kelime Maratoncusu', '13 ek kelime görevini çöz',
        widget.marathonCompleted.length >= 13, 15, Icons.directions_run),
      _V316Medal('marathon100', 'Maraton Şampiyonu', '100 ek kelime görevi çöz',
        widget.marathonCompleted.length >= 100, 30, Icons.emoji_events),
      _V316Medal('treasure1', 'Hazine Avcısı', '1 şehir hatırası topla',
        widget.treasures.isNotEmpty, 15, Icons.auto_awesome),
      _V316Medal('quiz10', 'Coğrafya Meraklısı', '10 ilin bölgesini doğru bul',
        _geoDone.length >= 10, 15, Icons.public),
      _V316Medal('quiz81', '81 İl Uzmanı', '81 il bilgi testini tamamla',
        _geoDone.length >= 81, 50, Icons.school),
      _V316Medal('daily3', 'Günlük Gezgin', '3 farklı günün kelimesini çöz',
        _dailyDone.length >= 3, 15, Icons.today),
      _V316Medal('streak7', '7 Günlük Seri', 'Art arda 7 gün kelime çöz',
        _streak >= 7, 35, Icons.local_fire_department),
    ];
  }

  Future<void> _claimMedal(_V316Medal medal) async {
    if (_saving || !medal.earned || _medals.contains(medal.id)) return;
    setState(() => _saving = true);
    final next = <String>{..._medals, medal.id};
    final ok = await _saveSet('v316_medals_claimed', next);
    if (!mounted) return;
    setState(() {
      if (ok) _medals = next;
      _saving = false;
    });
    if (ok) {
      widget.onReward(medal.reward, 'ROZET: ${medal.title}');
      _message('${medal.title} rozeti alındı! +${medal.reward} altın');
    }
  }

  Widget _medalsView() {
    final all = _availableMedals();
    return ListView(children: [
      _panel('BAŞARI ROZETLERİ', [
        const Icon(Icons.workspace_premium, color: _v31Gold, size: 46),
        const SizedBox(height: 8),
        _text('${_medals.length} / ${all.length} rozet alındı · Ödüller yalnızca bir kez verilir.',
          color: _v31Gold),
        _text('Görevleri oyun içinde tamamla, ardından hazır rozetlerini topla.'),
      ]),
      ...all.map((medal) => _panel(medal.title, [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(medal.icon, color: medal.earned ? _v31Gold : Colors.white38, size: 36),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [_text(medal.detail), const SizedBox(height: 4),
              _text('+${medal.reward} altın', color: _v31Gold)])),
        ]),
        _button(_medals.contains(medal.id) ? 'ROZET ALINDI ✓' :
          medal.earned ? 'ROZETİ AL' : 'HENÜZ KİLİTLİ',
          _saving || !medal.earned || _medals.contains(medal.id)
            ? null : () => _claimMedal(medal),
          medal.earned ? Icons.card_giftcard : Icons.lock_outline),
      ])),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    const labels = <String>['GÜNLÜK', 'İL TESTİ', 'ROZETLER'];
    const icons = <IconData>[Icons.today, Icons.public, Icons.workspace_premium];
    return Column(children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(children: List.generate(labels.length, (i) => Expanded(
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2),
            child: ChoiceChip(selected: _section == i,
              selectedColor: _v31Gold,
              label: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icons[i], size: 14,
                  color: _section == i ? _v31Navy : _v31Gold),
                const SizedBox(width: 3),
                Flexible(child: Text(labels[i], maxLines: 1,
                  overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,
                    color: _section == i ? _v31Navy : _v31Cream))),
              ]), onSelected: (_) => setState(() => _section = i))))))),
      Expanded(child: _section == 0 ? _dailyView() :
        _section == 1 ? _regionQuizView() : _medalsView()),
    ]);
  }
}
