part of kelime_sehirleri;

// 12 additional, handcrafted word sets, cross-connected and validated.
// Original 18 indices are untouched for backwards-compatible save data.
final List<PuzzleLevel> _extraLevels = <PuzzleLevel>[
  PuzzleLevel(city: 'İstanbul', subtitle: 'Boğaz macerası', letters: 'SEVDA',
    answers: [
      WordPosition('SEVDA', 3, 0),
      WordPosition('VEDA', 0, 4, down: true),
      WordPosition('DEV', 0, 2),
      WordPosition('SEV', 2, 1, down: true),
    ], bonusWords: ['EV', 'AD']),
  PuzzleLevel(city: 'İstanbul', subtitle: 'Sahil anıları', letters: 'ÇİLEK',
    answers: [
      WordPosition('ÇİLEK', 4, 0),
      WordPosition('ÇİLE', 1, 3, down: true),
      WordPosition('ELÇİ', 1, 1),
      WordPosition('ÇEK', 0, 1, down: true),
    ], bonusWords: ['İLE', 'EL']),
  PuzzleLevel(city: 'Kapadokya', subtitle: 'Gizemli hikâyeler', letters: 'MASAL',
    answers: [
      WordPosition('MASAL', 3, 0),
      WordPosition('MASA', 0, 1, down: true),
      WordPosition('SAL', 1, 0),
      WordPosition('ASAL', 0, 4, down: true),
    ], bonusWords: ['AS', 'AL']),
  PuzzleLevel(city: 'Kapadokya', subtitle: 'Akşam esintisi', letters: 'MEVSİM',
    answers: [
      WordPosition('MEVSİM', 2, 0),
      WordPosition('SEV', 0, 2, down: true),
      WordPosition('MİS', 0, 0),
      WordPosition('SİM', 0, 5, down: true),
    ], bonusWords: ['EV', 'İS']),
  PuzzleLevel(city: 'Antalya', subtitle: 'Güzel koylar', letters: 'DALGA',
    answers: [
      WordPosition('DALGA', 3, 0),
      WordPosition('GALA', 0, 1, down: true),
      WordPosition('ADA', 1, 1),
      WordPosition('DAL', 2, 4, down: true),
    ], bonusWords: ['AL', 'AD']),
  PuzzleLevel(city: 'Antalya', subtitle: 'Dağ yolları', letters: 'RENKLİ',
    answers: [
      WordPosition('RENKLİ', 3, 0),
      WordPosition('RENK', 0, 3, down: true),
      WordPosition('LİNK', 2, 5, down: true),
      WordPosition('KİL', 5, 5),
    ], bonusWords: ['EN', 'İL']),
  PuzzleLevel(city: 'Mardin', subtitle: 'Eski konaklar', letters: 'SARMA',
    answers: [
      WordPosition('SARMA', 3, 1),
      WordPosition('MASA', 0, 2, down: true),
      WordPosition('ARMA', 0, 5, down: true),
      WordPosition('ASMA', 0, 0),
    ], bonusWords: ['AS', 'AR']),
  PuzzleLevel(city: 'Mardin', subtitle: 'Taş köprüler', letters: 'PERDE',
    answers: [
      WordPosition('PERDE', 3, 0),
      WordPosition('DERE', 0, 1, down: true),
      WordPosition('EDER', 0, 0),
      WordPosition('PER', 2, 4, down: true),
    ], bonusWords: ['ER', 'DE']),
  PuzzleLevel(city: 'İzmir', subtitle: 'Güzel çarşılar', letters: 'PAZAR',
    answers: [
      WordPosition('PAZAR', 2, 0),
      WordPosition('PAZ', 0, 2, down: true),
      WordPosition('ZAR', 0, 4, down: true),
      WordPosition('ARPA', 0, 0, down: true),
    ], bonusWords: ['AZ', 'AR']),
  PuzzleLevel(city: 'İzmir', subtitle: 'Yolculuk', letters: 'TARİH',
    answers: [
      WordPosition('TARİH', 2, 0),
      WordPosition('TAR', 0, 2, down: true),
      WordPosition('HAT', 0, 0),
      WordPosition('AHİ', 1, 4, down: true),
    ], bonusWords: ['AT', 'AH']),
  PuzzleLevel(city: 'Ankara', subtitle: 'Yaz tatili', letters: 'KUMSAL',
    answers: [
      WordPosition('KUMSAL', 2, 0),
      WordPosition('KUM', 0, 2, down: true),
      WordPosition('SAL', 2, 3, down: true),
      WordPosition('MAL', 0, 5, down: true),
    ], bonusWords: ['SU', 'AL']),
  PuzzleLevel(city: 'Ankara', subtitle: 'Yeni maceralar', letters: 'BİLET',
    answers: [
      WordPosition('BİLET', 2, 0),
      WordPosition('BİL', 2, 0, down: true),
      WordPosition('ELİ', 2, 3, down: true),
      WordPosition('TEL', 0, 2, down: true),
    ], bonusWords: ['İL', 'EL']),
];
