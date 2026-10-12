part of kelime_sehirleri;

class WordPosition {
  final String word;
  final int row;
  final int col;
  final bool down;
  const WordPosition(this.word, this.row, this.col, {this.down = false});
}

class PuzzleLevel {
  final String city;
  final String subtitle;
  final String letters;
  final List<WordPosition> answers;
  final List<String> bonusWords;

  const PuzzleLevel({
    required this.city,
    required this.subtitle,
    required this.letters,
    required this.answers,
    required this.bonusWords,
  });

  int get rows => answers.map((a) => a.row + (a.down ? a.word.length : 1))
      .reduce(math.max);
  int get cols => answers.map((a) => a.col + (a.down ? 1 : a.word.length))
      .reduce(math.max);

  Map<String, String> get cells {
    final result = <String, String>{};
    for (final a in answers) {
      for (var i = 0; i < a.word.length; i++) {
        final row = a.row + (a.down ? i : 0);
        final col = a.col + (a.down ? 0 : i);
        final id = '$row:$col';
        final letter = a.word[i];
        assert(!result.containsKey(id) || result[id] == letter,
            'Çakışan kelimeler: $id');
        result[id] = letter;
      }
    }
    return result;
  }

}

const _levels = <PuzzleLevel>[
  PuzzleLevel(
    city: 'İstanbul', subtitle: 'Gün batımında Boğaz', letters: 'KİRAZ',
    answers: [
      WordPosition('KİRAZ', 2, 0),
      WordPosition('KİRA', 0, 2, down: true),
      WordPosition('KİR', 2, 0, down: true),
      WordPosition('ARZ', 0, 4, down: true),
    ],
    bonusWords: ['KAR', 'KAZ', 'ZAR', 'AZ', 'İZ', 'AK', 'AR'],
  ),
  PuzzleLevel(
    city: 'İstanbul', subtitle: 'Tarihi yarımada', letters: 'DENİZ',
    answers: [
      WordPosition('DENİZ', 2, 0),
      WordPosition('DİZ', 0, 4, down: true),
      WordPosition('DİN', 0, 2, down: true),
      WordPosition('İZ', 2, 3, down: true),
      WordPosition('EN', 2, 1, down: true),
    ],
    bonusWords: ['DİNE', 'İNE', 'NE'],
  ),
  PuzzleLevel(
    city: 'İstanbul', subtitle: 'Saray bahçeleri', letters: 'SARAY',
    answers: [
      WordPosition('SARAY', 0, 0),
      WordPosition('SAY', 0, 0, down: true),
      WordPosition('YAS', 0, 4, down: true),
      WordPosition('ARA', 1, 4),
      WordPosition('YAR', 2, 0),
    ],
    bonusWords: ['SAR', 'AR', 'AS'],
  ),
  PuzzleLevel(
    city: 'Kapadokya', subtitle: 'Peri bacaları', letters: 'KALEM',
    answers: [
      WordPosition('KALEM', 0, 2),
      WordPosition('KALE', 0, 2, down: true),
      WordPosition('ELMA', 0, 5, down: true),
      WordPosition('MAL', 3, 3, down: true),
      WordPosition('ALEM', 3, 0),
    ],
    bonusWords: ['KEL', 'AL', 'EL'],
  ),
  PuzzleLevel(
    city: 'Kapadokya', subtitle: 'Balonların dansı', letters: 'BALON',
    answers: [
      WordPosition('BALON', 1, 2),
      WordPosition('OLAN', 0, 4, down: true),
      WordPosition('BAL', 1, 2, down: true),
      WordPosition('BOL', 3, 0),
      WordPosition('NAL', 3, 4),
    ],
    bonusWords: ['AL', 'ON', 'AN', 'OL'],
  ),
  PuzzleLevel(
    city: 'Kapadokya', subtitle: 'Gizemli mağaralar', letters: 'PERİ',
    answers: [
      WordPosition('PERİ', 0, 0),
      WordPosition('PİRE', 0, 0, down: true),
      WordPosition('ERİ', 3, 0),
      WordPosition('İPE', 0, 3, down: true),
      WordPosition('PİR', 1, 3),
    ],
    bonusWords: ['ER', 'İR'],
  ),
  PuzzleLevel(
    city: 'Antalya', subtitle: 'Akdeniz kıyısı', letters: 'SAHİL',
    answers: [
      WordPosition('SAHİL', 2, 0),
      WordPosition('SAL', 0, 4, down: true),
      WordPosition('HAL', 1, 1, down: true),
      WordPosition('HİS', 0, 2),
      WordPosition('İL', 2, 3, down: true),
    ],
    bonusWords: ['SİL', 'AHİ', 'AL', 'AS'],
  ),
  PuzzleLevel(
    city: 'Antalya', subtitle: 'Yaz güneşi', letters: 'YAZAR',
    answers: [
      WordPosition('YAZAR', 2, 0),
      WordPosition('YAZ', 0, 2, down: true),
      WordPosition('ZAR', 0, 4, down: true),
      WordPosition('ARA', 1, 4),
      WordPosition('YAR', 0, 6, down: true),
    ],
    bonusWords: ['AZ', 'AR'],
  ),
  PuzzleLevel(
    city: 'Antalya', subtitle: 'Güneşli koylar', letters: 'GÜNEŞ',
    answers: [
      WordPosition('GÜNEŞ', 0, 0),
      WordPosition('GÜN', 0, 0, down: true),
      WordPosition('ŞEN', 0, 4, down: true),
      WordPosition('GEN', 2, 2),
      WordPosition('EŞ', 1, 4),
    ],
    bonusWords: ['ÜŞEN', 'EN'],
  ),
  PuzzleLevel(
    city: 'Mardin', subtitle: 'Taş sokaklar', letters: 'TAŞLI',
    answers: [
      WordPosition('TAŞLI', 2, 0),
      WordPosition('TAŞ', 0, 2, down: true),
      WordPosition('ALI', 0, 4, down: true),
      WordPosition('ALT', 0, 0, down: true),
      WordPosition('ATI', 0, 4),
    ],
    bonusWords: ['AL', 'AT', 'IL'],
  ),
  PuzzleLevel(
    city: 'Mardin', subtitle: 'Altın teraslar', letters: 'BAHAR',
    answers: [
      WordPosition('BAHAR', 2, 0),
      WordPosition('HAR', 2, 2, down: true),
      WordPosition('BAR', 4, 0),
      WordPosition('ARA', 0, 3, down: true),
      WordPosition('ABA', 0, 1),
    ],
    bonusWords: ['AH', 'AR', 'RAH'],
  ),
  PuzzleLevel(
    city: 'Mardin', subtitle: 'Eski çarşı', letters: 'KEMER',
    answers: [
      WordPosition('KEMER', 2, 0),
      WordPosition('EMEK', 0, 3, down: true),
      WordPosition('KREM', 0, 1, down: true),
      WordPosition('ER', 0, 3),
      WordPosition('EK', 0, 0),
    ],
    bonusWords: ['EM', 'KERE'],
  ),
  PuzzleLevel(
    city: 'İzmir', subtitle: 'Kordon akşamı', letters: 'PAZAR',
    answers: [
      WordPosition('PAZAR', 0, 0),
      WordPosition('AZAR', 0, 3, down: true),
      WordPosition('ZAR', 3, 1),
      WordPosition('ARA', 2, 3),
      WordPosition('PAR', 1, 5, down: true),
    ],
    bonusWords: ['AZ', 'AR', 'PAZ'],
  ),
  PuzzleLevel(
    city: 'İzmir', subtitle: 'Körfez esintisi', letters: 'KORDON',
    answers: [
      WordPosition('KORDON', 2, 0),
      WordPosition('KOD', 2, 0, down: true),
      WordPosition('DON', 2, 3, down: true),
      WordPosition('KOR', 0, 2, down: true),
      WordPosition('DOK', 0, 0),
    ],
    bonusWords: ['ON', 'OR'],
  ),
  PuzzleLevel(
    city: 'İzmir', subtitle: 'Kıyı sokakları', letters: 'BADEM',
    answers: [
      WordPosition('BADEM', 2, 0),
      WordPosition('ADEM', 1, 2, down: true),
      WordPosition('DEM', 4, 0),
      WordPosition('DAM', 0, 4, down: true),
      WordPosition('EDA', 0, 3),
    ],
    bonusWords: ['AD', 'EM'],
  ),
  PuzzleLevel(
    city: 'Ankara', subtitle: 'Şehrin kalbi', letters: 'KİTAP',
    answers: [
      WordPosition('KİTAP', 2, 0),
      WordPosition('KATİP', 0, 2, down: true),
      WordPosition('TİP', 4, 0),
      WordPosition('PAT', 2, 4, down: true),
      WordPosition('KAP', 0, 2),
    ],
    bonusWords: ['KAT', 'AT', 'İP', 'PİK'],
  ),
  PuzzleLevel(
    city: 'Ankara', subtitle: 'Sanat ve kültür', letters: 'MECLİS',
    answers: [
      WordPosition('MECLİS', 2, 0),
      WordPosition('SİL', 2, 5, down: true),
      WordPosition('SEL', 4, 3),
      WordPosition('MİS', 2, 0, down: true),
      WordPosition('MİL', 0, 3, down: true),
    ],
    bonusWords: ['İL', 'EL', 'İS'],
  ),
  PuzzleLevel(
    city: 'Ankara', subtitle: 'Zafer meydanı', letters: 'ZAFER',
    answers: [
      WordPosition('ZAFER', 0, 2),
      WordPosition('ZARF', 0, 2, down: true),
      WordPosition('FARZ', 0, 4, down: true),
      WordPosition('RAF', 2, 4),
      WordPosition('ZAR', 2, 0),
    ],
    bonusWords: ['FAR', 'AR', 'ER'],
  ),
];

