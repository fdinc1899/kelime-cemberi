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
