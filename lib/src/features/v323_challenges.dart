part of kelime_sehirleri;

// V32.3 – offline word sprint, simulated rival and ten-floor mastery tower.
// Never uses or modifies the original main-level progress/save IDs.
class V323Challenges extends StatefulWidget {
  const V323Challenges({super.key, required this.prefs, required this.onReward});
  final SharedPreferences? prefs;
  final void Function(int, String) onReward;
  @override
  State<V323Challenges> createState() => _V323ChallengesState();
}

class _V323ChallengesState extends State<V323Challenges>
    with WidgetsBindingObserver {
  int _mode = 0; // 0 timed, 1 offline duel, 2 mastery tower
  int _difficulty = 0;
  int _solved = 0;
  int _rival = 0;
  int _secondsLeft = 60;
  int _question = 0;
  bool _running = false;
  bool _paused = false;
  bool _saving = false;
  String _status = 'Başlamak için hazır ol.';
  final TextEditingController _answer = TextEditingController();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  List<String> _rewardedDays = <String>[];
  Set<String> _duelRewards = <String>{};
  Set<int> _towerDone = <int>{};
  int _bestTime = 0;
  static const _rivalNames = <String>['Çırak', 'Gezgin', 'Usta'];
  static const _rivalSpeed = <int>[18, 13, 9];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void didUpdateWidget(covariant V323Challenges oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.prefs != widget.prefs) _load();
  }

  void _load() {
    final p = widget.prefs;
    _rewardedDays = p?.getStringList('v323_sprint_reward_days') ?? <String>[];
    _duelRewards = (p?.getStringList('v323_duel_rewarded') ?? <String>[]).toSet();
    _towerDone = (p?.getStringList('v323_tower_completed') ?? <String>[])
        .map(int.tryParse).whereType<int>().where((n) => n >= 0 && n < 10).toSet();
    _bestTime = p?.getInt('v323_sprint_best') ?? 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && _running && !_paused) {
      _stopwatch.stop();
      if (mounted) setState(() => _paused = true);
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _stopwatch.stop();
    _answer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  int get _duration => _mode == 0 ? 60 : 90;
  String get _dateKey {
    final t = DateTime.now();
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${pad(t.month)}-${pad(t.day)}';
  }
  _V322Clue get _clue {
    final seed = _mode == 2 ? _towerDone.length * 5 :
        _mode == 1 ? _difficulty * 7 + _question * 3 : _question * 7;
    return _v322Clues[(seed + 3) % _v322Clues.length];
  }

  String _scramble(String word, int salt) {
    final letters = word.split('');
    letters.shuffle(math.Random(323000 + salt));
    if (letters.join() == word && letters.length > 1) {
      final first = letters[0];
      letters[0] = letters[1];
      letters[1] = first;
    }
    return letters.join('  ');
  }

  void _notice(String value) {
    if (mounted) ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(value)));
  }

  void _chooseMode(int index) {
    if (_saving) return;
    _stopRound();
    setState(() {
      _mode = index;
      _status = 'Başlamak için hazır ol.';
      _solved = 0;
      _rival = 0;
      _question = 0;
      _answer.clear();
      _secondsLeft = index == 0 ? 60 : 90;
    });
  }

  void _stopRound() {
    _ticker?.cancel();
    _ticker = null;
    _stopwatch.stop();
    _stopwatch.reset();
    _running = false;
    _paused = false;
  }

  void _startRound() {
    if (_running || _saving) return;
    _ticker?.cancel();
    _stopwatch.reset();
    setState(() {
      _running = true;
      _paused = false;
      _solved = 0;
      _rival = 0;
      _question = 0;
      _secondsLeft = _duration;
      _status = 'Doğru kelimeleri bul!';
      _answer.clear();
    });
    _stopwatch.start();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
  }

  void _tick() {
    if (!mounted || !_running || _paused) return;
    final elapsed = _stopwatch.elapsed.inSeconds;
    final left = math.max(0, _duration - elapsed);
    final rival = _mode == 1 ? math.min(5, elapsed ~/ _rivalSpeed[_difficulty]) : 0;
    if (left == 0 || (_mode == 1 && rival >= 5)) {
      _finishRound(left: left, rival: rival);
    } else if (left != _secondsLeft || rival != _rival) {
      setState(() { _secondsLeft = left; _rival = rival; });
    }
  }

  void _resume() {
    if (!_paused || !_running) return;
    setState(() => _paused = false);
    _stopwatch.start();
  }

  Future<void> _finishRound({int? left, int? rival}) async {
    if (!_running || _saving) return;
    final isSprint = _mode == 0;
    final score = _solved;
    final opponent = rival ?? _rival;
    final victory = isSprint ? score >= 5 : score >= 5 && score > opponent;
    _ticker?.cancel();
    _ticker = null;
    _stopwatch.stop();
    if (!mounted) return;
    setState(() {
      _running = false;
      _paused = false;
      _secondsLeft = left ?? _secondsLeft;
      _rival = opponent;
      _status = victory ? 'Tebrikler! Hedef tamamlandı.' :
          isSprint ? 'Süre bitti. 5 kelimeye ulaşmayı dene.' :
          'Düello bitti. Rakibini geçmeyi dene.';
    });
    if (isSprint && score > _bestTime && widget.prefs != null) {
      _bestTime = score;
      try { await widget.prefs!.setInt('v323_sprint_best', score); } catch (_) { /* best score optional */ }
    }
    if (!victory) return;
    final prefs = widget.prefs;
    if (prefs == null) { _notice('Kayıt hazır değil, ödül verilemedi.'); return; }
    setState(() => _saving = true);
    bool saved = false;
    bool newlyRewarded = false;
    final today = _dateKey;
    final difficulty = '$_difficulty';
    try {
      if (isSprint) {
        if (!_rewardedDays.contains(today)) {
          final next = <String>{..._rewardedDays, today}.toList()..sort();
          saved = await prefs.setStringList('v323_sprint_reward_days', next);
          if (saved) {
            _rewardedDays = next;
            newlyRewarded = true;
            widget.onReward(12, 'V32.3 GÜNLÜK SÜRAT');
          }
        } else { saved = true; }
        if (_bestTime < score) {
          _bestTime = score;
          await prefs.setInt('v323_sprint_best', score);
        }
      } else {
        if (!_duelRewards.contains(difficulty)) {
          final next = <String>{..._duelRewards, difficulty}.toList()..sort();
          saved = await prefs.setStringList('v323_duel_rewarded', next);
          if (saved) {
            _duelRewards = next.toSet();
            newlyRewarded = true;
            widget.onReward(10 + _difficulty * 5, 'V32.3 DÜELLO');
          }
        } else { saved = true; }
      }
    } catch (_) { saved = false; }
    if (!mounted) return;
    setState(() => _saving = false);
    if (!saved) _notice('Ödül kaydedilemedi; tekrar deneyebilirsin.');
    else if (newlyRewarded) _notice('Tebrikler! Ödül ilk zaferin için kaydedildi.');
    else _notice('Bu ödülü daha önce aldın; tekrar altın verilmez.');
  }

  Future<void> _submitWord() async {
    if (_saving) return;
    final guess = v31TurkishUpper(_answer.text.trim());
    if (guess != _clue.answer) {
      _notice('Kelime doğru değil. İpucunu tekrar oku.');
      return;
    }
    if (_mode == 2) {
      final floor = _towerDone.length;
      if (floor >= 10 || widget.prefs == null) return;
      setState(() => _saving = true);
      final next = <int>{..._towerDone, floor};
      bool saved = false;
      try {
        saved = await widget.prefs!.setStringList('v323_tower_completed',
            (next.toList()..sort()).map((e) => '$e').toList());
      } catch (_) { saved = false; }
      if (!mounted) return;
      setState(() {
        _saving = false;
        if (saved) _towerDone = next;
        _answer.clear();
      });
      if (saved) {
        widget.onReward(4 + floor, 'V32.3 USTALIK KULESİ');
        _notice('Kat ${floor + 1} tamam! +${4 + floor} altın.');
      } else { _notice('Kaydedilemedi, ödül verilmedi.'); }
      return;
    }
    if (!_running || _paused) return;
    final count = _solved + 1;
    setState(() {
      _solved = count;
      _question++;
      _answer.clear();
      _status = 'Doğru kelime!';
    });
    if (count >= 5) {
      // A rival at score 5 wins ties; player must reach 5 first.
      final opponent = _mode == 1 ?
          math.min(5, _stopwatch.elapsed.inSeconds ~/ _rivalSpeed[_difficulty]) : 0;
      await _finishRound(
          left: math.max(0, _duration - _stopwatch.elapsed.inSeconds),
          rival: opponent);
    }
  }

  Widget _panel(String title, Widget content) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: const Color(0xF4081C35),
      border: Border.all(color: _v31Gold, width: 1.2),
      borderRadius: BorderRadius.circular(18)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(title, style: const TextStyle(color: _v31Gold,
        fontSize: 19, fontWeight: FontWeight.w900)),
      const SizedBox(height: 13), content,
    ]));

  Widget _info(String text, {double size = 15, Color color = _v31Cream}) =>
    Text(text, textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: size, height: 1.35));

  Widget _button(String text, VoidCallback? onTap, {IconData icon = Icons.check_circle}) =>
    Padding(padding: const EdgeInsets.only(top: 12), child: SizedBox(
      width: double.infinity, child: ElevatedButton.icon(
        onPressed: onTap, icon: Icon(icon, size: 19), label: Text(text,
          textAlign: TextAlign.center),
        style: ElevatedButton.styleFrom(backgroundColor: _v31Gold,
          foregroundColor: _v31Navy, disabledBackgroundColor: const Color(0xFF465771),
          disabledForegroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))))));

  Widget _wordField() => TextField(
    controller: _answer, textCapitalization: TextCapitalization.characters,
    autocorrect: false, enableSuggestions: false, onSubmitted: (_) => _submitWord(),
    style: const TextStyle(color: _v31Cream, fontSize: 18),
    decoration: InputDecoration(hintText: 'Bulduğun kelime',
      hintStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: _v31Gold),
        borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: _v31Gold, width: 2),
        borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)));

  Widget _questionCard(int salt) => Column(children: [
    _info('KARIŞIK HARFLER', size: 11, color: _v31Gold),
    const SizedBox(height: 8),
    FittedBox(fit: BoxFit.scaleDown,
      child: Text(_scramble(_clue.answer, salt),
        style: const TextStyle(color: _v31Gold, fontSize: 26,
          fontWeight: FontWeight.w900, letterSpacing: 2))),
    const SizedBox(height: 11),
    _info('İpucu: ${_clue.hint}'),
    const SizedBox(height: 12), _wordField(),
    _button('KELİMEYİ ONAYLA', _saving || (_mode != 2 && (!_running || _paused)) ? null :
      () => _submitWord(), icon: Icons.spellcheck),
  ]);

  Widget _timedGame() {
    final wonToday = _rewardedDays.contains(_dateKey);
    return ListView(children: [
      _panel('60 SANİYE · KELİME SÜRATİ', Column(children: [
        _info('60 saniyede 5 doğru kelimeyi çöz. Bugün ilk başarına +12 altın.',
          color: _v31Cream),
        const SizedBox(height: 12),
        _info('⏱  $_secondsLeft sn    ·    $_solved / 5 kelime',
          color: _v31Gold, size: 24),
        const SizedBox(height: 9),
        LinearProgressIndicator(value: _solved / 5, minHeight: 9,
          backgroundColor: Colors.white12,
          valueColor: const AlwaysStoppedAnimation<Color>(_v31Gold)),
        if (wonToday) Padding(padding: const EdgeInsets.only(top: 10),
          child: _info('Bugünkü ödül kazanıldı ✓ Tekrar oynayabilirsin.', size: 12)),
        _button(_running ? 'YARIŞ DEVAM EDİYOR' : '60 SANİYELİK YARIŞI BAŞLAT',
          _running || _saving ? null : _startRound, icon: Icons.timer),
        if (_running && _paused)
          _button('DEVAM ET', _resume, icon: Icons.play_arrow),
      ])),
      if (_running)
        _panel('KELİME ${_solved + 1}', _questionCard(_question * 11 + 7)),
      _panel('YARIŞ DURUMU', Column(children: [
        _info(_status),
        const SizedBox(height: 9),
        _info('En yüksek doğru sayısı: $_bestTime · Ödüllü gün: ${_rewardedDays.length}',
          size: 12),
      ])),
    ]);
  }

  Widget _duelGame() => ListView(children: [
    _panel('ÇEVRİMDIŞI KELİME DÜELLOSU', Column(children: [
      _info('Bilgisayar rakibi belirlenmiş hızda ilerler; gerçek bir kişi ya da '
        'sunucuya bağlı yapay zekâ değildir.', size: 13),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
        children: List.generate(3, (i) => ChoiceChip(
          selected: _difficulty == i,
          selectedColor: _v31Gold,
          label: Text(_rivalNames[i], style: const TextStyle(color: _v31Navy,
            fontWeight: FontWeight.bold)),
          onSelected: _running || _saving ? null : (_) => setState(() {
            _difficulty = i;
            _answer.clear();
          })))),
      const SizedBox(height: 12),
      _info('SEN $_solved   —   $_rival ${_rivalNames[_difficulty].toUpperCase()}',
        color: _v31Gold, size: 22),
      _info('Kalan süre: $_secondsLeft saniye · Hedef: önce 5 kelime', size: 13),
      if (_duelRewards.contains('$_difficulty'))
        _info('Bu rakibin ilk galibiyet ödülü alındı ✓', size: 12),
      _button(_running ? 'DÜELLO DEVAM EDİYOR' :
          '${_rivalNames[_difficulty].toUpperCase()} İLE DÜELLO BAŞLAT',
        _running || _saving ? null : _startRound, icon: Icons.sports_martial_arts),
      if (_running && _paused) _button('DEVAM ET', _resume, icon: Icons.play_arrow),
    ])),
    if (_running) _panel('KELİME ${_solved + 1}', _questionCard(_difficulty * 101 + _question)),
    _panel('DÜELLO SONUCU', Column(children: [
      _info(_status),
      _info('İlk galibiyet ödülü: ${10 + _difficulty * 5} altın. '
        'Her zorluk düzeyinde yalnızca bir kez kazanılır.', size: 12),
    ])),
  ]);

  Widget _towerGame() {
    final floor = _towerDone.length;
    return ListView(children: [
      _panel('10 KATLI USTALIK KULESİ', Column(children: [
        _info('Katları sırayla geç. Her katta yeni kelime ve artan altın ödülü.'),
        const SizedBox(height: 12),
        Wrap(spacing: 7, runSpacing: 8, alignment: WrapAlignment.center,
          children: List.generate(10, (i) => Container(
            width: 55, height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: i < floor ? _v31Gold : const Color(0xFF183651),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _v31Gold)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(i < floor ? Icons.check : i == floor ? Icons.lock_open : Icons.lock,
                size: 15, color: i < floor ? _v31Navy : _v31Gold),
              Text('${i + 1}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,
                color: i < floor ? _v31Navy : _v31Cream)),
            ])))),
        const SizedBox(height: 13),
        _info('$floor / 10 kat tamamlandı', size: 19, color: _v31Gold),
      ])),
      _panel(floor >= 10 ? 'USTALIK KULESİ TAMAMLANDI ✓' :
          'KAT ${floor + 1} · +${floor + 4} ALTIN',
        floor >= 10 ? Column(children: [
          const Icon(Icons.emoji_events, color: _v31Gold, size: 58),
          _info('Tüm katları bitirdin. Ödüller bir defa verildi.'),
        ]) : _questionCard(floor * 13 + 31)),
      _panel('USTALIK ÖDÜLLERİ', _info(
        'Her kat 4–13 altın verir. Aynı kat tekrar ödül kazandırmaz.', size: 13)),
    ]);
  }

  Widget _menu(String title, IconData icon, int index) => Expanded(child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3),
    child: ElevatedButton(
      onPressed: _saving ? null : () => _chooseMode(index),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 3),
        minimumSize: const Size(0, 47),
        backgroundColor: _mode == index ? _v31Gold : const Color(0xFF18324E),
        foregroundColor: _mode == index ? _v31Navy : _v31Cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11),
          side: const BorderSide(color: _v31Gold))),
      child: FittedBox(fit: BoxFit.scaleDown, child: Row(
        mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15), const SizedBox(width: 3),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ])))));

  @override
  Widget build(BuildContext context) => Column(children: [
    Padding(padding: const EdgeInsets.fromLTRB(6, 6, 6, 1), child: Row(children: [
      _menu('SÜRELİ', Icons.timer, 0),
      _menu('DÜELLO', Icons.sports_martial_arts, 1),
      _menu('KULE', Icons.emoji_events, 2),
    ])),
    Expanded(child: _mode == 0 ? _timedGame() :
      _mode == 1 ? _duelGame() : _towerGame()),
  ]);
}
