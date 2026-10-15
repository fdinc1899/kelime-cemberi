#!/usr/bin/env python3
"""V31 additive, idempotent patch. Fail if target code differs; no save migrations."""
from pathlib import Path
import re
root=Path.cwd()
main=root/'kelime_main.dart'; lib=root/'lib/main.dart'; game=root/'lib/src/screens/game_screen.dart'
v29=root/'lib/src/features/v29_experience.dart'; feature=root/'lib/src/features/v31_world.dart'; pub=root/'pubspec.yaml'; provinces=root/'lib/src/data/provinces.dart'
for f in (main,game,v29,feature,pub,provinces):
    if not f.is_file():raise SystemExit('V31 HATA: Eksik proje dosyasi: '+str(f))
if not (root/'assets/images/v28_city_cards/osmaniye.webp').exists():
    raise SystemExit('V31 HATA: V28 manzara dosyalari eksik.')
for s in ['marmara','ege','akdeniz','icanadolu','karadeniz','doguanadolu','guneydogu']:
    if not (root/f'assets/audio/v31_{s}.mp3').is_file() or (root/f'assets/audio/v31_{s}.mp3').stat().st_size<500_000:
        raise SystemExit('V31 HATA: Bolge muzigi eksik '+s)
def replace_once(text,old,new,where):
    if new in text: return text
    if text.count(old)!=1:raise SystemExit(f'V31 HATA: {where} beklenen kod bulunamadi ({text.count(old)}).')
    return text.replace(old,new,1)
updates={}
for f in [main,lib]:
    if not f.is_file():continue
    s=f.read_text()
    s=replace_once(s,"import 'dart:io';","import 'dart:io';\nimport 'dart:convert';",'ana import')
    s=replace_once(s,"part 'src/features/v29_experience.dart';", "part 'src/features/v29_experience.dart';\npart 'src/features/v31_world.dart';",'v31 part')
    updates[f]=s

s=game.read_text()
s=replace_once(s,'  bool _showCityChoice = false;', '''  bool _showCityChoice = false;
  bool _v31Night = false;
  bool _v31RegionalMusic = false;''','oyun state')
s=replace_once(s,"    _musicOn = prefs.getBool('music_enabled_v3') ?? true;", "    _musicOn = prefs.getBool('music_enabled_v3') ?? true;\n    _v31Night = prefs.getBool('v31_night_mode') ?? false;\n    _v31RegionalMusic = prefs.getBool('v31_regional_music') ?? false;", 'restore')
s=replace_once(s,'''      await _musicPlayer.play(DeviceFileSource(f.path));''', '''      if (_v31RegionalMusic) {
        final province = _provinceForLevel(_level);
        final regionalTrack = v31RegionTrack(province?.region ?? 'Marmara');
        await _musicPlayer.play(AssetSource(regionalTrack));
      } else {
        await _musicPlayer.play(DeviceFileSource(f.path));
      }''', 'region music player')
s=replace_once(s, '''    if (justCompleted) _announceLevelCompleted(index);
  }

  // Bulmaca''', '''    if (justCompleted) _announceLevelCompleted(index);
    if (_readyToPlay && _v31RegionalMusic && _musicOn) {
      _startMusic(); // switch audio only when the chosen region changes
    }
  }

  // Bulmaca''', 'region switch')
s=replace_once(s, '''    setState(() {
      if (_dragged.length > 1 && _dragged[_dragged.length - 2] == index) {''', '''    if (_vibrationOn && !_dragged.contains(index)) HapticFeedback.selectionClick();
    setState(() {
      if (_dragged.length > 1 && _dragged[_dragged.length - 2] == index) {''','letter haptic')
s=replace_once(s,'''          Positioned.fill(
            child: _cityImageWidget(_puzzle.city),
          ),''','''          Positioned.fill(
            child: V31LivingBackdrop(
              night: _v31Night,
              child: _cityImageWidget(_puzzle.city),
            ),
          ),''','animated backdrop')
s=replace_once(s,'''        coins: _coins,
        onAwardCoins:''', '''        coins: _coins,
        night: _v31Night,
        regionMusic: _v31RegionalMusic,
        onNightChange: (on) {
          setState(() => _v31Night = on);
          _prefs?.setBool('v31_night_mode', on);
          refresh(() {});
        },
        onRestoreProgress: () {
          _restore(); // refresh in-memory coins before the next autosave
        },
        onRegionMusicChange: (on) {
          setState(() => _v31RegionalMusic = on);
          _prefs?.setBool('v31_regional_music', on);
          refresh(() {});
          if (_musicOn) _startMusic();
        },
        onAwardCoins:''','dashboard props')
updates[game]=s
s=v29.read_text()
s=replace_once(s,'''    required this.coins, required this.classicCenter,
    required this.onAwardCoins, required this.onOpenLevel});''','''    required this.coins, required this.classicCenter,
    required this.onAwardCoins, required this.onOpenLevel,
    required this.night, required this.regionMusic,
    required this.onNightChange, required this.onRegionMusicChange,
    required this.onRestoreProgress});''','v29 ctor')
s=replace_once(s,'''  final Widget classicCenter;
  final void Function(int, String) onAwardCoins;''','''  final Widget classicCenter;
  final bool night;
  final bool regionMusic;
  final ValueChanged<bool> onNightChange;
  final ValueChanged<bool> onRegionMusicChange;
  final VoidCallback onRestoreProgress;
  final void Function(int, String) onAwardCoins;''','v29 fields')
s=replace_once(s,'''    final titles = ['GÜNLÜK', 'PASAPORT', 'YOLCULUK', 'LİG', 'ÖDÜLLER', 'PROFİL'];''','''    final titles = ['GÜNLÜK', 'PASAPORT', 'YOLCULUK', 'LİG', 'ÖDÜLLER', 'PROFİL', 'V31'];''','v29 tabs')
s=replace_once(s,'''      Icons.card_giftcard_rounded, Icons.account_circle_rounded];''','''      Icons.card_giftcard_rounded, Icons.account_circle_rounded,
      Icons.rocket_launch_rounded];''','v29 tab icons')
s=replace_once(s,'''      widget.classicCenter, _profileTab(),
    ];''','''      widget.classicCenter, _profileTab(),
      V31WorldCenter(prefs: widget.prefs, completed: widget.completed,
        unlocked: widget.unlocked, coins: widget.coins,
        night: widget.night, regionMusic: widget.regionMusic,
        onTheme: widget.onNightChange, onMusic: widget.onRegionMusicChange,
        onReward: widget.onAwardCoins, onOpenLevel: widget.onOpenLevel,
        onRestore: widget.onRestoreProgress),
    ];''','v29 dashboard v31 view')
updates[v29]=s

s=provinces.read_text()
# Real separate city assets: 50 detailed V28 cards, 19 HD V21 cards,
# remaining 12 individual existing province files, no repeated regional background.
assets=list((root/'assets/images/v28_city_cards').glob('*.webp'))
if len(assets)!=50:
    raise SystemExit(f'V31 HATA: V28 resimler eksik: {len(assets)} / 50')
slugs=', '.join(repr(x.stem) for x in sorted(assets))
# V31.1: Select only HD cities whose BOTH card and game scene exist.
# Do not delete or overwrite V22 extra city graphics.
hd_cards={x.stem for x in (root/'assets/images/hd_provinces/cards').glob('*.webp')}
hd_scenes={x.stem for x in (root/'assets/images/hd_provinces/scenes').glob('*.webp')}
hd_slugs=', '.join(repr(slug) for slug in sorted(hd_cards & hd_scenes))
city_list='''// V31: dedicated province art selection. Keep names and level IDs unchanged.
const Set<String> _v31V28Slugs = <String>{'''+slugs+'''};
const Set<String> _v31HdSlugs = <String>{'''+hd_slugs+'''};
'''
if '_v31V28Slugs' not in s:
    s=s.replace('ImageProvider _cityImageProvider(String city) {',city_list+'\nImageProvider _cityImageProvider(String city) {',1)
if '_v31HdSlugs.contains(p.slug)' not in s:
    old_back='''  final p = _provinces.firstWhere((p) => p.city == city);
  return AssetImage(_provinceArt(p));'''
    modern_back='''  final p = _provinces.firstWhere((p) => p.city == city);
  return AssetImage(cityCatalogBySlug[p.slug]!.sceneAsset);'''
    if old_back in s: old=old_back; fallback='_provinceArt(p)'
    elif modern_back in s: old=modern_back; fallback='cityCatalogBySlug[p.slug]!.sceneAsset'
    else: raise SystemExit('V31 HATA: Oyun sahnesi resim kodu bulunamadi.')
    updated='''  final p = _provinces.firstWhere((p) => p.city == city);
  if (_v31HdSlugs.contains(p.slug)) {
    return AssetImage('assets/images/hd_provinces/scenes/${p.slug}.webp');
  }
  if (_v31V28Slugs.contains(p.slug)) {
    return AssetImage('assets/images/v28_city_cards/${p.slug}.webp');
  }
  return AssetImage('''+fallback+''');'''
    s=replace_once(s,old,updated,'game background provider')
if '_v31HdSlugs.contains(province.slug)' not in s:
    s=replace_once(s,'ImageProvider _citySelectionImageProvider(ProvinceInfo province) {', '''ImageProvider _citySelectionImageProvider(ProvinceInfo province) {
  if (_v31HdSlugs.contains(province.slug) && !_v31V28Slugs.contains(province.slug)) {
    return AssetImage('assets/images/hd_provinces/cards/${province.slug}.webp');
  }''','card background provider')
if ': _regionScenicAsset(province.region));' in s:
    s=s.replace(': _regionScenicAsset(province.region));',': _provinceArt(province));')
updates[provinces]=s
s=pub.read_text()
if 'assets/images/hd_provinces/cards/' not in s:
    s=replace_once(s,'  assets:\n','  assets:\n    - assets/images/hd_provinces/cards/\n    - assets/images/hd_provinces/scenes/\n','pubspec assets')

m=re.search(r'^version:\s*(\S+)\+(\d+)\s*$',s,re.M)
if m and int(m.group(2))<31:
    s=s[:m.start()]+'version: 3.1.0+31'+s[m.end():]
updates[pub]=s
# All sources are prepared in memory first. Commit to disk only after validation.
for f,data in updates.items():
    f.write_text(data)
assert "part 'src/features/v31_world.dart';" in main.read_text()
assert 'V31LivingBackdrop(' in game.read_text()
assert 'V31WorldCenter(' in v29.read_text()
assert '_v31HdSlugs' in provinces.read_text()
print('V31 YAMA BASARILI: yeni sekme, bolge muzikleri, gece modu, harf efekti baglandi.')
