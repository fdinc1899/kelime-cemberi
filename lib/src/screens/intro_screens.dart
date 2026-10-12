part of kelime_sehirleri;

/// V13: interactive welcome and chapter selection screens. The saved V3
/// progress is never changed until an unlocked chapter is explicitly chosen.
class PremiumOpeningScreen extends StatefulWidget {
  const PremiumOpeningScreen({super.key,
    required this.currentCity, required this.currentStage,
    required this.finishedCount, required this.onContinue,
    required this.onChooseCity, required this.onChooseChapter,
    required this.onSettings, required this.onExit});

  final String currentCity;
  final int currentStage;
  final int finishedCount;
  final VoidCallback onContinue;
  final VoidCallback onChooseCity;
  final VoidCallback onChooseChapter;
  final VoidCallback onSettings;
  final VoidCallback onExit;

  @override
  State<PremiumOpeningScreen> createState() => _PremiumOpeningScreenState();
}

class _PremiumOpeningScreenState extends State<PremiumOpeningScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _appear;

  @override
  void initState() {
    super.initState();
    _appear = AnimationController(vsync: this,
      duration: const Duration(milliseconds: 900))..forward();
  }

  @override
  void dispose() {
    _appear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = _premiumCityScenes['Kapadokya'] ?? _istanbulBackground;
    return Scaffold(
      backgroundColor: const Color(0xFF06162D),
      body: Stack(children: [
        Positioned.fill(child: Image.memory(bg,
          fit: BoxFit.cover, alignment: Alignment.center)),
        const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            stops: [0, .24, .58, 1],
            colors: [Color(0xB5041731), Color(0x33031930),
              Color(0x77051B33), Color(0xEB061325)])))),
        SafeArea(child: LayoutBuilder(builder: (context, area) {
          return SingleChildScrollView(child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: area.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 17, 22, 25),
              child: Column(children: [
                Row(children: [
                  _WelcomeRound(icon: Icons.music_note_rounded, onTap: widget.onSettings),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFFD76E)),
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xD10B233B)),
                    child: Text('${widget.finishedCount} / 18  ★',
                      style: const TextStyle(color: Color(0xFFFFD76E),
                      fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  _WelcomeRound(icon: Icons.settings_rounded, onTap: widget.onSettings),
                ]),
                SizedBox(height: area.maxHeight * .12),
                FadeTransition(opacity: _appear,
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0, .22), end: Offset.zero)
                      .animate(CurvedAnimation(parent: _appear, curve: Curves.easeOutCubic)),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xEB081B34),
                        border: Border.all(color: const Color(0xFFFFD76E), width: 2),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: Color(0xC6000000),
                          blurRadius: 22, offset: Offset(0, 8))],
                      ),
                      child: Column(children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFFFFD76E), size: 36),
                        const SizedBox(height: 8),
                        const FittedBox(child: Text('ŞEHİR HİKÂYELERİ',
                          style: TextStyle(color: Color(0xFFFFE4A0),
                          fontSize: 30, fontFamily: 'serif',
                          fontWeight: FontWeight.w900, letterSpacing: 1.7,
                          shadows: [Shadow(color: Colors.black, blurRadius: 8)]))),
                        const SizedBox(height: 12),
                        const Text("TÜRKİYE'Yİ KEŞFET  •  KELİMELERLE TANI",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFFFE8B2),
                            fontSize: 10.5, letterSpacing: 1.2)),
                      ]),
                    ),
                  )),
                SizedBox(height: area.maxHeight * .14),
                FadeTransition(opacity: _appear,
                  child: Column(children: [
                    _WelcomeAction(label: 'OYUNA BAŞLA',
                      icon: Icons.play_arrow_rounded, primary: true,
                      onPressed: widget.onChooseCity),
                    const SizedBox(height: 10),
                    _WelcomeAction(label: 'ŞEHİR SEÇ',
                      icon: Icons.map_rounded, onPressed: widget.onChooseCity),
                    const SizedBox(height: 10),
                    _WelcomeAction(label: 'BÖLÜM SEÇ',
                      icon: Icons.grid_view_rounded, onPressed: widget.onChooseChapter),
                    const SizedBox(height: 10),
                    _WelcomeAction(label: 'KALDIĞIM YERDEN DEVAM ET',
                      icon: Icons.subdirectory_arrow_right_rounded,
                      onPressed: widget.onContinue),
                    const SizedBox(height: 10),
                    Text('Kaydedilen bölüm: ${widget.currentCity}  ${widget.currentStage}/3',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFFFE2A1),
                        shadows: [Shadow(color: Colors.black, blurRadius: 3)])),
                    const SizedBox(height: 8),
                    TextButton.icon(onPressed: widget.onExit,
                      icon: const Icon(Icons.exit_to_app_rounded),
                      label: const Text('Çıkış'),
                      style: TextButton.styleFrom(foregroundColor: Colors.white)),
                  ])),
              ]),
            ),
          ));
        })),
      ]),
    );
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

  @override
  Widget build(BuildContext context) {
    final which = _cityIndex;
    final heading = which == null ? 'ŞEHİR SEÇİMİ' : '${_levels[which * 3].city.toUpperCase()} · BÖLÜMLER';
    return Scaffold(
      backgroundColor: const Color(0xFF07192D),
      body: Stack(children: [
        Positioned.fill(child: Image.memory(_premiumCityScenes['Antalya'] ?? _istanbulBackground,
          fit: BoxFit.cover)),
        const Positioned.fill(child: ColoredBox(color: Color(0xC5081528))),
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
          const Divider(color: Color(0xAAFFD77D), indent: 20, endIndent: 20),
          Expanded(child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: which == null
              ? ListView.builder(key: const ValueKey('allCities'),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 25),
                  itemCount: 6,
                  itemBuilder: (context, i) {
                    final city = _levels[i * 3].city;
                    final unlockedCity = i * 3 <= widget.unlocked;
                    final done = List.generate(3, (j) => i * 3 + j)
                      .where(widget.completed.contains).length;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 11),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFFD77D), width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [BoxShadow(color: Color(0x99000000), blurRadius: 8)]),
                      child: Material(color: const Color(0xFF0A213B),
                        child: InkWell(onTap: unlockedCity
                          ? () => setState(() => _cityIndex = i)
                          : () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bu şehir henüz kilitli. Önceki şehri tamamla.'))),
                          child: SizedBox(height: 104,
                            child: Stack(children: [
                              Positioned.fill(child: Image.memory(
                                i == 0 ? _premiumCityThumbs['İstanbul']! : _premiumCityThumbs[city]!,
                                fit: BoxFit.cover)),
                              const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Color(0x44061930), Color(0xEE05162C)])))),
                              Padding(padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
                                child: Row(children: [
                                  CircleAvatar(backgroundColor: const Color(0xFFFFD77D),
                                    child: Text('${i + 1}',
                                      style: const TextStyle(color: Color(0xFF07192D),
                                        fontWeight: FontWeight.w900))),
                                  const Spacer(),
                                  Column(mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(city.toUpperCase(),
                                        style: const TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w900, fontSize: 17)),
                                      Text(unlockedCity ? '$done / 3 BÖLÜM' : 'KİLİTLİ',
                                        style: const TextStyle(color: Color(0xFFFFDB7B),
                                          fontSize: 12, fontWeight: FontWeight.bold)),
                                      Text(List.generate(3, (j) => j < done ? '★' : '☆').join(' '),
                                        style: const TextStyle(color: Color(0xFFFFD77D), fontSize: 20)),
                                    ]),
                                  const SizedBox(width: 10),
                                  Icon(unlockedCity ? Icons.chevron_right_rounded : Icons.lock,
                                    color: Colors.white),
                                ])),
                            ])),
                        ),
                      ),
                    );
                  })
              : ListView.builder(key: ValueKey('chapters_$which'),
                  padding: const EdgeInsets.fromLTRB(17, 15, 17, 25),
                  itemCount: 3,
                  itemBuilder: (context, stage) {
                    final index = which * 3 + stage;
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
