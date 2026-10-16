part of kelime_sehirleri;

/// V32.5 — Offline, live Adventure Center palette selector.
/// Saves under its own key: no legacy level, money, or achievement keys touched.
class V325AdventureTheme {
  static const preferenceKey = 'v325_adventure_palette';
  static final ValueNotifier<int> selected = ValueNotifier<int>(0);
  static const names = <String>[
    'Lacivert • Altın', 'Zümrüt', 'Mor Gece', 'Bordo', 'Okyanus'
  ];
  static const _backgrounds = <Color>[
    Color(0xFF061B34), Color(0xFF082A27), Color(0xFF23152F),
    Color(0xFF301820), Color(0xFF072637)
  ];
  static const _surfaces = <Color>[
    Color(0xFF123655), Color(0xFF164B43), Color(0xFF463156),
    Color(0xFF5C2C3B), Color(0xFF155368)
  ];
  static const _accents = <Color>[
    Color(0xFFFFD473), Color(0xFFC7F6D6), Color(0xFFE5C9FF),
    Color(0xFFFFD7B1), Color(0xFFACEBFF)
  ];
  static const _inks = <Color>[
    Color(0xFF071B32), Color(0xFF082A27), Color(0xFF23152F),
    Color(0xFF301820), Color(0xFF072637)
  ];
  static const _secondary = <Color>[
    Color(0xFFD8C9AA), Color(0xFFB5DCCF), Color(0xFFD8C5E6),
    Color(0xFFEAD1D0), Color(0xFFB5DDEB)
  ];
  static int get index => selected.value.clamp(0, names.length - 1).toInt();
  static Color get background => _backgrounds[index];
  static Color get surface => _surfaces[index];
  static Color get accent => _accents[index];
  static Color get ink => _inks[index];
  static Color get secondaryText => _secondary[index];
  static const Color text = Color(0xFFFFFAF2);
  static Color get panel => Color.lerp(background, surface, .25)!;
  static Color get chipBackground => const Color(0xFFFFF7ED);
  static Color get chipText => const Color(0xFF15263B);

  static void load(SharedPreferences prefs) {
    final value = (prefs.getInt(preferenceKey) ?? 0)
        .clamp(0, names.length - 1).toInt();
    if (selected.value != value) selected.value = value;
  }

  static Future<void> choose(int value) async {
    if (value < 0 || value >= names.length) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(preferenceKey, value);
    if (selected.value != value) selected.value = value;
  }

  static Future<void> showPicker(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0C1930),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)),
      builder: (sheetContext) => SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: selected,
          builder: (context, current, _) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
            child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('MACERA MERKEZİ • TEMA RENGİ',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFFFE3A6), fontSize: 18,
                  fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text('Bir renk seç. Anında uygulanır ve kaydedilir.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 16),
              for (var i = 0; i < names.length; i++) Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Material(
                  color: _backgrounds[i],
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => choose(i),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 51),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        border: Border.all(color: _accents[i],
                          width: current == i ? 2.5 : 1),
                        borderRadius: BorderRadius.circular(14)),
                      child: Row(children: [
                        Container(width: 21, height: 21,
                          decoration: BoxDecoration(color: _accents[i],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white54))),
                        const SizedBox(width: 12),
                        Expanded(child: Text(names[i],
                          style: const TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w800, fontSize: 15))),
                        if (current == i) Icon(Icons.check_circle_rounded,
                          color: _accents[i], size: 25),
                      ])),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(onPressed: () => Navigator.of(sheetContext).pop(),
                child: const Text('TAMAM',
                  style: TextStyle(color: Color(0xFFFFE3A6),
                    fontWeight: FontWeight.w900))),
            ])),
          ),
        ),
    );
  }
}

/// Replaces only the Macera Merkezi wrapper. All original interactive child
/// tabs remain live: no screenshot-overlay or duplicated button callbacks.
class V325AdventureShell extends StatelessWidget {
  const V325AdventureShell({super.key, required this.background,
    required this.onClose, required this.child});
  final Uint8List background;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Palette changes rebuild the shell AND its dynamic V29 panels.
    return ValueListenableBuilder<int>(
      valueListenable: V325AdventureTheme.selected,
      builder: (context, _, __) {
        final backgroundColor = V325AdventureTheme.background;
        final surfaceColor = V325AdventureTheme.surface;
        final accentColor = V325AdventureTheme.accent;
        final darkText = V325AdventureTheme.ink;
        final readable = Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: accentColor, brightness: Brightness.dark,
            surface: backgroundColor),
          chipTheme: ChipThemeData(
            backgroundColor: V325AdventureTheme.chipBackground,
            selectedColor: accentColor,
            secondarySelectedColor: accentColor,
            checkmarkColor: darkText,
            labelStyle: TextStyle(color: V325AdventureTheme.chipText,
              fontWeight: FontWeight.w800),
            secondaryLabelStyle: TextStyle(color: V325AdventureTheme.chipText,
              fontWeight: FontWeight.w800),
            side: BorderSide(color: accentColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12))),
          inputDecorationTheme: InputDecorationTheme(
            filled: true, fillColor: surfaceColor,
            hintStyle: TextStyle(color: V325AdventureTheme.secondaryText),
            labelStyle: TextStyle(color: accentColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: accentColor)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: accentColor, width: 2))),
        );
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          child: SizedBox.expand(child: Stack(children: [
            Positioned.fill(child: Image.memory(background,
              fit: BoxFit.cover, color: backgroundColor.withOpacity(.95),
              colorBlendMode: BlendMode.multiply)),
            Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [backgroundColor.withOpacity(.98),
                  backgroundColor.withOpacity(.95),
                  backgroundColor.withOpacity(.98)])))),
            SafeArea(child: Theme(data: readable, child: Column(children: [
              Padding(padding: const EdgeInsets.fromLTRB(13, 10, 13, 9),
                child: Row(children: [
                  Material(color: surfaceColor,
                    shape: CircleBorder(side: BorderSide(
                      color: accentColor, width: 1.8)),
                    child: IconButton(onPressed: onClose,
                      tooltip: 'Geri dön',
                      icon: Icon(Icons.arrow_back_rounded,
                        color: accentColor))),
                  const SizedBox(width: 5),
                  Expanded(child: FittedBox(fit: BoxFit.scaleDown,
                    child: Text('MACERA MERKEZİ',
                      maxLines: 1, textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'serif', fontSize: 26,
                        fontWeight: FontWeight.w900, color: accentColor)))),
                  const SizedBox(width: 5),
                  Material(color: surfaceColor,
                    shape: CircleBorder(side: BorderSide(
                      color: accentColor, width: 1.8)),
                    child: IconButton(
                      onPressed: () => V325AdventureTheme.showPicker(context),
                      tooltip: 'Tema rengini değiştir',
                      icon: Icon(Icons.palette_rounded,
                        color: accentColor))),
                ])),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Expanded(child: Divider(color: accentColor, thickness: 1)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.diamond_outlined,
                      color: accentColor, size: 20)),
                  Expanded(child: Divider(color: accentColor, thickness: 1)),
                ])),
              const SizedBox(height: 5),
              Expanded(child: child),
            ]))),
          ])),
        );
      },
    );
  }
}
