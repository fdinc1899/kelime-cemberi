#!/usr/bin/env python3
"""V31.4 additive City Guide / Statistics, preserves all save IDs and old data."""
from pathlib import Path
import os, sys, datetime, shutil, tempfile
root = Path.cwd()
p = root / 'lib/src/features/v31_world.dart'
if not (root/'kelime_main.dart').is_file() or not p.is_file():
    sys.exit('V31.4: Proje bulunamadı. ~/kelime-cemberi içinde çalıştırın.')
s = p.read_text(encoding='utf-8')
marker='// V314_CITY_GUIDE'
if marker in s:
    print('V31.4 zaten kurulmuş; dosya değiştirilmedi.')
    sys.exit(0)
if 'class V31WorldCenter extends StatefulWidget {' not in s:
    sys.exit('V31.4: V31 Macera Merkezi bulunamadı; mevcut dosyaya dokunulmadı.')

def change(old, new, name):
    global s
    count=s.count(old)
    if count != 1: sys.exit(f'V31.4: {name} farklı ({count} eşleşme); dosyalar değiştirilmedi.')
    s=s.replace(old,new,1)

change('  Set<int> _treasures = <int>{};', '''  Set<int> _treasures = <int>{};
  // V314_CITY_GUIDE — Favorites stored under a NEW key, never overwrite V3.
  Set<String> _v314Favorites = <String>{};
  final TextEditingController _v314Search = TextEditingController();
  String _v314Region = 'Tümü';
  bool _v314FavoritesOnly = false;''','state')
change('''    _treasures = widget.prefs?.getStringList('v31_treasure_claimed')
      ?.map(int.tryParse).whereType<int>().where((n) => n >= 0 && n < 81).toSet() ?? <int>{};''', '''    _treasures = widget.prefs?.getStringList('v31_treasure_claimed')
      ?.map(int.tryParse).whereType<int>().where((n) => n >= 0 && n < 81).toSet() ?? <int>{};
    _v314Favorites = widget.prefs?.getStringList('v31_favorite_city_slugs')?.toSet()
        ?? <String>{};''','favorite restore')
change('''  @override void dispose() { _answer.dispose(); _importText.dispose(); super.dispose(); }''', '''  @override void dispose() {
    _answer.dispose(); _importText.dispose(); _v314Search.dispose();
    super.dispose();
  }''', 'controllers dispose')

widget_methods = '''// V314_CITY_GUIDE: 81 searchable cities, regional filter, favorites and progress stats.
  // No gameplay IDs, reward callbacks or legacy settings are modified.
  Future<void> _v314ToggleFavorite(ProvinceInfo city) async {
    final prefs = widget.prefs;
    if (prefs == null) { _notice('Kayıtlar henüz hazır değil.'); return; }
    final updated = <String>{..._v314Favorites};
    if (!updated.remove(city.slug)) updated.add(city.slug);
    final result = await prefs.setStringList('v31_favorite_city_slugs',
      (updated.toList()..sort()));
    if (!mounted) return;
    if (!result) { _notice('Favori kaydedilemedi.'); return; }
    setState(() => _v314Favorites = updated);
  }

  int _v314DoneIn(ProvinceInfo p) => p.levels.where(widget.completed.contains).length;

  Widget _v314Metric(String caption, String value, double ratio) => Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFF142C48),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: const Color(0x55FFD479))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: _text(caption)),
        _text(value, color: _v31Gold),
      ]),
      const SizedBox(height: 8),
      LinearProgressIndicator(value: ratio.clamp(0.0, 1.0).toDouble(),
        backgroundColor: const Color(0xFF41536A),
        valueColor: const AlwaysStoppedAnimation<Color>(_v31Gold), minHeight: 6),
    ]));

  Widget _v314CityGuide() {
    final needle = v31TurkishUpper(_v314Search.text.trim());
    const regions = <String>['Tümü', 'Marmara', 'Ege', 'Akdeniz',
      'İç Anadolu', 'Karadeniz', 'Doğu Anadolu', 'Güneydoğu Anadolu'];
    final entries = _provinces.where((p) =>
      (needle.isEmpty || v31TurkishUpper(p.province).contains(needle)) &&
      (_v314Region == 'Tümü' || p.region == _v314Region) &&
      (!_v314FavoritesOnly || _v314Favorites.contains(p.slug))).toList();
    final next = _provinces.expand((p) => p.levels)
      .where((id) => id <= widget.unlocked && !widget.completed.contains(id))
      .toList()..sort();
    final resume = next.isNotEmpty ? next.first : null;

    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: _panel('81 ŞEHİR REHBERİ', Column(children: [
        TextField(controller: _v314Search,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(color: _v31Cream),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: _v31Gold),
            hintText: 'Şehir ara (ör. Amasya)',
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
        ),
        const SizedBox(height: 9),
        SizedBox(height: 44, child: ListView(scrollDirection: Axis.horizontal,
          children: regions.map((name) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(label: Text(name), selected: _v314Region == name,
              selectedColor: _v31Gold,
              onSelected: (_) => setState(() => _v314Region = name)))) .toList())),
        SwitchListTile(contentPadding: EdgeInsets.zero,
          title: const Text('Yalnız favorilerim',
            style: TextStyle(color: _v31Cream)),
          value: _v314FavoritesOnly,
          activeThumbColor: _v31Gold,
          onChanged: (v) => setState(() => _v314FavoritesOnly = v)),
        _action('KALDIĞIM AÇIK BÖLÜME DÖN',
          resume == null ? null : () => widget.onOpenLevel(resume),
          icon: Icons.play_circle_fill),
        const SizedBox(height: 8),
        _text('${entries.length} şehir bulundu · ${_v314Favorites.length} favori',
          color: _v31Gold, size: 12),
      ]))),
      if (entries.isEmpty) SliverToBoxAdapter(child: _panel('SONUÇ YOK',
        _text('Aramayı veya bölge filtresini değiştir.'))),
      SliverList(delegate: SliverChildBuilderDelegate((context, i) {
        final city = entries[i];
        final done = _v314DoneIn(city);
        final open = city.start <= widget.unlocked;
        final destination = city.levels.firstWhere(
          (id) => id <= widget.unlocked && !widget.completed.contains(id),
          orElse: () => city.start);
        final fav = _v314Favorites.contains(city.slug);
        return _panel('${city.province.toUpperCase()} · ${city.region}', Column(
          children: [
            _cityPicture(city, height: 132),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _text('$done / ${city.levels.length} ana bölüm',
                color: _v31Gold)),
              IconButton(tooltip: fav ? 'Favorilerden çıkar' : 'Favorilere ekle',
                onPressed: () => _v314ToggleFavorite(city),
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                  color: _v31Gold)),
            ]),
            LinearProgressIndicator(value: city.levels.isEmpty ? 0.0 : done / city.levels.length,
              minHeight: 5, backgroundColor: const Color(0xFF41536A),
              valueColor: const AlwaysStoppedAnimation<Color>(_v31Gold)),
            _action(open ? 'ŞEHRE GİT' : 'ŞEHİR KİLİTLİ',
              open ? () => widget.onOpenLevel(destination) : null,
              icon: open ? Icons.explore : Icons.lock),
          ]));
      }, childCount: entries.length)),
    ]);
  }

  Widget _v314Statistics() {
    final all = _provinces.expand((p) => p.levels).toSet();
    final mainDone = widget.completed.intersection(all).length;
    final fullCities = _provinces.where((p) =>
      p.levels.isNotEmpty && p.levels.every(widget.completed.contains)).length;
    final marathon = _marathonDone.length;
    final top = _provinces.where((p) => _v314DoneIn(p) > 0).toList()
      ..sort((a, b) => _v314DoneIn(b).compareTo(_v314DoneIn(a)));
    return ListView(children: [
      _panel('İLERLEME İSTATİSTİKLERİ', Column(children: [
        _v314Metric('Ana bulmacalar', '$mainDone / ${all.length}',
          all.isEmpty ? 0.0 : mainDone / all.length),
        _v314Metric('Tamamlanan şehirler', '$fullCities / ${_provinces.length}',
          fullCities / _provinces.length),
        _v314Metric('Ek kelime görevleri', '$marathon / $v31ChallengeCount',
          marathon / v31ChallengeCount),
        _v314Metric('Toplanan şehir hatıraları', '${_treasures.length} / 81',
          _treasures.length / 81),
        const SizedBox(height: 10),
        _text('Açılan bölüm: ${widget.unlocked} · Favoriler: ${_v314Favorites.length}',
          size: 12, color: Colors.white70),
        const SizedBox(height: 4),
        _text('Mevcut altın: ${widget.coins}', color: _v31Gold),
      ])),
      _panel('İLERLEDİĞİN ŞEHİRLER', top.isEmpty
        ? _text('İlk bölümü tamamladığında şehir ilerlemen burada görünecek.')
        : Column(children: top.take(12).map((p) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(children: [
              Expanded(child: _text(p.province)),
              _text('${_v314DoneIn(p)} / ${p.levels.length}', color: _v31Gold),
            ]))).toList())),
      _panel('KAYIT GÜVENLİĞİ', _text(
        'İstatistikler cihazdaki mevcut kayıtlarından hesaplanır; internet bağlantısı '
        'gerektirmez. V31 YEDEK sekmesinden ilerlemeyi ayrıca yedekle.')),
    ]);
  }

  '''

change('  Widget _backupView() => ListView(children: [',widget_methods+'Widget _backupView() => ListView(children: [','new widgets')
change("    const titles = ['MARATON', 'HATIRALAR', 'GÖRÜNÜM', 'YEDEK'];", "    const titles = ['MARATON', 'HATIRALAR', 'GÖRÜNÜM', 'YEDEK', 'ŞEHİRLER', 'İSTATİSTİK'];", 'tab titles')
change('''    const icons = [Icons.abc, Icons.collections_bookmark, Icons.nightlight,
      Icons.cloud_upload_outlined];''', '''    const icons = [Icons.abc, Icons.collections_bookmark, Icons.nightlight,
      Icons.cloud_upload_outlined, Icons.map_outlined, Icons.bar_chart_rounded];''', 'tab icons')
change('''    final views = [_challengeView(), _memoriesView(), _visualsView(), _backupView()];''', '''    final views = [_challengeView(), _memoriesView(), _visualsView(),
      _backupView(), _v314CityGuide(), _v314Statistics()];''', 'tab screens')

# Fix a possible old v31 Dart null-safety build blocker too.
if 'final data = <String, Object>{};' in s:
    s=s.replace('final data = <String, Object>{};', 'final data = <String, Object?>{};',1)

assert s.count(marker)==2, s.count(marker)
assert 'v31_favorite_city_slugs' in s
assert "widget.onOpenLevel(destination)" in s
assert "const titles = ['MARATON'" in s
# Back up original outside repository, then write atomically.
folder = Path.home()/'kelime_cemberi_v314_yedekler'
folder.mkdir(parents=True,exist_ok=True)
copy=folder / ('v31_world_' + datetime.datetime.now().strftime('%Y%m%d_%H%M%S') + '.dart')
shutil.copy2(p,copy)
fd,temp=tempfile.mkstemp(prefix='.v314_',suffix='.dart',dir=str(p.parent))
try:
    with os.fdopen(fd,'w',encoding='utf-8') as h: h.write(s)
    os.replace(temp,p)
finally:
    if os.path.exists(temp):os.unlink(temp)
print('V31.4 KOD BASARILI: Şehir Rehberi + İstatistik sekmeleri eklendi.')
print('Yeni kayıt anahtarı: v31_favorite_city_slugs (eski anahtarlar korunur).')
print('Kod yedeği:',copy)
