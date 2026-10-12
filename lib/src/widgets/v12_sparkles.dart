part of kelime_sehirleri;

/// Golden rays and stars for reward/bonus panels. Painter is decorative only;
/// interactive buttons are separate widgets.
class V12SparklePainter extends CustomPainter {
  const V12SparklePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * .54);
    final halo = Rect.fromCircle(center: center,
        radius: size.shortestSide * .58);
    canvas.drawOval(halo, Paint()..shader = const RadialGradient(colors: [
      Color(0x99FFE98B), Color(0x55F3A32C), Color(0x00FFB428),
    ]).createShader(halo));
    final random = math.Random(8741);
    for (var i = 0; i < 32; i++) {
      final angle = 2 * math.pi * random.nextDouble();
      final r = size.shortestSide * (.19 + random.nextDouble() * .38);
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      final radius = 1.5 + random.nextDouble() * 3.8;
      final path = Path()
        ..moveTo(x, y - radius * 2)
        ..quadraticBezierTo(x + radius * .35, y - radius * .35,
          x + radius * 1.7, y)
        ..quadraticBezierTo(x + radius * .35, y + radius * .35,
          x, y + radius * 2)
        ..quadraticBezierTo(x - radius * .35, y + radius * .35,
          x - radius * 1.7, y)
        ..quadraticBezierTo(x - radius * .35, y - radius * .35,
          x, y - radius * 2)..close();
      canvas.drawPath(path, Paint()..color = i.isEven
        ? const Color(0xFFFFE7A4) : const Color(0xFFF5AF35));
    }
  }
  @override
  bool shouldRepaint(covariant V12SparklePainter oldDelegate) => false;
}

class V12PillButton extends StatelessWidget {
  const V12PillButton({super.key, required this.label,
    required this.onPressed, this.danger = false});
  final String label;
  final VoidCallback onPressed;
  final bool danger;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter, colors: danger
              ? const [Color(0xFFFF6C5E),Color(0xFFB70B1B),Color(0xFF650817)]
              : const [Color(0xFF58A9EC),Color(0xFF0D4E9E),Color(0xFF051C4C)]),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFFFD36E), width: 1.4),
          boxShadow: const [BoxShadow(color: Color(0x99000000), blurRadius: 8,
            offset: Offset(0, 4))],
        ),
        child: Text(label, style: const TextStyle(color: Colors.white,
          fontWeight: FontWeight.w900, fontSize: 13)),
      ),
    ),
  );
}
