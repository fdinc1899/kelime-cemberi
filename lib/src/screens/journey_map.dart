part of kelime_sehirleri;

/// A scrollable path through six distinct cities, each with three chapters.
/// Only the map scrolls; gameplay itself remains fixed to the phone screen.
class JourneyMapView extends StatelessWidget {
  const JourneyMapView({super.key, required this.completed, required this.unlocked,
    required this.cardBuilder});

  final int completed;
  final int unlocked;
  final Widget Function(BuildContext, int) cardBuilder;

  @override
  Widget build(BuildContext context) => Column(children: [
    const SizedBox(height: 12),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: PremiumPalette.navy,
        border: Border.all(color: PremiumPalette.gold),
        borderRadius: BorderRadius.circular(20)),
      child: Text('★  $completed / 18 BÖLÜM TAMAMLANDI  ★',
        style: const TextStyle(color: PremiumPalette.gold,
          fontWeight: FontWeight.bold, fontSize: 12)),
    ),
    Padding(padding: const EdgeInsets.fromLTRB(26, 14, 26, 3),
      child: ClipRRect(borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(value: completed / 18,
          minHeight: 8, backgroundColor: const Color(0xFF52657B),
          valueColor: const AlwaysStoppedAnimation<Color>(PremiumPalette.gold)))),
    Expanded(child: ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 40),
      itemCount: 11,
      itemBuilder: (context, index) {
        if (index.isOdd) {
          final pathIndex = index ~/ 2;
          return SizedBox(height: 47, child: Center(child: CustomPaint(
            size: const Size(115, 45),
            painter: _TrailPainter(reached: (pathIndex + 1) * 3 <= unlocked))));
        }
        final cityIndex = index ~/ 2;
        return Align(
          alignment: cityIndex.isEven ? Alignment.centerLeft : Alignment.centerRight,
          child: SizedBox(width: MediaQuery.sizeOf(context).width * .81,
            child: cardBuilder(context, cityIndex)));
      },
    )),
  ]);
}
