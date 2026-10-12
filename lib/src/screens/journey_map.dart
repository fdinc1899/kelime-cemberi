part of kelime_sehirleri;

/// Scenic six-city route. Only the map scrolls; the game screen stays fixed.
class JourneyMapView extends StatelessWidget {
  const JourneyMapView({super.key, required this.completed, required this.unlocked,
    required this.cardBuilder});

  final int completed;
  final int unlocked;
  final Widget Function(BuildContext, int) cardBuilder;

  @override
  Widget build(BuildContext context) => Column(children: [
    const SizedBox(height: 9),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF07172C), Color(0xFF183D62)]),
        border: Border.all(color: PremiumPalette.gold, width: 1.6),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Color(0x88000000), blurRadius: 12)],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.stars_rounded, color: PremiumPalette.gold, size: 20),
        const SizedBox(width: 9),
        Text('$completed / 18 BÖLÜM TAMAMLANDI',
          style: const TextStyle(color: PremiumPalette.gold,
            fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: .7)),
        const SizedBox(width: 9),
        const Icon(Icons.stars_rounded, color: PremiumPalette.gold, size: 20),
      ]),
    ),
    Padding(padding: const EdgeInsets.fromLTRB(23, 12, 23, 12),
      child: ClipRRect(borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(value: completed / 18,
          minHeight: 9, backgroundColor: const Color(0xFF52657B),
          valueColor: const AlwaysStoppedAnimation<Color>(PremiumPalette.gold)))),
    Expanded(child: LayoutBuilder(builder: (context, constraints) {
      final viewWidth = constraints.maxWidth;
      const cardSpacing = 174.0;
      const topGap = 22.0;
      final trailHeight = 6 * cardSpacing + 24;
      return ListView(children: [
        SizedBox(height: trailHeight, child: Stack(children: [
          Positioned.fill(child: CustomPaint(
            painter: _JourneyRoadPainter(reachedCities: unlocked ~/ 3))),
          for (var i = 0; i < 6; i++)
            Positioned(
              top: topGap + i * cardSpacing,
              left: i.isEven ? 6 : null,
              right: i.isOdd ? 6 : null,
              width: viewWidth * .84,
              child: cardBuilder(context, i),
            ),
        ])),
      ]);
    })),
  ]);
}

/// Winding dotted golden trail between destination cards.
class _JourneyRoadPainter extends CustomPainter {
  const _JourneyRoadPainter({required this.reachedCities});
  final int reachedCities;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final route = Path();
    Offset point(int i) => Offset(width * (i.isEven ? .25 : .75), 100 + i * 174.0);
    route.moveTo(point(0).dx, point(0).dy);
    for (var i = 0; i < 5; i++) {
      final a = point(i);
      final b = point(i + 1);
      route.cubicTo(width * (i.isEven ? 1.0 : 0.0), a.dy + 55,
        width * (i.isEven ? .0 : 1.0), b.dy - 55, b.dx, b.dy);
    }
    canvas.drawPath(route, Paint()..color = const Color(0x77000000)
      ..strokeWidth = 12..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    canvas.drawPath(route, Paint()..color = const Color(0x77F8C76D)
      ..strokeWidth = 5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7));
    for (final metric in route.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent != null) {
          final step = (d / metric.length * 5).floor();
          final unlocked = step <= reachedCities;
          canvas.drawCircle(tangent.position, unlocked ? 4.6 : 3.4,
            Paint()..color = unlocked ? const Color(0xFFFFD36E)
              : const Color(0xFFEEE3C0));
          if (unlocked && d % 7 < 4) {
            canvas.drawCircle(tangent.position, 7,
              Paint()..color = const Color(0x33FFD36E));
          }
        }
        d += 16;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _JourneyRoadPainter old) =>
      old.reachedCities != reachedCities;
}
