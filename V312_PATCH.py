#!/usr/bin/env python3
"""V31.2 additive fixes. No game progress keys, ids or icon changes."""
from pathlib import Path
import re, sys, shutil, datetime
root = Path.cwd()
game = root / 'lib/src/screens/game_screen.dart'
world = root / 'lib/src/features/v31_world.dart'
province = root / 'lib/src/data/provinces.dart'
files = [game,world,province]
for f in files:
    if not f.is_file(): sys.exit('V31.2: Dosya eksik: '+str(f))
source={f:f.read_text(encoding='utf-8') for f in files}
if ('V312RewardStars(stars: stars)' in source[game] and
        'V312_ADAPTIVE' in source[world] and 'V312_CINEMATIC' in source[world]):
    print('V31.2 zaten kurulu. Tekrar degisiklik yapilmadi.')
    sys.exit(0)
if ('V312RewardStars(stars: stars)' in source[game] or
        'V312_ADAPTIVE' in source[world] or 'V312_CINEMATIC' in source[world]):
    sys.exit('V31.2: YARIM kurulum bulundu. Dosyalar otomatik degistirilmedi.')

def replace_once(txt, old, new, name):
    if txt.count(old)!=1:
        sys.exit(f'V31.2: Beklenen Flutter kodu bulunamadi ({name}); {txt.count(old)} eslesme. Dosyalar korunuyor.')
    return txt.replace(old,new,1)

w=source[world]
# Prev build compile fix, do not regress.
if "final data = <String, Object>{};" in w:
    w=replace_once(w, "final data = <String, Object>{};", "final data = <String, Object?>{};",'backup Object?')
elif "final data = <String, Object?>{};" not in w:
    sys.exit('V31.2: V31 yerel yedek kodu bulunamadi.')

# Shared celebration animation widget, inserted before V31 world UI.
star_class='''// V312_CINEMATIC — staged reward stars; never changes awarded coins.
class V312RewardStars extends StatelessWidget {
  const V312RewardStars({super.key, required this.stars});
  final int stars;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (i) => TweenAnimationBuilder<double>(
      key: ValueKey('v312_reward_star_$i'),
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 520 + 210 * i),
      curve: Curves.elasticOut,
      builder: (context, v, _) => Transform.scale(
        scale: v.clamp(0.0, 1.35).toDouble(),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Icon(i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
            size: i == 1 ? 62 : 49,
            color: const Color(0xFFFFD36E))),
      ),
    )),
  );
}

'''
w=replace_once(w,'class V31WorldCenter extends StatefulWidget {',star_class+'class V31WorldCenter extends StatefulWidget {','add animated star widget')
# Animate the 81 city preview and scale images gracefully; preserve image selection routing.
w=replace_once(w,'''        Image(image: _citySelectionImageProvider(city), fit: BoxFit.cover,
''','''        Image(image: _citySelectionImageProvider(city), fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
''','city preview rendering')
# Adaptive challenge helper: do not change fixed answers, IDs, saved status or previous payouts.
w=replace_once(w,'''  Set<int> _treasures = <int>{};
''','''  Set<int> _treasures = <int>{};
  // V312_ADAPTIVE: wrong attempts affect hints but NEVER the saved answer or ID.
  final Map<int, int> _v312Wrong = <int, int>{};
  int get _v312Tier => _challengeSlot < 4 ? 0 : (_challengeSlot < 9 ? 1 : 2);
  int get _v312Reward => _v312Tier == 0 ? 3 : (_v312Tier == 1 ? 5 : 8);
  String get _v312TierName => const ['KOLAY', 'ORTA', 'ZOR'][_v312Tier];
  String _v312Hint(int id) {
    final misses = _v312Wrong[id] ?? 0;
    final answer = v31ChallengeAnswer(id);
    final needed = _v312Tier == 0 ? 0 : (_v312Tier == 1 ? 2 : 4);
    if (misses < needed) return 'İpucu $needed yanlış denemeden sonra açılır.';
    if (misses >= needed + 3 && answer.length > 3) {
      return 'İPUCU: ${answer[0]}${List.filled(answer.length - 2, '·').join()}${answer[answer.length - 1]}';
    }
    return 'İPUCU: ${answer[0]} ile başlayan ${answer.length} harfli kelime';
  }
''','challenge state')
w=replace_once(w,'''    if (entered != v31ChallengeAnswer(_challengeIndex)) {
      _notice('Kelime henüz doğru değil. Tekrar dene.');
      return;
    }
''','''    if (entered != v31ChallengeAnswer(_challengeIndex)) {
      setState(() => _v312Wrong.update(_challengeIndex,
        (old) => old + 1, ifAbsent: () => 1));
      _notice('Tekrar dene. Gerekirse yeni ipucunu kullan.');
      return;
    }
''','wrong attempts')
w=replace_once(w, '    final id = _challengeIndex;\n    setState(() => _busy = true);', '    final id = _challengeIndex;\n    final reward = _v312Reward;\n    setState(() => _busy = true);', 'reward snapshot')
w=replace_once(w,"    widget.onReward(3, 'MARATON +3');", "    widget.onReward(reward, 'MARATON +$reward');", 'tier based reward')
w=replace_once(w,"_text('${_marathonDone.length} / $v31ChallengeCount tamamlandı · Her görev +3 altın'),", "_text('${_marathonDone.length} / $v31ChallengeCount tamamlandı · Zorluğa göre 3–8 altın'),", 'reward description')
w=replace_once(w,'''        _text('${v31ChallengeAnswer(_challengeIndex).length} harf · '
          'Kolay / Orta / Zor görev serisi', color: Colors.white70),
''','''        _text('${v31ChallengeAnswer(_challengeIndex).length} harf · '
          '$_v312TierName · +$_v312Reward altın', color: _v31Gold),
        const SizedBox(height: 5),
        AnimatedSwitcher(duration: const Duration(milliseconds: 280),
          child: Text(_v312Hint(_challengeIndex),
            key: ValueKey('${_challengeIndex}_${_v312Wrong[_challengeIndex] ?? 0}'),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center)),
''','adaptive hint UI')
w=replace_once(w,"_text('Bu 1053 aşama, şehir başına 13 kayıtlı kelime görevidir. '","""_text('Zorluk 1–4 kolay, 5–9 orta, 10–13 zor. Takılırsan ipucu açılır. '
          'Bu 1053 aşama, şehir başına 13 kayıtlı kelime görevidir. '""", 'hint description')
source[world]=w

g=source[game]
# V31 city picture: fade + zoom on each selected scene transition.
g=replace_once(g,'''          Positioned.fill(
            child: V31LivingBackdrop(
              night: _v31Night,
              child: _cityImageWidget(_puzzle.city),
            ),
          ),''','''          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 740),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: .985, end: 1).animate(animation),
                  child: child)),
              child: V31LivingBackdrop(
                key: ValueKey('v312_city_${_puzzle.city}'),
                night: _v31Night,
                child: _cityImageWidget(_puzzle.city),
              ),
            ),
          ),''','game city image transition')
# Current result has static stars; replace strictly inside result dialog.
g=replace_once(g,'''              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => _goldStar(i, stars,
                  size: i == 1 ? 67 : 51))),''','''              V312RewardStars(stars: stars),''','result stars')
# City opening when changing province (not on restore or same-city chapter switch).
g=replace_once(g,'''  void _openLevel(int index) {
    if (index > _unlocked || index < 0 || index >= _levels.length) return;
    bool recovered = false;''','''  void _openLevel(int index) {
    if (index > _unlocked || index < 0 || index >= _levels.length) return;
    final wasInCity = _provinceForLevel(_level)?.slug;
    bool recovered = false;''','capture previous city')
g=replace_once(g,'''    if (_readyToPlay && _v31RegionalMusic && _musicOn) {
      _startMusic(); // switch audio only when the chosen region changes
    }
  }

  // Bulmaca''','''    if (_readyToPlay && _v31RegionalMusic && _musicOn) {
      _startMusic(); // switch audio only when the chosen region changes
    }
    final entering = _provinceForLevel(index);
    if (_readyToPlay && entering != null && entering.slug != wasInCity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _level == index) _v312RevealCity(entering);
      });
    }
  }

  void _v312RevealCity(ProvinceInfo p) {
    if (!mounted) return;
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Şehir tanıtımını kapat',
      barrierColor: const Color(0xC9000D25),
      transitionDuration: const Duration(milliseconds: 650),
      transitionBuilder: (context, animation, secondary, child) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: .87, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
          child: child)),
      pageBuilder: (dialogContext, animation, secondary) => Center(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Material(color: const Color(0xFF071D35),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(border: Border.all(
                color: const Color(0xFFFFD36E), width: 2),
                borderRadius: BorderRadius.circular(24)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.auto_awesome, color: Color(0xFFFFD36E), size: 30),
                const Text('YENİ ŞEHİR', style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFFFFD36E),
                  letterSpacing: 4)),
                const SizedBox(height: 9),
                Text(p.title.toUpperCase(), textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 25,
                    fontWeight: FontWeight.bold, fontFamily: 'serif')),
                const SizedBox(height: 14),
                ClipRRect(borderRadius: BorderRadius.circular(16),
                  child: SizedBox(height: 176, width: double.infinity,
                    child: Image(image: _citySelectionImageProvider(p),
                      fit: BoxFit.cover, filterQuality: FilterQuality.high))),
                const SizedBox(height: 14),
                Text('${p.region} · Yeni macera seni bekliyor!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFFFE6AB), fontSize: 13)),
                const SizedBox(height: 14),
                FilledButton.icon(onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.explore),
                  label: const Text('KEŞFE BAŞLA'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD36E),
                    foregroundColor: const Color(0xFF071D35))),
              ]),
            )))),
    );
  }

  // Bulmaca''','city dialog and trigger')
source[game]=g

p=source[province]
p=replace_once(p,'Image(image: _cityImageProvider(city), fit: fit, alignment: alignment);', 'Image(image: _cityImageProvider(city), fit: fit, alignment: alignment,\n      filterQuality: FilterQuality.high);','image quality')
source[province]=p

# preflight: 81 unique images, games stages unchanged, code anchors exist
catalog=root/'lib/src/data/city_catalog.dart'
if not catalog.is_file(): sys.exit('V31.2: city_catalog.dart eksik')
cat=catalog.read_text(encoding='utf-8')
entries=re.findall(r"CityInfo\(id: (\d+), name: '[^']+', gameCity: '[^']+', region: '[^']+', slug: '([^']+)', levelIds: <int>\[([^\]]+)\]",cat)
if len(entries)!=81:sys.exit(f'V31.2: 81 il bekleniyor, {len(entries)} bulundu')
ids=[int(x) for _,_,nums in entries for x in nums.split(',') if x.strip().isdigit()]
if len(ids)!=243 or len(set(ids))!=243:sys.exit('V31.2: 243 benzersiz bolum dogrulanamadi')
for num,slug,_ in entries:
    available = [
        root/f'assets/images/v28_city_cards/{slug}.webp',
        root/f'assets/images/hd_provinces/cards/{slug}.webp',
        root/f'assets/images/city_cards_hd/{slug}.webp',
        root/f'assets/images/provinces/{slug}.webp',
    ]
    if not any(f.is_file() and f.stat().st_size>1000 for f in available):
        sys.exit(f'V31.2: {num} {slug}: goruntu dosyasi bulunamadi')
# keep offline backups for safe rollback; generated under user home, not Git.
backup = Path.home() / ('kelime_v312_kod_yedegi_' + datetime.datetime.now().strftime('%Y%m%d_%H%M%S'))
for f in files:
    target=backup / f.relative_to(root)
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(f, target)
for f in files:
    f.write_text(source[f], encoding='utf-8')
print('V31.2 YAMA BASARILI: 81 kart yolu ve 243 bolum dogrulandi.')
print('V31.2: sehir gecisi, odul yildizlari, 1053 gorev icin ipuclari ve zorluk odulleri baglandi.')
print('V31.2: ana seviyeler, altin kayit anahtarlari ve bolum kimlikleri DEGISTIRILMEDI.')
print('Kod yedegi:', backup)
