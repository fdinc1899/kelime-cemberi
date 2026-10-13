part of kelime_sehirleri;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final math.Random _random = math.Random();
  final AdventureProgress _adventure = AdventureProgress();
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  late final AnimationController _cheerController;
  bool _musicOn = true;
  bool _effectsOn = true;
  bool _vibrationOn = true;
  double _musicVolume = .23;
  double _effectsVolume = .55;
  bool _confettiVisible = false;
  String _cheerHeadline = 'BRAVO!';
  String _cheerSubline = '+10 ALTIN';
  SharedPreferences? _prefs;
  int _level = 0;
  int _unlocked = 0;
  int _coins = 120;
  String _lastGiftDay = '';
  List<String> _wheelLetters = [];
  final Set<String> _solved = {};
  final Set<String> _bonuses = {};
  final Set<String> _hintCells = {};
  final Set<int> _completedLevels = {};
  final List<int> _dragged = [];
  int? _activeWheelPointer;
  Offset? _lastWheelPoint;
  String _notice = 'Harfleri parmağınla birleştir';
  bool _exitDialogOpen = false;
  bool _readyToPlay = false;
  bool _showWelcome = true;
  bool _showCityChoice = false;

  PuzzleLevel get _puzzle => _levels[_level];
  bool get _complete => _puzzle.answers.every((w) => _solved.contains(w.word));
  String get _selection => _dragged.map((i) => _wheelLetters[i]).join();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cheerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _confettiVisible = false);
      }
    });
    _wheelLetters = _levels.first.letters.split('');
    _restore();
  }

  @override
  void dispose() {
    _saveProgress();
    _adventure.save();
    WidgetsBinding.instance.removeObserver(this);
    _cheerController.dispose();
    _musicPlayer.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _saveProgress();
    }
  }

  Future<void> _startMusic() async {
    if (!_musicOn) return;
    try {
      // Dosya local cache'e yazılır: internet ve asset manifest gerektirmez.
      final f = File('${Directory.systemTemp.path}/kelime_sehirleri_muzik.mp3');
      if (!await f.exists()) {
        await f.writeAsBytes(_musicBytes, flush: true);
      }
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(_musicVolume);
      await _musicPlayer.play(DeviceFileSource(f.path));
    } catch (e) {
      // Bazı cihazlarda medya motoru çalışmayabilir; oyun devam eder.
      debugPrint('Müzik başlatılamadı: $e');
      if (mounted) setState(() => _notice = 'Müzik bu cihazda başlatılamadı');
    }
  }

  Future<void> _toggleMusic() async {
    final next = !_musicOn;
    setState(() {
      _musicOn = next;
      _notice = next ? 'Müzik açık' : 'Müzik kapalı';
    });
    await _prefs?.setBool('music_enabled_v3', next);
    if (next) {
      await _startMusic();
    } else {
      await _musicPlayer.stop();
    }
  }

  Future<void> _playEffect() async {
    if (!_effectsOn || _effectsVolume <= 0) return;
    try {
      final f = File('${Directory.systemTemp.path}/kelime_sehirleri_tebrik_v5.wav');
      if (!await f.exists()) {
        await f.writeAsBytes(_celebrationEffectBytes, flush: true);
      }
      await _effectPlayer.stop();
      await _effectPlayer.setVolume(_effectsVolume);
      await _effectPlayer.play(DeviceFileSource(f.path));
    } catch (e) {
      debugPrint('Ses efekti çalıştırılamadı: $e');
    }
  }

  void _celebrate(String title, String subtitle) {
    setState(() {
      _cheerHeadline = title;
      _cheerSubline = subtitle;
      _confettiVisible = true;
    });
    _cheerController.forward(from: 0);
    _playEffect();
    if (_vibrationOn) HapticFeedback.lightImpact();
  }

  Future<void> _confirmExit() async {
    if (_exitDialogOpen || !mounted) return;
    _exitDialogOpen = true;
    await _saveProgress();
    if (!mounted) { _exitDialogOpen = false; return; }
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 25),
        child: _goldFrame(child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 76, width: double.infinity,
            child: ClipRRect(borderRadius: BorderRadius.circular(14),
              child: Stack(fit: StackFit.expand, children: [
                Image.memory(_istanbulBackground, fit: BoxFit.cover,
                  alignment: Alignment.topCenter),
                const DecoratedBox(decoration: BoxDecoration(
                  color: Color(0x8806172B))),
                const Icon(Icons.exit_to_app_rounded,
                  color: Color(0xFFFFD36E), size: 53),
              ]))),
          const V18GoldDivider(padding: 6),
          const Text('OYUNDAN ÇIKMAK', style: TextStyle(color: _gold,
              fontFamily: 'serif', fontWeight: FontWeight.w900, fontSize: 21)),
          const Text('İSTİYOR MUSUN?', style: TextStyle(color: _gold,
              fontFamily: 'serif', fontWeight: FontWeight.w900, fontSize: 20)),
          const SizedBox(height: 13),
          const Text('Bulduğun kelimeler, altınların ve bölümün kaydedilecek.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _cream, fontSize: 13)),
          const SizedBox(height: 22),
          Row(children: [
            Expanded(child: V12PillButton(label: 'HAYIR',
              onPressed: () => Navigator.of(dialogContext).pop(false))),
            const SizedBox(width: 12),
            Expanded(child: V12PillButton(label: 'EVET, ÇIK', danger: true,
              onPressed: () => Navigator.of(dialogContext).pop(true))),
          ]),
        ])),
      ),
    );
    if (!mounted) { _exitDialogOpen = false; return; }
    if (shouldExit == true) {
      await _saveProgress();
      await _musicPlayer.stop();
      await SystemNavigator.pop();
    }
    _exitDialogOpen = false;
  }


  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    _prefs = prefs;
    _coins = prefs.getInt('coins') ?? 120;
    _lastGiftDay = prefs.getString('gift_date') ?? '';
    _musicOn = prefs.getBool('music_enabled_v3') ?? true;
    _effectsOn = prefs.getBool('effects_enabled_v5') ?? true;
    _vibrationOn = prefs.getBool('vibration_enabled_v5') ?? true;
    _musicVolume = (prefs.getDouble('music_volume_v5') ?? .23).clamp(0.0, 1.0).toDouble();
    _effectsVolume = (prefs.getDouble('effects_volume_v5') ?? .55).clamp(0.0, 1.0).toDouble();
    if (prefs.getInt('chapter_schema') != 3) {
      // V1/V2 geçişi: İstanbul 1. bölümün başarısı ve altınlar korunur.
      // Eski Kapadokya 2. sıradaydı; şimdi İstanbul'da 3 bölüm var.
      final oldDone = (prefs.getStringList('finished_levels') ?? []).contains('0');
      _completedLevels.clear();
      if (oldDone) _completedLevels.add(0);
      _unlocked = oldDone ? 1 : 0;
      _level = _unlocked;
      await prefs.setStringList('solved_v3_0', prefs.getStringList('solved_0') ?? []);
      await prefs.setStringList('bonuses_v3_0', prefs.getStringList('bonuses_0') ?? []);
      await prefs.setStringList('hints_v3_0', prefs.getStringList('hints_0') ?? []);
      await prefs.setStringList('finished_levels_v3', _completedLevels.map((e) => '$e').toList());
      await prefs.setInt('unlocked_v3', _unlocked);
      await prefs.setInt('current_level_v3', _level);
      await prefs.setInt('chapter_schema', 3);
    } else {
      _unlocked = (prefs.getInt('unlocked_v3') ?? 0).clamp(0, _levels.length - 1).toInt();
      _level = (prefs.getInt('current_level_v3') ?? 0).clamp(0, _unlocked).toInt();
      _completedLevels.addAll(
        (prefs.getStringList('finished_levels_v3') ?? [])
            .map(int.tryParse).whereType<int>(),
      );
    }
    // A user who finished the original 18 stages before V15 must be able
    // to enter bonus chapter 19 without losing their saved level selection.
    if (_completedLevels.contains(17) && _unlocked < 30) {
      _unlocked = 30;
      await prefs.setInt('unlocked_v3', 30);
    }
    _adventure.load(prefs, _completedLevels);
    _openLevel(_level);
    if (mounted) setState(() => _readyToPlay = true);
    _startMusic();
  }

  void _openLevel(int index) {
    if (index > _unlocked || index < 0 || index >= _levels.length) return;
    bool recovered = false;
    bool justCompleted = false;
    setState(() {
      _level = index;
      _wheelLetters = _levels[index].letters.split('');
      _solved
        ..clear()
        ..addAll(_prefs?.getStringList('solved_v3_$index') ?? []);
      _bonuses
        ..clear()
        ..addAll(_prefs?.getStringList('bonuses_v3_$index') ?? []);
      _hintCells
        ..clear()
        ..addAll(_prefs?.getStringList('hints_v3_$index') ?? []);
      _dragged.clear();
      _activeWheelPointer = null;
      _lastWheelPoint = null;
      // Eski APK'da bütün kutular doluyken sayaç ilerlemeyebiliyordu.
      // Hali hazırda görünür olan tam kelimeleri kayıt üzerinden onar.
      recovered = _completeFullyRevealedWords() > 0;
      justCompleted = _finishLevelIfSolved();
      _notice = justCompleted
          ? 'Bölüm tamamlandı! Sonraki bölüm açıldı.'
          : recovered ? 'Açılmış kelimeler tamamlandı' : 'Harfleri parmağınla birleştir';
    });
    _prefs?.setInt('current_level_v3', index);
    if (recovered || justCompleted) _saveProgress();
    if (justCompleted) _announceLevelCompleted(index);
  }

  // Bulmaca hücrelerinin görünmesi ile kelimenin çözüldü olarak sayılması
  // önceki sürümde iki ayrı durumdu. Tamamı görünür hale gelen bir kelime
  // artık otomatik tanınır. İpucuyla tamamlanan kelimeler +10 altın kazandırmaz.
  bool _wordFullyRevealed(WordPosition word) {
    for (var i = 0; i < word.word.length; i++) {
      final row = word.row + (word.down ? i : 0);
      final col = word.col + (word.down ? 0 : i);
      if (!_hintCells.contains('$row:$col') && !_isSolvedCell(row, col)) {
        return false;
      }
    }
    return true;
  }

  int _completeFullyRevealedWords() {
    var addedCount = 0;
    // Bir kelimenin tamamlanması kesişen başka bir kelimeyi de tamamlayabilir.
    bool changed;
    do {
      changed = false;
      for (final word in _puzzle.answers) {
        if (_solved.contains(word.word) || !_wordFullyRevealed(word)) continue;
        if (_solved.add(word.word)) {
          addedCount++;
          changed = true;
        }
      }
    } while (changed);
    return addedCount;
  }

  bool _finishLevelIfSolved() {
    if (!_complete || !_completedLevels.add(_level)) return false;
    _coins += 40;
    _adventure.finishedLevel(_level, _hintCells.length);
    if (_level + 1 < _levels.length) {
      _unlocked = math.max(_unlocked, _nextStoryLevel(_level));
    }
    return true;
  }

  void _announceLevelCompleted(int finishedIndex) {
    _celebrate('TEBRİKLER!', 'BÖLÜM TAMAMLANDI! +40 ALTIN');
    Future.delayed(const Duration(milliseconds: 1650), () {
      if (mounted && _level == finishedIndex) _showLevelResult();
    });
  }

  Future<void> _saveProgress() async {
    final prefs = _prefs;
    if (prefs == null) return;
    // Asenkron yazma sürerken bölüm değişebilir: kaydedilecek anı dondur.
    final index = _level;
    final solvedSnapshot = _solved.toList();
    final bonusesSnapshot = _bonuses.toList();
    final hintsSnapshot = _hintCells.toList();
    await prefs.setInt('current_level_v3', index);
    await prefs.setStringList('solved_v3_$index', solvedSnapshot);
    await prefs.setStringList('bonuses_v3_$index', bonusesSnapshot);
    await prefs.setStringList('hints_v3_$index', hintsSnapshot);
    await prefs.setStringList('finished_levels_v3',
        _completedLevels.map((e) => '$e').toList());
    await prefs.setInt('coins', _coins);
    await prefs.setInt('unlocked_v3', _unlocked);
    await _adventure.save();
  }

  // Ham dokunma olayları + EagerGestureRecognizer ile kaydırma çakışmasını
  // önleriz. Üst SingleChildScrollView, tekerlekteki sürüklemeyi alamaz.
  void _wheelTouchDown(PointerDownEvent event, double size) {
    if (_activeWheelPointer != null) return;
    _activeWheelPointer = event.pointer;
    _lastWheelPoint = null;
    if (_dragged.isNotEmpty) setState(() => _dragged.clear());
    _handleWheelMotion(event.localPosition, size);
  }

  void _wheelTouchMove(PointerMoveEvent event, double size) {
    if (_activeWheelPointer != event.pointer) return;
    _handleWheelMotion(event.localPosition, size);
  }

  void _wheelTouchUp(PointerUpEvent event) {
    if (_activeWheelPointer != event.pointer) return;
    _activeWheelPointer = null;
    _lastWheelPoint = null;
    _submitWord();
  }

  void _wheelTouchCancel(PointerCancelEvent event) {
    if (_activeWheelPointer != event.pointer) return;
    _activeWheelPointer = null;
    _lastWheelPoint = null;
    if (mounted) setState(() => _dragged.clear());
  }

  void _handleWheelMotion(Offset local, double size) {
    final from = _lastWheelPoint;
    _lastWheelPoint = local;
    if (from == null) {
      _handleDrag(local, size);
      return;
    }
    // Parmağı hızlı hareket ettirince arada kalan harfleri kaçırma.
    final steps = math.max(1, ((local - from).distance / (size * .035)).ceil());
    for (var i = 1; i <= steps; i++) {
      final part = i / steps;
      _handleDrag(Offset.lerp(from, local, part)!, size);
    }
  }

  void _handleDrag(Offset local, double size) {
    final index = LetterWheelPainter.hitLetter(local, size, _wheelLetters.length);
    if (index == null) return;
    if (_dragged.isNotEmpty && _dragged.last == index) return;
    setState(() {
      if (_dragged.length > 1 && _dragged[_dragged.length - 2] == index) {
        _dragged.removeLast();
      } else if (!_dragged.contains(index)) {
        _dragged.add(index);
      }
    });
  }

  void _submitWord() {
    if (_dragged.isEmpty) return;
    final word = _selection;
    final targets = _puzzle.answers.map((e) => e.word).toSet();
    bool newWord = false;
    bool newBonus = false;
    bool justCompleted = false;
    setState(() {
      _dragged.clear();
      if (targets.contains(word)) {
        if (_solved.add(word)) {
          newWord = true;
          _coins += 10;
          _notice = '$word bulundu! +10 altın';
          final autoCount = _completeFullyRevealedWords();
          if (autoCount > 0) _notice = '$word bulundu! $autoCount kelime de tamamlandı';
          justCompleted = _finishLevelIfSolved();
          if (justCompleted) _notice = 'Bölüm tamamlandı! +40 altın';
        } else {
          _notice = '$word zaten bulundu';
        }
      } else if (_puzzle.bonusWords.contains(word)) {
        if (_bonuses.add(word)) {
          newBonus = true;
          _coins += 5;
          _notice = 'Bonus: $word +5 altın';
        } else {
          _notice = 'Bu bonus kelimeyi bulmuştun';
        }
      } else {
        _notice = '$word bu bölümün kelime listesinde yok';
      }
    });
    if (newWord || newBonus) {
      _adventure.foundWord(bonus: newBonus);
    }
    _saveProgress();
    if (newWord) {
      if (justCompleted) {
        _announceLevelCompleted(_level);
      } else {
        _celebrate('BRAVO!', '$word  +10 ALTIN');
      }
    } else if (newBonus) {
      _celebrate('BONUS!', '$word  +5 ALTIN');
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) _showBonusAward(word);
      });
    }
  }

  void _shuffle() {
    setState(() {
      final previous = _wheelLetters.join();
      for (int i = 0; i < 6; i++) {
        _wheelLetters.shuffle(_random);
        if (_wheelLetters.join() != previous) break;
      }
      _dragged.clear();
      _notice = 'Harfler karıştırıldı';
    });
  }

  void _hint() {
    if (_complete) return;
    final cells = _puzzle.cells;
    for (final word in _puzzle.answers.where((w) => !_solved.contains(w.word))) {
      for (int i = 0; i < word.word.length; i++) {
        final row = word.row + (word.down ? i : 0);
        final col = word.col + (word.down ? 0 : i);
        final id = '$row:$col';
        if (!_hintCells.contains(id) && !_isSolvedCell(row, col)) {
          if (_coins < 25 && _adventure.freeHints < 1) {
            setState(() => _notice = 'İpucu için 25 altın gerekiyor');
            return;
          }
          var autoCount = 0;
          var justCompleted = false;
          setState(() {
            _hintCells.add(id);
            if (!_adventure.spendFreeHint()) _coins -= 25;
            autoCount = _completeFullyRevealedWords();
            justCompleted = _finishLevelIfSolved();
            _notice = justCompleted
                ? 'Bölüm tamamlandı! +40 altın'
                : autoCount > 0
                    ? '$autoCount kelime otomatik tamamlandı'
                    : 'İpucu açıldı: ${cells[id]}  −25 altın';
          });
          _saveProgress();
          if (justCompleted) _announceLevelCompleted(_level);
          return;
        }
      }
    }
    // Bu duruma yalnızca önceki sürümden bozuk kayıtla gelinebilir.
    var recovered = 0;
    var justCompleted = false;
    setState(() {
      recovered = _completeFullyRevealedWords();
      justCompleted = _finishLevelIfSolved();
      _notice = justCompleted
          ? 'Bölüm tamamlandı! +40 altın'
          : recovered > 0 ? '$recovered kelime tamamlandı' : 'Harfleri birleştirerek devam et';
    });
    if (recovered > 0 || justCompleted) _saveProgress();
    if (justCompleted) _announceLevelCompleted(_level);
  }

  bool _isSolvedCell(int row, int col) {
    for (final answer in _puzzle.answers) {
      if (!_solved.contains(answer.word)) continue;
      for (int i = 0; i < answer.word.length; i++) {
        if (answer.row + (answer.down ? i : 0) == row &&
            answer.col + (answer.down ? 0 : i) == col) return true;
      }
    }
    return false;
  }

  void _next() {
    if (!_complete) return;
    if (_nextStoryLevel(_level) >= _levels.length) {
      _showFinished();
    } else {
      _openLevel(_nextStoryLevel(_level));
    }
  }

  void _showFinished() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tebrikler! 🏆'),
        content: const Text(
          'Türkiye’nin 81 iline ait 243 ana bölümü tamamladın! Tebrikler!',
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Harika!'))],
      ),
    );
  }

  Widget _mapProgressPill(String text, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(text,
            style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w800)),
      );

  Widget _cityStageDot(bool done, bool active, bool locked) {
    final Color fill = done ? const Color(0xFF55B36C) : (active ? _gold : (locked ? const Color(0xFFE9DFCF) : const Color(0xFF123255)));
    final Color border = done ? Colors.white : (active ? Colors.white : _gold.withOpacity(.75));
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: Border.all(color: border, width: 1.4),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 3)],
      ),
      child: done ? const Icon(Icons.check, size: 9, color: Colors.white) : null,
    );
  }

  Widget _cityMapCard(BuildContext sheetContext, int i) {
    final province = _provinces[i];
    final start = province.start;
    final city = province.city;
    final locked = !_cityOpen(province, _unlocked);
    final done = province.levels.where(_completedLevels.contains).length;
    final active = province.levels.contains(_level);
    final nextLevel = province.levels.firstWhere((n) => n <= _unlocked && !_completedLevels.contains(n),
        orElse: () => province.levels.first);
    return Material(color: Colors.transparent, child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: locked ? null : () {
        Navigator.pop(sheetContext);
        _openLevel(nextLevel);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD877),
            width: active ? 2.5 : 1.8),
          boxShadow: const [
            BoxShadow(color: Color(0xA9000000), blurRadius: 15, offset: Offset(0, 5)),
            BoxShadow(color: Color(0x55FFD06B), blurRadius: 7),
          ]),
        child: ClipRRect(borderRadius: BorderRadius.circular(14),
          child: Stack(children: [
            Positioned.fill(child: Container(color: const Color(0xFF061A31))),
            Positioned(left: 0, top: 0, bottom: 0, width: 167,
              child: _cityImageWidget(city)),
            Positioned(left: 136, top: 0, bottom: 0, width: 51,
              child: DecoratedBox(decoration: BoxDecoration(
                gradient: LinearGradient(colors: [const Color(0x00051A31),
                  const Color(0xFF061A31)])))),
            Positioned.fill(child: IgnorePointer(child: DecoratedBox(
              decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.white.withOpacity(.07), Colors.transparent,
                  const Color(0x55000000)]))))),
            Positioned(left: 5, top: 5, child: Container(
              width: 32, height: 32, alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFFFFF5BD),
                  Color(0xFFFFC449), Color(0xFFB66D0F)]),
                boxShadow: [BoxShadow(color: Color(0xB8000000), blurRadius: 5)]),
              child: Text('${i + 1}', style: const TextStyle(color: _navy,
                fontSize: 16, fontWeight: FontWeight.w900)))),
            Positioned(left: 173, right: 6, top: 0, bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, children: [
                  FittedBox(fit: BoxFit.scaleDown,
                    child: Text(province.title, style: const TextStyle(color: Colors.white,
                      fontSize: 16, fontWeight: FontWeight.w900,
                      shadows: [Shadow(color: Colors.black87, blurRadius: 6)]))),
                  const SizedBox(height: 2),
                  Text(locked ? 'KİLİTLİ' : '$done/3 BÖLÜM',
                    style: const TextStyle(color: _gold,
                      fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    ...List.generate(3, (j) => Padding(
                      padding: const EdgeInsets.only(right: 1),
                      child: Icon(_completedLevels.contains(province.levels[j])
                        ? Icons.star_rounded : Icons.star_border_rounded,
                        color: _gold, size: 16))),
                    const Spacer(),
                    Icon(locked ? Icons.lock_rounded :
                      done == 3 ? Icons.check_circle_rounded : Icons.arrow_forward_ios_rounded,
                      color: locked ? Colors.white : _gold, size: 18),
                  ]),
                  const SizedBox(height: 3),
                  ClipRRect(borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(value: done / 3,
                      minHeight: 4, backgroundColor: const Color(0xFF31485A),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF22C665)))),
                ])),
          ])),
      ),
    ));
  }

  // Ekranlar resim değil; gerçek dokunulabilir Flutter kontrolleridir.
  void _premiumPage(String title, Widget body, {Uint8List? background}) {
    showDialog<void>(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black87,
      builder: (pageContext) => PremiumPageShell(
        title: title,
        background: background ?? _istanbulBackground,
        onClose: () => Navigator.pop(pageContext),
        child: body,
      ),
    );
  }

  Widget _premiumMenuItem(IconData icon, String label, VoidCallback onTap,
      {String? detail, Color? accent}) => V18MenuLine(
        icon: icon, title: label, onTap: onTap, trailing: detail);

  Widget _settingToggle(String label, IconData icon, bool enabled,
      ValueChanged<bool> onChange) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      gradient: const LinearGradient(begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A3A59), Color(0xFF051627)]),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFF4CB71), width: 1.3),
      boxShadow: const [BoxShadow(color: Color(0x70000000), blurRadius: 8)]),
    child: SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: _gold, size: 26),
      title: Text(label, style: const TextStyle(color: _cream, fontWeight: FontWeight.w800)),
      value: enabled, activeColor: _navy,
      activeTrackColor: _gold, inactiveTrackColor: const Color(0xFF3A5269),
      onChanged: onChange,
    ),
  );

  Widget _statsLine(String title, String data, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    margin: const EdgeInsets.symmetric(vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xD60B2A48), borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0x7BFFD36E))),
    child: Row(children: [
      Icon(icon, color: _gold, size: 22), const SizedBox(width: 10),
      Expanded(child: Text(title, style: const TextStyle(color: _cream, fontWeight: FontWeight.w600))),
      Text(data, style: const TextStyle(color: _gold, fontSize: 16, fontWeight: FontWeight.w900)),
    ]),
  );

  void _showMap() {
    _premiumPage(
      'ŞEHİR HARİTASI',
      JourneyMapView(
        completed: _mainDone(_completedLevels),
        unlocked: _unlocked,
        cardBuilder: _cityMapCard,
      ),
      background: _premiumCityScenes['Antalya'] ?? _istanbulBackground,
    );
  }

  void _showGameMenu() {
    showDialog<void>(context: context,
      builder: (menuContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: _goldFrame(child: SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              const Expanded(child: Text('OYUN MENÜSÜ', textAlign: TextAlign.center,
                style: TextStyle(color: _gold, fontSize: 22, fontFamily: 'serif',
                    fontWeight: FontWeight.w900))),
              IconButton(onPressed: () => Navigator.pop(menuContext),
                icon: const Icon(Icons.close, color: _cream)),
            ]),
            const SizedBox(height: 8),
            _premiumMenuItem(Icons.home_rounded, 'Ana menü / Şehir seç', () {
              Navigator.pop(menuContext);
              _saveProgress();
              _showWelcomeChoice();
            }),
            _premiumMenuItem(Icons.map_rounded, 'Şehir haritası', () {
              Navigator.pop(menuContext);
              WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _showMap(); });
            }),
            _premiumMenuItem(Icons.auto_awesome_rounded, 'Macera merkezi · 10 özellik', () {
              Navigator.pop(menuContext);
              WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _showAdventureHub(); });
            }),
            _premiumMenuItem(Icons.person_rounded, 'Profilim', () {
              Navigator.pop(menuContext);
              WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _showProfile(); });
            }),
            _premiumMenuItem(Icons.bar_chart_rounded, 'İstatistikler', () {
              Navigator.pop(menuContext);
              WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _showStatistics(); });
            }),
            _premiumMenuItem(Icons.settings_rounded, 'Ayarlar', () {
              Navigator.pop(menuContext);
              WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _showSettings(); });
            }),
            _premiumMenuItem(Icons.save_rounded, 'Oyunu kaydet', () async {
              await _saveProgress();
              if (!mounted) return;
              Navigator.pop(menuContext);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
                Text('Oyun ilerlemen telefona kaydedildi ✓')));
            }),
            _premiumMenuItem(Icons.logout_rounded, 'Oyundan çık', () {
              Navigator.pop(menuContext);
              WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _confirmExit(); });
            }, accent: const Color(0xFFFF7777)),
          ],
        ))),
      ));
  }


  Widget _goldFrame({required Widget child, EdgeInsetsGeometry? padding}) =>
      V18GildedPanel(padding: padding ?? const EdgeInsets.all(17), child: child);

  Widget _goldStar(int index, int count, {double size = 43}) => Icon(
      index < count ? Icons.star_rounded : Icons.star_outline_rounded,
      color: index < count ? const Color(0xFFFFE178) : _gold,
      shadows: const [Shadow(color: Color(0xFFFA9919), blurRadius: 13)],
      size: size);

  Widget _settingsHeading(String title, IconData icon) => Row(children: [
    Icon(icon, color: const Color(0xFF9C6D30)),
    const SizedBox(width: 8),
    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
  ]);

  void _showSettings() {
    _premiumPage('AYARLAR', StatefulBuilder(builder: (ctx, refresh) {
      void change(VoidCallback callback) {
        setState(callback);
        refresh(() {});
      }
      return ListView(padding: const EdgeInsets.fromLTRB(15, 18, 15, 28), children: [
        const SizedBox(height: 2),
        V10SettingsSection(
          icon: Icons.music_note_rounded, label: 'Müzik', value: _musicOn,
          level: _musicVolume,
          onToggle: (v) { _toggleMusic(); refresh(() {}); },
          onSlide: (v) { change(() => _musicVolume = v);
            _musicPlayer.setVolume(v); _prefs?.setDouble('music_volume_v5', v); },
        ),
        V10SettingsSection(
          icon: Icons.volume_up_rounded, label: 'Ses Efektleri', value: _effectsOn,
          level: _effectsVolume,
          onToggle: (v) { change(() => _effectsOn = v);
            _prefs?.setBool('effects_enabled_v5', v); if (v) _playEffect(); },
          onSlide: (v) { change(() => _effectsVolume = v);
            _prefs?.setDouble('effects_volume_v5', v); },
        ),
        _settingToggle('Titreşim', Icons.vibration_rounded, _vibrationOn, (v) {
          change(() => _vibrationOn = v); _prefs?.setBool('vibration_enabled_v5', v);
          if (v) HapticFeedback.selectionClick();
        }),
        _premiumMenuItem(Icons.palette_outlined, 'Tema', () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
            Text('Premium gece teması etkin')));
        }, detail: 'Premium gece'),
        _premiumMenuItem(Icons.language_rounded, 'Dil', () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
            Text('Türkçe kelime paketi etkin')));
        }, detail: 'Türkçe'),
        _premiumMenuItem(Icons.person_rounded, 'Hesabım / İlerleme', () {
          Navigator.pop(ctx);
          WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _showProfile(); });
        }),
        _premiumMenuItem(Icons.save_rounded, 'Oyun Kaydı', () async {
          await _saveProgress();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('İlerlemen bu telefona kaydedildi ✓')));
        }, detail: 'Bu telefonda otomatik kayıt'),
        _premiumMenuItem(Icons.info_outline_rounded, 'Hakkında', () {
          showDialog<void>(context: ctx, builder: (d) => AlertDialog(
            title: const Text('Kelime Şehirleri'),
            content: const Text('81 il, 243 ana bölüm, 12 ek bölüm, bonuslar ve yerel kayıt.\n'
                'İlerleme bu cihazda saklanır; uygulama verilerini silmeyin.'),
            actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('Tamam'))]));
        }),
      ]);
    }));
  }

  Widget _profileStat(IconData icon, String value, String title) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
    decoration: BoxDecoration(color: const Color(0xFF102F4A),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: _gold, width: 1)),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: _gold, size: 24),
      const SizedBox(height: 5),
      Text(value, style: const TextStyle(color: _cream, fontWeight: FontWeight.w900, fontSize: 20)),
      Text(title, textAlign: TextAlign.center,
        style: const TextStyle(color: _cream, fontSize: 10)),
    ]),
  ));

  int get _totalSolvedCount => List.generate(_levels.length,
      (i) => _prefs?.getStringList('solved_v3_$i')?.length ?? 0)
      .fold<int>(0, (a, b) => a + b);

  int get _totalBonusCount => List.generate(_levels.length,
      (i) => _prefs?.getStringList('bonuses_v3_$i')?.length ?? 0)
      .fold<int>(0, (a, b) => a + b);

  int get _citiesComplete => _cityDone(_completedLevels);

  void _showProfile() {
    _premiumPage('PROFİLİM', ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 35), children: [
      Container(padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: const Color(0xDD051B33),
          border: Border.all(color: _gold, width: 1),
          borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Container(width: 68, height: 68,
            decoration: BoxDecoration(shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 3),
              image: DecorationImage(image: MemoryImage(_istanbulBackground),
                fit: BoxFit.cover)),
            child: const Icon(Icons.person_rounded, color: _cream, size: 35)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kelime Ustası', style: TextStyle(color: _cream,
                fontWeight: FontWeight.w900, fontSize: 19)),
              const Text('Şehirleri keşfet!', style: TextStyle(color: _gold,
                fontSize: 12)),
              Text('${_puzzle.city} · ${_levelLabel(_level)}',
                style: const TextStyle(color: _cream, fontSize: 11)),
            ])),
        ])),
      const SizedBox(height: 16),
      Row(children: [
        _profileStat(Icons.monetization_on, '$_coins', 'Altın'),
        const SizedBox(width: 6),
        _profileStat(Icons.emoji_events_rounded, '${_completedLevels.length}/${_levels.length}', 'Bölüm'),
        const SizedBox(width: 6),
        _profileStat(Icons.stars_rounded, '$_totalBonusCount', 'Bonus'),
      ]),
      const SizedBox(height: 17),
      _statsLine('Tamamlanan şehirler', '$_citiesComplete / 81', Icons.public_rounded),
      _statsLine('Bulunan kelimeler', '$_totalSolvedCount', Icons.abc_rounded),
      const SizedBox(height: 15),
      const Text('ŞEHİR ROZETLERİ', style: TextStyle(color: _gold,
          fontWeight: FontWeight.w900, fontSize: 17)),
      const SizedBox(height: 8),
      SizedBox(height: 104, child: ListView.builder(scrollDirection: Axis.horizontal,
        itemCount: _provinces.length, itemBuilder: (ctx, i) {
          final province = _provinces[i];
          final name = province.city;
          final done = province.levels.every(_completedLevels.contains);
          return Container(width: 92, margin: const EdgeInsets.only(right: 9),
            decoration: BoxDecoration(color: const Color(0xD50C2947),
                borderRadius: BorderRadius.circular(13), border: Border.all(color: _gold)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 54, height: 54,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _cityImageProvider(name),
                    fit: BoxFit.cover),
                  border: Border.all(color: _gold, width: 2.5),
                  boxShadow: const [BoxShadow(color: Color(0x77FFD36E), blurRadius: 7)]),
                child: !done ? Container(decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0x8805172A)),
                  child: const Icon(Icons.lock_outline_rounded,
                    color: _cream, size: 22)) : null),
              const SizedBox(height: 5),
              Text(name, textAlign: TextAlign.center, maxLines: 1,
                overflow: TextOverflow.ellipsis, style: const TextStyle(color: _cream, fontSize: 11)),
              Text(done ? 'TAMAM' : 'KİLİTLİ', style: TextStyle(
                color: done ? _gold : const Color(0xFF9CACBB), fontSize: 9)),
            ]),
          );
        })),
      const SizedBox(height: 15),
      ClipRRect(borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(
          value: _completedLevels.length / _levels.length,
          minHeight: 11,
          backgroundColor: const Color(0xFF42536C),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58C26E)))),
      const SizedBox(height: 12),
      _premiumMenuItem(Icons.bar_chart_rounded, 'Tüm istatistikler', () {
        Navigator.pop(context);
        WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _showStatistics(); });
      }),
      _premiumMenuItem(Icons.map_rounded, 'Şehir haritası', () {
        Navigator.pop(context);
        WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _showMap(); });
      }),
    ]), background: _istanbulBackground);
  }

  void _showStatistics() {
    _premiumPage('İSTATİSTİKLER', ListView(
      padding: const EdgeInsets.fromLTRB(18, 25, 18, 30), children: [
      const Center(child: SizedBox(height: 103, width: 145,
        child: Stack(alignment: Alignment.center, children: [
          Icon(Icons.emoji_events_rounded, color: _gold, size: 74),
          Positioned(top: 0, right: 11, child: Icon(Icons.auto_awesome,
            color: _gold, size: 23)),
        ]))),
      const SizedBox(height: 11),
      _statsLine('Tamamlanan bölümler', '${_completedLevels.length} / ${_levels.length}', Icons.emoji_events),
      _statsLine('Bulunan kelimeler', '$_totalSolvedCount', Icons.abc_rounded),
      _statsLine('Bonus kelimeler', '$_totalBonusCount', Icons.stars_rounded),
      _statsLine('Mevcut altın', '$_coins', Icons.monetization_on_rounded),
      _statsLine('Tamamlanan şehirler', '$_citiesComplete / 81', Icons.public),
      const SizedBox(height: 18),
      const Text('ŞEHİR İLERLEMESİ', style: TextStyle(color: _gold,
          fontWeight: FontWeight.w900, fontSize: 18)),
      const SizedBox(height: 10),
      ...List.generate(_provinces.length, (i) {
        final province = _provinces[i];
        final done = province.levels.where(_completedLevels.contains).length;
        return Container(padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            CircleAvatar(radius: 18, backgroundColor: _navy,
              child: Text('${i+1}', style: const TextStyle(color: _gold))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_provinces[i].title, style: const TextStyle(color: _cream,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              LinearProgressIndicator(value: done / 3, minHeight: 6,
                  backgroundColor: const Color(0xFF354E67),
                  valueColor: const AlwaysStoppedAnimation<Color>(_gold)),
            ])),
            const SizedBox(width: 12),
            Text('$done/3', style: const TextStyle(color: _gold, fontWeight: FontWeight.bold)),
          ]));
      }),
    ]));
  }


  void _showLevelResult() {
    final level = _level;
    final total = _puzzle.answers.length;
    final bonusCount = _bonuses.length;
    final stageLabel = _levelLabel(level);
    final stars = _adventure.stars[level] ?? 1;
    final art = _cityImageProvider(_puzzle.city);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: _goldFrame(
          padding: const EdgeInsets.all(17),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              const V10Ribbon(title: 'TEBRİKLER!', compact: true),
              const Text('BÖLÜM TAMAMLANDI!', textAlign: TextAlign.center,
                style: TextStyle(color: _cream, fontFamily: 'serif',
                  fontSize: 21, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => _goldStar(i, stars,
                  size: i == 1 ? 67 : 51))),
              const SizedBox(height: 8),
              Container(height: 130, width: 240,
                decoration: BoxDecoration(shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: _gold, width: 3),
                  image: DecorationImage(image: art,
                    fit: BoxFit.cover)),
                alignment: Alignment.bottomCenter,
                child: Container(width: double.infinity, padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: const Color(0xB50C2440),
                      borderRadius: BorderRadius.circular(60)),
                  child: Text('${_puzzle.city.toUpperCase()}  $stageLabel',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _cream,
                      fontWeight: FontWeight.w900, fontSize: 12)))),
              const SizedBox(height: 16),
              _resultStat(Icons.check_circle_rounded, 'Bulunan kelimeler', '$total / $total'),
              _resultStat(Icons.stars_rounded, 'Bonus kelimeler', '$bonusCount'),
              _resultStat(Icons.monetization_on_rounded, 'Bölüm ödülü', '+40 altın'),
              const SizedBox(height: 12),
              const Text('✓  İLERLEME KAYDEDİLDİ', style: TextStyle(
                color: Color(0xFF8CE6A9), fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              SizedBox(width: double.infinity, child: PremiumActionButton(
                title: level == _levels.length - 1
                  ? 'OYUNU BİTİR' : 'SONRAKİ BÖLÜM',
                icon: Icons.arrow_forward_rounded,
                onPressed: () { Navigator.pop(ctx); _next(); })),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity,
                child: PremiumActionButton(title: 'HARİTAYA DÖN',
                  accent: const Color(0xFF1478D2), icon: Icons.map_outlined,
                  onPressed: () { Navigator.pop(ctx); _showMap(); })),
            ])),
        ),
      ),
    );
  }

  Widget _resultStat(IconData icon, String name, String number) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(children: [
      Icon(icon, color: _gold, size: 20),
      const SizedBox(width: 8),
      Expanded(child: Text(name, style: const TextStyle(color: _cream, fontSize: 12))),
      Text(number, style: const TextStyle(color: _gold,
        fontWeight: FontWeight.w900, fontSize: 12)),
    ]),
  );

  // Reward chest is a transparent game asset, never a static screenshot.
  void _showRewards() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final claimed = _lastGiftDay == today;
    showDialog<void>(
      context: context,
      barrierColor: const Color(0xD800091A),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .83),
          child: SingleChildScrollView(child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF09233C), Color(0xFF030A17), Color(0xFF0B2B45)]),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: _gold, width: 2),
              boxShadow: const [BoxShadow(color: Color(0xBB000000), blurRadius: 22)],
            ),
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 23),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(alignment: Alignment.centerRight,
                child: IconButton(onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(Icons.close_rounded, color: _cream, size: 26))),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: .80, end: 1),
                duration: const Duration(milliseconds: 750),
                curve: Curves.elasticOut,
                builder: (ctx, value, child) => Transform.scale(scale: value, child: child),
                child: Stack(alignment: Alignment.center, children: [
                  Container(height: 224, decoration: BoxDecoration(shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      _gold.withOpacity(.83), const Color(0x22FFD36E),
                      const Color(0x00FFD36E)]))),
                  SizedBox(height: 212, width: double.infinity,
                    child: CustomPaint(painter: V12SparklePainter())),
                  Image.asset('assets/images/ui/reward_chest_v18.png',
                    height: 215, fit: BoxFit.contain),
                  const Positioned(top: 4, left: 30, child: Icon(Icons.auto_awesome_rounded,
                    color: _gold, size: 27)),
                  const Positioned(bottom: 18, right: 24, child: Icon(Icons.stars_rounded,
                    color: _gold, size: 32)),
                  const Positioned(top: 30, right: 17, child: Icon(Icons.star_rounded,
                    color: _cream, size: 20)),
                ]),
              ),
              const V10Ribbon(title: 'GÜNLÜK ÖDÜL'),
              const SizedBox(height: 5),
              const Text('Her gün oyuna girerek altın kazan!',
                textAlign: TextAlign.center,
                style: TextStyle(color: _cream, fontSize: 14,
                  fontWeight: FontWeight.w700)),
              const V18GoldDivider(padding: 8),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.monetization_on_rounded, color: _gold, size: 33),
                Text(claimed ? ' BUGÜN ALINDI' : ' +35 ALTIN',
                  style: const TextStyle(color: _gold, fontSize: 23,
                    fontWeight: FontWeight.w900)),
              ]),
              const SizedBox(height: 19),
              SizedBox(width: double.infinity, child: PremiumActionButton(
                title: claimed ? 'YARIN TEKRAR GEL' : 'AL',
                icon: claimed ? Icons.check_circle_rounded : Icons.card_giftcard_rounded,
                onPressed: claimed ? null : () {
                  setState(() {
                    _coins += 35;
                    _lastGiftDay = today;
                    _notice = 'Günlük ödül! +35 altın';
                  });
                  _prefs?.setString('gift_date', today);
                  _saveProgress();
                  Navigator.pop(dialogContext);
                  _celebrate('ÖDÜL!', 'GÜNLÜK +35 ALTIN');
                },
              )),
            ]),
          )),
        ),
      ),
    );
  }

  void _continueFromSave() {
    setState(() {
      _showWelcome = false;
      _showCityChoice = false;
    });
  }

  void _openFromWelcome(int index) {
    if (index < 0 || index > _unlocked || index >= _levels.length) return;
    _openLevel(index); // persists the selected chapter using the V3 keys
    setState(() {
      _showWelcome = false;
      _showCityChoice = false;
    });
  }

  void _showWelcomeChoice() => setState(() {
    _showWelcome = true;
    _showCityChoice = false;
  });

  void _chooseCityOnWelcome() => setState(() {
    _showWelcome = true;
    _showCityChoice = true;
  });

  // Premium arayüz — oyun mekaniği ve kayıt sistemi aynı kalır.
  static const _navy = Color(0xFF0C2440);
  static const _gold = Color(0xFFFFD36E);
  static const _cream = Color(0xFFFFF7E6);

  @override
  Widget build(BuildContext context) {
    if (!_readyToPlay) {
      return const Scaffold(
        backgroundColor: Color(0xFF071628),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFFCC68))),
      );
    }
    if (_showWelcome) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_showCityChoice) {
            _showWelcomeChoice();
          } else {
            _confirmExit();
          }
        },
        child: _showCityChoice
            ? PremiumCityChooser(
                unlocked: _unlocked,
                completed: _completedLevels,
                onBack: _showWelcomeChoice,
                onOpenLevel: _openFromWelcome,
              )
            : PremiumOpeningScreen(
                currentCity: _puzzle.city,
                currentStage: _stageOf(_level),
                finishedCount: _mainDone(_completedLevels),
                onContinue: _continueFromSave,
                onChooseCity: _chooseCityOnWelcome,
                onChooseChapter: _chooseCityOnWelcome,
                onSettings: _showSettings,
                onExit: _confirmExit,
                onAdventure: _showAdventureHub,
              ),
      );
    }
    final firstCity = _puzzle.city == 'İstanbul';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
      backgroundColor: _navy,
      body: Stack(
        children: [
          Positioned.fill(
            child: _cityImageWidget(_puzzle.city),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, .17, .46, .69, 1],
                  colors: [
                    _navy.withOpacity(.76),
                    _navy.withOpacity(.14),
                    _navy.withOpacity(.20),
                    _navy.withOpacity(.18),
                    _navy.withOpacity(.60),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(child: IgnorePointer(child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            color: Color.lerp(const Color(0x6C001728), Colors.transparent,
                (_solved.length / _puzzle.answers.length).clamp(0.0, 1.0).toDouble())!,
          ))),
          SafeArea(
            child: LayoutBuilder(builder: (context, viewport) {
              final narrow = viewport.maxWidth < 370;
              final compact = viewport.maxHeight < 730;
              final wheelSize = math.min(
                viewport.maxWidth * (narrow ? .56 : .58),
                compact ? 195.0 : 230.0,
              ).clamp(170.0, 230.0).toDouble();
              final boardMax = compact ? 40.0 : 47.0;
              return Padding(
                padding: EdgeInsets.fromLTRB(narrow ? 10 : 15, 10,
                    narrow ? 10 : 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _premiumTopBar(narrow),
                    SizedBox(height: compact ? 7 : 11),
                    _cityPlaque(),
                    SizedBox(height: compact ? 7 : 12),
                    Expanded(
                      child: Column(
                        children: [
                          Flexible(flex: 11, child: Center(child: _premiumBoard(boardMax))),
                          SizedBox(height: compact ? 8 : 10),
                          _selectionMessage(),
                          SizedBox(height: compact ? 4 : 6),
                          Flexible(flex: 10, child: Center(child: _wheelAndActions(wheelSize, narrow))),
                          SizedBox(height: compact ? 8 : 10),
                          _complete ? _nextButton() : _levelDots(),
                          const SizedBox(height: 10),
                          _premiumBottomBar(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          if (_confettiVisible)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _cheerController,
                  builder: (context, child) {
                    final p = _cheerController.value;
                    final opacity = p < .18 ? p / .18 :
                        p > .78 ? (1-p)/.22 : 1.0;
                    return Stack(children: [
                      CustomPaint(
                        size: MediaQuery.sizeOf(context),
                        painter: CelebrationPainter(p),
                      ),
                      Align(
                        alignment: const Alignment(0, -.21),
                        child: Opacity(
                          opacity: opacity.clamp(0, 1).toDouble(),
                          child: Transform.scale(
                            scale: .55 + .45 * Curves.elasticOut.transform(p.clamp(0.0, .92).toDouble()),
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              Row(mainAxisSize: MainAxisSize.min,
                                children: List.generate(3, (i) => Icon(Icons.star_rounded,
                                  size: i == 1 ? 56 : 38, color: _gold))),
                              Text(_cheerHeadline, textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 48,
                                  color: Color(0xFFFFE37B), fontWeight: FontWeight.w900,
                                  fontFamily: 'serif', fontStyle: FontStyle.italic,
                                  shadows: [
                                    Shadow(color: Color(0xFFE77713), blurRadius: 1, offset: Offset(2, 3)),
                                    Shadow(color: Color(0xFFFFAA11), blurRadius: 19),
                                    Shadow(color: Colors.black, blurRadius: 12, offset: Offset(1, 5)),
                                  ])),
                              DecoratedBox(decoration: BoxDecoration(
                                color: const Color(0xD8071B35),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(color: _gold, width: 1.6)),
                                child: Padding(padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 9),
                                  child: Text(_cheerSubline, textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.w900, fontSize: 16)))),
                            ]),
                          ),
                        ),
                      ),
                    ]);
                  },
                ),
              ),
            ),
        ],
      ),
    ));
  }

  void _adventureToast(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text),
      duration: const Duration(seconds: 2)));
  }

  void _showAdventureHub() {
    _adventure.refreshPeriod();
    _premiumPage('MACERA MERKEZİ', StatefulBuilder(builder: (pageContext, refresh) =>
      AdventureCenterView(
        progress: _adventure, completed: _completedLevels, unlocked: _unlocked,
        onClaimDaily: (id, minimum, value, reward) {
          final coins = _adventure.claimDaily(id, minimum, value, reward);
          if (coins == 0) return;
          setState(() => _coins += coins);
          refresh(() {});
          _saveProgress();
          _celebrate('GÖREV!', '+$coins ALTIN');
        },
        onClaimWeekly: (id, target, reward) {
          final coins = _adventure.claimWeekly(id, target, reward);
          if (coins == 0) return;
          setState(() => _coins += coins);
          refresh(() {});
          _saveProgress();
          _celebrate('HAFTALIK ÖDÜL!', '+$coins ALTIN');
        },
        onSpin: () {
          final result = _adventure.spin(_random);
          if (result < 0) return;
          const outcomes = [20, 40, 60, 100, 0, 0];
          setState(() => _coins += outcomes[result]);
          refresh(() {});
          _saveProgress();
          final notice = result == 4 ? 'ÜCRETSİZ İPUCU!'
              : result == 5 ? 'SANDIK KAZANDIN!'
              : '+${outcomes[result]} ALTIN';
          _celebrate('ÇARK ÖDÜLÜ!', notice);
        },
        onChest: () {
          final prize = _adventure.openChest(_random);
          if (prize == 0) return;
          setState(() => _coins += prize);
          refresh(() {});
          _saveProgress();
          _celebrate('SANDIK AÇILDI!', '+$prize ALTIN');
        },
        onOpenExtra: (index) {
          Navigator.pop(pageContext);
          _openLevel(index);
          setState(() { _showWelcome = false; _showCityChoice = false; });
        },
        onUsePower: (power) {
          Navigator.pop(pageContext);
          setState(() { _showWelcome = false; _showCityChoice = false; });
          if (power == 'shuffle') {
            _shuffle();
          } else if (power == 'first') {
            _revealFirstLetter();
          } else if (power == 'word') {
            _revealWholeWord();
          }
        },
      ),
    ));
  }

  void _revealFirstLetter() {
    if (_coins < 15 || _complete) {
      _adventureToast('15 altın gerekiyor veya bölüm tamamlandı');
      return;
    }
    bool reveal = false;
    bool completed = false;
    setState(() {
      for (final word in _puzzle.answers) {
        if (_solved.contains(word.word)) continue;
        final id = '${word.row}:${word.col}';
        if (_hintCells.contains(id) || _isSolvedCell(word.row, word.col)) continue;
        _hintCells.add(id);
        _coins -= 15;
        reveal = true;
        _completeFullyRevealedWords();
        completed = _finishLevelIfSolved();
        _notice = 'İlk harf açıldı · −15 altın';
        break;
      }
    });
    if (reveal) _saveProgress();
    if (completed) _announceLevelCompleted(_level);
    if (!reveal) _adventureToast('Açılacak ilk harf kalmadı');
  }

  void _revealWholeWord() {
    if (_coins < 80 || _complete) {
      _adventureToast('80 altın gerekiyor veya bölüm tamamlandı');
      return;
    }
    bool completed = false;
    setState(() {
      final target = _puzzle.answers.firstWhere(
        (w) => !_solved.contains(w.word));
      for (int i = 0; i < target.word.length; i++) {
        _hintCells.add('${target.row + (target.down ? i : 0)}:${target.col + (target.down ? 0 : i)}');
      }
      _coins -= 80;
      _completeFullyRevealedWords();
      completed = _finishLevelIfSolved();
      _notice = '${target.word} açıldı · −80 altın';
    });
    _saveProgress();
    if (completed) _announceLevelCompleted(_level);
  }

  Widget _premiumTopBar(bool narrow) => Row(children: [
        _goldRoundButton(_musicOn ? Icons.music_note_rounded : Icons.music_off_rounded,
          _toggleMusic, radius: narrow ? 21 : 24),
        const SizedBox(width: 8),
        _goldRoundButton(Icons.menu_rounded, _showGameMenu,
            radius: narrow ? 21 : 24),
        const Spacer(),
        InkWell(
          onTap: _showRewards,
          borderRadius: BorderRadius.circular(25),
          child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 14, 8),
          decoration: BoxDecoration(
            color: _navy.withOpacity(.91),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: _gold, width: 1.8),
            boxShadow: const [BoxShadow(color: Color(0x88000000),
                blurRadius: 9, offset: Offset(0, 3))],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.monetization_on_rounded, color: _gold, size: 24),
            const SizedBox(width: 7),
            Text('$_coins', style: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(width: 7),
            const Icon(Icons.add_circle, color: Color(0xFF65D578), size: 24),
          ]),
        )),
        const SizedBox(width: 8),
        _goldRoundButton(Icons.lightbulb_rounded, _hint,
            radius: narrow ? 21 : 24),
      ]);

  Widget _cityPlaque() => Center(
    child: OrnateTitlePlaque(
      eyebrow: '✦  Ş E H İ R   H İ K Â Y E L E R İ  ✦',
      heading: _puzzle.city.toUpperCase(),
      footer: _levelLabel(_level),
    ),
  );

  Widget _premiumBoard(double maxCellSize) {
    final cells = _puzzle.cells;
    return LayoutBuilder(builder: (context, region) {
      final size = math.min(maxCellSize, math.min(
          (region.maxWidth - 4) / _puzzle.cols,
          (region.maxHeight - 4) / _puzzle.rows)).clamp(14.0, maxCellSize).toDouble();
      return Column(mainAxisSize: MainAxisSize.min, children: [
        ...List.generate(_puzzle.rows, (row) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_puzzle.cols, (col) =>
                _premiumCell(row, col, size, cells['$row:$col'])),
            )),
      ]);
    });
  }

  Widget _premiumCell(int row, int col, double size, String? letter) {
    if (letter == null) return SizedBox(width: size, height: size);
    final solvedCell = _isSolvedCell(row, col);
    final revealed = _hintCells.contains('$row:$col') || solvedCell;
    return Container(
      width: size - 3,
      height: size - 3,
      margin: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: solvedCell
              ? const [Color(0xFF7BE791), Color(0xFF159650)]
              : revealed
                  ? const [Color(0xFFFFE19C), Color(0xFFE9A744)]
                  : const [Color(0xFFFFFEF5), Color(0xFFFFEDD1)],
        ),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFCBA26E), width: 1.1),
        boxShadow: const [
          BoxShadow(color: Color(0xAF081527), blurRadius: 5,
              offset: Offset(1, 3)),
          BoxShadow(color: Color(0x66FFFFFF), blurRadius: 2,
              offset: Offset(-1, -1)),
        ],
      ),
      child: Center(
        child: Text(revealed ? letter : '',
            style: TextStyle(color: _navy, fontWeight: FontWeight.w900,
                fontSize: size * .52)),
      ),
    );
  }

  Widget _selectionMessage() => Container(
        height: 31,
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(_selection.isEmpty ? _notice : _selection,
              key: ValueKey(_selection.isEmpty ? _notice : _selection),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _cream,
                  fontSize: _selection.isNotEmpty ? 21 : 13,
                  shadows: const [Shadow(color: Colors.black,
                      blurRadius: 8, offset: Offset(0, 2))],
                  fontWeight: FontWeight.w800)),
        ),
      );

  Widget _wheelAndActions(double wheelSize, bool narrow) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            _smallAction(Icons.shuffle_rounded, 'KARIŞTIR', _shuffle),
            const SizedBox(height: 12),
            _smallAction(Icons.stars_rounded, 'BONUS', _showBonuses),
          ]),
          _premiumWheel(wheelSize),
          Column(mainAxisSize: MainAxisSize.min, children: [
            _smallAction(Icons.lightbulb_rounded, '25 ALTIN', _hint),
            const SizedBox(height: 12),
            _smallAction(Icons.card_giftcard_rounded, 'ÖDÜL', _showRewards),
          ]),
        ],
      );

  Widget _premiumWheel(double size) => SizedBox(
        height: size,
        width: size,
        child: Stack(children: [
          RawGestureDetector(
            behavior: HitTestBehavior.opaque,
            gestures: <Type, GestureRecognizerFactory>{
              // Sayfanın kaydırma hareketinden önce tekerlek dokunmayı kazanır.
              EagerGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<EagerGestureRecognizer>(
                () => EagerGestureRecognizer(),
                (EagerGestureRecognizer instance) {},
              ),
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) => _wheelTouchDown(event, size),
              onPointerMove: (event) => _wheelTouchMove(event, size),
              onPointerUp: _wheelTouchUp,
              onPointerCancel: _wheelTouchCancel,
              child: CustomPaint(
                size: Size.square(size),
                painter: LetterWheelPainter(_wheelLetters, _dragged),
              ),
            ),
          ),
          Center(
            child: Material(
              color: _navy,
              elevation: 5,
              shape: const CircleBorder(side: BorderSide(color: _gold, width: 2.2)),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _shuffle,
                child: SizedBox(
                  width: size * .23,
                  height: size * .23,
                  child: Icon(Icons.shuffle_rounded, size: size * .12,
                      color: _gold),
                ),
              ),
            ),
          ),
        ]),
      );

  Widget _smallAction(IconData icon, String label, VoidCallback onTap) =>
      Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: _navy.withOpacity(.92),
                shape: BoxShape.circle,
                border: Border.all(color: _gold, width: 2),
                boxShadow: const [BoxShadow(color: Color(0x85000000), blurRadius: 8)],
              ),
              child: Icon(icon, color: _cream, size: 24),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(color: _navy.withOpacity(.88),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(label, textAlign: TextAlign.center,
                  style: const TextStyle(color: _cream, fontSize: 9,
                      fontWeight: FontWeight.w800)),
            ),
          ]),
        ),
      );

  Widget _goldRoundButton(IconData icon, VoidCallback action,
      {double radius = 24}) => Material(
        color: _navy.withOpacity(.94),
        shape: CircleBorder(side: const BorderSide(color: _gold, width: 1.8)),
        elevation: 5,
        child: InkWell(
          onTap: action,
          customBorder: const CircleBorder(),
          child: SizedBox(width: radius * 2, height: radius * 2,
              child: Icon(icon, size: radius * 1.07, color: _cream)),
        ),
      );

  void _showBonusAward(String word) {
    showDialog<void>(context: context, builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Stack(children: [
        PremiumPanel(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 14),
          const SizedBox(height: 110, width: double.infinity,
            child: CustomPaint(painter: V12SparklePainter())),
          const V10Ribbon(title: 'BONUS KELİME!'),
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: word.split('').map((letter) => Container(
              height: 43, width: 38,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFFFFF5DF),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: _gold, width: 1.4),
                boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 5)]),
              child: Text(letter, style: const TextStyle(color: _navy,
                fontWeight: FontWeight.w900, fontSize: 22)))).toList()),
          const SizedBox(height: 16),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.monetization_on_rounded, color: _gold, size: 32),
            Text('  +5 ALTIN', style: TextStyle(color: _gold,
              fontSize: 23, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 19),
          SizedBox(width: double.infinity,
            child: PremiumActionButton(title: 'DEVAM ET',
              onPressed: () => Navigator.pop(ctx))),
        ])),
        Positioned(top: 4, right: 5,
          child: IconButton(onPressed: () => Navigator.pop(ctx),
            icon: const Icon(Icons.close, color: _cream))),
      ]),
    ));
  }

  void _showBonuses() {
    showDialog<void>(context: context,
      builder: (ctx) => Dialog(backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 25),
        child: _goldFrame(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(alignment: Alignment.topRight,
            child: IconButton(onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close_rounded, color: _cream))),
          const Icon(Icons.stars_rounded, color: _gold, size: 72),
          const SizedBox(height: 7),
          const V10Ribbon(title: 'BONUS KELİMELER', compact: true),
          const SizedBox(height: 15),
          _statsLine('Bulduğun bonuslar', '${_bonuses.length}', Icons.auto_awesome_rounded),
          const SizedBox(height: 9),
          Text(_bonuses.isEmpty
              ? 'Farklı kelimeler oluştur, sürpriz altınlar kazan.'
              : (_bonuses.toList()..sort()).join('   ·   '),
            textAlign: TextAlign.center, style: const TextStyle(color: _cream, fontSize: 15)),
          const SizedBox(height: 18),
          const Text('Her yeni bonus kelime +5 altın kazandırır.',
              style: TextStyle(color: _gold, fontSize: 12)),
        ])),
      ));
  }


  Widget _levelDots() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_isBonusChapter(_level) ? 2 : 3, (index) {
          final localStage = _stageOf(_level) - 1;
          final realLevel = _isBonusChapter(_level) ? 18 + ((_level - 18) ~/ 2) * 2 + index
              : _provinceForLevel(_level)!.levels[index];
          final active = localStage == index;
          final locked = realLevel > _unlocked;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: locked ? null : () => _openLevel(realLevel),
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: active ? 40 : 33,
                height: active ? 40 : 33,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? _gold : _navy.withOpacity(.95),
                  border: Border.all(color: active ? Colors.white : _gold,
                      width: active ? 2.5 : 1.5),
                  boxShadow: const [BoxShadow(color: Color(0x99000000),blurRadius: 8)],
                ),
                child: locked ? const Icon(Icons.lock_outline,size: 13,color: _cream)
                  : Text('${index + 1}',style: TextStyle(
                    color: active ? _navy : _cream,
                    fontSize: 14,fontWeight: FontWeight.w900)),
              ),
            ),
          );
        }),
      );

  Widget _premiumBottomBar() => Row(children: [
        Expanded(child: _bottomButton(Icons.map_outlined, 'HARİTA', _showMap)),
        const SizedBox(width: 12),
        Expanded(child: Center(child: Text(
            '${_solved.length} / ${_puzzle.answers.length} KELİME',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _cream, fontSize: 11,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(color: Colors.black, blurRadius: 5)])))),
        const SizedBox(width: 12),
        Expanded(child: _bottomButton(Icons.auto_awesome_rounded,
            'MACERA', _showAdventureHub)),
      ]);

  Widget _bottomButton(IconData icon, String title, VoidCallback onPressed) =>
      Material(
        color: const Color(0xFF071D37),
        shadowColor: _gold.withOpacity(.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
          side: const BorderSide(color: _gold, width: 1.6),
        ),
        elevation: 3,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, color: _cream, size: 22),
              const SizedBox(height: 3),
              Text(title, style: const TextStyle(color: _cream, fontSize: 10,
                  fontWeight: FontWeight.w900)),
            ]),
          ),
        ),
      );

  Widget _nextButton() => Center(
        child: FilledButton.icon(
          onPressed: _next,
          style: FilledButton.styleFrom(
            backgroundColor: _gold,
            foregroundColor: _navy,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26))),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: Text(_level == _levels.length - 1
              ? 'OYUNU BİTİR' : (!_isBonusChapter(_level) && _stageOf(_level) == 3
                  ? 'SONRAKİ ŞEHİR' : 'SONRAKİ BÖLÜM'),
              style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
      );
}

// Şehir kartlarını bağlayan noktalı, altın renkli yol.
