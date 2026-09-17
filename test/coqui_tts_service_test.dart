import 'package:flutter_test/flutter_test.dart';
import 'package:jaroos/core/services/coqui_tts_service.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/models/voice_persona_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CoquiTtsService Unit Tests', () {
    test('Initializes with default child persona and idle state', () {
      final tts = CoquiTtsService(simulateDelay: false);

      expect(tts.isSpeaking, isFalse);
      expect(tts.currentSpeech.value, isNull);
      expect(tts.currentVoicePersona, 'sparky_kid');
      expect(tts.currentLanguageCode, 'en');
      expect(tts.availablePersonas.isNotEmpty, isTrue);
    });

    test('Configures server URL and normalizes trailing slashes', () {
      final tts = CoquiTtsService(
        customServerUrl: 'http://127.0.0.1:5002///',
        simulateDelay: false,
      );

      expect(tts.serverUrl, 'http://127.0.0.1:5002');

      tts.serverUrl = 'http://192.168.1.100:5002/';
      expect(tts.serverUrl, 'http://192.168.1.100:5002');
    });

    test('Switches voice personas and speech parameters correctly', () async {
      final tts = CoquiTtsService(simulateDelay: false);

      await tts.setVoicePersona('dora_explorer');
      expect(tts.currentVoicePersona, 'dora_explorer');

      await tts.setLanguage('hi');
      expect(tts.currentLanguageCode, 'hi');

      await tts.setSpeechRate(1.25);
      // Ensure no crash or exception
      expect(tts.isSpeaking, isFalse);
    });

    test('Handles speak request and stops cleanly with fallback', () async {
      final tts = CoquiTtsService(simulateDelay: false);

      final speakFuture = tts.speak('Coqui AI neural speech synthesis');
      expect(tts.isSpeaking, isTrue);
      expect(tts.currentSpeech.value, 'Coqui AI neural speech synthesis');

      await speakFuture;
      expect(tts.isSpeaking, isFalse);
      expect(tts.currentSpeech.value, isNull);
    });

    test('Stop immediately halts ongoing speech and resets notifier', () async {
      final tts = CoquiTtsService(simulateDelay: false);

      tts.speak('Long story narration test with Coqui');
      expect(tts.isSpeaking, isTrue);

      await tts.stop();
      expect(tts.isSpeaking, isFalse);
      expect(tts.currentSpeech.value, isNull);
    });

    test('Preview persona executes sample phrase cleanly', () async {
      final tts = CoquiTtsService(simulateDelay: false);
      final dora = VoicePersona.dora;

      await tts.previewPersona(dora);
      expect(tts.isSpeaking, isFalse);
    });
  });

  group('ModularTtsService Coqui Integration Tests', () {
    test('ModularTtsService supports Coqui neural and Piper engine modes', () {
      expect(
        ModularTtsService.engineMode == TtsEngineMode.piperNeural || ModularTtsService.engineMode == TtsEngineMode.coquiNeural,
        isTrue,
      );

      ModularTtsService.setEngineMode(TtsEngineMode.systemNative);
      expect(ModularTtsService.engineMode, TtsEngineMode.systemNative);

      ModularTtsService.setEngineMode(TtsEngineMode.coquiNeural);
      expect(ModularTtsService.engineMode, TtsEngineMode.coquiNeural);

      ModularTtsService.setEngineMode(TtsEngineMode.piperNeural);
      expect(ModularTtsService.engineMode, TtsEngineMode.piperNeural);
    });

    test('ModularTtsService configures and exposes Coqui server URL', () {
      ModularTtsService.setCoquiServerUrl('http://10.0.2.2:5002');
      expect(ModularTtsService.coquiServerUrl, 'http://10.0.2.2:5002');
      expect(ModularTtsService.piperServerUrl, 'http://10.0.2.2:5002');
    });
  });
}
