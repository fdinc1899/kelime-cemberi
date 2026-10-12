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
          ? Image.asset('assets/images/ui/map_backdrop_v12.webp',
              fit: BoxFit.cover, color: const Color(0x2405172A),
              colorBlendMode: BlendMode.multiply)
          : Image.memory(background, fit: BoxFit.cover,
              color: const Color(0xE005172A), colorBlendMode: BlendMode.multiply)),
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter, colors: map
              ? [const Color(0xAF032038), const Color(0x32061920), const Color(0x97041B30)]
              : [const Color(0xE905172A), const Color(0xE7071B32),
                  const Color(0xF105172A)])))),
        SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(children: [
              Material(color: const Color(0xED061B31),
                shape: const CircleBorder(side: BorderSide(
                  color: PremiumPalette.gold, width: 1.8)),
                child: IconButton(onPressed: onClose,
                  icon: const Icon(Icons.arrow_back_rounded,
                    color: PremiumPalette.cream))),
              const SizedBox(width: 8),
              Expanded(child: FittedBox(fit: BoxFit.scaleDown,
                child: Text(map ? '✦  ŞEHİR HARİTASI  ✦' : title,
                  style: TextStyle(color: map ? PremiumPalette.gold
                      : PremiumPalette.cream,
                    fontSize: 25, fontFamily: map ? 'serif' : null,
                    fontWeight: FontWeight.w900,
                    shadows: const [Shadow(color: Colors.black87, blurRadius: 9)])))),
              const SizedBox(width: 55),
            ])),
          if (map) Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 15),
            color: PremiumPalette.gold.withOpacity(.85)),
          Expanded(child: child),
        ])),
      ])),
    );
  }
}
