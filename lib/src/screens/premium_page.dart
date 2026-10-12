part of kelime_sehirleri;

/// Full-screen premium route used for settings, player profile and map.
class PremiumPageShell extends StatelessWidget {
  const PremiumPageShell({super.key, required this.title, required this.background,
    required this.onClose, required this.child});

  final String title;
  final Uint8List background;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: PremiumPalette.navy,
    insetPadding: EdgeInsets.zero,
    child: SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Stack(children: [
        Positioned.fill(child: title == 'ŞEHİR HARİTASI'
          ? Image.asset('assets/images/ui/map_backdrop_v11.webp',
              fit: BoxFit.cover, color: const Color(0x5505172A),
              colorBlendMode: BlendMode.multiply)
          : Image.memory(background, fit: BoxFit.cover,
              color: const Color(0xD905172A), colorBlendMode: BlendMode.multiply)),
        Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter, colors: [
              PremiumPalette.navy.withOpacity(title == 'ŞEHİR HARİTASI' ? .22 : .93),
              PremiumPalette.navy.withOpacity(title == 'ŞEHİR HARİTASI' ? .04 : .46),
              PremiumPalette.navy.withOpacity(title == 'ŞEHİR HARİTASI' ? .38 : .98),
            ])))),
        SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
            child: Row(children: [
              Material(color: PremiumPalette.navy,
                shape: const CircleBorder(side: BorderSide(color: PremiumPalette.gold, width: 1.6)),
                child: IconButton(onPressed: onClose, icon: const Icon(Icons.arrow_back_rounded,
                  color: PremiumPalette.cream))),
              Expanded(child: FittedBox(fit: BoxFit.scaleDown,
                child: Text('✦  $title  ✦', textAlign: TextAlign.center,
                  style: const TextStyle(color: PremiumPalette.gold, fontSize: 21,
                    fontFamily: 'serif', fontWeight: FontWeight.w900)))),
              const SizedBox(width: 48),
            ])),
          Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 18),
            color: PremiumPalette.gold.withOpacity(.67)),
          Expanded(child: child),
        ])),
      ]),
    ),
  );
}
