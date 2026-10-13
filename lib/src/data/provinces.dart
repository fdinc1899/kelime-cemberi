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

const List<ProvinceInfo> _provinces = <ProvinceInfo>[
  ProvinceInfo('İstanbul', 'İstanbul', 'Marmara', 'istanbul', <int>[0, 1, 2]),
  ProvinceInfo('Nevşehir', 'Kapadokya', 'İç Anadolu', 'nevsehir', <int>[3, 4, 5]),
  ProvinceInfo('Antalya', 'Antalya', 'Akdeniz', 'antalya', <int>[6, 7, 8]),
  ProvinceInfo('Mardin', 'Mardin', 'Güneydoğu Anadolu', 'mardin', <int>[9, 10, 11]),
  ProvinceInfo('İzmir', 'İzmir', 'Ege', 'izmir', <int>[12, 13, 14]),
  ProvinceInfo('Ankara', 'Ankara', 'İç Anadolu', 'ankara', <int>[15, 16, 17]),
  ProvinceInfo('Edirne', 'Edirne', 'Marmara', 'edirne', <int>[30, 31, 32]),
  ProvinceInfo('Kırklareli', 'Kırklareli', 'Marmara', 'kirklareli', <int>[33, 34, 35]),
  ProvinceInfo('Tekirdağ', 'Tekirdağ', 'Marmara', 'tekirdag', <int>[36, 37, 38]),
  ProvinceInfo('Çanakkale', 'Çanakkale', 'Marmara', 'canakkale', <int>[39, 40, 41]),
  ProvinceInfo('Balıkesir', 'Balıkesir', 'Marmara', 'balikesir', <int>[42, 43, 44]),
  ProvinceInfo('Bursa', 'Bursa', 'Marmara', 'bursa', <int>[45, 46, 47]),
  ProvinceInfo('Yalova', 'Yalova', 'Marmara', 'yalova', <int>[48, 49, 50]),
  ProvinceInfo('Kocaeli', 'Kocaeli', 'Marmara', 'kocaeli', <int>[51, 52, 53]),
  ProvinceInfo('Sakarya', 'Sakarya', 'Marmara', 'sakarya', <int>[54, 55, 56]),
  ProvinceInfo('Bilecik', 'Bilecik', 'Marmara', 'bilecik', <int>[57, 58, 59]),
  ProvinceInfo('Aydın', 'Aydın', 'Ege', 'aydin', <int>[60, 61, 62]),
  ProvinceInfo('Muğla', 'Muğla', 'Ege', 'mugla', <int>[63, 64, 65]),
  ProvinceInfo('Denizli', 'Denizli', 'Ege', 'denizli', <int>[66, 67, 68]),
  ProvinceInfo('Manisa', 'Manisa', 'Ege', 'manisa', <int>[69, 70, 71]),
  ProvinceInfo('Uşak', 'Uşak', 'Ege', 'usak', <int>[72, 73, 74]),
  ProvinceInfo('Kütahya', 'Kütahya', 'Ege', 'kutahya', <int>[75, 76, 77]),
  ProvinceInfo('Afyonkarahisar', 'Afyonkarahisar', 'Ege', 'afyonkarahisar', <int>[78, 79, 80]),
  ProvinceInfo('Isparta', 'Isparta', 'Akdeniz', 'isparta', <int>[81, 82, 83]),
  ProvinceInfo('Burdur', 'Burdur', 'Akdeniz', 'burdur', <int>[84, 85, 86]),
  ProvinceInfo('Mersin', 'Mersin', 'Akdeniz', 'mersin', <int>[87, 88, 89]),
  ProvinceInfo('Adana', 'Adana', 'Akdeniz', 'adana', <int>[90, 91, 92]),
  ProvinceInfo('Osmaniye', 'Osmaniye', 'Akdeniz', 'osmaniye', <int>[93, 94, 95]),
  ProvinceInfo('Hatay', 'Hatay', 'Akdeniz', 'hatay', <int>[96, 97, 98]),
  ProvinceInfo('Kahramanmaraş', 'Kahramanmaraş', 'Akdeniz', 'kahramanmaras', <int>[99, 100, 101]),
  ProvinceInfo('Konya', 'Konya', 'İç Anadolu', 'konya', <int>[102, 103, 104]),
  ProvinceInfo('Karaman', 'Karaman', 'İç Anadolu', 'karaman', <int>[105, 106, 107]),
  ProvinceInfo('Aksaray', 'Aksaray', 'İç Anadolu', 'aksaray', <int>[108, 109, 110]),
  ProvinceInfo('Niğde', 'Niğde', 'İç Anadolu', 'nigde', <int>[111, 112, 113]),
  ProvinceInfo('Kırşehir', 'Kırşehir', 'İç Anadolu', 'kirsehir', <int>[114, 115, 116]),
  ProvinceInfo('Kırıkkale', 'Kırıkkale', 'İç Anadolu', 'kirikkale', <int>[117, 118, 119]),
  ProvinceInfo('Çankırı', 'Çankırı', 'İç Anadolu', 'cankiri', <int>[120, 121, 122]),
  ProvinceInfo('Yozgat', 'Yozgat', 'İç Anadolu', 'yozgat', <int>[123, 124, 125]),
  ProvinceInfo('Kayseri', 'Kayseri', 'İç Anadolu', 'kayseri', <int>[126, 127, 128]),
  ProvinceInfo('Sivas', 'Sivas', 'İç Anadolu', 'sivas', <int>[129, 130, 131]),
  ProvinceInfo('Eskişehir', 'Eskişehir', 'İç Anadolu', 'eskisehir', <int>[132, 133, 134]),
  ProvinceInfo('Bolu', 'Bolu', 'Karadeniz', 'bolu', <int>[135, 136, 137]),
  ProvinceInfo('Düzce', 'Düzce', 'Karadeniz', 'duzce', <int>[138, 139, 140]),
  ProvinceInfo('Zonguldak', 'Zonguldak', 'Karadeniz', 'zonguldak', <int>[141, 142, 143]),
  ProvinceInfo('Bartın', 'Bartın', 'Karadeniz', 'bartin', <int>[144, 145, 146]),
  ProvinceInfo('Karabük', 'Karabük', 'Karadeniz', 'karabuk', <int>[147, 148, 149]),
  ProvinceInfo('Kastamonu', 'Kastamonu', 'Karadeniz', 'kastamonu', <int>[150, 151, 152]),
  ProvinceInfo('Sinop', 'Sinop', 'Karadeniz', 'sinop', <int>[153, 154, 155]),
  ProvinceInfo('Samsun', 'Samsun', 'Karadeniz', 'samsun', <int>[156, 157, 158]),
  ProvinceInfo('Ordu', 'Ordu', 'Karadeniz', 'ordu', <int>[159, 160, 161]),
  ProvinceInfo('Giresun', 'Giresun', 'Karadeniz', 'giresun', <int>[162, 163, 164]),
  ProvinceInfo('Trabzon', 'Trabzon', 'Karadeniz', 'trabzon', <int>[165, 166, 167]),
  ProvinceInfo('Rize', 'Rize', 'Karadeniz', 'rize', <int>[168, 169, 170]),
  ProvinceInfo('Artvin', 'Artvin', 'Karadeniz', 'artvin', <int>[171, 172, 173]),
  ProvinceInfo('Gümüşhane', 'Gümüşhane', 'Karadeniz', 'gumushane', <int>[174, 175, 176]),
  ProvinceInfo('Bayburt', 'Bayburt', 'Karadeniz', 'bayburt', <int>[177, 178, 179]),
  ProvinceInfo('Tokat', 'Tokat', 'Karadeniz', 'tokat', <int>[180, 181, 182]),
  ProvinceInfo('Amasya', 'Amasya', 'Karadeniz', 'amasya', <int>[183, 184, 185]),
  ProvinceInfo('Çorum', 'Çorum', 'Karadeniz', 'corum', <int>[186, 187, 188]),
  ProvinceInfo('Erzincan', 'Erzincan', 'Doğu Anadolu', 'erzincan', <int>[189, 190, 191]),
  ProvinceInfo('Erzurum', 'Erzurum', 'Doğu Anadolu', 'erzurum', <int>[192, 193, 194]),
  ProvinceInfo('Ağrı', 'Ağrı', 'Doğu Anadolu', 'agri', <int>[195, 196, 197]),
  ProvinceInfo('Iğdır', 'Iğdır', 'Doğu Anadolu', 'igdir', <int>[198, 199, 200]),
  ProvinceInfo('Kars', 'Kars', 'Doğu Anadolu', 'kars', <int>[201, 202, 203]),
  ProvinceInfo('Ardahan', 'Ardahan', 'Doğu Anadolu', 'ardahan', <int>[204, 205, 206]),
  ProvinceInfo('Malatya', 'Malatya', 'Doğu Anadolu', 'malatya', <int>[207, 208, 209]),
  ProvinceInfo('Elazığ', 'Elazığ', 'Doğu Anadolu', 'elazig', <int>[210, 211, 212]),
  ProvinceInfo('Tunceli', 'Tunceli', 'Doğu Anadolu', 'tunceli', <int>[213, 214, 215]),
  ProvinceInfo('Bingöl', 'Bingöl', 'Doğu Anadolu', 'bingol', <int>[216, 217, 218]),
  ProvinceInfo('Muş', 'Muş', 'Doğu Anadolu', 'mus', <int>[219, 220, 221]),
  ProvinceInfo('Bitlis', 'Bitlis', 'Doğu Anadolu', 'bitlis', <int>[222, 223, 224]),
  ProvinceInfo('Van', 'Van', 'Doğu Anadolu', 'van', <int>[225, 226, 227]),
  ProvinceInfo('Hakkâri', 'Hakkâri', 'Doğu Anadolu', 'hakkri', <int>[228, 229, 230]),
  ProvinceInfo('Diyarbakır', 'Diyarbakır', 'Güneydoğu Anadolu', 'diyarbakir', <int>[231, 232, 233]),
  ProvinceInfo('Şanlıurfa', 'Şanlıurfa', 'Güneydoğu Anadolu', 'sanliurfa', <int>[234, 235, 236]),
  ProvinceInfo('Gaziantep', 'Gaziantep', 'Güneydoğu Anadolu', 'gaziantep', <int>[237, 238, 239]),
  ProvinceInfo('Kilis', 'Kilis', 'Güneydoğu Anadolu', 'kilis', <int>[240, 241, 242]),
  ProvinceInfo('Adıyaman', 'Adıyaman', 'Güneydoğu Anadolu', 'adiyaman', <int>[243, 244, 245]),
  ProvinceInfo('Batman', 'Batman', 'Güneydoğu Anadolu', 'batman', <int>[246, 247, 248]),
  ProvinceInfo('Siirt', 'Siirt', 'Güneydoğu Anadolu', 'siirt', <int>[249, 250, 251]),
  ProvinceInfo('Şırnak', 'Şırnak', 'Güneydoğu Anadolu', 'sirnak', <int>[252, 253, 254]),
];

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

ImageProvider _cityImageProvider(String city) {
  if (city == 'İstanbul') return MemoryImage(_istanbulBackground);
  if (_premiumCityScenes.containsKey(city)) return MemoryImage(_premiumCityScenes[city]!);
  final p = _provinces.firstWhere((p) => p.city == city);
  return AssetImage(_provinceArt(p));
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
