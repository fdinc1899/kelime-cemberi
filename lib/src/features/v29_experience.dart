part of kelime_sehirleri;

/// V29 is additive. It never changes current_level_v3, unlocked_v3, coins,
/// chapter_schema, or any pre-existing AdventureProgress preference keys.
class V29AdventureDashboard extends StatefulWidget {
  const V29AdventureDashboard({super.key, required this.progress,
    required this.prefs, required this.completed, required this.unlocked,
    required this.coins, required this.classicCenter,
    required this.onAwardCoins, required this.onOpenLevel});

  final AdventureProgress progress;
  final SharedPreferences? prefs;
  final Set<int> completed;
  final int unlocked;
  final int coins;
  final Widget classicCenter;
  final void Function(int, String) onAwardCoins;
  final void Function(int) onOpenLevel;

  @override
  State<V29AdventureDashboard> createState() => _V29AdventureDashboardState();
}

class _V29AdventureDashboardState extends State<V29AdventureDashboard> {
  static const _navy = Color(0xFF061B34);
  static const _navyLight = Color(0xFF123655);
  static const _gold = Color(0xFFFFD473);
  static const _cream = Color(0xFFFFF6E6);
  static const _muted = Color(0xFFD6C5A6);
  static const _answers = <String>[
    'İSTANBUL', 'KAPADOKYA', 'BOĞAZ', 'DENİZ', 'YILDIZ',
    'KÜLTÜR', 'SEYAHAT', 'ANADOLU', 'TARİH', 'KALE',
    'KÖPRÜ', 'GÜNEŞ', 'ŞEHİR', 'ORMAN', 'SAHİL',
    'YOLCULUK', 'MÜZE', 'BULMACA', 'KELİME', 'KEŞİF',
    'HARİTA', 'GEZGİN', 'DOĞA', 'DENİZCİ', 'MACERA',
    'GÖKYÜZÜ', 'KERVAN', 'HİKÂYE', 'BAŞKENT', 'ANIT',
  ];

  static const _avatars = ['🧭', '🦉', '👑', '🦊', '🗺️', '⭐', '🏆', '🚀'];
  int _page = 0;
  String _avatar = '🧭';
  String _nickname = 'Şehir Gezgini';
  String _dailyClaimDate = '';
  String _eventClaimMonth = '';
  bool _loaded = false;
  bool _dailyPending = false;
  bool _seasonPending = false;
  final TextEditingController _answer = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadV29();
  }

  Future<void> _loadV29() async {
    final prefs = widget.prefs;
    if (prefs != null && mounted) {
      setState(() {
        _avatar = prefs.getString('v29_avatar') ?? '🧭';
        _nickname = prefs.getString('v29_nickname') ?? 'Şehir Gezgini';
        _dailyClaimDate = prefs.getString('v29_daily_challenge_date') ?? '';
        _eventClaimMonth = prefs.getString('v29_season_claim_month') ?? '';
        _loaded = true;
      });
    } else if (mounted) {
      setState(() => _loaded = true);
    }
  }

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  String get _today => AdventureProgress.today();
  String get _month {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}';
  }
  int get _dayIndex {
    final d = DateTime.now();
    return (DateTime.utc(d.year, d.month, d.day)
      .millisecondsSinceEpoch ~/ Duration.millisecondsPerDay) % _answers.length;
  }
  String get _dailyWord => _answers[_dayIndex];
  String get _scrambled {
    final letters = _dailyWord.split('');
    // Deterministic, readable puzzle: same answer for all sessions today.
    final random = math.Random(_dayIndex * 7103 + DateTime.now().year * 11);
    for (var n = letters.length - 1; n > 0; n--) {
      final index = random.nextInt(n + 1);
      final tmp = letters[n];
      letters[n] = letters[index];
      letters[index] = tmp;
    }
    if (letters.join() == _dailyWord && letters.length > 2) {
      final tmp = letters[0]; letters[0] = letters[1]; letters[1] = tmp;
    }
    return letters.join('  ');
  }

  Widget _panel(String title, Widget child) => Container(
    margin: const EdgeInsets.fromLTRB(12, 9, 12, 5),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xEF071E36),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _gold, width: 1.3),
      boxShadow: const [BoxShadow(color: Color(0xAA000000), blurRadius: 14)],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(title, style: const TextStyle(color: _gold, fontSize: 19,
        fontWeight: FontWeight.w900, fontFamily: 'serif')),
      const SizedBox(height: 11), child,
    ]),
  );

  Widget _button(String title, VoidCallback? action, {IconData? icon}) =>
    Padding(padding: const EdgeInsets.only(top: 8), child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: action,
        icon: Icon(icon ?? Icons.stars_rounded, size: 20),
        label: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        style: ElevatedButton.styleFrom(
          backgroundColor: action == null ? const Color(0xFF566577) : _gold,
          foregroundColor: _navy, padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    ));

  Widget _miniInfo(String title, String info, IconData icon) =>
    Container(margin: const EdgeInsets.only(bottom: 9), padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: _navyLight,
        borderRadius: BorderRadius.circular(12)),
      child: Row(children: [Icon(icon, color: _gold), const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: _cream, fontWeight: FontWeight.w800)),
          Text(info, style: const TextStyle(color: _muted, fontSize: 12)),
        ]))]));

  void _message(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _claimDailyChallenge() async {
    if (!_loaded || _dailyPending || _dailyClaimDate == _today) return;
    final guess = _answer.text.trim().toUpperCase().replaceAll(' ', '');
    if (guess != _dailyWord) {
      _message('Henüz doğru değil. Harfleri yeniden sırala.');
      return;
    }
    // Mark the prize as taken before notifying the parent / granting coins.
    setState(() => _dailyPending = true);
    await widget.prefs?.setString('v29_daily_challenge_date', _today);
    if (!mounted) return;
    setState(() { _dailyClaimDate = _today; _dailyPending = false; _answer.clear(); });
    widget.onAwardCoins(45, 'GÜNLÜK BULMACA!');
  }

  String get _seasonName {
    final m = DateTime.now().month;
    if (m == 12 || m <= 2) return 'KIŞ KEŞİF FESTİVALİ';
    if (m <= 5) return 'BAHAR YOLCULUĞU';
    if (m <= 8) return 'YAZIN ŞEHİRLERİ';
    return 'SONBAHAR MACERASI';
  }

  Future<void> _claimSeason() async {
    if (!_loaded || _seasonPending || _eventClaimMonth == _month || widget.progress.experience < 250) return;
    setState(() => _seasonPending = true);
    await widget.prefs?.setString('v29_season_claim_month', _month);
    if (!mounted) return;
    setState(() { _eventClaimMonth = _month; _seasonPending = false; });
    widget.onAwardCoins(75, 'SEZON ÖDÜLÜ!');
  }

  int get _rank {
    final s = widget.progress.weeklyScore;
    if (s >= 2400) return 4;
    if (s >= 1200) return 3;
    if (s >= 500) return 2;
    if (s >= 200) return 1;
    return 0;
  }
  String get _rankName => const ['Çırak', 'Bronz', 'Gümüş', 'Altın', 'Elmas'][_rank];
  String get _title {
    final xp = widget.progress.experience;
    if (xp >= 15000) return 'Kelime Efsanesi';
    if (xp >= 7000) return 'Şehir Ustası';
    if (xp >= 2500) return 'Usta Gezgin';
    if (xp >= 500) return 'Gezgin';
    return 'Kelime Çırağı';
  }

  void _showCityStory(ProvinceInfo province) {
    final story = adventureCityStories[province.city] ??
      v29CityFacts[province.province] ??
      '${province.province}, Türkiye’nin ${province.region} bölgesindeki şehirlerimizden biridir. ' 
      'Bölümleri tamamladıkça bu şehir için koleksiyon mührü kazanırsın.';
    showDialog<void>(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: _navy, title: Text('${province.province} · Şehir Hikâyesi',
        style: const TextStyle(color: _gold)),
      content: SingleChildScrollView(child: Text(story,
        style: const TextStyle(color: _cream))),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx),
        child: const Text('KAPAT', style: TextStyle(color: _gold)))],
    ));
  }

  Widget _todayTab() => ListView(children: [
    _panel('GÜNLÜK KELİME MEYDAN OKUMASI', Column(children: [
      const Text('Bugünün karışık kelimesini çöz · +45 altın',
        style: TextStyle(color: _cream)),
      const SizedBox(height: 12),
      Container(padding: const EdgeInsets.symmetric(vertical: 17),
        width: double.infinity, decoration: BoxDecoration(
          color: _navyLight, borderRadius: BorderRadius.circular(13)),
        child: Text(_scrambled, textAlign: TextAlign.center,
          style: const TextStyle(color: _gold, fontSize: 22,
            fontWeight: FontWeight.w900, letterSpacing: 1))),
      const SizedBox(height: 10),
      TextField(controller: _answer, enabled: _dailyClaimDate != _today,
        textCapitalization: TextCapitalization.characters,
        style: const TextStyle(color: _cream),
        decoration: InputDecoration(
          hintText: 'Kelimeyi yaz', hintStyle: const TextStyle(color: _muted),
          filled: true, fillColor: _navyLight,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      _button(_dailyClaimDate == _today ? 'BUGÜN TAMAMLANDI ✓' : 'KELİMEYİ KONTROL ET',
        _loaded && !_dailyPending && _dailyClaimDate != _today ? _claimDailyChallenge : null,
        icon: Icons.check_circle_rounded),
    ])),
    _panel(_seasonName, Column(children: [
      const Icon(Icons.celebration_rounded, color: _gold, size: 68),
      _miniInfo('Aylık özel ödül',
        '${widget.progress.experience} / 250 deneyim puanı · +75 altın',
        Icons.card_giftcard_rounded),
      _button(_eventClaimMonth == _month ? 'BU AY ALINDI ✓' : 'SEZON ÖDÜLÜNÜ AL',
        _loaded && !_seasonPending && _eventClaimMonth != _month && widget.progress.experience >= 250
          ? _claimSeason : null),
    ])),
    _panel('GÜNLÜK GÖREVLER & SÜRPRİZLER', Column(children: [
      _miniInfo('Kelime görevi', '${widget.progress.dailyWords} kelime bulundu', Icons.abc),
      _miniInfo('Bonus avı', '${widget.progress.dailyBonuses} bonus kelime bulundu', Icons.star),
      _miniInfo('Tamamlanan bölüm', '${widget.progress.dailyLevels} bölüm', Icons.flag),
      const Text('Günlük görev ödülleri, çark ve sandıklar Ödüller sekmesinde.',
        style: TextStyle(color: _muted, fontSize: 12)),
    ])),
  ]);

  Widget _atlasTab() => Column(children: [
    _panel('TÜRKİYE KOLEKSİYONU · 81 İL', Column(children: [
      _miniInfo('Pasaport mühürleri', '${_cityCompletedCount()} / 81 şehir tamamlandı',
        Icons.workspace_premium_rounded),
      ClipRRect(borderRadius: BorderRadius.circular(12),
        child: LinearProgressIndicator(value: _cityCompletedCount() / 81,
          minHeight: 10, backgroundColor: _navyLight,
          valueColor: const AlwaysStoppedAnimation<Color>(_gold))),
      const SizedBox(height: 6),
      const Text('Her şehrin 3 bölümünü bitir, manzarasını ve altın mührünü koleksiyonuna ekle.',
        style: TextStyle(color: _muted, fontSize: 12)),
    ])),
    Expanded(child: GridView.builder(
      padding: const EdgeInsets.all(10), itemCount: _provinces.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: .88, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemBuilder: (ctx, index) {
        final p = _provinces[index];
        final done = p.levels.where(widget.completed.contains).length;
        final unlocked = _cityOpen(p, widget.unlocked);
        return InkWell(onTap: () => _showCityStory(p), child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
            border: Border.all(color: done == 3 ? _gold : const Color(0xFF667080)),
            color: _navy),
          clipBehavior: Clip.antiAlias, child: Column(children: [
            Expanded(child: Stack(fit: StackFit.expand, children: [
              Image(image: _citySelectionImageProvider(p), fit: BoxFit.cover),
              if (!unlocked) Container(color: const Color(0x77000000)),
              if (done == 3) const Align(alignment: Alignment.topRight,
                child: Padding(padding: EdgeInsets.all(6), child: Icon(
                  Icons.workspace_premium_rounded, color: _gold, size: 33))),
            ])),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              child: Column(children: [
                Text(p.province, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _cream, fontWeight: FontWeight.w800)),
                Text('$done / 3 · ${done == 3 ? 'MÜHÜRLENDİ' : unlocked ? 'KEŞFET' : 'KİLİTLİ'}',
                  style: const TextStyle(color: _gold, fontSize: 10)),
              ])),
          ])),
        );
      },
    )),
  ]);

  int _cityCompletedCount() => _provinces.where(
    (p) => p.levels.every(widget.completed.contains)).length;

  Widget _routeTab() => Column(children: [
    _panel('ALTIN ROTA · TÜRKİYE TURU', Column(children: [
      _miniInfo('Ana bölümler', '${_mainDone(widget.completed)} / 243', Icons.route_rounded),
      _miniInfo('Toplam yıldız', '${widget.progress.totalStars} ★', Icons.stars_rounded),
      const Text('Şehri tamamladıkça sonraki şehre ilerle. Açık şehir kartına dokunup oynamaya devam et.',
        style: TextStyle(color: _muted, fontSize: 12)),
    ])),
    Expanded(child: ListView.builder(itemCount: _provinces.length,
      itemBuilder: (ctx, index) {
        final p = _provinces[index];
        final done = p.levels.where(widget.completed.contains).length;
        final active = _cityOpen(p, widget.unlocked);
        final next = p.levels.firstWhere((i) => i <= widget.unlocked &&
          !widget.completed.contains(i), orElse: () => p.levels.first);
        return Column(children: [
          Container(margin: const EdgeInsets.fromLTRB(12, 2, 12, 2),
            decoration: BoxDecoration(color: _navy,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _gold)),
            child: ListTile(
              onTap: active ? () => widget.onOpenLevel(next) : null,
              leading: SizedBox(width: 65, height: 52, child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(image: _citySelectionImageProvider(p), fit: BoxFit.cover))),
              title: Text('${index + 1}. ${p.province}', style:
                const TextStyle(color: _cream, fontWeight: FontWeight.w800)),
              subtitle: Text('$done/3 bölüm · ${done == 3 ? '★★★' : '☆☆☆'}',
                style: const TextStyle(color: _gold)),
              trailing: Icon(active ? Icons.chevron_right : Icons.lock,
                color: _gold),
            ),
          ),
          if (index < _provinces.length - 1) SizedBox(height: 19,
            child: CustomPaint(size: const Size(60, 19), painter:
              _ShortProvinceRoadPainter(leftToRight: index.isEven,
                open: _cityOpen(_provinces[index + 1], widget.unlocked)))),
        ]);
      })),
  ]);

  Widget _leagueTab() {
    final names = ['Çırak', 'Bronz', 'Gümüş', 'Altın', 'Elmas'];
    final limits = [0, 200, 500, 1200, 2400];
    return ListView(children: [
      _panel('HAFTALIK YEREL LİG', Column(children: [
        const Icon(Icons.emoji_events_rounded, color: _gold, size: 68),
        Text(_rankName.toUpperCase(), style: const TextStyle(
          color: _gold, fontSize: 23, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text('Bu haftaki puanın: ${widget.progress.weeklyScore}',
          style: const TextStyle(color: _cream)),
        const SizedBox(height: 10),
        for (var i = 0; i < names.length; i++) _miniInfo(
          names[i], '${limits[i]} puan eşiği',
          i <= _rank ? Icons.check_circle_rounded : Icons.lock_outline),
        const Text('Bu bir çevrimdışı puan ligi. Gerçek oyuncu sıralaması, '
          'sunucu veya para ödülü içermez. Haftalık puanlar pazartesi sıfırlanır.',
          style: TextStyle(color: _muted, fontSize: 12)),
      ])),
      _panel('YARDIMCI GÜÇLER', Column(children: [
        _miniInfo('İlk harfi aç', '15 altın · oyun ekranından veya Ödüller sekmesinden',
          Icons.lightbulb_outline),
        _miniInfo('Tüm kelimeyi aç', '80 altın · Ödüller sekmesinden', Icons.auto_fix_high),
        _miniInfo('Karıştır', 'Ücretsiz harf karıştırma', Icons.shuffle),
        _miniInfo('Sürpriz sandık', '${widget.progress.unopenedChests} sandığın var',
          Icons.inventory_2_rounded),
        _button('ÇARK / SANDIK / GÜÇLER', () => setState(() => _page = 4),
          icon: Icons.casino_rounded),
      ])),
    ]);
  }

  Future<void> _pickAvatar(String avatar) async {
    await widget.prefs?.setString('v29_avatar', avatar);
    if (mounted) setState(() => _avatar = avatar);
  }
  Future<void> _editName() async {
    var proposedName = _nickname;
    final name = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: _navy,
      title: const Text('Oyuncu adını seç', style: TextStyle(color: _gold)),
      content: TextFormField(initialValue: _nickname, maxLength: 22,
        onChanged: (value) => proposedName = value,
        style: const TextStyle(color: _cream),
        decoration: const InputDecoration(hintText: 'Takma ad')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('VAZGEÇ')),
        TextButton(onPressed: () => Navigator.pop(ctx, proposedName.trim()),
          child: const Text('KAYDET')),
      ],
    ));
    if (name == null || name.isEmpty) return;
    await widget.prefs?.setString('v29_nickname', name);
    if (mounted) setState(() => _nickname = name);
  }

  Widget _profileTab() => ListView(children: [
    _panel('OYUNCU PROFİLİ', Column(children: [
      Text(_avatar, textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 72)),
      Text(_nickname, textAlign: TextAlign.center,
        style: const TextStyle(color: _cream, fontSize: 21, fontWeight: FontWeight.w900)),
      Text(_title, textAlign: TextAlign.center,
        style: const TextStyle(color: _gold, fontSize: 17)),
      _button('İSMİ DEĞİŞTİR', _editName, icon: Icons.edit_rounded),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: [for (final a in _avatars)
        InkWell(onTap: () => _pickAvatar(a), child: Container(
          width: 57, height: 57, alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _navyLight, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: a == _avatar ? _gold : Colors.white24,
              width: a == _avatar ? 2.5 : 1)),
          child: Text(a, style: const TextStyle(fontSize: 29))))]),
      const SizedBox(height: 12),
      _miniInfo('Deneyim', '${widget.progress.experience} XP', Icons.bolt_rounded),
      _miniInfo('Altın', '${widget.coins}', Icons.monetization_on_rounded),
      _miniInfo('Tamamlanan il', '${_cityCompletedCount()} / 81', Icons.map_rounded),
      _miniInfo('Toplam yıldız', '${widget.progress.totalStars}', Icons.star_rounded),
      const Text('Oyuncu adı ve avatar bu cihazda saklanır. Şifre veya hesap gerektirmez.',
        style: TextStyle(color: _muted, fontSize: 12)),
    ])),
  ]);

  @override
  Widget build(BuildContext context) {
    final titles = ['GÜNLÜK', 'PASAPORT', 'YOLCULUK', 'LİG', 'ÖDÜLLER', 'PROFİL'];
    final icons = [Icons.today_rounded, Icons.collections_bookmark_rounded,
      Icons.route_rounded, Icons.emoji_events_rounded,
      Icons.card_giftcard_rounded, Icons.account_circle_rounded];
    final views = <Widget>[
      _todayTab(), _atlasTab(), _routeTab(), _leagueTab(),
      widget.classicCenter, _profileTab(),
    ];
    return Column(children: [
      SizedBox(height: 55, child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: titles.length, padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (ctx, i) => Padding(padding: const EdgeInsets.all(4),
          child: ChoiceChip(
            selected: _page == i, onSelected: (_) => setState(() => _page = i),
            label: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icons[i], size: 16,
                color: _page == i ? _navy : _gold),
              const SizedBox(width: 4), Text(titles[i]),
            ]),
            labelStyle: TextStyle(fontSize: 11,
              fontWeight: FontWeight.w900,
              color: _page == i ? _navy : _cream),
            selectedColor: _gold, backgroundColor: _navyLight,
            side: const BorderSide(color: _gold),
          )),
      )),
      Expanded(child: KeyedSubtree(key: ValueKey<int>(_page), child: views[_page])),
    ]);
  }
}

/// The original V15 daily wheel now has a visible spin before claiming once.
class V29SpinDialog extends StatefulWidget {
  const V29SpinDialog({super.key, required this.onComplete});
  final VoidCallback onComplete;

  @override
  State<V29SpinDialog> createState() => _V29SpinDialogState();
}

class _V29SpinDialogState extends State<V29SpinDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(vsync: this,
      duration: const Duration(milliseconds: 1750))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted && !_completed) {
          _completed = true;
          Navigator.of(context).pop();
          widget.onComplete(); // V15 persisted daily spin and applies reward.
        }
      });
    _spin.forward();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: const Color(0xFF071B33),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22),
      side: const BorderSide(color: Color(0xFFFFD473), width: 2)),
    child: Padding(padding: const EdgeInsets.all(22),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('GÜNLÜK ŞANS ÇARKI', style: TextStyle(
          color: Color(0xFFFFD473), fontSize: 21,
          fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        AnimatedBuilder(animation: _spin, builder: (context, child) =>
          Transform.rotate(angle: _spin.value * math.pi * 10,
            child: child),
          child: Container(width: 175, height: 175,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: const SweepGradient(colors: [Color(0xFFFFD473),
                Color(0xFFCA8125), Color(0xFFFFF0AB), Color(0xFF173D63),
                Color(0xFFFFD473)]),
              border: Border.all(color: Colors.white, width: 3)),
            child: const Icon(Icons.casino_rounded,
              color: Color(0xFF08223C), size: 90))),
        const SizedBox(height: 16),
        const Text('Ödülün belirleniyor…',
          style: TextStyle(color: Color(0xFFFFF6E6))),
        TextButton(onPressed: () => Navigator.pop(context),
          child: const Text('İPTAL', style: TextStyle(color: Color(0xFFFFD473)))),
      ])),
  );
}

/// Brief offline travel notes. Full-city passport UI covers all 81 provinces;
/// unknown attractions are deliberately not invented.
const Map<String, String> v29CityFacts = {
  'Edirne': 'Selimiye Camii, Edirne’nin en tanınmış tarihî yapılarındandır.',
  'Kırklareli': 'Dupnisa Mağarası ve İğneada longozları Kırklareli’nin doğal duraklarıdır.',
  'Tekirdağ': 'Tekirdağ, Marmara Denizi kıyısındaki tarihî Trakya kentlerindendir.',
  'Çanakkale': 'Troya Antik Kenti ve Gelibolu Yarımadası Çanakkale’nin tarihî duraklarıdır.',
  'Balıkesir': 'Ayvalık kıyıları ve Kazdağları Balıkesir’in gezilecek yerlerindendir.',
  'Bursa': 'Uludağ ve tarihî Osmanlı külliyeleri Bursa’nın simgelerindendir.',
  'Yalova': 'Yalova, Marmara kıyıları ve termal kaynaklarıyla tanınır.',
  'Kocaeli': 'İzmit Körfezi, Kocaeli’nin coğrafyasındaki önemli oluşumlardandır.',
  'Sakarya': 'Sapanca Gölü, Sakarya çevresinin tanınmış doğal duraklarındandır.',
  'Bilecik': 'Söğüt, Osmanlı tarihinin erken dönemleriyle ilişkilendirilen yerleşimlerdendir.',
  'Aydın': 'Afrodisias Antik Kenti, Aydın’ın önemli tarihî alanlarındandır.',
  'Muğla': 'Bodrum ve Fethiye kıyıları, Muğla’nın en tanınan turizm bölgelerindendir.',
  'Denizli': 'Pamukkale travertenleri ve Hierapolis Antik Kenti Denizli’dedir.',
  'Manisa': 'Spil Dağı, Manisa’nın doğal simgelerinden biridir.',
  'Uşak': 'Ulubey Kanyonu, Uşak’ın dikkat çeken doğa alanlarındandır.',
  'Kütahya': 'Kütahya, çini sanatının köklü merkezlerindendir.',
  'Afyonkarahisar': 'Afyonkarahisar Kalesi şehrin üzerinde yükselen tarihî bir yapıdır.',
  'Isparta': 'Eğirdir Gölü ve lavanta tarlaları Isparta ile özdeşleşen manzaralardandır.',
  'Burdur': 'Salda Gölü, Burdur’un en çok bilinen doğal güzelliklerindendir.',
  'Mersin': 'Kızkalesi, Mersin kıyılarındaki tarihî yapılardan biridir.',
  'Adana': 'Taşköprü, Adana’nın Seyhan Nehri üzerindeki tarihî simgesidir.',
  'Osmaniye': 'Karatepe-Aslantaş, Osmaniye’de yer alan tarihî alanlardan biridir.',
  'Hatay': 'Hatay, farklı kültürlerin izlerini taşıyan Antakya ve çevresiyle tanınır.',
  'Kahramanmaraş': 'Kahramanmaraş dondurması ve tarihî çarşılarıyla bilinir.',
  'Konya': 'Mevlânâ Müzesi ve Selçuklu eserleri Konya’nın kültürel mirasıdır.',
  'Karaman': 'Karaman Kalesi şehir merkezindeki tarihî yapılardan biridir.',
  'Aksaray': 'Ihlara Vadisi, Aksaray yakınındaki önemli doğal ve tarihî rotalardandır.',
  'Niğde': 'Aladağlar, Niğde çevresindeki dağ turizminin önemli adreslerindendir.',
  'Kırşehir': 'Kırşehir, âşıklık kültürü ve Cacabey Medresesi ile tanınır.',
  'Kırıkkale': 'Çeşnigir Köprüsü, Kırıkkale’de Kızılırmak üzerinde yer alır.',
  'Çankırı': 'Çankırı’nın tuz mağarası bölgenin ilginç jeolojik duraklarındandır.',
  'Yozgat': 'Yozgat Çamlığı Millî Parkı, şehrin doğal alanlarındandır.',
  'Kayseri': 'Erciyes Dağı, Kayseri siluetinin en belirgin simgesidir.',
  'Sivas': 'Divriği Ulu Camii ve Darüşşifası, Sivas’ın önemli tarihî mirasıdır.',
  'Eskişehir': 'Porsuk Çayı ve Odunpazarı evleri Eskişehir’in tanınmış duraklarıdır.',
  'Bolu': 'Abant Gölü, Bolu’nun tanınmış doğal güzelliklerindendir.',
  'Düzce': 'Akçakoca kıyıları ve şelaleler Düzce çevresindeki doğal rotalardandır.',
  'Zonguldak': 'Zonguldak, taş kömürü madenciliği tarihiyle bilinir.',
  'Bartın': 'Amasra, Bartın’ın tarihî kıyı yerleşimlerinden biridir.',
  'Karabük': 'Safranbolu’nun tarihî evleri, Karabük ilindeki kültürel mirastandır.',
  'Kastamonu': 'Kastamonu Kalesi ve tarihî konaklar şehrin simgelerindendir.',
  'Sinop': 'İnceburun, Türkiye’nin kuzeydeki uç noktasıdır.',
  'Samsun': 'Samsun, Millî Mücadele tarihindeki rolüyle öne çıkar.',
  'Ordu': 'Boztepe’den Ordu kentini ve Karadeniz kıyılarını izlemek mümkündür.',
  'Giresun': 'Giresun Adası, Karadeniz’in kıyıya yakın tarihî adalarındandır.',
  'Trabzon': 'Sümela Manastırı, Trabzon’un Maçka ilçesi yakınlarındadır.',
  'Rize': 'Rize, çay bahçeleri ve Kaçkar Dağları’yla tanınır.',
  'Artvin': 'Karagöl ve yaylalar Artvin’in doğal manzaraları arasındadır.',
  'Gümüşhane': 'Karaca Mağarası, Gümüşhane’nin doğal duraklarından biridir.',
  'Bayburt': 'Bayburt Kalesi, kentin simgelerinden biridir.',
  'Tokat': 'Tokat, Ballıca Mağarası ve tarihî şehir dokusuyla tanınır.',
  'Amasya': 'Yeşilırmak kıyısındaki Yalıboyu evleri Amasya’nın simgesidir.',
  'Çorum': 'Hattuşa Antik Kenti, Çorum’un Boğazkale ilçesindedir.',
  'Erzincan': 'Girlevik Şelalesi, Erzincan yakınındaki doğal duraklardandır.',
  'Erzurum': 'Çifte Minareli Medrese, Erzurum’daki Selçuklu dönemi mirasıdır.',
  'Ağrı': 'İshak Paşa Sarayı, Doğubayazıt yakınındaki tarihî bir yapıdır.',
  'Iğdır': 'Iğdır, Ağrı Dağı’nın çevresindeki geniş ova manzaralarıyla tanınır.',
  'Kars': 'Ani Ören Yeri, Kars’ın en önemli tarihî alanlarındandır.',
  'Ardahan': 'Çıldır Gölü, Ardahan çevresinin bilinen doğal duraklarındandır.',
  'Malatya': 'Malatya, kayısısıyla tanınan şehirlerimizdendir.',
  'Elazığ': 'Harput, Elazığ’ın tarihî yerleşimlerinden biridir.',
  'Tunceli': 'Munzur Vadisi Millî Parkı, Tunceli’deki doğal koruma alanlarından biridir.',
  'Bingöl': 'Yüzen Adalar, Bingöl’ün Solhan ilçesindeki doğal oluşumlardandır.',
  'Muş': 'Muş Ovası, lale çiçeklenmesiyle tanınır.',
  'Bitlis': 'Nemrut Krater Gölü, Bitlis ilinin doğal güzelliklerindendir.',
  'Van': 'Akdamar Kilisesi, Van Gölü’ndeki Akdamar Adası’ndadır.',
  'Hakkâri': 'Cilo Dağları, Hakkâri’nin yüksek dağlık manzaralarındandır.',
  'Diyarbakır': 'Diyarbakır Surları ve Hevsel Bahçeleri kentin tarihî mirasıdır.',
  'Şanlıurfa': 'Göbeklitepe, Şanlıurfa yakınında yer alan önemli arkeolojik alandır.',
  'Gaziantep': 'Zeugma Mozaik Müzesi, Gaziantep’in öne çıkan kültür duraklarındandır.',
  'Kilis': 'Kilis, taş mimarisi ve tarihî sokaklarıyla tanınır.',
  'Adıyaman': 'Nemrut Dağı’ndaki heykeller, Adıyaman’ın simgesidir.',
  'Batman': 'Hasankeyf, Batman’ın Dicle kıyısındaki tarihî yerleşimidir.',
  'Siirt': 'Tillo, Siirt çevresinde tarihî ve kültürel önemi olan bir yerleşimdir.',
  'Şırnak': 'Cudi Dağı, Şırnak’ın coğrafyasındaki önemli yükseltilerdendir.',
};
