part of kelime_sehirleri;

/// New V15 data lives under dedicated keys. Existing V3 game saves are untouched.
class AdventureProgress {
  SharedPreferences? _prefs;
  String _day = '';
  String _week = '';
  int dailyWords = 0;
  int dailyBonuses = 0;
  int dailyLevels = 0;
  int weeklyScore = 0;
  String spinDay = '';
  int unopenedChests = 0;
  int freeHints = 0;
  int experience = 0;
  final Set<String> claimedDaily = {};
  final Set<String> claimedWeekly = {};
  final Map<int, int> stars = {};

  static String today() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
  }

  static String thisWeek() {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2,'0')}-${monday.day.toString().padLeft(2,'0')}';
  }

  void load(SharedPreferences prefs, Set<int> completed) {
    _prefs = prefs;
    _day = prefs.getString('adv15_day') ?? '';
    _week = prefs.getString('adv15_week') ?? '';
    dailyWords = prefs.getInt('adv15_daily_words') ?? 0;
    dailyBonuses = prefs.getInt('adv15_daily_bonus') ?? 0;
    dailyLevels = prefs.getInt('adv15_daily_levels') ?? 0;
    weeklyScore = prefs.getInt('adv15_week_score') ?? 0;
    spinDay = prefs.getString('adv15_spin_day') ?? '';
    unopenedChests = prefs.getInt('adv15_chests') ?? 0;
    freeHints = prefs.getInt('adv15_free_hints') ?? 0;
    experience = prefs.getInt('adv15_xp') ?? 0;
    claimedDaily.addAll(prefs.getStringList('adv15_claimed_daily') ?? []);
    claimedWeekly.addAll(prefs.getStringList('adv15_claimed_weekly') ?? []);
    for (final i in completed) {
      final old = prefs.getInt('adv15_stars_$i');
      // Older builds had no star record: never overwrite or remove their wins.
      stars[i] = (old ?? 1).clamp(1, 3).toInt();
    }
    refreshPeriod();
  }

  void refreshPeriod() {
    bool updated = false;
    final currentDay = today();
    final currentWeek = thisWeek();
    if (_day != currentDay) {
      _day = currentDay;
      dailyWords = 0;
      dailyBonuses = 0;
      dailyLevels = 0;
      claimedDaily.clear();
      updated = true;
    }
    if (_week != currentWeek) {
      _week = currentWeek;
      weeklyScore = 0;
      claimedWeekly.clear();
      updated = true;
    }
    if (updated) save();
  }

  Future<void> save() async {
    final p = _prefs;
    if (p == null) return;
    await p.setString('adv15_day', _day);
    await p.setString('adv15_week', _week);
    await p.setInt('adv15_daily_words', dailyWords);
    await p.setInt('adv15_daily_bonus', dailyBonuses);
    await p.setInt('adv15_daily_levels', dailyLevels);
    await p.setInt('adv15_week_score', weeklyScore);
    await p.setString('adv15_spin_day', spinDay);
    await p.setInt('adv15_chests', unopenedChests);
    await p.setInt('adv15_free_hints', freeHints);
    await p.setInt('adv15_xp', experience);
    await p.setStringList('adv15_claimed_daily', claimedDaily.toList());
    await p.setStringList('adv15_claimed_weekly', claimedWeekly.toList());
    for (final entry in stars.entries) {
      await p.setInt('adv15_stars_${entry.key}', entry.value);
    }
  }

  void foundWord({bool bonus = false}) {
    refreshPeriod();
    if (bonus) {
      dailyBonuses++;
      weeklyScore += 25;
      experience += 15;
    } else {
      dailyWords++;
      weeklyScore += 10;
      experience += 10;
    }
    save();
  }

  void finishedLevel(int index, int hintsUsed) {
    refreshPeriod();
    if (!stars.containsKey(index)) {
      dailyLevels++;
      weeklyScore += 100;
      experience += 60;
      if (index % 3 == 2) unopenedChests++;
    }
    final score = hintsUsed == 0 ? 3 : hintsUsed <= 2 ? 2 : 1;
    final old = stars[index] ?? 0;
    if (score > old) stars[index] = score;
    save();
  }

  int get totalStars => stars.values.fold<int>(0, (sum, v) => sum + v);
  bool get canSpin => spinDay != today();

  int claimDaily(String id, int minimum, int current, int reward) {
    refreshPeriod();
    if (current < minimum || !claimedDaily.add(id)) return 0;
    save();
    return reward;
  }

  int claimWeekly(String id, int target, int reward) {
    refreshPeriod();
    if (weeklyScore < target || !claimedWeekly.add(id)) return 0;
    save();
    return reward;
  }

  // 0-3: coin rewards; 4: free hint; 5: bonus chest.
  int spin(math.Random random) {
    refreshPeriod();
    if (!canSpin) return -1;
    spinDay = today();
    final choice = random.nextInt(6);
    if (choice == 4) freeHints++;
    if (choice == 5) unopenedChests++;
    save();
    return choice;
  }

  int openChest(math.Random random) {
    if (unopenedChests < 1) return 0;
    unopenedChests--;
    final reward = 30 + 10 * random.nextInt(6);
    save();
    return reward;
  }

  bool spendFreeHint() {
    if (freeHints <= 0) return false;
    freeHints--;
    save();
    return true;
  }
}

/// Six researched-safe, brief city notes, shown after finishing each city's
/// original three levels. These are offline editorial notes, not live data.
const Map<String, String> adventureCityStories = {
  'İstanbul': 'İstanbul, Boğaz’ın iki yakasında Avrupa ve Asya’yı birleştirir. Tarihi yarımadada Bizans ve Osmanlı dönemlerinden eserler bulunur.',
  'Kapadokya': 'Kapadokya’nın peri bacaları, volkanik kayaçların aşınmasıyla şekillendi. Kayalara oyulan yerleşimler bölgenin simgelerindendir.',
  'Antalya': 'Antalya’nın tarihi Kaleiçi semti, Akdeniz limanı ve dar taş sokaklarıyla tanınır. Bölgenin kıyıları pek çok antik kente yakındır.',
  'Mardin': 'Mardin, Mezopotamya ovasına bakan taş evleri ve sokaklarıyla ünlüdür. Farklı kültürlerin izleri kent mimarisinde görülür.',
  'İzmir': 'İzmir, Ege Denizi kıyısındaki tarihî liman kentlerinden biridir. Kordon ve Saat Kulesi şehrin önemli simgeleridir.',
  'Ankara': 'Ankara, Türkiye’nin başkentidir. Anıtkabir ve Cumhuriyet dönemi yapıları yakın tarihinin simgeleridir.',
};

class AdventureCenterView extends StatelessWidget {
  const AdventureCenterView({super.key, required this.progress,
      required this.completed, required this.unlocked, required this.onClaimDaily,
      required this.onClaimWeekly, required this.onSpin, required this.onChest,
      required this.onOpenExtra, required this.onUsePower});
  final AdventureProgress progress;
  final Set<int> completed;
  final int unlocked;
  final void Function(String, int, int, int) onClaimDaily;
  final void Function(String, int, int) onClaimWeekly;
  final VoidCallback onSpin;
  final VoidCallback onChest;
  final void Function(int) onOpenExtra;
  final void Function(String) onUsePower;

  static const Color gold = Color(0xFFFFD36E);
  static const Color cream = Color(0xFFFFF6DC);
  static const Color dark = Color(0xEC071B33);

  Widget _panel(String heading, Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: dark,
      border: Border.all(color: gold, width: 1.5),
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 9, offset: Offset(0, 4))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(heading, style: const TextStyle(color: gold, fontSize: 18,
        fontFamily: 'serif', fontWeight: FontWeight.w900)),
      const SizedBox(height: 10), child,
    ]),
  );

  Widget _row(String label, String description, String badge, VoidCallback? onTap,
       {IconData icon = Icons.star_rounded}) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Material(color: const Color(0xFF102D4B), borderRadius: BorderRadius.circular(12),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: Padding(padding: const EdgeInsets.all(10),
          child: Row(children: [
            Icon(icon, color: gold, size: 24), const SizedBox(width: 9),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(color: cream, fontWeight: FontWeight.w800)),
              Text(description, style: const TextStyle(color: Color(0xFFD5C6AB), fontSize: 11)),
            ])), const SizedBox(width: 5),
            Text(badge, style: TextStyle(color: onTap == null ? const Color(0xFF9BACB7) : gold,
                fontWeight: FontWeight.w900, fontSize: 12)),
          ])),
      ),
    ),
  );

  void _story(BuildContext context, String city) => showDialog<void>(context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF0D2642),
      title: Text('$city · Şehir Hikâyesi', style: const TextStyle(color: gold)),
      content: Text(adventureCityStories[city]!, style: const TextStyle(color: cream)),
      actions: [TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('KAPAT'))],
    ));

  @override
  Widget build(BuildContext context) {
    progress.refreshPeriod();
    const tasks = <(String, String, int, int, IconData)>[
      ('words', '5 kelime bul', 5, 30, Icons.abc_rounded),
      ('bonus', '2 bonus kelime bul', 2, 35, Icons.star_rounded),
      ('levels', '1 bölüm tamamla', 1, 50, Icons.check_circle_rounded),
    ];
    const milestones = <(String, int, int)>[
      ('rookie', 200, 35), ('explorer', 500, 65), ('master', 1200, 100),
    ];
    final dailyValues = <String, int>{
      'words': progress.dailyWords, 'bonus': progress.dailyBonuses,
      'levels': progress.dailyLevels,
    };
    final claimed = progress.claimedDaily;
    final weeklyClaimed = progress.claimedWeekly;
    final coinSpinRewards = [20, 40, 60, 100];
    return ListView(padding: const EdgeInsets.fromLTRB(14, 12, 14, 34), children: [
      _panel('MACERA İLERLEMESİ', Column(children: [
        _row('Deneyim puanın', 'Kelime çözerek, bonus bularak ve bölüm bitirerek kazanılır',
          '${progress.experience} XP', null, icon: Icons.military_tech_rounded),
        _row('Klasik bölümler', '18 ana bulmaca + 12 ek bölüm',
          '${completed.length}/30', null, icon: Icons.map_rounded),
      ])),
      _panel('GÜNLÜK GÖREVLER', Column(children: [
        for (final t in tasks)
          _row(t.$2, '${dailyValues[t.$1] ?? 0} / ${t.$3} · +${t.$4} altın',
            claimed.contains(t.$1) ? 'ALINDI' : (dailyValues[t.$1] ?? 0) >= t.$3 ? 'AL' : 'KİLİTLİ',
            claimed.contains(t.$1) || (dailyValues[t.$1] ?? 0) < t.$3
                ? null : () => onClaimDaily(t.$1, t.$3, dailyValues[t.$1]!, t.$4), icon: t.$5),
      ])),
      _panel('ŞEHİR PASAPORTU', Column(children: [
        for (int city = 0; city < 6; city++)
          Builder(builder: (ctx) {
            final name = _levels[city * 3].city;
            final done = List.generate(3, (i) => city * 3 + i)
                .where(completed.contains).length;
            return _row('$name mührü', '$done / 3 ana bölüm · ${done == 3 ? "Mühür kazanıldı" : "Keşfetmeye devam et"}',
              done == 3 ? '✓' : '🔒', done == 3 ? () => _story(context, name) : null,
              icon: done == 3 ? Icons.workspace_premium_rounded : Icons.lock_outline_rounded);
          }),
      ])),
      _panel('ÜÇ YILDIZ · MANZARA KEŞFİ', Column(children: [
        _row('Biriktirdiğin yıldızlar', '${progress.totalStars} yıldız · Her bölümde en fazla 3 yıldız',
          '${progress.totalStars} ★', null, icon: Icons.auto_awesome_rounded),
        const Text('İpucu kullanmadan tamamla: 3 yıldız. 1–2 ipucu: 2 yıldız. Daha fazlası: 1 yıldız. Kelimeleri açtıkça arka plan üzerindeki karartma hafifler.',
          style: TextStyle(color: cream, fontSize: 12)),
      ])),
      _panel('GÜNLÜK ÇARK', Column(children: [
        const Icon(Icons.toll_rounded, color: gold, size: 65),
        const Text('Her gün tek çevirme · Altın, ücretsiz ipucu veya sandık',
          textAlign: TextAlign.center, style: TextStyle(color: cream, fontSize: 12)),
        const SizedBox(height: 8),
        _row('Çarkı çevir', progress.canSpin
             ? 'Bugünkü çevirme hakkın hazır'
             : 'Bugün çevirdin · Yarın yeniden gel',
             progress.canSpin ? 'ÇEVİR' : 'ALINDI', progress.canSpin ? onSpin : null,
             icon: Icons.casino_rounded),
        Text('Olası ödüller: ${coinSpinRewards.map((e) => '$e altın').join(' · ')} · ipucu · sandık',
          style: const TextStyle(color: Color(0xFFD5C6AB), fontSize: 10), textAlign: TextAlign.center),
      ])),
      _panel('YARDIMCI GÜÇLER VE SANDIKLAR', Column(children: [
        _row('Sandık aç', '${progress.unopenedChests} sandık · 30–80 altın',
          progress.unopenedChests > 0 ? 'AÇ' : 'YOK', progress.unopenedChests > 0 ? onChest : null,
          icon: Icons.inventory_2_rounded),
        _row('Ücretsiz ipucu', '${progress.freeHints} hak · Çarktan kazanılır',
          '${progress.freeHints} HAK', null, icon: Icons.lightbulb_rounded),
        _row('İlk harfi aç', '15 altın · Çözülmemiş bir kelimenin ilk kutusu',
          '15', () => onUsePower('first'), icon: Icons.looks_one_rounded),
        _row('Bir kelimeyi aç', '80 altın · Çözülemeyen bir kelimeyi tamamla',
          '80', () => onUsePower('word'), icon: Icons.auto_fix_high_rounded),
        _row('Karıştır', 'Harflerin yerlerini ücretsiz değiştir',
          'ÜCRETSİZ', () => onUsePower('shuffle'), icon: Icons.shuffle_rounded),
      ])),
      _panel('HAFTALIK MÜCADELE · ÇEVRİMDIŞI', Column(children: [
        _row('Haftalık puan', 'Her pazartesi sıfırlanır · kelime +10, bonus +25, bölüm +100',
            '${progress.weeklyScore} PUAN', null, icon: Icons.emoji_events_rounded),
        for (final m in milestones)
          _row('${m.$2} puan hedefi', 'Kazanılacak: +${m.$3} altın',
            weeklyClaimed.contains(m.$1) ? 'ALINDI' : progress.weeklyScore >= m.$2 ? 'AL' : 'KİLİTLİ',
            weeklyClaimed.contains(m.$1) || progress.weeklyScore < m.$2
                ? null : () => onClaimWeekly(m.$1, m.$2, m.$3), icon: Icons.military_tech_rounded),
        const Text('Bu sürümde yarışma cihaz üzerindedir; diğer oyuncularla gerçek zamanlı sıralama veya ödüllü çevrim içi lig yoktur.',
          style: TextStyle(color: Color(0xFFD5C6AB), fontSize: 11)),
      ])),
      _panel('YENİ BÖLÜMLER · +12', Column(children: [
        const Text('18 klasik bölümün ardından 12 ek bulmaca açılır. Eski kayıtların bölüm sırası değişmez.',
            style: TextStyle(color: cream, fontSize: 12)),
        const SizedBox(height: 8),
        for (var i = 18; i < _levels.length; i++)
          _row('${_levels[i].city} · Ek ${((i-18)%2)+1}', _levels[i].subtitle,
            i <= unlocked ? (completed.contains(i) ? '✓' : 'OYNA') : '🔒',
            i <= unlocked ? () => onOpenExtra(i) : null, icon: Icons.grid_view_rounded),
      ])),
      _panel('ŞEHİR HİKÂYELERİ', const Text(
        'Her şehrin üç ana bölümünü bitirdiğinde pasaport mührüne dokunarak o şehrin kısa hikâyesini okuyabilirsin.',
        style: TextStyle(color: cream, fontSize: 12))),
    ]);
  }
}
