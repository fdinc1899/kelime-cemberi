part of kelime_sehirleri;

/// V18: decorative elements are painted natively; controls remain accessible.
class V18GoldDivider extends StatelessWidget {
  const V18GoldDivider({super.key, this.padding = 8});
  final double padding;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: padding, horizontal: 14),
    child: Row(children: [
      Expanded(child: Container(height: 1, decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.transparent,
          Color(0xFFFFD477)])))),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 8),
        child: Icon(Icons.diamond_outlined, size: 14,
          color: Color(0xFFFFDC7D))),
      Expanded(child: Container(height: 1, decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFFFD477),
          Colors.transparent])))),
    ]),
  );
}

class V18SparklingBackdrop extends StatelessWidget {
  const V18SparklingBackdrop({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Stack(children: [
    Positioned.fill(child: IgnorePointer(child: CustomPaint(
      painter: _V18FleckPainter()))),
    child,
  ]);
}

class _V18FleckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 34; i++) {
      final x = ((i * 79 + 19) % 113) / 113 * size.width;
      final y = ((i * 47 + 7) % 127) / 127 * size.height;
      final r = i % 5 == 0 ? 2.0 : 0.8;
      p.color = i % 3 == 0 ? const Color(0xCCFFE39D) :
        const Color(0x66FFF5D3);
      canvas.drawCircle(Offset(x, y), r, p);
      if (i % 6 == 0) {
        p..color = const Color(0xB6FFE3A0)..strokeWidth = .8;
        canvas.drawLine(Offset(x - 5, y), Offset(x + 5, y), p);
        canvas.drawLine(Offset(x, y - 5), Offset(x, y + 5), p);
      }
    }
  }
  @override
  bool shouldRepaint(covariant _V18FleckPainter old) => false;
}

class V18GildedPanel extends StatelessWidget {
  const V18GildedPanel({super.key, required this.child, this.padding = const EdgeInsets.all(17)});
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      gradient: const LinearGradient(begin: Alignment.topLeft,
        end: Alignment.bottomRight, colors: [
          Color(0xFF1B3A5C), Color(0xFF031225), Color(0xFF0B2B4A)]),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFFFDA7F), width: 2.0),
      boxShadow: const [
        BoxShadow(color: Color(0xE0000000), blurRadius: 26,
          offset: Offset(0, 11)),
        BoxShadow(color: Color(0x88FFA726), blurRadius: 15,
          spreadRadius: -7),
      ],
    ),
    child: V18SparklingBackdrop(child: child),
  );
}

class V18MenuLine extends StatelessWidget {
  const V18MenuLine({super.key, required this.icon,
    required this.title, required this.onTap, this.trailing});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Material(color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF183B5B), Color(0xFF061729)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEDC66C), width: 1.2),
            boxShadow: const [BoxShadow(color: Color(0x77000000),
              blurRadius: 8, offset: Offset(0, 3))],
          ),
          child: Padding(padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            child: Row(children: [
              Icon(icon, color: const Color(0xFFFFD677), size: 24),
              const SizedBox(width: 14),
              Expanded(child: Text(title,
                style: const TextStyle(color: Color(0xFFFFF4D4),
                  fontFamily: 'serif', fontWeight: FontWeight.w700,
                  fontSize: 16))),
              if (trailing != null) Text(trailing!,
                style: const TextStyle(color: Color(0xFFFFD677), fontSize: 12)),
              const SizedBox(width: 7),
              const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFFFD677)),
            ]),
          ),
        ),
      ),
    ),
  );
}

/// Interactive, full-width scenic cards for every province, not a screenshot.
class V18ProvinceCard extends StatelessWidget {
  const V18ProvinceCard({super.key, required this.province,
    required this.index, required this.unlocked, required this.done,
    required this.completed, required this.onTap});
  final ProvinceInfo province;
  final int index;
  final bool unlocked;
  final int done;
  final Set<int> completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 112,
          decoration: BoxDecoration(
            color: const Color(0xFF031427),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFD475), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0xB8000000), blurRadius: 14,
                offset: Offset(0, 6)),
              BoxShadow(color: Color(0x70FFCC48), blurRadius: 9, spreadRadius: -3),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: LayoutBuilder(builder: (context, region) => Stack(children: [
            Positioned(left: 0, top: 0, bottom: 0,
              width: region.maxWidth * .83,
              child: Image(image: _citySelectionImageProvider(province),
                fit: BoxFit.cover, alignment: Alignment.centerLeft,
                filterQuality: FilterQuality.high)),
            const Positioned.fill(child: DecoratedBox(
              decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0, .37, .66, .84, 1],
                colors: [Color(0x09001428), Color(0x18001428),
                  Color(0xD8061A32), Color(0xFC04152C), Color(0xFF05152A)])))),
            Positioned(left: 12, top: 0, bottom: 0,
              child: Center(child: Container(
                width: 47, height: 47, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [
                    Color(0xFFFFF6C8), Color(0xFFFFD064), Color(0xFFE6A82C)]),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [BoxShadow(color: Color(0xDD000000), blurRadius: 6)]),
                child: Text('${index+1}', style: const TextStyle(
                  fontWeight: FontWeight.w900, fontSize: 22,
                  color: Color(0xFF06182D))),
              ))),
            Positioned(right: 10, top: 7, bottom: 8,
              width: region.maxWidth * .47,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(fit: BoxFit.scaleDown,
                    child: Text(province.province.toUpperCase(),
                      maxLines: 1, textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.white,
                        fontSize: 20, fontWeight: FontWeight.w900,
                        shadows: [Shadow(color: Colors.black, blurRadius: 5)]))),
                  const SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Flexible(child: FittedBox(child: Text(
                      unlocked ? '$done / 3 BÖLÜM' : 'KİLİTLİ',
                      style: const TextStyle(color: Color(0xFFFFD777),
                        fontWeight: FontWeight.w800, fontSize: 13)))),
                    const SizedBox(width: 6),
                    Icon(unlocked ? Icons.chevron_right_rounded : Icons.lock_rounded,
                      color: Colors.white, size: 22),
                  ]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(3, (j) => Icon(
                      completed.contains(province.levels[j])
                        ? Icons.star_rounded : Icons.star_border_rounded,
                      color: const Color(0xFFFFD777), size: 23))),
                ],
              ),
            ),
          ])),
        ),
      ),
    ),
  );
}
