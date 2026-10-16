part of kelime_sehirleri;

class _TrailPainter extends CustomPainter {
  final bool reached;
  const _TrailPainter({required this.reached});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = reached ? const Color(0xFFD39C3C) : const Color(0xFFBFB4A5)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (double y = 0; y < size.height - 3; y += 9) {
      final x = size.width / 2 + math.sin(y / size.height * math.pi * 1.6) * size.width * .28;
      final y2 = math.min(y + 5, size.height);
      final x2 = size.width / 2 + math.sin(y2 / size.height * math.pi * 1.6) * size.width * .28;
      canvas.drawLine(Offset(x, y), Offset(x2, y2), paint);
    }
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 4,
      Paint()..color = reached ? const Color(0xFFFAD275) : const Color(0xFFD7C9B9));
  }
  @override
  bool shouldRepaint(covariant _TrailPainter old) => old.reached != reached;
}

// Özgün altın çerçeveli, sürüklemeyle seçilen harf tekerleği.
class LetterWheelPainter extends CustomPainter {
  final List<String> letters;
  final List<int> selected;
  final int themeIndex;
  LetterWheelPainter(this.letters, this.selected, {this.themeIndex = 0});

  static Offset centerFor(int i, int count, double size) {
    final angle = -math.pi / 2 + math.pi * 2 * i / count;
    return Offset(size / 2 + math.cos(angle) * size * .345,
        size / 2 + math.sin(angle) * size * .345);
  }

  static int? hitLetter(Offset local, double size, int count) {
    for (int i = 0; i < count; i++) {
      if ((centerFor(i, count, size) - local).distance <= size * .125) {
        return i;
      }
    }
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final midpoint = Offset(s / 2, s / 2);
    final rimColors = themeIndex == 1
      ? const [Color(0xFFAAF8EB), Color(0xFF26A98F),
          Color(0xFFBDFFF2), Color(0xFF137967)]
      : themeIndex == 2
      ? const [Color(0xFFD9C8FF), Color(0xFF8662D3),
          Color(0xFFE8DEFF), Color(0xFF5C419E)]
      : const [Color(0xFFFFF1B6), Color(0xFFD99A22),
          Color(0xFFFFE7A0), Color(0xFFBE7E13)];
    final baseColor = themeIndex == 1 ? const Color(0xFFDDFCF6) :
      themeIndex == 2 ? const Color(0xFFF3EDFF) : const Color(0xFFFFEFD7);
    final accentColor = themeIndex == 1 ? const Color(0xFF148876) :
      themeIndex == 2 ? const Color(0xFF7955BF) : const Color(0xFFC88E22);
    canvas.drawCircle(midpoint + const Offset(0, 5), s * .485,
        Paint()..color = const Color(0x66000000));
    canvas.drawCircle(midpoint, s * .49, Paint()
      ..shader = LinearGradient(begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: rimColors)
          .createShader(Rect.fromLTWH(0, 0, s, s)));
    canvas.drawCircle(midpoint, s * .465,
        Paint()..color = const Color(0xFFFFF4E2));
    canvas.drawCircle(midpoint, s * .45,
        Paint()..color = baseColor);
    canvas.drawCircle(midpoint, s * .46,
        Paint()..style = PaintingStyle.stroke
          ..strokeWidth = 1.7..color = accentColor);

    if (selected.length > 1) {
      final path = Path();
      for (var i = 0; i < selected.length; i++) {
        final p = centerFor(selected[i], letters.length, s);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(path, Paint()
        ..color = accentColor.withOpacity(.83)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = s * .036
        ..style = PaintingStyle.stroke);
    }
    for (var i = 0; i < letters.length; i++) {
      final p = centerFor(i, letters.length, s);
      final active = selected.contains(i);
      final r = s * .115;
      canvas.drawCircle(p + const Offset(0, 3), r,
          Paint()..color = const Color(0x44281714));
      canvas.drawCircle(p, r, Paint()
        ..shader = LinearGradient(begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: active
                ? [rimColors.first, rimColors[1]]
                : const [Colors.white, Color(0xFFF3ECE5)])
            .createShader(Rect.fromCircle(center: p, radius: r)));
      canvas.drawCircle(p, r, Paint()
          ..color = const Color(0xFFD6C5AF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0);
      final t = TextPainter(
        text: TextSpan(text: letters[i], style: TextStyle(
            color: const Color(0xFF0D2A4A),
            fontSize: s * .105, fontWeight: FontWeight.w900)),
        textDirection: TextDirection.ltr,
      )..layout();
      t.paint(canvas, p - Offset(t.width / 2, t.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant LetterWheelPainter old) =>
      old.letters.join() != letters.join() ||
      old.selected.join(',') != selected.join(',') ||
      old.themeIndex != themeIndex;
}

class ScenicCityPainter extends CustomPainter {
  const ScenicCityPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(sky, Paint()..shader = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0xFF78A7B5), Color(0xFFDBB28C), Color(0xFF4F7283), Color(0xFF243D4B)],
      stops: [0, .33, .6, 1],
    ).createShader(sky));

    final sun = Offset(size.width * .77, size.height * .21);
    canvas.drawCircle(sun, size.width * .2, Paint()..shader = RadialGradient(
      colors: const [Color(0xAAFFECC2), Color(0x00FFD7AB)],
    ).createShader(Rect.fromCircle(center: sun, radius: size.width * .2)));
    canvas.drawCircle(sun, size.width * .055,
      Paint()..color = const Color(0xFFFFE3B7));

    // Şehrin özgün, stilize silüeti: harici resim ve internet gerektirmez.
    _skyline(canvas, size, y: .41, seed: 8, color: const Color(0xFF718391), scale: .74);
    _skyline(canvas, size, y: .48, seed: 17, color: const Color(0xFF4B6476), scale: 1);
    final waterTop = size.height * .52;
    canvas.drawRect(Rect.fromLTWH(0, waterTop, size.width, size.height - waterTop),
      Paint()..color = const Color(0xFF314D5C));
    final random = math.Random(14);
    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width;
      final y = waterTop + random.nextDouble() * (size.height - waterTop) * .65;
      canvas.drawLine(Offset(x, y), Offset(x + 4 + random.nextDouble() * 26, y),
        Paint()..color = const Color(0x55E6B98A)..strokeWidth = 1);
    }
    _skyline(canvas, size, y: .64, seed: 24, color: const Color(0xFF1C3546), scale: 1.45);
  }

  void _skyline(Canvas canvas, Size size, {
    required double y, required int seed, required Color color, required double scale}) {
    final random = math.Random(seed);
    final bottom = size.height * y;
    double x = -8;
    while (x < size.width + 15) {
      final w = (14 + random.nextInt(24)) * scale;
      final h = (24 + random.nextInt(66)) * scale;
      canvas.drawRect(Rect.fromLTWH(x, bottom - h, w, h), Paint()..color = color);
      if (random.nextBool()) {
        canvas.drawRect(Rect.fromLTWH(x + w * .45, bottom - h - 10, w * .1, 10),
          Paint()..color = color);
      }
      for (double wy = bottom - h + 10; wy < bottom - 5; wy += 12) {
        for (double wx = x + 6; wx < x + w - 4; wx += 10) {
          if (random.nextInt(4) == 0) {
            canvas.drawRect(Rect.fromLTWH(wx, wy, 2.8, 4),
              Paint()..color = const Color(0xA3FFD8A1));
          }
        }
      }
      x += w + 2;
    }
  }

  @override
  bool shouldRepaint(covariant ScenicCityPainter oldDelegate) => false;
}


class CelebrationPainter extends CustomPainter {
  final double progress;
  CelebrationPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(199);
    final colors = <Color>[
      const Color(0xFFFFD36E), const Color(0xFFF6A65D),
      const Color(0xFFFDF4D0),const Color(0xFF70D6A6),
      const Color(0xFFFF859B),
    ];
    for (int i = 0; i < 84; i++) {
      final a = random.nextDouble()*math.pi*2;
      final speed = (85+random.nextDouble()*280);
      final cx = size.width*.5 + math.cos(a)*speed*progress;
      final cy = size.height*.39 + math.sin(a)*speed*progress + progress*progress*230;
      final length = 3 + random.nextDouble()*7;
      final opacity = progress > .8 ? ((1-progress)/.2).clamp(0,1).toDouble() : 1.0;
      final p=Paint()..color=colors[i%colors.length].withOpacity(opacity);
      canvas.save();
      canvas.translate(cx,cy);
      canvas.rotate(a + progress * 3);
      canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center:Offset.zero,width:length,height:length*1.6),
        const Radius.circular(1)),p);
      canvas.restore();
    }
  }
  @override
  bool shouldRepaint(covariant CelebrationPainter oldDelegate) => oldDelegate.progress != progress;
}
