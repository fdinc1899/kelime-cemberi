part of kelime_sehirleri;

/// V12: a real, tappable scenic route; no flattened screenshot as an interface.
class JourneyMapView extends StatelessWidget {
  const JourneyMapView({super.key, required this.completed,
    required this.unlocked, required this.cardBuilder});

  final int completed;
  final int unlocked;
  final Widget Function(BuildContext, int) cardBuilder;

  @override
  Widget build(BuildContext context) => Column(children: [
    const SizedBox(height: 7),
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xED071A31),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: PremiumPalette.gold, width: 1.4),
        boxShadow: const [BoxShadow(color: Color(0x99000000), blurRadius: 14)],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.stars_rounded, color: PremiumPalette.gold, size: 19),
        const SizedBox(width: 9),
        Text('$completed / 243 TAMAMLANAN BÖLÜM',
          style: const TextStyle(color: PremiumPalette.cream,
            fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: .35)),
        const SizedBox(width: 9),
        const Icon(Icons.stars_rounded, color: PremiumPalette.gold, size: 19),
      ]),
    ),
    const SizedBox(height: 8),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ClipRRect(borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(value: completed / 243,
          backgroundColor: const Color(0x99051D34), minHeight: 6,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC95F))))),
    const SizedBox(height: 4),
    Expanded(child: ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 25),
      itemCount: _provinces.length * 2 - 1,
      itemBuilder: (context, position) {
        if (position.isOdd) {
          final index = position ~/ 2;
          return SizedBox(height: 30,
            child: CustomPaint(painter: _ShortProvinceRoadPainter(
              leftToRight: index.isEven,
              open: _cityOpen(_provinces[index + 1], unlocked))));
        }
        final index = position ~/ 2;
        return Align(
          alignment: index.isEven ? Alignment.centerLeft : Alignment.centerRight,
          child: SizedBox(width: MediaQuery.sizeOf(context).width * .90,
            height: 102, child: cardBuilder(context, index)),
        );
      },
    )),
  ]);
}

class _JourneyRoadPainter extends CustomPainter {
  const _JourneyRoadPainter({required this.reachedCities, required this.stepHeight});
  final int reachedCities;
  final double stepHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final route = Path();
    Offset pin(int i) => Offset(size.width * (i.isEven ? .32 : .68),
        57 + i * stepHeight);
    route.moveTo(pin(0).dx, pin(0).dy);
    for (var i = 0; i < 5; i++) {
      final a = pin(i);
      final b = pin(i + 1);
      route.cubicTo(size.width * (i.isEven ? .98 : .02), a.dy + 58,
          size.width * (i.isEven ? .02 : .98), b.dy - 58, b.dx, b.dy);
    }
    canvas.drawPath(route, Paint()..color = const Color(0xB5031022)
      ..style = PaintingStyle.stroke..strokeWidth = 14);
    canvas.drawPath(route, Paint()..color = const Color(0xFFB46F12)
      ..style = PaintingStyle.stroke..strokeWidth = 8);
    canvas.drawPath(route, Paint()..color = const Color(0xFFFFE9A5)
      ..style = PaintingStyle.stroke..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    for (final metric in route.computeMetrics()) {
      double d = 5;
      while (d < metric.length) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent != null) {
          final progress = d / metric.length;
          final active = progress <= reachedCities / 5.0;
          canvas.drawCircle(tangent.position, active ? 4 : 3,
            Paint()..color = active ? const Color(0xFFFFE997)
              : const Color(0xFFD2BD93));
        }
        d += 18;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _JourneyRoadPainter old) =>
    old.reachedCities != reachedCities || old.stepHeight != stepHeight;
}


class _ShortProvinceRoadPainter extends CustomPainter {
  const _ShortProvinceRoadPainter({required this.leftToRight, required this.open});
  final bool leftToRight;
  final bool open;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final a = leftToRight ? size.width*.28 : size.width*.72;
    final b = leftToRight ? size.width*.72 : size.width*.28;
    path.moveTo(a, 0);
    path.quadraticBezierTo(size.width*.5, size.height*.5, b, size.height);
    canvas.drawPath(path, Paint()..color = const Color(0xFF987035)
      ..strokeWidth = 8..style = PaintingStyle.stroke);
    for (final metric in path.computeMetrics()) {
      for (double k = 3; k < metric.length; k += 9) {
        final point = metric.getTangentForOffset(k)?.position;
        if (point != null) canvas.drawCircle(point, 2.8,
          Paint()..color = open ? const Color(0xFFFFE191) : const Color(0xFF877D71));
      }
    }
  }
  @override
  bool shouldRepaint(covariant _ShortProvinceRoadPainter old) =>
      old.leftToRight != leftToRight || old.open != open;
}
