import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tts_service.dart';

/// Musical note representation for kids interactive xylophone & piano.
class XylophoneKeyData {
  final String note;
  final String solfege;
  final double pitch;
  final Color color;

  const XylophoneKeyData({
    required this.note,
    required this.solfege,
    required this.pitch,
    required this.color,
  });
}

/// A melodic verse line score with singing prosody, pitch, and sheet notes.
class RhymeVerseScore {
  final String lyrics;
  final String sungLyrics;
  final double pitch;
  final double rate;
  final List<String> notes;

  const RhymeVerseScore({
    required this.lyrics,
    required this.sungLyrics,
    required this.pitch,
    this.rate = 0.40,
    required this.notes,
  });
}

/// Full musical arrangement for an educational nursery rhyme.
class MusicalRhyme {
  final String title;
  final String emoji;
  final String tag;
  final Color themeColor;
  final String musicalKey;
  final List<RhymeVerseScore> scores;
  final List<String> melodyNotes;
  final List<String> melodySyllables;

  const MusicalRhyme({
    required this.title,
    required this.emoji,
    required this.tag,
    required this.themeColor,
    required this.musicalKey,
    required this.scores,
    required this.melodyNotes,
    required this.melodySyllables,
  });

  List<String> get plainVerses => scores.map((s) => s.lyrics).toList();
}

/// High-level musical orchestration service for JAROOS rhymes.
class RhymeMusicService {
  final TtsService _tts;

  RhymeMusicService({TtsService? ttsService})
      : _tts = ttsService ?? ModularTtsService();

  static const List<XylophoneKeyData> rainbowKeys = [
    XylophoneKeyData(note: 'C', solfege: 'Do', pitch: 0.90, color: Color(0xFFEF5350)),
    XylophoneKeyData(note: 'D', solfege: 'Re', pitch: 1.00, color: Color(0xFFFF9800)),
    XylophoneKeyData(note: 'E', solfege: 'Mi', pitch: 1.12, color: Color(0xFFFFCA28)),
    XylophoneKeyData(note: 'F', solfege: 'Fa', pitch: 1.20, color: Color(0xFF66BB6A)),
    XylophoneKeyData(note: 'G', solfege: 'Sol', pitch: 1.35, color: Color(0xFF26A69A)),
    XylophoneKeyData(note: 'A', solfege: 'La', pitch: 1.50, color: Color(0xFF29B6F6)),
    XylophoneKeyData(note: 'B', solfege: 'Ti', pitch: 1.68, color: Color(0xFFAB47BC)),
    XylophoneKeyData(note: 'C5', solfege: 'Do!', pitch: 1.85, color: Color(0xFFEC407A)),
  ];

  static const List<MusicalRhyme> catalog = [
    MusicalRhyme(
      title: 'Twinkle, Twinkle, Little Star',
      emoji: '⭐',
      tag: 'Lullaby • Star',
      themeColor: Color(0xFFFFB300),
      musicalKey: 'Key of C Major',
      scores: [
        RhymeVerseScore(
          lyrics: 'Twinkle, twinkle, little star,\nHow I wonder what you are!',
          sungLyrics: '🎶 Twin-kle, twin-kle, lit-tle staaar... How I won-der what you aaare! ✨',
          pitch: 1.25,
          rate: 0.38,
          notes: ['C', 'C', 'G', 'G', 'A', 'A', 'G'],
        ),
        RhymeVerseScore(
          lyrics: 'Up above the world so high,\nLike a diamond in the sky.',
          sungLyrics: '🎶 Up a-bove the world so hiiigh... Like a dia-mond in the skyyy! 💎',
          pitch: 1.35,
          rate: 0.38,
          notes: ['F', 'F', 'E', 'E', 'D', 'D', 'C'],
        ),
        RhymeVerseScore(
          lyrics: 'When the blazing sun is gone,\nWhen he nothing shines upon,',
          sungLyrics: '🎶 When the bla-zing sun is goone... When he no-thing shines u-pooon... ☀️',
          pitch: 1.30,
          rate: 0.38,
          notes: ['G', 'G', 'F', 'F', 'E', 'E', 'D'],
        ),
        RhymeVerseScore(
          lyrics: 'Then you show your little light,\nTwinkle, twinkle, all the night.',
          sungLyrics: '🎶 Then you show your lit-tle liiight... Twin-kle, twin-kle, all the niiight! 🌙',
          pitch: 1.20,
          rate: 0.38,
          notes: ['C', 'C', 'G', 'G', 'A', 'A', 'G'],
        ),
      ],
      melodyNotes: ['C', 'C', 'G', 'G', 'A', 'A', 'G', 'F', 'F', 'E', 'E', 'D', 'D', 'C'],
      melodySyllables: ['Twin-', 'kle,', 'twin-', 'kle,', 'lit-', 'tle', 'star!', 'How', 'I', 'won-', 'der', 'what', 'you', 'are!'],
    ),
    MusicalRhyme(
      title: 'The Wheels on the Bus',
      emoji: '🚌',
      tag: 'Action Song • Travel',
      themeColor: Color(0xFFEF5350),
      musicalKey: 'Key of F Major',
      scores: [
        RhymeVerseScore(
          lyrics: 'The wheels on the bus go round and round,\nRound and round, round and round.\nThe wheels on the bus go round and round,\nAll through the town!',
          sungLyrics: '🎶 The wheels on the bus go round and round... Round and round, round and round! The wheels on the bus go round and round... All through the toown! 🚌',
          pitch: 1.25,
          rate: 0.40,
          notes: ['C', 'F', 'F', 'F', 'F', 'A', 'C5', 'A', 'F'],
        ),
        RhymeVerseScore(
          lyrics: 'The wipers on the bus go swish, swish, swish,\nSwish, swish, swish, swish, swish, swish.\nThe wipers on the bus go swish, swish, swish,\nAll through the town!',
          sungLyrics: '🎶 The wi-pers on the bus go swish, swish, swish... Swish, swish, swish! The wi-pers on the bus go swish, swish, swish... All through the toown! 🌧️',
          pitch: 1.30,
          rate: 0.40,
          notes: ['G', 'G', 'G', 'E', 'E', 'E', 'F'],
        ),
        RhymeVerseScore(
          lyrics: 'The horn on the bus goes beep, beep, beep,\nBeep, beep, beep, beep, beep, beep.\nThe horn on the bus goes beep, beep, beep,\nAll through the town!',
          sungLyrics: '🎶 The horn on the bus goes beep, beep, beep... Beep, beep, beep! The horn on the bus goes beep, beep, beep... All through the toown! 📯',
          pitch: 1.35,
          rate: 0.40,
          notes: ['A', 'A', 'A', 'F', 'F', 'F', 'C'],
        ),
        RhymeVerseScore(
          lyrics: 'The doors on the bus go open and shut,\nOpen and shut, open and shut.\nThe doors on the bus go open and shut,\nAll through the town!',
          sungLyrics: '🎶 The doors on the bus go o-pen and shut... O-pen and shut! The doors on the bus go o-pen and shut... All through the toown! 🚪',
          pitch: 1.20,
          rate: 0.40,
          notes: ['C', 'F', 'F', 'F', 'A', 'C5', 'F'],
        ),
      ],
      melodyNotes: ['C', 'F', 'F', 'F', 'F', 'A', 'C5', 'A', 'F', 'G', 'C', 'A', 'F'],
      melodySyllables: ['The', 'wheels', 'on', 'the', 'bus', 'go', 'round', 'and', 'round', 'all', 'through', 'the', 'town!'],
    ),
    MusicalRhyme(
      title: 'Old MacDonald Had a Farm',
      emoji: '🚜',
      tag: 'Animals • Farm',
      themeColor: Color(0xFF66BB6A),
      musicalKey: 'Key of G Major',
      scores: [
        RhymeVerseScore(
          lyrics: 'Old MacDonald had a farm, E-I-E-I-O!\nAnd on his farm he had a cow, E-I-E-I-O!',
          sungLyrics: '🎶 Old Mac-Do-nald had a farm... E-I-E-I-O! 🌾 And on his farm he had a cooow... E-I-E-I-O! 🐮',
          pitch: 1.20,
          rate: 0.38,
          notes: ['G', 'G', 'G', 'D', 'E', 'E', 'D'],
        ),
        RhymeVerseScore(
          lyrics: 'With a moo-moo here and a moo-moo there,\nHere a moo, there a moo, everywhere a moo-moo!\nOld MacDonald had a farm, E-I-E-I-O!',
          sungLyrics: '🎶 With a moo-moo here, and a moo-moo there! Here a moo, there a moo, eve-ry-where a moo-moo! Old Mac-Do-nald had a farm... E-I-E-I-O! 🥛',
          pitch: 1.30,
          rate: 0.38,
          notes: ['B', 'B', 'A', 'A', 'G'],
        ),
        RhymeVerseScore(
          lyrics: 'And on his farm he had a duck, E-I-E-I-O!\nWith a quack-quack here and a quack-quack there,\nEverywhere a quack-quack!\nOld MacDonald had a farm, E-I-E-I-O!',
          sungLyrics: '🎶 And on his farm he had a duuuck... E-I-E-I-O! 🦆 With a quack-quack here and a quack-quack there... Old Mac-Do-nald had a farm... E-I-E-I-O! 🌾',
          pitch: 1.25,
          rate: 0.38,
          notes: ['G', 'G', 'G', 'D', 'E', 'E', 'D', 'B', 'B', 'G'],
        ),
      ],
      melodyNotes: ['G', 'G', 'G', 'D', 'E', 'E', 'D', 'B', 'B', 'A', 'A', 'G'],
      melodySyllables: ['Old', 'Mac-', 'Do-', 'nald', 'had', 'a', 'farm,', 'E-', 'I-', 'E-', 'I-', 'O!'],
    ),
    MusicalRhyme(
      title: 'Baa, Baa, Black Sheep',
      emoji: '🐑',
      tag: 'Gentle • Animals',
      themeColor: Color(0xFF78909C),
      musicalKey: 'Key of D Major',
      scores: [
        RhymeVerseScore(
          lyrics: 'Baa, baa, black sheep, have you any wool?\nYes, sir, yes, sir, three bags full!',
          sungLyrics: '🎶 Baa, baa, black sheep, have you a-ny wooool? 🐑 Yes, sir, yes, sir, three bags fuuull! 🧶',
          pitch: 1.15,
          rate: 0.38,
          notes: ['D', 'D', 'A', 'A', 'B', 'B', 'A'],
        ),
        RhymeVerseScore(
          lyrics: 'One for the master, and one for the dame,\nAnd one for the little boy who lives down the lane.',
          sungLyrics: '🎶 One for the mas-ter, and one for the daaame... And one for the lit-tle boy who lives down the laaane! 🏡',
          pitch: 1.25,
          rate: 0.38,
          notes: ['G', 'G', 'F', 'F', 'E', 'E', 'D'],
        ),
      ],
      melodyNotes: ['D', 'D', 'A', 'A', 'B', 'B', 'A', 'G', 'G', 'F', 'F', 'E', 'E', 'D'],
      melodySyllables: ['Baa,', 'baa,', 'black', 'sheep,', 'have', 'you', 'wool?', 'Yes', 'sir,', 'yes', 'sir,', 'three', 'bags', 'full!'],
    ),
    MusicalRhyme(
      title: 'Humpty Dumpty',
      emoji: '🥚',
      tag: 'Classic • Rhythm',
      themeColor: Color(0xFFFF7043),
      musicalKey: 'Key of C Major',
      scores: [
        RhymeVerseScore(
          lyrics: 'Humpty Dumpty sat on a wall,\nHumpty Dumpty had a great fall!',
          sungLyrics: '🎶 Hump-ty Dump-ty sat on a waaall... Hump-ty Dump-ty had a great faaall! 🥚💥',
          pitch: 1.20,
          rate: 0.40,
          notes: ['C', 'E', 'G', 'C5', 'G', 'E', 'C'],
        ),
        RhymeVerseScore(
          lyrics: 'All the king\'s horses and all the king\'s men,\nCouldn\'t put Humpty together again!',
          sungLyrics: '🎶 All the king\'s hor-ses and all the king\'s meeen... Could-n\'t put Hump-ty to-ge-ther a-gaaain! 🏰',
          pitch: 1.10,
          rate: 0.40,
          notes: ['D', 'F', 'A', 'G', 'F', 'E', 'D', 'C'],
        ),
      ],
      melodyNotes: ['C', 'E', 'G', 'C5', 'G', 'E', 'C', 'D', 'F', 'A', 'G', 'C'],
      melodySyllables: ['Hump-', 'ty', 'Dump-', 'ty', 'sat', 'on', 'wall,', 'had', 'a', 'very', 'great', 'fall!'],
    ),
    MusicalRhyme(
      title: 'Row, Row, Row Your Boat',
      emoji: '🚣',
      tag: 'Calm • Water',
      themeColor: Color(0xFF29B6F6),
      musicalKey: 'Key of C Major',
      scores: [
        RhymeVerseScore(
          lyrics: 'Row, row, row your boat,\nGently down the stream,\nMerrily, merrily, merrily, merrily,\nLife is but a dream!',
          sungLyrics: '🎶 Row, row, row your boooat... Gent-ly down the streeeam... 🚣 Mer-ri-ly, mer-ri-ly, mer-ri-ly, mer-ri-ly... Life is but a dreeeam! ✨',
          pitch: 1.20,
          rate: 0.36,
          notes: ['C', 'C', 'C', 'D', 'E', 'E', 'D', 'E', 'F', 'G', 'C5'],
        ),
      ],
      melodyNotes: ['C', 'C', 'C', 'D', 'E', 'E', 'D', 'E', 'F', 'G', 'C5', 'G', 'E', 'C'],
      melodySyllables: ['Row,', 'row,', 'row', 'your', 'boat', 'gent-', 'ly', 'down', 'the', 'stream,', 'mer-', 'ri-', 'ly', 'dream!'],
    ),
    MusicalRhyme(
      title: 'Incy Wincy Spider',
      emoji: '🕷️',
      tag: 'Perseverance • Nature',
      themeColor: Color(0xFFAB47BC),
      musicalKey: 'Key of G Major',
      scores: [
        RhymeVerseScore(
          lyrics: 'Incy Wincy spider climbed up the water spout.\nDown came the rain and washed the spider out!',
          sungLyrics: '🎶 In-cy Win-cy spi-der climbed up the wa-ter spout... 🕷️ Down came the rain and washed the spi-der out! 🌧️',
          pitch: 1.25,
          rate: 0.38,
          notes: ['G', 'C', 'C', 'C', 'D', 'E', 'E', 'E', 'D', 'C', 'D', 'E', 'C'],
        ),
        RhymeVerseScore(
          lyrics: 'Out came the sunshine and dried up all the rain,\nAnd Incy Wincy spider climbed up the spout again!',
          sungLyrics: '🎶 Out came the sun-shine and dried up all the rain... ☀️ And In-cy Win-cy spi-der climbed up the spout a-gaaain! 🌈',
          pitch: 1.30,
          rate: 0.38,
          notes: ['E', 'E', 'F', 'G', 'G', 'F', 'E', 'F', 'G', 'E', 'C', 'C', 'D', 'E', 'C'],
        ),
      ],
      melodyNotes: ['G', 'C', 'C', 'C', 'D', 'E', 'E', 'E', 'D', 'C', 'D', 'E', 'C'],
      melodySyllables: ['In-', 'cy', 'Win-', 'cy', 'spi-', 'der', 'climbed', 'up', 'the', 'wa-', 'ter', 'spout', 'again!'],
    ),
    MusicalRhyme(
      title: 'Five Little Monkeys',
      emoji: '🐒',
      tag: 'Counting • Fun',
      themeColor: Color(0xFFFFA000),
      musicalKey: 'Key of E Major',
      scores: [
        RhymeVerseScore(
          lyrics: 'Five little monkeys jumping on the bed,\nOne fell off and bumped his head!',
          sungLyrics: '🎶 Five lit-tle mon-keys jum-ping on the beeed! 🐒 One fell off and bumped his head! Ouch! 🤕',
          pitch: 1.25,
          rate: 0.40,
          notes: ['E', 'E', 'E', 'G', 'E', 'D', 'C'],
        ),
        RhymeVerseScore(
          lyrics: 'Mama called the doctor and the doctor said:\n"No more monkeys jumping on the bed!"',
          sungLyrics: '🎶 Ma-ma called the doc-tor and the doc-tor saaaid: 📞 "No more mon-keys jum-ping on the beeed!" 🩺',
          pitch: 1.35,
          rate: 0.38,
          notes: ['G', 'G', 'G', 'E', 'D', 'C'],
        ),
      ],
      melodyNotes: ['E', 'E', 'E', 'G', 'E', 'D', 'C', 'G', 'G', 'G', 'E', 'D', 'C'],
      melodySyllables: ['Five', 'lit-', 'tle', 'mon-', 'keys', 'jum-', 'ping', 'on', 'the', 'bed,', 'bumped', 'his', 'head!'],
    ),
  ];

  static MusicalRhyme findRhyme(String title) {
    return catalog.firstWhere(
      (r) => r.title.toLowerCase().trim() == title.toLowerCase().trim(),
      orElse: () => catalog.first,
    );
  }

  Future<void> playXylophoneKey(XylophoneKeyData key) async {
    try {
      await SystemSound.play(SystemSoundType.click);
      await HapticFeedback.lightImpact();
    } catch (_) {}

    await _tts.singPhrase('${key.solfege}! 🎵', pitch: key.pitch, rate: 0.55);
  }

  Future<void> playPercussion(String instrument) async {
    try {
      await SystemSound.play(SystemSoundType.click);
      await HapticFeedback.mediumImpact();
    } catch (_) {}

    switch (instrument.toLowerCase()) {
      case 'drum':
        await _tts.singPhrase('Boom! Boom-chick! 🥁', pitch: 0.85, rate: 0.50);
        break;
      case 'bell':
        await _tts.singPhrase('Ting-a-ling! 🔔 Sparkle! ✨', pitch: 1.65, rate: 0.55);
        break;
      case 'horn':
        await _tts.singPhrase('Honk! Beep-beep! 📯', pitch: 1.40, rate: 0.50);
        break;
      case 'clap':
        await _tts.singPhrase('Clap-clap-clap! 👏 Yay! 🎉', pitch: 1.25, rate: 0.55);
        break;
      case 'frog':
        await _tts.singPhrase('La-la-la! Ribbit-sing! 🐸🎵', pitch: 1.15, rate: 0.45);
        break;
      default:
        await _tts.singPhrase('Music! 🎶', pitch: 1.20, rate: 0.50);
        break;
    }
  }

  Future<void> singVerse(RhymeVerseScore score) async {
    await _tts.singPhrase(
      score.sungLyrics,
      pitch: score.pitch,
      rate: score.rate,
    );
  }

  Future<void> playMusicalLeadIn() async {
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {}
    await _tts.singPhrase('🎵 1, 2, 3... Let\'s sing together! 🎶', pitch: 1.20, rate: 0.44);
  }

  Future<void> playMusicalFinale(String title) async {
    try {
      await SystemSound.play(SystemSoundType.click);
      await HapticFeedback.heavyImpact();
    } catch (_) {}
    await _tts.singPhrase('🌟 Yay! Beautiful singing for $title! You earned 10 Music Stars! 🎶👏', pitch: 1.25, rate: 0.44);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
