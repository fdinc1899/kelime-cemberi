part of kelime_sehirleri;

/// V13: interactive welcome and chapter selection screens. The saved V3
/// progress is never changed until an unlocked chapter is explicitly chosen.
class PremiumOpeningScreen extends StatefulWidget {
  const PremiumOpeningScreen({super.key,
    required this.currentCity, required this.currentStage,
    required this.finishedCount, required this.onContinue,
    required this.onChooseCity, required this.onChooseChapter,
    required this.onSettings, required this.onExit, required this.onAdventure,
    required this.musicOn, required this.onMusicToggle});

  final String currentCity;
  final int currentStage;
  final int finishedCount;
  final VoidCallback onContinue;
  final VoidCallback onChooseCity;
  final VoidCallback onChooseChapter;
  final VoidCallback onSettings;
  final VoidCallback onExit;
  final VoidCallback onAdventure;
  final bool musicOn;
  final VoidCallback onMusicToggle;

  @override
  State<PremiumOpeningScreen> createState() => _PremiumOpeningScreenState();
}

// V317_PREMIUM_HOME: existing routes/saves stay connected, music button actually controls playback.
class _PremiumOpeningScreenState extends State<PremiumOpeningScreen>
    with TickerProviderStateMixin {
  late final AnimationController _appear;
  late final AnimationController _scenery;

  @override
  void initState() {
    super.initState();
    _appear = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _scenery = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _appear.dispose();
    _scenery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = _premiumCityScenes['Kapadokya'] ?? _istanbulBackground;
    const gold = Color(0xFFFFD57D);
    return Scaffold(
      backgroundColor: const Color(0xFF071629),
      body: Stack(children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _scenery,
              child: Image.memory(bg, fit: BoxFit.cover,
                filterQuality: FilterQuality.high, gaplessPlayback: true),
              builder: (context, image) => ClipRect(
                child: Transform.scale(
                  scale: 1.045 + .065 * _scenery.value,
                  child: Transform.translate(
                    offset: Offset(4 * _scenery.value, -7 * _scenery.value),
                    child: SizedBox.expand(child: image),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned.fill(child: DecoratedBox(
          decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, .26, .52, .81, 1],
            colors: [Color(0xBF06152C), Color(0x3808162D),
              Color(0x7306162B), Color(0xBD05152A), Color(0xEB051429)],
          )),
        )),
        Positioned.fill(child: IgnorePointer(child: Align(
          alignment: const Alignment(.76, -.37),
          child: Container(
            width: 250, height: 250,
            decoration: const BoxDecoration(
              gradient: RadialGradient(colors: [Color(0x22FFD57D),
                Color(0x00FFD57D)]),
              shape: BoxShape.circle,
            ),
          ),
        ))),
        SafeArea(child: LayoutBuilder(builder: (context, area) {
          final narrow = area.maxWidth < 365;
          final titleSpace = (area.maxHeight * .075).clamp(22.0, 65.0).toDouble();
          final actionSpace = (area.maxHeight * .085).clamp(28.0, 68.0).toDouble();
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: area.maxHeight),
              child: Padding(
                padding: EdgeInsets.fromLTRB(narrow ? 14 : 20, 10,
                    narrow ? 14 : 20, 18),
                child: Column(children: [
                  Row(children: [
                    Tooltip(
                      message: widget.musicOn ? 'Müziği kapat' : 'Müziği aç',
                      child: _WelcomeRound(
                        icon: widget.musicOn
                            ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                        onTap: widget.onMusicToggle,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14,
                          vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: const LinearGradient(colors: [
                          Color(0xEA102C4A), Color(0xE7071B32),
                        ]),
                        border: Border.all(color: gold, width: 1.5),
                        boxShadow: const [BoxShadow(color: Color(0x8B020812),
                          blurRadius: 13, offset: Offset(0, 4))],
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.stars_rounded,
                            color: gold, size: 21),
                        const SizedBox(width: 6),
                        Text('${widget.finishedCount} / 243',
                          style: const TextStyle(color: Color(0xFFFFE5A5),
                            fontSize: 16, fontWeight: FontWeight.w900)),
                      ]),
                    ),
                    const SizedBox(width: 12),
                    Tooltip(message: 'Ayarlar', child: _WelcomeRound(
                      icon: Icons.settings_rounded,
                      onTap: widget.onSettings,
                    )),
                  ]),
                  SizedBox(height: titleSpace),
                  FadeTransition(opacity: _appear, child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, .12), end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _appear, curve: Curves.easeOutCubic)),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xF50B294B), Color(0xF6071933),
                            Color(0xF70B2445)],
                        ),
                        border: Border.all(color: gold, width: 2.0),
                        boxShadow: const [
                          BoxShadow(color: Color(0xC3000000), blurRadius: 25,
                            offset: Offset(0, 12)),
                          BoxShadow(color: Color(0x39FFCE74), blurRadius: 20),
                        ],
                      ),
                      child: Column(children: [
                        const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.auto_awesome, color: gold, size: 19),
                          SizedBox(width: 9),
                          Text('KELİME ÇEMBERİ', style: TextStyle(
                            color: Color(0xFFECC784), fontSize: 11,
                            letterSpacing: 2.5, fontWeight: FontWeight.w800)),
                          SizedBox(width: 9),
                          Icon(Icons.auto_awesome, color: gold, size: 19),
                        ]),
                        const SizedBox(height: 13),
                        FittedBox(fit: BoxFit.scaleDown, child: Text(
                          'ŞEHİR HİKÂYELERİ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFFFE8AA),
                            fontSize: narrow ? 27 : 31,
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            shadows: const [Shadow(
                              color: Color(0xF504070A), blurRadius: 9,
                              offset: Offset(0, 3))],
                          ),
                        )),
                        const SizedBox(height: 13),
                        const Row(children: [
                          Expanded(child: Divider(color: Color(0x7FFFDA91),
                            thickness: .8)),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.diamond_outlined,
                              color: gold, size: 14)),
                          Expanded(child: Divider(color: Color(0x7FFFDA91),
                            thickness: .8)),
                        ]),
                        const SizedBox(height: 11),
                        const Text('TÜRKİYE’Yİ KEŞFET  •  KELİMELERLE TANI',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFF8DCA8),
                            fontSize: 10.8, letterSpacing: 1.0,
                            fontWeight: FontWeight.w600)),
                        const SizedBox(height: 9),
                        const Text('81 ŞEHİR   ✦   243 BÖLÜM   ✦   BİR MACERA',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFF6EDDC),
                            fontSize: 10.2, letterSpacing: .6)),
                      ]),
                    ),
                  )),
                  SizedBox(height: actionSpace),
                  FadeTransition(opacity: _appear, child: Column(children: [
                    _V317HomeButton(label: 'OYUNA BAŞLA',
                      icon: Icons.play_arrow_rounded, primary: true,
                      onTap: widget.onChooseCity),
                    const SizedBox(height: 10),
                    _V317HomeButton(label: 'ŞEHİR SEÇ',
                      icon: Icons.map_rounded, onTap: widget.onChooseCity),
                    const SizedBox(height: 10),
                    _V317HomeButton(label: 'BÖLÜM SEÇ',
                      icon: Icons.grid_view_rounded, onTap: widget.onChooseChapter),
                    const SizedBox(height: 10),
                    _V317HomeButton(label: 'KALDIĞIM YERDEN DEVAM ET',
                      icon: Icons.subdirectory_arrow_right_rounded,
                      onTap: widget.onContinue),
                    const SizedBox(height: 10),
                    _V317HomeButton(label: 'MACERA MERKEZİ · GÜNLÜK ÖDÜLLER',
                      icon: Icons.auto_awesome_rounded,
                      onTap: widget.onAdventure),
                    const SizedBox(height: 19),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: const Color(0xD4091D34),
                        border: Border.all(color: const Color(0x7DE6BF77)),
                      ),
                      child: Text(
                        'Kaldığın yer  ·  ${widget.currentCity}  ${widget.currentStage}/3',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFFFE4B0),
                            fontWeight: FontWeight.w600, fontSize: 12.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: widget.onExit,
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Çıkış'),
                      style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFFBEEDD)),
                    ),
                  ])),
                ]),
              ),
            ),
          );
        })),
      ]),
    );
  }
}

class _V317HomeButton extends StatelessWidget {
  const _V317HomeButton({required this.label, required this.icon,
      required this.onTap, this.primary = false});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        width: double.infinity,
        height: primary ? 59 : 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: primary
              ? const [Color(0xFF36E985), Color(0xFF099D55),
                  Color(0xFF006E41)]
              : const [Color(0xFF194779), Color(0xF50C2B52),
                  Color(0xFF071C36)],
          ),
          border: Border.all(color: const Color(0xFFFFD57D), width: 1.7),
          boxShadow: const [
            BoxShadow(color: Color(0xB2030B15), blurRadius: 12,
                offset: Offset(0, 5)),
            BoxShadow(color: Color(0x2DFFE1A3), blurRadius: 9),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: Colors.white,
              size: primary ? 25 : 22),
            const SizedBox(width: 10),
            Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(
              label,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: primary ? 18 : 15,
                letterSpacing: .45),
            ))),
          ]),
        ),
      ),
    ),
  );
}

class _WelcomeRound extends StatelessWidget {
  const _WelcomeRound({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xDA06172C),
    shape: const CircleBorder(side: BorderSide(color: Color(0xFFFFD76E), width: 1.8)),
    child: InkWell(onTap: onTap, customBorder: const CircleBorder(),
      child: SizedBox(width: 42, height: 42,
        child: Icon(icon, color: const Color(0xFFFFE1A0)))),
  );
}

class _WelcomeAction extends StatelessWidget {
  const _WelcomeAction({required this.label, required this.icon,
    required this.onPressed, this.primary = false});
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool primary;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(onTap: onPressed,
      borderRadius: BorderRadius.circular(29),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: primary
              ? const [Color(0xFF17D567), Color(0xFF006D3E)]
              : const [Color(0xFF143A66), Color(0xFF04182F)]),
          borderRadius: BorderRadius.circular(29),
          border: Border.all(color: const Color(0xFFFFD76E), width: 1.8),
          boxShadow: const [BoxShadow(color: Color(0xAD000000),
            blurRadius: 7, offset: Offset(0, 3))],
        ),
        child: SizedBox(width: double.infinity, height: 48,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 9),
              Flexible(child: FittedBox(child: Text(label,
                style: const TextStyle(color: Colors.white,
                  fontWeight: FontWeight.w900, fontSize: 15)))),
            ])),
      ),
    ),
  );
}

class PremiumCityChooser extends StatefulWidget {
  const PremiumCityChooser({super.key, required this.unlocked,
    required this.completed, required this.onOpenLevel, required this.onBack});
  final int unlocked;
  final Set<int> completed;
  final ValueChanged<int> onOpenLevel;
  final VoidCallback onBack;
  @override
  State<PremiumCityChooser> createState() => _PremiumCityChooserState();
}

class _PremiumCityChooserState extends State<PremiumCityChooser> {
  int? _cityIndex;
  String _selectedRegion = 'Tümü';

  @override
  Widget build(BuildContext context) {
    final which = _cityIndex;
    final heading = which == null ? 'ŞEHİR SEÇİMİ' : '${_provinces[which].title.toUpperCase()} · BÖLÜMLER';
    return Scaffold(
      backgroundColor: const Color(0xFF07192D),
      body: Stack(children: [
        Positioned.fill(child: Image.memory(_istanbulBackground, fit: BoxFit.cover)),
        const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter, colors: [
              Color(0xDB061528), Color(0xED071A32), Color(0xF705132A)])))),
        SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(children: [
              _WelcomeRound(icon: Icons.arrow_back_rounded, onTap: () {
                if (_cityIndex != null) {
                  setState(() => _cityIndex = null);
                } else {
                  widget.onBack();
                }
              }),
              const SizedBox(width: 10),
              Expanded(child: FittedBox(fit: BoxFit.scaleDown,
                child: Text(heading, textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFFFDF82),
                    fontSize: 24, fontWeight: FontWeight.w900,
                    fontFamily: 'serif')))),
            ])),
          const V18GoldDivider(padding: 5),
          if (which == null) Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFFD36E)),
                color: const Color(0xD3061C35),
                borderRadius: BorderRadius.circular(25)),
              child: Text('✦  ${math.min(widget.completed.length,243)} / 243 BÖLÜM  ✦',
                style: const TextStyle(color: Color(0xFFFFE09A),
                  fontWeight: FontWeight.w800, fontSize: 12)),
            )),
          Expanded(child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: which == null
              ? Column(key: const ValueKey('allCities'), children: [
                  SizedBox(height: 49, child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: _regions.map((region) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        selected: _selectedRegion == region,
                        selectedColor: const Color(0xFFFFD77D),
                        backgroundColor: const Color(0xFF0D2946),
                        labelStyle: TextStyle(color: _selectedRegion == region
                            ? const Color(0xFF061A31) : Colors.white),
                        label: Text(region),
                        showCheckmark: false,
                        side: const BorderSide(color: Color(0xFFEBCB7D), width: 1.1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        onSelected: (_) => setState(() => _selectedRegion = region),
                      ),
                    )).toList(),
                  )),
                  if (_selectedRegion != 'Tümü')
                    _V19RegionBanner(region: _selectedRegion),
                  Expanded(child: Builder(builder: (context) {
                    final filtered = List.generate(_provinces.length, (i) => i)
                        .where((i) => _selectedRegion == 'Tümü' ||
                            _provinces[i].region == _selectedRegion).toList();
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 25),
                      itemCount: filtered.length,
                      itemBuilder: (context, position) {
                        final i = filtered[position];
                        final province = _provinces[i];
                        final unlockedCity = _cityOpen(province, widget.unlocked);
                        final done = province.levels.where(widget.completed.contains).length;
                        return V18ProvinceCard(
                          province: province, index: i,
                          unlocked: unlockedCity, done: done,
                          completed: widget.completed,
                          onTap: unlockedCity
                            ? () => setState(() => _cityIndex = i)
                            : () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(
                                  'Bu şehir kilitli. Önce önceki şehri tamamla.'))),
                        );
                      },
                    );
                  })),
                ])
              : ListView.builder(key: ValueKey('chapters_$which'),
                  padding: const EdgeInsets.fromLTRB(17, 15, 17, 25),
                  itemCount: 3,
                  itemBuilder: (context, stage) {
                    final index = _provinces[which].levels[stage];
                    final locked = index > widget.unlocked;
                    final done = widget.completed.contains(index);
                    return Padding(padding: const EdgeInsets.only(bottom: 16),
                      child: _WelcomeAction(
                        label: 'BÖLÜM ${stage + 1}   ${done ? '★ TAMAMLANDI' : locked ? '🔒 KİLİTLİ' : '▶ OYNA'}',
                        icon: done ? Icons.verified_rounded
                          : (locked ? Icons.lock_rounded : Icons.play_arrow_rounded),
                        primary: !locked,
                        onPressed: locked
                            ? () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Bu bölüm henüz kilitli.')))
                            : () => widget.onOpenLevel(index),
                      ),
                    );
                  }),
          )),
        ])),
      ]),
    );
  }
}


/// Scenic region header on the province-selection page.
/// This is a real widget: chips and level-selection cards remain tappable.
class _V19RegionBanner extends StatelessWidget {
  const _V19RegionBanner({required this.region});
  final String region;

  @override
  Widget build(BuildContext context) {
    final count = _provinces.where((p) => p.region == region).length;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 7, 14, 3),
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xFF03152A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFDA83), width: 1.5),
        boxShadow: const [BoxShadow(
          color: Color(0x77000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        Positioned.fill(child: Image.asset(_regionScenicAsset(region),
          fit: BoxFit.cover, filterQuality: FilterQuality.high)),
        const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft, end: Alignment.centerRight,
            colors: [Color(0x26041931), Color(0xCE05162D),
              Color(0xFF05162D)])))),
        Positioned.fill(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(children: [
            const Icon(Icons.auto_awesome, color: Color(0xFFFFDC7E)),
            const Spacer(),
            Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(region.toUpperCase(),
                  style: const TextStyle(color: Color(0xFFFFE4A1),
                    fontSize: 17, fontWeight: FontWeight.w900)),
                Text('$count il · 3 bölüm / il',
                  style: const TextStyle(color: Colors.white,
                    fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
          ]),
        )),
      ]),
    );
  }
}
