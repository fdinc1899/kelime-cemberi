part of kelime_sehirleri;

/// Native interactive ornaments that mirror the reference art direction.
/// No screenshot is used as a tap target.
class OrnateTitlePlaque extends StatelessWidget {
  const OrnateTitlePlaque({super.key, required this.eyebrow,
    required this.heading, required this.footer});
  final String eyebrow;
  final String heading;
  final String footer;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 310),
    child: SizedBox(height: 104, child: Stack(children: [
      Positioned.fill(child: CustomPaint(painter: _PlaquePainter())),
      Center(child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 11),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FittedBox(fit: BoxFit.scaleDown, child: Text(eyebrow,
            style: const TextStyle(fontSize: 9, letterSpacing: 1.2,
              color: PremiumPalette.gold, fontWeight: FontWeight.bold))),
          const SizedBox(height: 4),
          Expanded(child: FittedBox(fit: BoxFit.contain,
            child: Text(heading, textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'serif', color: PremiumPalette.cream,
                fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: .8,
                shadows: [Shadow(color: Colors.black, blurRadius: 5,
                  offset: Offset(0, 2))])))),
          Container(width: 94, height: 1, color: PremiumPalette.gold),
          const SizedBox(height: 4),
          Text(footer, style: const TextStyle(fontSize: 10,
            letterSpacing: 1.4, color: PremiumPalette.cream,
            fontWeight: FontWeight.w900)),
        ]))),
    ])),
  );
}

class _PlaquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    Path shape(double inset) {
      final a = inset + 16, b = w - inset - 16;
      return Path()
        ..moveTo(a, inset)
        ..lineTo(b, inset)
        ..quadraticBezierTo(w-inset, inset, w-inset, inset+16)
        ..lineTo(w-inset, h*.31)
        ..lineTo(w-inset+5, h*.5)
        ..lineTo(w-inset, h*.69)
        ..lineTo(w-inset, h-inset-16)
        ..quadraticBezierTo(w-inset, h-inset, b, h-inset)
        ..lineTo(a, h-inset)
        ..quadraticBezierTo(inset, h-inset, inset, h-inset-16)
        ..lineTo(inset, h*.69)
        ..lineTo(inset-5, h*.5)
        ..lineTo(inset, h*.31)
        ..lineTo(inset, inset+16)
        ..quadraticBezierTo(inset, inset, a, inset)
        ..close();
    }
    canvas.drawShadow(shape(4), const Color(0xFF000000), 8, true);
    canvas.drawPath(shape(3), Paint()..shader = const LinearGradient(
      colors: [Color(0xFF133D65), Color(0xFF06152A), Color(0xFF183C60)],
    ).createShader(Rect.fromLTWH(0, 0, w, h)));
    canvas.drawPath(shape(3), Paint()..style = PaintingStyle.stroke
      ..strokeWidth = 2.2..color = const Color(0xFFF6C76B));
    canvas.drawPath(shape(8), Paint()..style = PaintingStyle.stroke
      ..strokeWidth = .8..color = const Color(0x88FFEAB6));
    for (final x in [w*.10, w*.90]) {
      final y = h*.50;
      final star=Path()..moveTo(x,y-6)..lineTo(x+2,y-2)
        ..lineTo(x+6,y)..lineTo(x+2,y+2)..lineTo(x,y+6)
        ..lineTo(x-2,y+2)..lineTo(x-6,y)..lineTo(x-2,y-2)..close();
      canvas.drawPath(star, Paint()..color=const Color(0xFFF6CC76));
    }
  }
  @override
  bool shouldRepaint(covariant _PlaquePainter oldDelegate) => false;
}

class V10Ribbon extends StatelessWidget {
  const V10Ribbon({super.key, required this.title, this.compact = false});
  final String title;
  final bool compact;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: compact ? 66 : 76,
    width: double.infinity,
    child: Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(painter: _RibbonPainter()),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'serif',
                  color: Colors.white,
                  fontSize: compact ? 25 : 28,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w900,
                  shadows: const [
                    Shadow(color: Color(0xFF5E1016), blurRadius: 6,
                      offset: Offset(2, 3)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _RibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final y0 = h*.22; final y1 = h*.82;
    final tailLeft=Path()..moveTo(0,y0+3)..lineTo(w*.2,y0)
      ..lineTo(w*.2,y1)..lineTo(0,y1+2)
      ..lineTo(w*.075,h*.56)..close();
    final tailRight=Path()..moveTo(w,y0+3)..lineTo(w*.8,y0)
      ..lineTo(w*.8,y1)..lineTo(w,y1+2)
      ..lineTo(w*.925,h*.56)..close();
    final tailPaint=Paint()..color=const Color(0xFF831121);
    canvas.drawPath(tailLeft,tailPaint);canvas.drawPath(tailRight,tailPaint);
    final main=Path()..moveTo(w*.12,y0)..quadraticBezierTo(w*.5,y0-14,w*.88,y0)
      ..lineTo(w*.88,y1)..quadraticBezierTo(w*.5,y1+6,w*.12,y1)..close();
    canvas.drawShadow(main, Colors.black, 8,true);
    canvas.drawPath(main, Paint()..shader=const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0xFFFF744C),Color(0xFFD31D27),Color(0xFF890B26)],
    ).createShader(Rect.fromLTWH(0, y0-12, w, y1-y0+24)));
    canvas.drawPath(main, Paint()..color=const Color(0xFFFFCE69)
      ..style=PaintingStyle.stroke..strokeWidth=2);
    final highlight=Path()..moveTo(w*.14,y0+7)
      ..quadraticBezierTo(w*.5,y0-5,w*.86,y0+7);
    canvas.drawPath(highlight, Paint()..color=const Color(0x99FFEDB9)
      ..strokeWidth=1.6..style=PaintingStyle.stroke);
  }
  @override
  bool shouldRepaint(covariant _RibbonPainter oldDelegate)=>false;
}

class V10SettingsSection extends StatelessWidget {
  const V10SettingsSection({super.key, required this.icon,
    required this.label, required this.value, required this.level,
    required this.onToggle, required this.onSlide});
  final IconData icon;
  final String label;
  final bool value;
  final double level;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onSlide;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: const Color(0xEB071E39),
      border: Border.all(color: const Color(0x99DEB360)),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [BoxShadow(color: Color(0x77000000), blurRadius: 10)],
    ),
    padding: const EdgeInsets.fromLTRB(12, 9, 6, 3),
    child: Row(children: [
      Icon(icon, color: PremiumPalette.cream, size: 28),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: PremiumPalette.cream,
            fontSize: 16, fontWeight: FontWeight.w700)),
          SliderTheme(data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            activeTrackColor: PremiumPalette.gold,
            inactiveTrackColor: const Color(0xFF47617D),
            thumbColor: const Color(0xFFFFD36E)),
            child: Slider(value: level.clamp(0.0,1.0).toDouble(), onChanged: value ? onSlide : null)),
        ])),
      Switch(value: value, onChanged: onToggle,
        activeColor: Colors.white,
        activeTrackColor: PremiumPalette.gold,
        inactiveThumbColor: const Color(0xFF9AA7BA),
        inactiveTrackColor: const Color(0xFF43556D)),
    ]),
  );
}
