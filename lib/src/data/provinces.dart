part of kelime_sehirleri;

/// V16 province catalog. Old 0..29 save indices are intentionally unchanged.
class ProvinceInfo {
  const ProvinceInfo(this.province, this.city, this.region, this.slug, this.levels);
  final String province;
  final String city;
  final String region;
  final String slug;
  final List<int> levels;
  String get title => province == 'Nevşehir' ? 'Nevşehir · Kapadokya' : province;
  int get start => levels.first;
}

final List<ProvinceInfo> _provinces = List<ProvinceInfo>.unmodifiable(
  cityCatalog.map((city) => ProvinceInfo(
    city.name, city.gameCity, city.region, city.slug, city.levelIds,
  )),
);

const List<String> _regions = ['Tümü', 'Marmara', 'Ege', 'Akdeniz', 'İç Anadolu', 'Karadeniz', 'Doğu Anadolu', 'Güneydoğu Anadolu'];

ProvinceInfo? _provinceForLevel(int index) {
  // Legacy bonus chapters 18..29 use the corresponding historical city.
  if (index >= 18 && index < 30) {
    final name = _levels[index].city;
    for (final p in _provinces) { if (p.city == name) return p; }
    return null;
  }
  for (final p in _provinces) {
    if (p.levels.contains(index)) return p;
  }
  return null;
}

bool _cityOpen(ProvinceInfo p, int unlocked) => p.start <= unlocked;
int _mainDone(Set<int> done) => _provinces.fold<int>(0, (sum, p) => sum + p.levels.where(done.contains).length);
int _cityDone(Set<int> done) => _provinces.where((p) => p.levels.every(done.contains)).length;
String _provinceArt(ProvinceInfo p) => 'assets/images/provinces/${p.slug}.webp';

// V21: One province -> one card art + one game-scene art.
// Filenames all point to real files shipped with the V21 full bundle.
// V31: dedicated province art selection. Keep names and level IDs unchanged.
const Set<String> _v31V28Slugs = <String>{'adana', 'adiyaman', 'agri', 'amasya', 'ardahan', 'artvin', 'aydin', 'bartin', 'batman', 'bayburt', 'burdur', 'cankiri', 'corum', 'diyarbakir', 'duzce', 'erzincan', 'erzurum', 'gaziantep', 'giresun', 'gumushane', 'hakkri', 'hatay', 'igdir', 'kahramanmaras', 'karaman', 'kars', 'kastamonu', 'kayseri', 'kilis', 'kirikkale', 'kirsehir', 'konya', 'manisa', 'mersin', 'mugla', 'nigde', 'ordu', 'osmaniye', 'rize', 'samsun', 'sanliurfa', 'siirt', 'sinop', 'sirnak', 'tokat', 'trabzon', 'usak', 'van', 'yozgat', 'zonguldak'};
const Set<String> _v31HdSlugs = <String>{'afyonkarahisar', 'aksaray', 'balikesir', 'bilecik', 'bingol', 'bitlis', 'bolu', 'bursa', 'canakkale', 'denizli', 'edirne', 'elazig', 'eskisehir', 'isparta', 'karabuk', 'kirklareli', 'kocaeli', 'kutahya', 'malatya', 'mus', 'sakarya', 'sivas', 'tekirdag', 'tunceli', 'yalova'};

ImageProvider _cityImageProvider(String city) {
  if (city == 'İstanbul') return MemoryImage(_istanbulBackground);
  if (_premiumCityScenes.containsKey(city)) return MemoryImage(_premiumCityScenes[city]!);
  final p = _provinces.firstWhere((p) => p.city == city);
  if (_v31HdSlugs.contains(p.slug)) {
    return AssetImage('assets/images/hd_provinces/scenes/${p.slug}.webp');
  }
  if (_v31V28Slugs.contains(p.slug)) {
    return AssetImage('assets/images/v28_city_cards/${p.slug}.webp');
  }
  return AssetImage(cityCatalogBySlug[p.slug]!.sceneAsset);
}

// V19: Featured art for the first ten cities, one regional panorama for all
// remaining cities. Asset paths are stable and never affect save indices.
const Map<String, String> _regionScenicAssets = <String, String>{
  'Marmara': 'assets/images/regional_cards/marmara.webp',
  'Ege': 'assets/images/regional_cards/ege.webp',
  'Akdeniz': 'assets/images/regional_cards/akdeniz.webp',
  'İç Anadolu': 'assets/images/regional_cards/ic_anadolu.webp',
  'Karadeniz': 'assets/images/regional_cards/karadeniz.webp',
  'Doğu Anadolu': 'assets/images/regional_cards/dogu_anadolu.webp',
  'Güneydoğu Anadolu': 'assets/images/regional_cards/guneydogu_anadolu.webp',
};

String _regionScenicAsset(String region) =>
    _regionScenicAssets[region] ?? _regionScenicAssets['Marmara']!;

ImageProvider _citySelectionImageProvider(ProvinceInfo province) {
  if (_v31HdSlugs.contains(province.slug) && !_v31V28Slugs.contains(province.slug)) {
    return AssetImage('assets/images/hd_provinces/cards/${province.slug}.webp');
  }
  // V28_CARD_OVERRIDE: 50 provincial HD card images, never a shared region image.
  const v28Cities = <String>{
    'aydin', 'mugla', 'manisa', 'usak', 'burdur', 'mersin',
    'adana', 'osmaniye', 'hatay', 'kahramanmaras', 'konya', 'karaman',
    'nigde', 'kirsehir', 'kirikkale', 'cankiri', 'yozgat', 'kayseri',
    'duzce', 'zonguldak', 'bartin', 'kastamonu', 'sinop', 'samsun',
    'ordu', 'giresun', 'trabzon', 'rize', 'artvin', 'gumushane',
    'bayburt', 'tokat', 'amasya', 'corum', 'erzincan', 'erzurum',
    'agri', 'igdir', 'kars', 'ardahan', 'van', 'hakkri',
    'diyarbakir', 'sanliurfa', 'gaziantep', 'kilis', 'adiyaman', 'batman',
    'siirt', 'sirnak',
  };
  if (v28Cities.contains(province.slug)) {
    return AssetImage('assets/images/v28_city_cards/${province.slug}.webp');
  }
  // Previous releases used the same regional photo for dozens of provinces.
  // Each province now has a different, verified image asset.
  return AssetImage(cityCatalogBySlug[province.slug]!.cardAsset);
}

Widget _cityImageWidget(String city, {BoxFit fit = BoxFit.cover, Alignment alignment = Alignment.center}) =>
    Image(image: _cityImageProvider(city), fit: fit, alignment: alignment);

/// Old bonus indices 18..29 are preserved, but province 7 starts at 30.
int _nextStoryLevel(int index) => index == 17 ? 30 : index + 1;
bool _isBonusChapter(int index) => index >= 18 && index < 30;
int _stageOf(int index) => _isBonusChapter(index) ? (index - 18) % 2 + 1 : (_provinceForLevel(index)?.levels.indexOf(index) ?? 0) + 1;
String _levelLabel(int index) => _isBonusChapter(index)
    ? 'EK BÖLÜM ${_stageOf(index)} / 2'
    : 'BÖLÜM ${_stageOf(index)} / 3';
