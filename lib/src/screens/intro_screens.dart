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

// V318_DESIGN: native, tappable Flutter layout inspired by the selected concept.
// Existing navigation callbacks, music settings and saved values are untouched.
class _PremiumOpeningScreenState extends State<PremiumOpeningScreen>
    with TickerProviderStateMixin {
  late final AnimationController _appear = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 750))..forward();
  late final AnimationController _scenery = AnimationController(
    vsync: this, duration: const Duration(seconds: 28))..repeat(reverse: true);

  @override
  void dispose() {
    _appear.dispose();
    _scenery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD477);
    const ivory = Color(0xFFFFEDC0);
    return Scaffold(
      backgroundColor: const Color(0xFF06162B),
      body: Stack(children: [
        Positioned.fill(child: AnimatedBuilder(
          animation: _scenery,
          child: Image.asset('assets/images/v318/cappadocia_luxury.webp',
            fit: BoxFit.cover, filterQuality: FilterQuality.high),
          builder: (context, child) => ClipRect(child: Transform.scale(
            scale: 1.015 + .025 * _scenery.value,
            child: Transform.translate(
              offset: Offset(-4 * _scenery.value, 5 * _scenery.value),
              child: SizedBox.expand(child: child)))))),
        const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, .20, .37, .72, 1],
            colors: [Color(0x66031020), Color(0x10031020),
              Color(0x36061225), Color(0x39020A19), Color(0xAE030F23)])))),
        SafeArea(child: LayoutBuilder(builder: (context, bounds) {
          final narrow = bounds.maxWidth < 370;
          final compact = bounds.maxHeight < 690;
          final horizontal = narrow ? 14.0 : 19.0;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: bounds.maxHeight),
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 15),
                child: Column(children: [
                  Row(children: [
                    Semantics(label: widget.musicOn ? 'Müziği kapat' : 'Müziği aç',
                      button: true, child: _WelcomeRound(
                        icon: widget.musicOn
                          ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                        onTap: widget.onMusicToggle)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xF007213E),
                        border: Border.all(color: gold, width: 1.8),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [BoxShadow(color: Color(0x98010916),
                          blurRadius: 13, offset: Offset(0, 4))]),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.stars_rounded, color: gold, size: 23),
                        const SizedBox(width: 8),
                        Text('${widget.finishedCount} / 243',
                          style: const TextStyle(color: ivory, fontSize: 17,
                            fontWeight: FontWeight.w900)),
                      ])),
                    const SizedBox(width: 13),
                    Semantics(label: 'Ayarlar', button: true,
                      child: _WelcomeRound(icon: Icons.settings_rounded,
                        onTap: widget.onSettings)),
                  ]),
                  SizedBox(height: compact ? 31 : 48),
                  FadeTransition(opacity: _appear, child: _V318TitleCard(narrow: narrow)),
                  SizedBox(height: compact ? 26 : 40),
                  FadeTransition(opacity: _appear, child: Column(children: [
                    _V318MenuButton(
                      label: 'OYUNA BAŞLA', icon: Icons.play_arrow_rounded,
                      onTap: widget.onChooseCity, primary: true),
                    const SizedBox(height: 11),
                    _V318MenuButton(label: 'ŞEHİR SEÇ',
                      icon: Icons.map_rounded, onTap: widget.onChooseCity,
                      scene: 'assets/images/cities/istanbul.webp'),
                    const SizedBox(height: 11),
                    _V318MenuButton(label: 'BÖLÜM SEÇ',
                      icon: Icons.grid_view_rounded, onTap: widget.onChooseChapter,
                      scene: 'assets/images/cities/antalya.webp'),
                    const SizedBox(height: 11),
                    _V318MenuButton(label: 'KALDIĞIM YERDEN DEVAM ET',
                      icon: Icons.history_rounded, onTap: widget.onContinue,
                      scene: 'assets/images/cities/kapadokya.webp'),
                    const SizedBox(height: 11),
                    _V318MenuButton(label: 'MACERA MERKEZİ · GÜNLÜK ÖDÜLLER',
                      icon: Icons.auto_awesome_rounded, onTap: widget.onAdventure,
                      scene: 'assets/images/cities/mardin.webp'),
                    const SizedBox(height: 17),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xEE071C36),
                        border: Border.all(color: gold, width: 1),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [BoxShadow(color: Color(0x90010A16), blurRadius: 7)]),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.location_on_rounded, color: gold, size: 18),
                        const SizedBox(width: 8),
                        Flexible(child: Text(
                          'Kaldığın yer  ·  ${widget.currentCity}  ${widget.currentStage}/3',
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: ivory, fontSize: 13,
                            fontWeight: FontWeight.w600))),
                      ])),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: widget.onExit,
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: const Text('Çıkış'),
                      style: TextButton.styleFrom(foregroundColor: ivory,
                        textStyle: const TextStyle(fontWeight: FontWeight.w800,
                          fontSize: 15))),
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

class _V318TitleCard extends StatelessWidget {
  const _V318TitleCard({required this.narrow});
  final bool narrow;
  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD477);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(narrow ? 12 : 15, 16, narrow ? 12 : 15, 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        gradient: const LinearGradient(begin: Alignment.topLeft,
          end: Alignment.bottomRight, colors: [Color(0xF20E335A),
            Color(0xF8061A35), Color(0xF9061A30)]),
        border: Border.all(color: gold, width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xC0040914), blurRadius: 23,
            offset: Offset(0, 9)),
          BoxShadow(color: Color(0x6DF7B450), blurRadius: 13),
        ]),
      child: Column(children: [
        const Icon(Icons.explore_outlined, color: gold, size: 31),
        const SizedBox(height: 4),
        const Text('✦  K E L İ M E  Ç E M B E R İ  ✦',
          textAlign: TextAlign.center,
          style: TextStyle(color: gold, fontSize: 11.2,
            fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        FittedBox(fit: BoxFit.scaleDown,
          child: Text('ŞEHİR HİKÂYELERİ',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'serif',
              fontSize: narrow ? 30 : 35,
              color: const Color(0xFFFFE6A5),
              fontWeight: FontWeight.w900, letterSpacing: .2,
              shadows: const [Shadow(color: Colors.black,
                blurRadius: 8, offset: Offset(0, 3))]))),
        const SizedBox(height: 10),
        const Row(children: [
          Expanded(child: Divider(color: gold, thickness: .8)),
          Padding(padding: EdgeInsets.symmetric(horizontal: 9),
            child: Icon(Icons.diamond_outlined, color: gold, size: 16)),
          Expanded(child: Divider(color: gold, thickness: .8)),
        ]),
        const SizedBox(height: 10),
        const FittedBox(fit: BoxFit.scaleDown,
          child: Text('TÜRKİYE’Yİ KEŞFET   •   KELİMELERLE TANI',
            maxLines: 1, style: TextStyle(color: Color(0xFFFFE8BB),
              letterSpacing: .8, fontSize: 12, fontWeight: FontWeight.w700))),
        const SizedBox(height: 13),
        const FittedBox(fit: BoxFit.scaleDown,
          child: Text('81 ŞEHİR    ✦    243 BÖLÜM    ✦    BİR MACERA',
            style: TextStyle(color: Color(0xFFF9E8C8),
              letterSpacing: .4, fontSize: 11.5))),
      ]),
    );
  }
}

class _V318MenuButton extends StatelessWidget {
  const _V318MenuButton({required this.label, required this.icon,
    required this.onTap, this.primary = false, this.scene});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  final String? scene;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD477);
    return Material(color: Colors.transparent, child: InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(29),
      child: Container(height: primary ? 64 : 60,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(29),
          border: Border.all(color: gold, width: 2),
          gradient: LinearGradient(begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: primary
              ? const [Color(0xFF21E870), Color(0xFF008E55), Color(0xFF006E4A)]
              : const [Color(0xFF174C7E), Color(0xFF08254C), Color(0xFF071A33)]),
          boxShadow: const [BoxShadow(color: Color(0xAA01101F),
            blurRadius: 11, offset: Offset(0, 4)),
            BoxShadow(color: Color(0x3FFFF1A0), blurRadius: 7)]),
        child: ClipRRect(borderRadius: BorderRadius.circular(27),
          child: Stack(fit: StackFit.expand, children: [
            if (!primary && scene != null) Align(
              alignment: Alignment.centerRight,
              child: SizedBox(width: 130, child: Image.asset(scene!,
                fit: BoxFit.cover, color: const Color(0x7C0A2D4D),
                colorBlendMode: BlendMode.multiply))),
            if (!primary) const DecoratedBox(decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xCC0A2C55),
                Color(0x9E082245), Color(0x130A2444)]))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(children: [
                Icon(icon, size: primary ? 32 : 25,
                  color: const Color(0xFFFFE8B4)),
                const SizedBox(width: 9),
                Expanded(child: FittedBox(fit: BoxFit.scaleDown,
                  child: Text(label, maxLines: 1,
                    style: TextStyle(color: const Color(0xFFFFF7E8),
                      fontSize: primary ? 23 : 16.7,
                      fontWeight: FontWeight.w900, letterSpacing: .2,
                      shadows: const [Shadow(color: Color(0x99000000),
                        blurRadius: 3)])))),
                const SizedBox(width: 8),
                Icon(primary ? Icons.explore_outlined : Icons.chevron_right_rounded,
                  color: const Color(0xFFFFE8B4), size: primary ? 26 : 23),
              ])),
          ]))),
    ));
  }
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
