part of kelime_sehirleri;

/// Full screen native premium pages, each row retains actual touch callbacks.
class PremiumPageShell extends StatelessWidget {
  const PremiumPageShell({super.key, required this.title,
    required this.background, required this.onClose, required this.child});
  final String title;
  final Uint8List background;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (title == 'MACERA MERKEZİ') {
      return V325AdventureShell(background: background,
        onClose: onClose, child: child);
    }
    final map = title == 'ŞEHİR HARİTASI';
    return Dialog(
      backgroundColor: PremiumPalette.navy,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(children: [
        Positioned.fill(child: map
          ? Image.asset('assets/images/cities/antalya.webp',
              fit: BoxFit.cover, color: const Color(0x2805172A),
              colorBlendMode: BlendMode.multiply)
          : Image.memory(background, fit: BoxFit.cover,
              color: const Color(0xE005172A), colorBlendMode: BlendMode.multiply)),
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter, colors: map
              ? [const Color(0x90031A30), const Color(0x0C051A2C), const Color(0x51031A2D)]
              : [const Color(0xE905172A), const Color(0xE7071B32),
                  const Color(0xF105172A)])))),
        SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Row(children: [
              Material(color: const Color(0xED061B31),
                shape: const CircleBorder(side: BorderSide(
                  color: PremiumPalette.gold, width: 1.8)),
                child: IconButton(onPressed: onClose,
                  icon: const Icon(Icons.arrow_back_rounded,
                    color: PremiumPalette.cream))),
              const SizedBox(width: 8),
              Expanded(child: Container(
                constraints: const BoxConstraints(minHeight: 45),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: map ? BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF163D5D),
                    Color(0xFF061628), Color(0xFF153958)]),
                  border: Border.all(color: PremiumPalette.gold, width: 1.8),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 8)],
                ) : null,
                child: Center(child: FittedBox(fit: BoxFit.scaleDown,
                  child: Text(map ? '✦ ŞEHİR HARİTASI ✦' : title,
                    style: const TextStyle(color: PremiumPalette.gold,
                      fontSize: 23, fontFamily: 'serif',
                      fontWeight: FontWeight.w900,
                      shadows: const [Shadow(color: Colors.black87, blurRadius: 9)])))))),
              const SizedBox(width: 55),
            ])),
          const V18GoldDivider(padding: 6),
          Expanded(child: child),
        ])),
      ])),
    );
  }
}

// V318_ADVENTURE: premium legible layout for Macera Merkezi only.
class _V318AdventurePage extends StatelessWidget {
  const _V318AdventurePage({required this.background, required this.onClose,
    required this.child});
  final Uint8List background;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD477);
    const navy = Color(0xFF071A35);
    final base = Theme.of(context);
    // KEY FIX: pale/yellow chip surfaces always use dark text & icons.
    final readable = base.copyWith(
      chipTheme: const ChipThemeData(
        backgroundColor: Color(0xFFFFF5E5),
        disabledColor: Color(0xFFD5CDCA),
        selectedColor: gold,
        secondarySelectedColor: gold,
        checkmarkColor: navy,
        labelStyle: TextStyle(color: navy, fontWeight: FontWeight.w800,
          fontSize: 12),
        secondaryLabelStyle: TextStyle(color: navy, fontWeight: FontWeight.w800),
        side: BorderSide(color: Color(0xFFCCA355), width: 1),
        shape: RoundedRectangleBorder(borderRadius:
          BorderRadius.all(Radius.circular(11))),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true, fillColor: Color(0xFF0A2547),
        hintStyle: TextStyle(color: Color(0xFFDCCAA7)),
        labelStyle: TextStyle(color: gold),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gold, width: 1.2)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gold, width: 2)),
      ),
    );
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: navy,
      child: SizedBox.expand(child: Stack(children: [
        Positioned.fill(child: Image.memory(background,
          fit: BoxFit.cover, color: const Color(0xF0071832),
          colorBlendMode: BlendMode.multiply)),
        const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xF3071C35), Color(0xF6081C34),
              Color(0xF9081932)])))),
        SafeArea(child: Theme(data: readable,
          child: Column(children: [
            Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(children: [
                Material(color: const Color(0xFF092444),
                  shape: const CircleBorder(side: BorderSide(color: gold,
                    width: 1.8)),
                  child: IconButton(onPressed: onClose,
                    icon: const Icon(Icons.arrow_back_rounded, color: gold))),
                const SizedBox(width: 5),
                Expanded(child: FittedBox(fit: BoxFit.scaleDown,
                  child: const Text('MACERA MERKEZİ',
                    maxLines: 1, textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'serif', fontSize: 27,
                      fontWeight: FontWeight.w900, color: gold,
                      shadows: [Shadow(color: Colors.black,
                        blurRadius: 5)])))),
                const SizedBox(width: 42),
              ])),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(children: [
                Expanded(child: Divider(color: gold, thickness: .9)),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.diamond_outlined, color: gold, size: 19)),
                Expanded(child: Divider(color: gold, thickness: .9)),
              ])),
            const SizedBox(height: 7),
            Expanded(child: child),
          ]))),
      ])),
    );
  }
}
