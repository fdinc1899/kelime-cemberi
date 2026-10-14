part of kelime_sehirleri;

/// V21: complete 81-province city catalog.
/// Ordered exactly like the previous save schema. Do NOT sort by city name:
/// the order is the on-screen chapter order, not vehicle plate code order.
/// Historical level IDs 0..17 and 18..29 (bonus) MUST NOT be reassigned.
/// There are 243 city levels (0..17 and 30..254), plus 12 legacy bonus levels.
class CityInfo {
  const CityInfo({
    required this.id,
    required this.name,
    required this.gameCity,
    required this.region,
    required this.slug,
    required this.levelIds,
    required this.cardAsset,
    required this.sceneAsset,
  });

  /// Position in the existing game (1 to 81), not the vehicle licence plate.
  final int id;
  final String name;
  final String gameCity;
  final String region;
  final String slug;
  final List<int> levelIds;
  final String cardAsset;
  final String sceneAsset;

  int get totalLevels => levelIds.length;
  bool isUnlocked(int highestUnlockedLevel) =>
      highestUnlockedLevel >= levelIds.first;
  int completedCount(Set<int> finished) =>
      levelIds.where(finished.contains).length;
}

const List<CityInfo> cityCatalog = <CityInfo>[
  CityInfo(id: 1, name: 'İstanbul', gameCity: 'İstanbul', region: 'Marmara', slug: 'istanbul', levelIds: <int>[0, 1, 2], cardAsset: 'assets/images/city_cards_hd/istanbul.webp', sceneAsset: 'assets/images/cities/istanbul.webp'),
  CityInfo(id: 2, name: 'Nevşehir', gameCity: 'Kapadokya', region: 'İç Anadolu', slug: 'nevsehir', levelIds: <int>[3, 4, 5], cardAsset: 'assets/images/city_cards_hd/nevsehir.webp', sceneAsset: 'assets/images/cities/kapadokya.webp'),
  CityInfo(id: 3, name: 'Antalya', gameCity: 'Antalya', region: 'Akdeniz', slug: 'antalya', levelIds: <int>[6, 7, 8], cardAsset: 'assets/images/city_cards_hd/antalya.webp', sceneAsset: 'assets/images/cities/antalya.webp'),
  CityInfo(id: 4, name: 'Mardin', gameCity: 'Mardin', region: 'Güneydoğu Anadolu', slug: 'mardin', levelIds: <int>[9, 10, 11], cardAsset: 'assets/images/city_cards_hd/mardin.webp', sceneAsset: 'assets/images/cities/mardin.webp'),
  CityInfo(id: 5, name: 'İzmir', gameCity: 'İzmir', region: 'Ege', slug: 'izmir', levelIds: <int>[12, 13, 14], cardAsset: 'assets/images/city_cards_hd/izmir.webp', sceneAsset: 'assets/images/cities/izmir.webp'),
  CityInfo(id: 6, name: 'Ankara', gameCity: 'Ankara', region: 'İç Anadolu', slug: 'ankara', levelIds: <int>[15, 16, 17], cardAsset: 'assets/images/city_cards_hd/ankara.webp', sceneAsset: 'assets/images/cities/ankara.webp'),
  CityInfo(id: 7, name: 'Edirne', gameCity: 'Edirne', region: 'Marmara', slug: 'edirne', levelIds: <int>[30, 31, 32], cardAsset: 'assets/images/hd_provinces/cards/edirne.webp', sceneAsset: 'assets/images/hd_provinces/scenes/edirne.webp'),
  CityInfo(id: 8, name: 'Kırklareli', gameCity: 'Kırklareli', region: 'Marmara', slug: 'kirklareli', levelIds: <int>[33, 34, 35], cardAsset: 'assets/images/hd_provinces/cards/kirklareli.webp', sceneAsset: 'assets/images/hd_provinces/scenes/kirklareli.webp'),
  CityInfo(id: 9, name: 'Tekirdağ', gameCity: 'Tekirdağ', region: 'Marmara', slug: 'tekirdag', levelIds: <int>[36, 37, 38], cardAsset: 'assets/images/hd_provinces/cards/tekirdag.webp', sceneAsset: 'assets/images/hd_provinces/scenes/tekirdag.webp'),
  CityInfo(id: 10, name: 'Çanakkale', gameCity: 'Çanakkale', region: 'Marmara', slug: 'canakkale', levelIds: <int>[39, 40, 41], cardAsset: 'assets/images/hd_provinces/cards/canakkale.webp', sceneAsset: 'assets/images/hd_provinces/scenes/canakkale.webp'),
  CityInfo(id: 11, name: 'Balıkesir', gameCity: 'Balıkesir', region: 'Marmara', slug: 'balikesir', levelIds: <int>[42, 43, 44], cardAsset: 'assets/images/hd_provinces/cards/balikesir.webp', sceneAsset: 'assets/images/hd_provinces/scenes/balikesir.webp'),
  CityInfo(id: 12, name: 'Bursa', gameCity: 'Bursa', region: 'Marmara', slug: 'bursa', levelIds: <int>[45, 46, 47], cardAsset: 'assets/images/hd_provinces/cards/bursa.webp', sceneAsset: 'assets/images/hd_provinces/scenes/bursa.webp'),
  CityInfo(id: 13, name: 'Yalova', gameCity: 'Yalova', region: 'Marmara', slug: 'yalova', levelIds: <int>[48, 49, 50], cardAsset: 'assets/images/hd_provinces/cards/yalova.webp', sceneAsset: 'assets/images/hd_provinces/scenes/yalova.webp'),
  CityInfo(id: 14, name: 'Kocaeli', gameCity: 'Kocaeli', region: 'Marmara', slug: 'kocaeli', levelIds: <int>[51, 52, 53], cardAsset: 'assets/images/hd_provinces/cards/kocaeli.webp', sceneAsset: 'assets/images/hd_provinces/scenes/kocaeli.webp'),
  CityInfo(id: 15, name: 'Sakarya', gameCity: 'Sakarya', region: 'Marmara', slug: 'sakarya', levelIds: <int>[54, 55, 56], cardAsset: 'assets/images/hd_provinces/cards/sakarya.webp', sceneAsset: 'assets/images/hd_provinces/scenes/sakarya.webp'),
  CityInfo(id: 16, name: 'Bilecik', gameCity: 'Bilecik', region: 'Marmara', slug: 'bilecik', levelIds: <int>[57, 58, 59], cardAsset: 'assets/images/hd_provinces/cards/bilecik.webp', sceneAsset: 'assets/images/hd_provinces/scenes/bilecik.webp'),
  CityInfo(id: 17, name: 'Aydın', gameCity: 'Aydın', region: 'Ege', slug: 'aydin', levelIds: <int>[60, 61, 62], cardAsset: 'assets/images/v25_city_cards/aydin.webp', sceneAsset: 'assets/images/provinces/aydin.webp'),
  CityInfo(id: 18, name: 'Muğla', gameCity: 'Muğla', region: 'Ege', slug: 'mugla', levelIds: <int>[63, 64, 65], cardAsset: 'assets/images/v25_city_cards/mugla.webp', sceneAsset: 'assets/images/provinces/mugla.webp'),
  CityInfo(id: 19, name: 'Denizli', gameCity: 'Denizli', region: 'Ege', slug: 'denizli', levelIds: <int>[66, 67, 68], cardAsset: 'assets/images/hd_provinces/cards/denizli.webp', sceneAsset: 'assets/images/hd_provinces/scenes/denizli.webp'),
  CityInfo(id: 20, name: 'Manisa', gameCity: 'Manisa', region: 'Ege', slug: 'manisa', levelIds: <int>[69, 70, 71], cardAsset: 'assets/images/v25_city_cards/manisa.webp', sceneAsset: 'assets/images/provinces/manisa.webp'),
  CityInfo(id: 21, name: 'Uşak', gameCity: 'Uşak', region: 'Ege', slug: 'usak', levelIds: <int>[72, 73, 74], cardAsset: 'assets/images/v25_city_cards/usak.webp', sceneAsset: 'assets/images/provinces/usak.webp'),
  CityInfo(id: 22, name: 'Kütahya', gameCity: 'Kütahya', region: 'Ege', slug: 'kutahya', levelIds: <int>[75, 76, 77], cardAsset: 'assets/images/hd_provinces/cards/kutahya.webp', sceneAsset: 'assets/images/hd_provinces/scenes/kutahya.webp'),
  CityInfo(id: 23, name: 'Afyonkarahisar', gameCity: 'Afyonkarahisar', region: 'Ege', slug: 'afyonkarahisar', levelIds: <int>[78, 79, 80], cardAsset: 'assets/images/hd_provinces/cards/afyonkarahisar.webp', sceneAsset: 'assets/images/hd_provinces/scenes/afyonkarahisar.webp'),
  CityInfo(id: 24, name: 'Isparta', gameCity: 'Isparta', region: 'Akdeniz', slug: 'isparta', levelIds: <int>[81, 82, 83], cardAsset: 'assets/images/hd_provinces/cards/isparta.webp', sceneAsset: 'assets/images/hd_provinces/scenes/isparta.webp'),
  CityInfo(id: 25, name: 'Burdur', gameCity: 'Burdur', region: 'Akdeniz', slug: 'burdur', levelIds: <int>[84, 85, 86], cardAsset: 'assets/images/v25_city_cards/burdur.webp', sceneAsset: 'assets/images/provinces/burdur.webp'),
  CityInfo(id: 26, name: 'Mersin', gameCity: 'Mersin', region: 'Akdeniz', slug: 'mersin', levelIds: <int>[87, 88, 89], cardAsset: 'assets/images/v25_city_cards/mersin.webp', sceneAsset: 'assets/images/provinces/mersin.webp'),
  CityInfo(id: 27, name: 'Adana', gameCity: 'Adana', region: 'Akdeniz', slug: 'adana', levelIds: <int>[90, 91, 92], cardAsset: 'assets/images/v25_city_cards/adana.webp', sceneAsset: 'assets/images/provinces/adana.webp'),
  CityInfo(id: 28, name: 'Osmaniye', gameCity: 'Osmaniye', region: 'Akdeniz', slug: 'osmaniye', levelIds: <int>[93, 94, 95], cardAsset: 'assets/images/v25_city_cards/osmaniye.webp', sceneAsset: 'assets/images/provinces/osmaniye.webp'),
  CityInfo(id: 29, name: 'Hatay', gameCity: 'Hatay', region: 'Akdeniz', slug: 'hatay', levelIds: <int>[96, 97, 98], cardAsset: 'assets/images/v25_city_cards/hatay.webp', sceneAsset: 'assets/images/provinces/hatay.webp'),
  CityInfo(id: 30, name: 'Kahramanmaraş', gameCity: 'Kahramanmaraş', region: 'Akdeniz', slug: 'kahramanmaras', levelIds: <int>[99, 100, 101], cardAsset: 'assets/images/v25_city_cards/kahramanmaras.webp', sceneAsset: 'assets/images/provinces/kahramanmaras.webp'),
  CityInfo(id: 31, name: 'Konya', gameCity: 'Konya', region: 'İç Anadolu', slug: 'konya', levelIds: <int>[102, 103, 104], cardAsset: 'assets/images/v25_city_cards/konya.webp', sceneAsset: 'assets/images/provinces/konya.webp'),
  CityInfo(id: 32, name: 'Karaman', gameCity: 'Karaman', region: 'İç Anadolu', slug: 'karaman', levelIds: <int>[105, 106, 107], cardAsset: 'assets/images/v25_city_cards/karaman.webp', sceneAsset: 'assets/images/provinces/karaman.webp'),
  CityInfo(id: 33, name: 'Aksaray', gameCity: 'Aksaray', region: 'İç Anadolu', slug: 'aksaray', levelIds: <int>[108, 109, 110], cardAsset: 'assets/images/v23_city_cards/aksaray.webp', sceneAsset: 'assets/images/hd_provinces/scenes/aksaray.webp'),
  CityInfo(id: 34, name: 'Niğde', gameCity: 'Niğde', region: 'İç Anadolu', slug: 'nigde', levelIds: <int>[111, 112, 113], cardAsset: 'assets/images/v25_city_cards/nigde.webp', sceneAsset: 'assets/images/provinces/nigde.webp'),
  CityInfo(id: 35, name: 'Kırşehir', gameCity: 'Kırşehir', region: 'İç Anadolu', slug: 'kirsehir', levelIds: <int>[114, 115, 116], cardAsset: 'assets/images/v25_city_cards/kirsehir.webp', sceneAsset: 'assets/images/provinces/kirsehir.webp'),
  CityInfo(id: 36, name: 'Kırıkkale', gameCity: 'Kırıkkale', region: 'İç Anadolu', slug: 'kirikkale', levelIds: <int>[117, 118, 119], cardAsset: 'assets/images/v25_city_cards/kirikkale.webp', sceneAsset: 'assets/images/provinces/kirikkale.webp'),
  CityInfo(id: 37, name: 'Çankırı', gameCity: 'Çankırı', region: 'İç Anadolu', slug: 'cankiri', levelIds: <int>[120, 121, 122], cardAsset: 'assets/images/v25_city_cards/cankiri.webp', sceneAsset: 'assets/images/provinces/cankiri.webp'),
  CityInfo(id: 38, name: 'Yozgat', gameCity: 'Yozgat', region: 'İç Anadolu', slug: 'yozgat', levelIds: <int>[123, 124, 125], cardAsset: 'assets/images/v25_city_cards/yozgat.webp', sceneAsset: 'assets/images/provinces/yozgat.webp'),
  CityInfo(id: 39, name: 'Kayseri', gameCity: 'Kayseri', region: 'İç Anadolu', slug: 'kayseri', levelIds: <int>[126, 127, 128], cardAsset: 'assets/images/v25_city_cards/kayseri.webp', sceneAsset: 'assets/images/provinces/kayseri.webp'),
  CityInfo(id: 40, name: 'Sivas', gameCity: 'Sivas', region: 'İç Anadolu', slug: 'sivas', levelIds: <int>[129, 130, 131], cardAsset: 'assets/images/v23_city_cards/sivas.webp', sceneAsset: 'assets/images/hd_provinces/scenes/sivas.webp'),
  CityInfo(id: 41, name: 'Eskişehir', gameCity: 'Eskişehir', region: 'İç Anadolu', slug: 'eskisehir', levelIds: <int>[132, 133, 134], cardAsset: 'assets/images/v23_city_cards/eskisehir.webp', sceneAsset: 'assets/images/hd_provinces/scenes/eskisehir.webp'),
  CityInfo(id: 42, name: 'Bolu', gameCity: 'Bolu', region: 'Karadeniz', slug: 'bolu', levelIds: <int>[135, 136, 137], cardAsset: 'assets/images/hd_provinces/cards/bolu.webp', sceneAsset: 'assets/images/hd_provinces/scenes/bolu.webp'),
  CityInfo(id: 43, name: 'Düzce', gameCity: 'Düzce', region: 'Karadeniz', slug: 'duzce', levelIds: <int>[138, 139, 140], cardAsset: 'assets/images/v25_city_cards/duzce.webp', sceneAsset: 'assets/images/provinces/duzce.webp'),
  CityInfo(id: 44, name: 'Zonguldak', gameCity: 'Zonguldak', region: 'Karadeniz', slug: 'zonguldak', levelIds: <int>[141, 142, 143], cardAsset: 'assets/images/v25_city_cards/zonguldak.webp', sceneAsset: 'assets/images/provinces/zonguldak.webp'),
  CityInfo(id: 45, name: 'Bartın', gameCity: 'Bartın', region: 'Karadeniz', slug: 'bartin', levelIds: <int>[144, 145, 146], cardAsset: 'assets/images/v25_city_cards/bartin.webp', sceneAsset: 'assets/images/provinces/bartin.webp'),
  CityInfo(id: 46, name: 'Karabük', gameCity: 'Karabük', region: 'Karadeniz', slug: 'karabuk', levelIds: <int>[147, 148, 149], cardAsset: 'assets/images/v23_city_cards/karabuk.webp', sceneAsset: 'assets/images/hd_provinces/scenes/karabuk.webp'),
  CityInfo(id: 47, name: 'Kastamonu', gameCity: 'Kastamonu', region: 'Karadeniz', slug: 'kastamonu', levelIds: <int>[150, 151, 152], cardAsset: 'assets/images/v25_city_cards/kastamonu.webp', sceneAsset: 'assets/images/provinces/kastamonu.webp'),
  CityInfo(id: 48, name: 'Sinop', gameCity: 'Sinop', region: 'Karadeniz', slug: 'sinop', levelIds: <int>[153, 154, 155], cardAsset: 'assets/images/v25_city_cards/sinop.webp', sceneAsset: 'assets/images/provinces/sinop.webp'),
  CityInfo(id: 49, name: 'Samsun', gameCity: 'Samsun', region: 'Karadeniz', slug: 'samsun', levelIds: <int>[156, 157, 158], cardAsset: 'assets/images/v25_city_cards/samsun.webp', sceneAsset: 'assets/images/provinces/samsun.webp'),
  CityInfo(id: 50, name: 'Ordu', gameCity: 'Ordu', region: 'Karadeniz', slug: 'ordu', levelIds: <int>[159, 160, 161], cardAsset: 'assets/images/v25_city_cards/ordu.webp', sceneAsset: 'assets/images/provinces/ordu.webp'),
  CityInfo(id: 51, name: 'Giresun', gameCity: 'Giresun', region: 'Karadeniz', slug: 'giresun', levelIds: <int>[162, 163, 164], cardAsset: 'assets/images/v25_city_cards/giresun.webp', sceneAsset: 'assets/images/provinces/giresun.webp'),
  CityInfo(id: 52, name: 'Trabzon', gameCity: 'Trabzon', region: 'Karadeniz', slug: 'trabzon', levelIds: <int>[165, 166, 167], cardAsset: 'assets/images/v25_city_cards/trabzon.webp', sceneAsset: 'assets/images/provinces/trabzon.webp'),
  CityInfo(id: 53, name: 'Rize', gameCity: 'Rize', region: 'Karadeniz', slug: 'rize', levelIds: <int>[168, 169, 170], cardAsset: 'assets/images/v25_city_cards/rize.webp', sceneAsset: 'assets/images/provinces/rize.webp'),
  CityInfo(id: 54, name: 'Artvin', gameCity: 'Artvin', region: 'Karadeniz', slug: 'artvin', levelIds: <int>[171, 172, 173], cardAsset: 'assets/images/v25_city_cards/artvin.webp', sceneAsset: 'assets/images/provinces/artvin.webp'),
  CityInfo(id: 55, name: 'Gümüşhane', gameCity: 'Gümüşhane', region: 'Karadeniz', slug: 'gumushane', levelIds: <int>[174, 175, 176], cardAsset: 'assets/images/v25_city_cards/gumushane.webp', sceneAsset: 'assets/images/provinces/gumushane.webp'),
  CityInfo(id: 56, name: 'Bayburt', gameCity: 'Bayburt', region: 'Karadeniz', slug: 'bayburt', levelIds: <int>[177, 178, 179], cardAsset: 'assets/images/v25_city_cards/bayburt.webp', sceneAsset: 'assets/images/provinces/bayburt.webp'),
  CityInfo(id: 57, name: 'Tokat', gameCity: 'Tokat', region: 'Karadeniz', slug: 'tokat', levelIds: <int>[180, 181, 182], cardAsset: 'assets/images/v25_city_cards/tokat.webp', sceneAsset: 'assets/images/provinces/tokat.webp'),
  CityInfo(id: 58, name: 'Amasya', gameCity: 'Amasya', region: 'Karadeniz', slug: 'amasya', levelIds: <int>[183, 184, 185], cardAsset: 'assets/images/v25_city_cards/amasya.webp', sceneAsset: 'assets/images/provinces/amasya.webp'),
  CityInfo(id: 59, name: 'Çorum', gameCity: 'Çorum', region: 'Karadeniz', slug: 'corum', levelIds: <int>[186, 187, 188], cardAsset: 'assets/images/v25_city_cards/corum.webp', sceneAsset: 'assets/images/provinces/corum.webp'),
  CityInfo(id: 60, name: 'Erzincan', gameCity: 'Erzincan', region: 'Doğu Anadolu', slug: 'erzincan', levelIds: <int>[189, 190, 191], cardAsset: 'assets/images/v25_city_cards/erzincan.webp', sceneAsset: 'assets/images/provinces/erzincan.webp'),
  CityInfo(id: 61, name: 'Erzurum', gameCity: 'Erzurum', region: 'Doğu Anadolu', slug: 'erzurum', levelIds: <int>[192, 193, 194], cardAsset: 'assets/images/v25_city_cards/erzurum.webp', sceneAsset: 'assets/images/provinces/erzurum.webp'),
  CityInfo(id: 62, name: 'Ağrı', gameCity: 'Ağrı', region: 'Doğu Anadolu', slug: 'agri', levelIds: <int>[195, 196, 197], cardAsset: 'assets/images/v25_city_cards/agri.webp', sceneAsset: 'assets/images/provinces/agri.webp'),
  CityInfo(id: 63, name: 'Iğdır', gameCity: 'Iğdır', region: 'Doğu Anadolu', slug: 'igdir', levelIds: <int>[198, 199, 200], cardAsset: 'assets/images/v25_city_cards/igdir.webp', sceneAsset: 'assets/images/provinces/igdir.webp'),
  CityInfo(id: 64, name: 'Kars', gameCity: 'Kars', region: 'Doğu Anadolu', slug: 'kars', levelIds: <int>[201, 202, 203], cardAsset: 'assets/images/v25_city_cards/kars.webp', sceneAsset: 'assets/images/provinces/kars.webp'),
  CityInfo(id: 65, name: 'Ardahan', gameCity: 'Ardahan', region: 'Doğu Anadolu', slug: 'ardahan', levelIds: <int>[204, 205, 206], cardAsset: 'assets/images/v25_city_cards/ardahan.webp', sceneAsset: 'assets/images/provinces/ardahan.webp'),
  CityInfo(id: 66, name: 'Malatya', gameCity: 'Malatya', region: 'Doğu Anadolu', slug: 'malatya', levelIds: <int>[207, 208, 209], cardAsset: 'assets/images/hd_provinces/cards/malatya.webp', sceneAsset: 'assets/images/hd_provinces/scenes/malatya.webp'),
  CityInfo(id: 67, name: 'Elazığ', gameCity: 'Elazığ', region: 'Doğu Anadolu', slug: 'elazig', levelIds: <int>[210, 211, 212], cardAsset: 'assets/images/hd_provinces/cards/elazig.webp', sceneAsset: 'assets/images/hd_provinces/scenes/elazig.webp'),
  CityInfo(id: 68, name: 'Tunceli', gameCity: 'Tunceli', region: 'Doğu Anadolu', slug: 'tunceli', levelIds: <int>[213, 214, 215], cardAsset: 'assets/images/hd_provinces/cards/tunceli.webp', sceneAsset: 'assets/images/hd_provinces/scenes/tunceli.webp'),
  CityInfo(id: 69, name: 'Bingöl', gameCity: 'Bingöl', region: 'Doğu Anadolu', slug: 'bingol', levelIds: <int>[216, 217, 218], cardAsset: 'assets/images/hd_provinces/cards/bingol.webp', sceneAsset: 'assets/images/hd_provinces/scenes/bingol.webp'),
  CityInfo(id: 70, name: 'Muş', gameCity: 'Muş', region: 'Doğu Anadolu', slug: 'mus', levelIds: <int>[219, 220, 221], cardAsset: 'assets/images/hd_provinces/cards/mus.webp', sceneAsset: 'assets/images/hd_provinces/scenes/mus.webp'),
  CityInfo(id: 71, name: 'Bitlis', gameCity: 'Bitlis', region: 'Doğu Anadolu', slug: 'bitlis', levelIds: <int>[222, 223, 224], cardAsset: 'assets/images/hd_provinces/cards/bitlis.webp', sceneAsset: 'assets/images/hd_provinces/scenes/bitlis.webp'),
  CityInfo(id: 72, name: 'Van', gameCity: 'Van', region: 'Doğu Anadolu', slug: 'van', levelIds: <int>[225, 226, 227], cardAsset: 'assets/images/v25_city_cards/van.webp', sceneAsset: 'assets/images/provinces/van.webp'),
  CityInfo(id: 73, name: 'Hakkâri', gameCity: 'Hakkâri', region: 'Doğu Anadolu', slug: 'hakkri', levelIds: <int>[228, 229, 230], cardAsset: 'assets/images/v25_city_cards/hakkri.webp', sceneAsset: 'assets/images/provinces/hakkri.webp'),
  CityInfo(id: 74, name: 'Diyarbakır', gameCity: 'Diyarbakır', region: 'Güneydoğu Anadolu', slug: 'diyarbakir', levelIds: <int>[231, 232, 233], cardAsset: 'assets/images/v25_city_cards/diyarbakir.webp', sceneAsset: 'assets/images/provinces/diyarbakir.webp'),
  CityInfo(id: 75, name: 'Şanlıurfa', gameCity: 'Şanlıurfa', region: 'Güneydoğu Anadolu', slug: 'sanliurfa', levelIds: <int>[234, 235, 236], cardAsset: 'assets/images/v25_city_cards/sanliurfa.webp', sceneAsset: 'assets/images/provinces/sanliurfa.webp'),
  CityInfo(id: 76, name: 'Gaziantep', gameCity: 'Gaziantep', region: 'Güneydoğu Anadolu', slug: 'gaziantep', levelIds: <int>[237, 238, 239], cardAsset: 'assets/images/v25_city_cards/gaziantep.webp', sceneAsset: 'assets/images/provinces/gaziantep.webp'),
  CityInfo(id: 77, name: 'Kilis', gameCity: 'Kilis', region: 'Güneydoğu Anadolu', slug: 'kilis', levelIds: <int>[240, 241, 242], cardAsset: 'assets/images/v26_city_cards/kilis.webp', sceneAsset: 'assets/images/provinces/kilis.webp'),
  CityInfo(id: 78, name: 'Adıyaman', gameCity: 'Adıyaman', region: 'Güneydoğu Anadolu', slug: 'adiyaman', levelIds: <int>[243, 244, 245], cardAsset: 'assets/images/v26_city_cards/adiyaman.webp', sceneAsset: 'assets/images/provinces/adiyaman.webp'),
  CityInfo(id: 79, name: 'Batman', gameCity: 'Batman', region: 'Güneydoğu Anadolu', slug: 'batman', levelIds: <int>[246, 247, 248], cardAsset: 'assets/images/v26_city_cards/batman.webp', sceneAsset: 'assets/images/provinces/batman.webp'),
  CityInfo(id: 80, name: 'Siirt', gameCity: 'Siirt', region: 'Güneydoğu Anadolu', slug: 'siirt', levelIds: <int>[249, 250, 251], cardAsset: 'assets/images/v26_city_cards/siirt.webp', sceneAsset: 'assets/images/provinces/siirt.webp'),
  CityInfo(id: 81, name: 'Şırnak', gameCity: 'Şırnak', region: 'Güneydoğu Anadolu', slug: 'sirnak', levelIds: <int>[252, 253, 254], cardAsset: 'assets/images/v26_city_cards/sirnak.webp', sceneAsset: 'assets/images/provinces/sirnak.webp'),
];

final Map<String, CityInfo> cityCatalogBySlug = <String, CityInfo>{
  for (final city in cityCatalog) city.slug: city,
};
