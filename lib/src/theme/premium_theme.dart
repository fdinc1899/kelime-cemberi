part of kelime_sehirleri;

/// Shared premium style elements for dialog surfaces and player rewards.
class PremiumPalette {
  static const navy = Color(0xFF071B32);
  static const navyLight = Color(0xFF123457);
  static const gold = Color(0xFFFFD36E);
  static const cream = Color(0xFFFFF7E6);
}

class PremiumPanel extends StatelessWidget {
  const PremiumPanel({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFF102E50), Color(0xFF07172E)],
      ),
      border: Border.all(color: PremiumPalette.gold, width: 1.6),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [BoxShadow(color: Color(0xA6000000), blurRadius: 22, offset: Offset(0, 8))],
    ),
    child: child,
  );
}

class PremiumActionButton extends StatelessWidget {
  const PremiumActionButton({super.key, required this.title,
    required this.onPressed, this.icon, this.accent = const Color(0xFF119D53)});
  final String title;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [accent, Color.lerp(accent, Colors.black, .28)!]),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: PremiumPalette.gold, width: 1.8),
      boxShadow: const [BoxShadow(color: Color(0x85000000), blurRadius: 9, offset: Offset(0, 3))],
    ),
    child: TextButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, color: Colors.white),
      label: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
    ),
  );
}
