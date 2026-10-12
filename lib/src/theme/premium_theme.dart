part of kelime_sehirleri;

/// Shared premium style elements for dialog surfaces and player rewards.
class PremiumPalette {
  static const navy = Color(0xFF071B32);
  static const navyLight = Color(0xFF123457);
  static const gold = Color(0xFFFFD36E);
  static const cream = Color(0xFFFFF7E6);
}

/// Glossy, touchable panels and buttons: built in Flutter rather than using
/// flat screenshot images. Shared by map, settings, rewards and profile.
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
        colors: [Color(0xFF15375C), Color(0xFF061324), Color(0xFF0A2847)],
        stops: [.0, .57, 1],
      ),
      border: Border.all(color: const Color(0xFFFFD46D), width: 1.9),
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(color: Color(0xCC000000), blurRadius: 28, offset: Offset(0, 10)),
        BoxShadow(color: Color(0x66F2B94A), blurRadius: 10, spreadRadius: -6),
      ],
    ),
    child: child,
  );
}

class PremiumActionButton extends StatelessWidget {
  const PremiumActionButton({super.key, required this.title,
    required this.onPressed, this.icon, this.accent = const Color(0xFF109743)});
  final String title;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isRed = accent.red > accent.green * 1.4;
    final top = isRed ? const Color(0xFFFF6E63) :
      accent.blue > accent.green ? const Color(0xFF4EBDFF) : const Color(0xFF7BFF98);
    final mid = isRed ? const Color(0xFFDC1B20) :
      accent.blue > accent.green ? const Color(0xFF0860B4) : const Color(0xFF05B348);
    final bottom = isRed ? const Color(0xFF7E0718) :
      accent.blue > accent.green ? const Color(0xFF05295C) : const Color(0xFF046026);
    return Opacity(
      opacity: onPressed == null ? .55 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(35),
          child: Container(
            constraints: const BoxConstraints(minHeight: 47),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: const Color(0xFFFCE6A2), width: 1.65),
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [top, mid, bottom], stops: const [0, .34, 1],
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x9C000000), blurRadius: 8, offset: Offset(0, 4)),
                BoxShadow(color: Color(0x65FFD76A), blurRadius: 6, spreadRadius: -2),
              ],
            ),
            child: Stack(children: [
              Positioned(top: 0, left: 9, right: 9, height: 1,
                child: DecoratedBox(decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.78),
                  borderRadius: BorderRadius.circular(20)))),
              Row(mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, children: [
                if (icon != null) ...[Icon(icon, color: Colors.white, size: 20), const SizedBox(width: 8)],
                Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 16,
                    fontWeight: FontWeight.w900,
                    shadows: [Shadow(color: Color(0xB3000000), blurRadius: 3,
                      offset: Offset(0, 2))])))),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}
