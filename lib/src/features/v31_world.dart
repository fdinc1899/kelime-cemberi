part of kelime_sehirleri;

// V31 is strictly additive: legacy V3 keys and all 255 stage IDs stay fixed.
const Color _v31Navy = Color(0xFF081C35);
const Color _v31Gold = Color(0xFFFFD479);
const Color _v31Cream = Color(0xFFFFF6E7);

const List<String> _v31WordBank = <String>[
  'KELİME','ÇEMBER','DENİZ','KALEM','KİTAP','SEYAHAT','GEZGİN','GÜNEŞ',
  'YILDIZ','BULUT','ORMAN','KÖPRÜ','BAHAR','KUMSAL','MÜZE','KALE',
  'TARİH','SANAT','HARİTA','BULMACA','MACERA','DOĞA','GÖKYÜZÜ','GÖL',
  'KULE','GÜL','ÇİÇEK','ÇINAR','SOKAK','BAHÇE','KERVAN','ANIT',
  'KEŞİF','YOLCULUK','KÜLTÜR','MASAL','ŞEHİR','DÜNYA','IŞIK','ZAFER',
  'KİRAZ','ELMA','ÇİLEK','PENCERE','ARABA','NEHİR','OVALAR','YAMAÇ',
];

// 81 cities x 13 optional challenges = 1053 additional playable tasks.
// Stage identity is unique; words intentionally recur (not 1053 unique words).
const int v31ChallengesPerCity = 13;
const int v31ChallengeCount = 81 * v31ChallengesPerCity;
String v31ChallengeAnswer(int index) =>
    _v31WordBank[((index ~/ 13) * 17 + (index % 13) * 7) % _v31WordBank.length];
String v31TurkishUpper(String s) => s.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();
String v31Scramble(int index) {
  final letters = v31ChallengeAnswer(index).split('');
  final random = math.Random(77029 + index * 911);
  for (var i = letters.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    final old = letters[i]; letters[i] = letters[j]; letters[j] = old;
  }
  if (letters.join() == v31ChallengeAnswer(index)) {
    final old = letters[0]; letters[0] = letters[1]; letters[1] = old;
  }
  return letters.join('  ');
}

String v31RegionTrack(String region) {
  if (region == 'Marmara') return 'audio/v31_marmara.mp3';
  if (region == 'Ege') return 'audio/v31_ege.mp3';
  if (region == 'Akdeniz') return 'audio/v31_akdeniz.mp3';
  if (region == 'İç Anadolu') return 'audio/v31_icanadolu.mp3';
  if (region == 'Karadeniz') return 'audio/v31_karadeniz.mp3';
  if (region == 'Doğu Anadolu') return 'audio/v31_doguanadolu.mp3';
  return 'audio/v31_guneydogu.mp3';
}

// Subtle parallax breathing on city art, with a persistent night mode.
class V31LivingBackdrop extends StatefulWidget {
  const V31LivingBackdrop({super.key, required this.child, required this.night});
  final Widget child;
  final bool night;
  @override
  State<V31LivingBackdrop> createState() => _V31LivingBackdropState();
}
class _V31LivingBackdropState extends State<V31LivingBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(vsync: this,
    duration: const Duration(seconds: 13))..repeat(reverse: true);
  @override void dispose() { _motion.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => ClipRect(child: Stack(
    fit: StackFit.expand, children: [
      AnimatedBuilder(animation: _motion, child: widget.child,
        builder: (context, child) => Transform.scale(
          scale: 1.018 + _motion.value * .035, child: child)),
      IgnorePointer(child: AnimatedContainer(duration: const Duration(milliseconds: 550),
        color: widget.night ? const Color(0x99020D2C) : Colors.transparent)),
      if (widget.night) const IgnorePointer(child: Align(
        alignment: Alignment(.75, -.81), child: Icon(Icons.nightlight_round,
        color: Color(0xCCFFF0B2), size: 25))),
    ],
  ));
}

class V31WorldCenter extends StatefulWidget {
  const V31WorldCenter({super.key, required this.prefs, required this.completed,
    required this.unlocked, required this.coins, required this.night,
    required this.regionMusic, required this.onTheme, required this.onMusic,
    required this.onReward, required this.onOpenLevel, required this.onRestore});
  final SharedPreferences? prefs;
  final Set<int> completed;
  final int unlocked;
  final int coins;
  final bool night;
  final bool regionMusic;
  final ValueChanged<bool> onTheme;
  final ValueChanged<bool> onMusic;
  final void Function(int, String) onReward;
  final void Function(int) onOpenLevel;
  final VoidCallback onRestore;
  @override State<V31WorldCenter> createState() => _V31WorldCenterState();
}

class _V31WorldCenterState extends State<V31WorldCenter> {
  int _tab = 0;
  int _cityIndex = 0;
  int _challengeSlot = 0;
  bool _busy = false;
  Set<int> _marathonDone = <int>{};
  Set<int> _treasures = <int>{};
  final TextEditingController _answer = TextEditingController();
  final TextEditingController _importText = TextEditingController();

  @override void initState() { super.initState(); _reloadLocal(); }
  void _reloadLocal() {
    _marathonDone = widget.prefs?.getStringList('v31_marathon_done')
      ?.map(int.tryParse).whereType<int>().where((n) => n >= 0 && n < v31ChallengeCount).toSet() ?? <int>{};
    _treasures = widget.prefs?.getStringList('v31_treasure_claimed')
      ?.map(int.tryParse).whereType<int>().where((n) => n >= 0 && n < 81).toSet() ?? <int>{};
  }
  @override void dispose() { _answer.dispose(); _importText.dispose(); super.dispose(); }
  void _notice(String message) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  Widget _panel(String title, Widget child) => Container(
    margin: const EdgeInsets.fromLTRB(10, 9, 10, 7), padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: const Color(0xF2081D36),
      border: Border.all(color: _v31Gold, width: 1.2),
      borderRadius: BorderRadius.circular(18)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(title, style: const TextStyle(fontFamily: 'serif', color: _v31Gold,
        fontSize: 18, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10), child,
    ]));
  Widget _text(String text, {Color color = _v31Cream, double size = 14}) => Text(text,
    style: TextStyle(color: color, fontSize: size));
  Widget _action(String label, VoidCallback? onPressed, {IconData icon = Icons.auto_awesome}) =>
    Padding(padding: const EdgeInsets.only(top: 9), child: ElevatedButton.icon(
      icon: Icon(icon, size: 18), label: Text(label, textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(backgroundColor: _v31Gold,
        foregroundColor: _v31Navy, disabledBackgroundColor: Colors.blueGrey,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
      onPressed: onPressed));
  Widget _cityPicture(ProvinceInfo city, {double height=125}) => ClipRRect(
    borderRadius: BorderRadius.circular(14), child: SizedBox(height: height,
      width: double.infinity, child: Stack(fit: StackFit.expand, children: [
        Image(image: _citySelectionImageProvider(city), fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const ColoredBox(color: _v31Navy,
            child: Icon(Icons.landscape, color: _v31Gold, size: 48))),
        const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color(0x99020D20)]))),
      ])));
  Widget _cityPicker() => SizedBox(height: 49, child: ListView.builder(
    scrollDirection: Axis.horizontal, itemCount: 81,
    itemBuilder: (context, i) => Padding(padding: const EdgeInsets.only(right: 7),
      child: ChoiceChip(label: Text('${i + 1} · ${_provinces[i].province}'),
        selected: _cityIndex == i, selectedColor: _v31Gold,
        onSelected: (_) { _answer.clear(); setState(() { _cityIndex = i; _challengeSlot = 0; }); }))));

  int get _challengeIndex => _cityIndex * 13 + _challengeSlot;
  Future<void> _solve() async {
    if (_busy || _marathonDone.contains(_challengeIndex)) return;
    final entered = v31TurkishUpper(_answer.text.trim()).replaceAll(' ', '');
    if (entered != v31ChallengeAnswer(_challengeIndex)) {
      _notice('Kelime henüz doğru değil. Tekrar dene.');
      return;
    }
    final id = _challengeIndex;
    setState(() => _busy = true);
    final newSet = <int>{..._marathonDone, id};
    final ok = await widget.prefs?.setStringList('v31_marathon_done',
      (newSet.toList()..sort()).map((e) => '$e').toList());
    if (ok == false || widget.prefs == null) {
      if (mounted) { setState(() => _busy = false); _notice('Kayıt yapılamadı; ödül verilmedi.'); }
      return;
    }
    if (!mounted) return;
    setState(() { _marathonDone = newSet; _busy = false; _answer.clear(); });
    widget.onReward(3, 'MARATON +3');
    _notice('Tebrikler! Görev tamamlandı.');
  }

  Widget _challengeView() {
    final doneForCity = List.generate(13, (k) => _cityIndex * 13 + k)
      .where(_marathonDone.contains).length;
    return ListView(children: [
      _panel('1053 EK KELİME GÖREVİ', Column(children: [
        _text('${_marathonDone.length} / $v31ChallengeCount tamamlandı · Her görev +3 altın'),
        const SizedBox(height: 10), _cityPicker(), const SizedBox(height: 10),
        _cityPicture(_provinces[_cityIndex]),
        const SizedBox(height: 7), _text('Bu şehirde: $doneForCity / 13', color: _v31Gold),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: List.generate(13, (i) {
          final solved = _marathonDone.contains(_cityIndex * 13 + i);
          return ChoiceChip(label: Text('${i+1}${solved ? ' ✓' : ''}'),
            selected: _challengeSlot == i,
            selectedColor: _v31Gold,
            onSelected: (_) { _answer.clear(); setState(() => _challengeSlot = i); });
        })),
        const SizedBox(height: 13),
        Text(v31Scramble(_challengeIndex), textAlign: TextAlign.center,
          style: const TextStyle(color: _v31Gold, fontSize: 24,
            fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 7),
        _text('${v31ChallengeAnswer(_challengeIndex).length} harf · '
          'Kolay / Orta / Zor görev serisi', color: Colors.white70),
        const SizedBox(height: 7),
        TextField(controller: _answer, enabled: !_marathonDone.contains(_challengeIndex),
          textCapitalization: TextCapitalization.characters,
          style: const TextStyle(color: _v31Cream),
          decoration: const InputDecoration(labelText: 'Bulduğun kelime',
            labelStyle: TextStyle(color: _v31Gold),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: _v31Gold)),
            border: OutlineInputBorder())),
        _action(_marathonDone.contains(_challengeIndex) ? 'TAMAMLANDI ✓' : 'KELİMEYİ KONTROL ET',
          _marathonDone.contains(_challengeIndex) || _busy ? null : _solve,
          icon: Icons.spellcheck),
        _action('BİR SONRAKİ GÖREV', () => setState(() {
          if (_challengeSlot < 12) { _challengeSlot++; }
          else { _challengeSlot = 0; _cityIndex = (_cityIndex + 1) % 81; }
          _answer.clear();
        }), icon: Icons.arrow_forward),
        const SizedBox(height: 7),
        _text('Bu 1053 aşama, şehir başına 13 kayıtlı kelime görevidir. '
          'Kelime havuzu bilinçli olarak yeniden kullanılır; 1053 farklı kelime değildir.',
          size: 11, color: Colors.white70),
      ])),
    ]);
  }

  Future<void> _claimTreasure() async {
    if (_busy || _treasures.contains(_cityIndex)) return;
    final p = _provinces[_cityIndex];
    if (!p.levels.every(widget.completed.contains)) return;
    setState(() => _busy = true);
    final updated = <int>{..._treasures, _cityIndex};
    final ok = await widget.prefs?.setStringList('v31_treasure_claimed',
      (updated.toList()..sort()).map((i) => '$i').toList());
    if (ok == false || widget.prefs == null) {
      if (mounted) { setState(() => _busy = false); _notice('Kayıt yapılamadı.'); }
      return;
    }
    if (!mounted) return;
    setState(() { _treasures = updated; _busy = false; });
    widget.onReward(25, '${p.province.toUpperCase()} HAZİNESİ');
  }

  Widget _memoriesView() {
    final p = _provinces[_cityIndex];
    final count = p.levels.where(widget.completed.contains).length;
    final collected = _treasures.contains(_cityIndex);
    return ListView(children: [
      _panel('81 İL · HATIRA ALBÜMÜ', Column(children: [
        _text('Şehirdeki 3 ana bölümü bitirince şehir hatırasını ve 25 altını kazan.',
          color: Colors.white70, size: 12),
        const SizedBox(height: 12), _cityPicker(), const SizedBox(height: 13),
        _cityPicture(p, height: 195),
        const SizedBox(height: 10),
        Text(p.title, style: const TextStyle(color: _v31Gold, fontSize: 22,
          fontWeight: FontWeight.w900)),
        _text('$count / 3 bölüm · ${collected ? 'Hazine alındı' : 'Keşfedilecek'}'),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8), child: Icon(
              i < count ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _v31Gold, size: 36)))),
        const SizedBox(height: 12),
        _text(v29CityFacts[p.province] ??
          '${p.province}, ${p.region} bölgesinde keşfedilmeyi bekliyor.'),
        _action(collected ? 'HATIRA KOLEKSİYONDA ✓' :
          'ŞEHİR HAZİNESİNİ AL · +25 ALTIN',
          count == 3 && !collected && !_busy ? _claimTreasure : null,
          icon: Icons.card_giftcard),
        _action('ŞEHRİN AÇIK BÖLÜMÜNE GİT',
          p.start <= widget.unlocked ? () => widget.onOpenLevel(p.levels.firstWhere(
            (id) => id <= widget.unlocked && !widget.completed.contains(id),
            orElse: () => p.start)) : null, icon: Icons.map),
        const SizedBox(height: 8),
        _text('Toplanan hatıralar: ${_treasures.length} / 81', color: _v31Gold),
      ])),
    ]);
  }

  Widget _visualsView() => ListView(children: [
    _panel('SİNEMATİK GÖRÜNÜM', Column(children: [
      const Icon(Icons.movie_filter, color: _v31Gold, size: 52),
      _text('Manzaralarda yavaş kamera hareketi. Gece modu seçiliyse '
        'karanlık gökyüzü efekti uygulanır.'),
      SwitchListTile(value: widget.night, onChanged: widget.onTheme,
        title: const Text('Gece manzarası', style: TextStyle(color: _v31Cream)),
        activeThumbColor: _v31Gold, secondary: const Icon(Icons.nightlight,
          color: _v31Gold)),
      const SizedBox(height: 12),
      V31LivingBackdrop(night: widget.night,
        child: _cityPicture(_provinces[_cityIndex], height: 165)),
      const SizedBox(height: 14), _cityPicker(),
      const SizedBox(height: 10),
      _text('Şehir geçişleri ve renk efektleri animasyonludur. '
        'Önceden kullanılan fotoğraf ve illüstrasyonlar korunmuştur; '
        '81 şehir için yeni gerçek HD fotoğraflar içermez.',
        size: 12, color: Colors.white70),
    ])),
    _panel('BÖLGEYE ÖZEL MÜZİK', Column(children: [
      _text('7 bölge için 7 özgün enstrümantal döngü. V30 ana müzik varsayılan olarak kalır.'),
      SwitchListTile(value: widget.regionMusic, onChanged: widget.onMusic,
        title: const Text('Şehre göre müzik çal', style: TextStyle(color: _v31Cream)),
        subtitle: _text('Müzik kapalıysa bu seçenek de ses çalmaz', size: 11),
        activeThumbColor: _v31Gold, secondary: const Icon(Icons.music_note,
          color: _v31Gold)),
    ])),
  ]);

  // Restrict backups to this game's progress and V29/V31 features.
  bool _allowedKey(String key) => key == 'coins' || key == 'gift_date' ||
    key == 'chapter_schema' || key == 'current_level_v3' ||
    key == 'unlocked_v3' || key == 'finished_levels_v3' ||
    key.startsWith('solved_v3_') || key.startsWith('bonuses_v3_') ||
    key.startsWith('hints_v3_') || key.startsWith('adv15_') ||
    key.startsWith('v29_') || key.startsWith('v31_');
  int _check(String data) => data.codeUnits.fold<int>(2166136261,
    (sum, unit) => ((sum ^ unit) * 16777619) & 0xFFFFFFFF);
  Future<void> _exportBackup() async {
    final prefs = widget.prefs;
    if (prefs == null) return;
    final data = <String, Object>{};
    for (final k in prefs.getKeys()) {
      if (!_allowedKey(k)) continue;
      final val = prefs.get(k);
      if (val is int || val is String || val is bool || val is double) {
        data[k] = val;
      } else if (val is List<String>) { data[k] = val; }
    }
    final json = jsonEncode({'format':31, 'data':data});
    final encoded = base64Url.encode(utf8.encode(json));
    final payload = 'KC31.${_check(json).toRadixString(16)}.$encoded';
    await Clipboard.setData(ClipboardData(text: payload));
    _notice('Yedek panoya kopyalandı. Güvenli bir yere kaydet.');
  }

  Future<void> _importBackup() async {
    if (_busy) return;
    final prefs = widget.prefs;
    if (prefs == null) return;
    final payload = _importText.text.trim();
    if (payload.length > 400000 || !payload.startsWith('KC31.')) {
      _notice('Yedek kodu geçerli değil.'); return;
    }
    try {
      final parts = payload.split('.');
      if (parts.length != 3) throw const FormatException('Bölümler eksik');
      final json = utf8.decode(base64Url.decode(base64Url.normalize(parts[2])));
      if (_check(json).toRadixString(16) != parts[1]) {
        throw const FormatException('Yedek bozulmuş');
      }
      final obj = jsonDecode(json);
      if (obj is! Map || obj['format'] != 31 || obj['data'] is! Map) {
        throw const FormatException('Desteklenmeyen biçim');
      }
      final values = Map<String, dynamic>.from(obj['data'] as Map);
      if (values.length > 6000 || values.keys.any((k) => !_allowedKey(k))) {
        throw const FormatException('Geçersiz kayıt anahtarı');
      }
      final approve = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
        title: const Text('Yedek geri yüklensin mi?'),
        content: const Text('Eski seviyeler korunarak bulmacalar birleştirilecek. '
          'Altın miktarı azaltılmayacak. İşlemden sonra uygulamayı kapatıp aç.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İPTAL')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('YÜKLE')),
        ]));
      if (approve != true || !mounted) return;
      setState(() => _busy = true);
      // Never decrease progress; never re-award claimed events.
      for (final entry in values.entries) {
        final k = entry.key;
        final v = entry.value;
        if (k == 'current_level_v3' || k == 'chapter_schema') continue;
        if (v is int) {
          final next = math.max(prefs.getInt(k) ?? 0, v);
          await prefs.setInt(k, next);
        } else if (v is List && v.every((e) => e is String)) {
          final union = <String>{...?prefs.getStringList(k), ...v.cast<String>()}.toList();
          await prefs.setStringList(k, union);
        } else if (v is bool) {
          if (k.startsWith('v31_')) await prefs.setBool(k, v);
        } else if (v is String) {
          // Daily claims should not be reset backwards.
          final old = prefs.getString(k) ?? '';
          if (k.contains('date') || k.contains('day') || k.contains('month') ||
              k.contains('week')) {
            await prefs.setString(k, old.compareTo(v) >= 0 ? old : v);
          } else if (k == 'v29_nickname' || k == 'v29_avatar') {
            if (old.isEmpty) await prefs.setString(k, v);
          }
        }
      }
      if (mounted) {
        setState(() { _busy = false; _reloadLocal(); });
        widget.onRestore();
        _notice('Yedek alındı. İlerleme oyun ekranına yüklendi.');
      }
    } catch (e) {
      if (mounted) { setState(() => _busy = false); _notice('Yedek açılamadı: $e'); }
    }
  }

  Widget _backupView() => ListView(children: [
    _panel('GÜVENLİ YEREL KAYIT YEDEĞİ', Column(children: [
      const Icon(Icons.backup_rounded, color: _v31Gold, size: 65),
      _text('Oyunun bölüm kayıtlarını, altınlarını ve ödül verilerini '
        'şifrelenmemiş bir yedek koduna dönüştürür. '
        'Kodu yalnızca güvendiğin yerde sakla; içinde oyuncu adı da bulunabilir.'),
      _action('YEDEĞİ KOPYALA', _exportBackup, icon: Icons.copy),
      const SizedBox(height: 20),
      TextField(controller: _importText, maxLines: 4, minLines: 2,
        style: const TextStyle(color: _v31Cream, fontSize: 11),
        decoration: const InputDecoration(hintText: 'KC31. ile başlayan yedeği yapıştır',
          hintStyle: TextStyle(color: Colors.white54),
          border: OutlineInputBorder(borderSide: BorderSide(color: _v31Gold)))),
      _action('YEDEĞİ GÜVENLİ GERİ YÜKLE', _busy ? null : _importBackup,
        icon: Icons.restore),
      const SizedBox(height: 8),
      _text('Bu, çevrimdışı kopyala/yapıştır yedeğidir. '
        'Bulut hesabına otomatik senkronizasyon değildir.',
        color: Colors.white70, size: 12),
    ])),
  ]);

  @override Widget build(BuildContext context) {
    const titles = ['MARATON', 'HATIRALAR', 'GÖRÜNÜM', 'YEDEK'];
    const icons = [Icons.abc, Icons.collections_bookmark, Icons.nightlight,
      Icons.cloud_upload_outlined];
    final views = [_challengeView(), _memoriesView(), _visualsView(), _backupView()];
    return Column(children: [
      SizedBox(height: 54, child: ListView.builder(scrollDirection: Axis.horizontal,
        itemCount: titles.length, itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.all(4), child: ChoiceChip(
            selected: _tab == i, selectedColor: _v31Gold,
            label: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icons[i], size: 17, color: _tab == i ? _v31Navy : _v31Gold),
              const SizedBox(width: 4), Text(titles[i], style: TextStyle(
                fontSize: 11, color: _tab == i ? _v31Navy : _v31Cream)),
            ]), onSelected: (_) => setState(() => _tab = i))))),
      Expanded(child: views[_tab]),
    ]);
  }
}
