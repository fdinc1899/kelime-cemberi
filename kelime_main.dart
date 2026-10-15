library kelime_sehirleri;

import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'src/theme/premium_theme.dart';
part 'src/data/puzzles.dart';
part 'src/data/extra_puzzles.dart';
part 'src/data/provinces.dart';
part 'src/data/city_catalog.dart';
part 'src/data/province_puzzles.dart';
part 'src/features/adventure_features.dart';
part 'src/features/v29_experience.dart';
part 'src/features/v31_world.dart';
part 'src/features/v316_expedition.dart';
part 'src/screens/game_screen.dart';
part 'src/screens/premium_page.dart';
part 'src/screens/journey_map.dart';
part 'src/screens/intro_screens.dart';
part 'src/widgets/painters.dart';
part 'src/widgets/v10_ornaments.dart';
part 'src/widgets/v12_sparkles.dart';
part 'src/widgets/v18_premium_widgets.dart';

// Art and music are stored as genuine project assets, not inline Base64 source.
late Uint8List _istanbulBackground;
final Map<String, Uint8List> _cityBackgrounds = {};
final Map<String, Uint8List> _premiumCityThumbs = {};
final Map<String, Uint8List> _premiumCityScenes = {};
late Uint8List _musicBytes;
late Uint8List _celebrationEffectBytes;

Future<Uint8List> _loadBytes(String path) async {
  final data = await rootBundle.load(path);
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

Future<void> _loadArtAndAudio() async {
  const cityIds = <String, String>{
    'İstanbul': 'istanbul', 'Kapadokya': 'kapadokya',
    'Antalya': 'antalya', 'Mardin': 'mardin',
    'İzmir': 'izmir', 'Ankara': 'ankara',
  };
  for (final entry in cityIds.entries) {
    final image = await _loadBytes('assets/images/cities/${entry.value}.webp');
    if (entry.key == 'İstanbul') {
      _istanbulBackground = image;
    } else {
      _premiumCityScenes[entry.key] = image;
      _cityBackgrounds[entry.key] = image;
    }
    _premiumCityThumbs[entry.key] =
        await _loadBytes('assets/images/cards/${entry.value}.webp');
  }
  _musicBytes = await _loadBytes('assets/audio/ambient.mp3');
  _celebrationEffectBytes = await _loadBytes('assets/audio/success.wav');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadArtAndAudio();
  runApp(const KelimeSehirApp());
}

class KelimeSehirApp extends StatelessWidget {
  const KelimeSehirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelime Şehirleri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE6C897)),
      ),
      home: const GameScreen(),
    );
  }
}

