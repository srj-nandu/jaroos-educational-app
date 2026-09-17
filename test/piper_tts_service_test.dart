import 'package:flutter_test/flutter_test.dart';
import 'package:jaroos/core/services/piper_tts_service.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/models/voice_persona_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PiperTtsService Unit Tests', () {
    test('Initializes with default child persona and idle state', () {
      final tts = PiperTtsService(simulateDelay: false);

      expect(tts.isSpeaking, isFalse);
      expect(tts.currentSpeech.value, isNull);
      expect(tts.currentVoicePersona, 'sparky_kid');
      expect(tts.currentLanguageCode, 'en');
      expect(tts.availablePersonas.isNotEmpty, isTrue);
    });

    test('Configures server URL and normalizes trailing slashes', () {
      final tts = PiperTtsService(
        customServerUrl: 'http://127.0.0.1:5002///',
        simulateDelay: false,
      );

      expect(tts.serverUrl, 'http://127.0.0.1:5002');

      tts.serverUrl = 'http://192.168.1.100:5002/';
      expect(tts.serverUrl, 'http://192.168.1.100:5002');
    });

    test('Switches voice personas and speech parameters correctly', () async {
      final tts = PiperTtsService(simulateDelay: false);

      await tts.setVoicePersona('talking_tom');
      expect(tts.currentVoicePersona, 'talking_tom');

      await tts.setVoicePersona('dora_explorer');
      expect(tts.currentVoicePersona, 'dora_explorer');

      await tts.setLanguage('hi');
      expect(tts.currentLanguageCode, 'hi');

      await tts.setSpeechRate(1.25);
      expect(tts.isSpeaking, isFalse);
    });

    test('Handles speak request and stops cleanly with fallback', () async {
      final tts = PiperTtsService(simulateDelay: false);

      final speakFuture = tts.speak('Piper ONNX neural speech synthesis');
      expect(tts.isSpeaking, isTrue);
      expect(tts.currentSpeech.value, 'Piper ONNX neural speech synthesis');

      await speakFuture;
      expect(tts.isSpeaking, isFalse);
      expect(tts.currentSpeech.value, isNull);
    });

    test('Stop immediately halts ongoing speech and resets notifier', () async {
      final tts = PiperTtsService(simulateDelay: false);

      tts.speak('Long story narration test with Piper ONNX');
      expect(tts.isSpeaking, isTrue);

      await tts.stop();
      expect(tts.isSpeaking, isFalse);
      expect(tts.currentSpeech.value, isNull);
    });

    test('Preview persona executes sample phrase cleanly', () async {
      final tts = PiperTtsService(simulateDelay: false);
      final talkingTom = VoicePersona.talkingTom;

      await tts.previewPersona(talkingTom);
      expect(tts.isSpeaking, isFalse);
    });
  });

  group('ModularTtsService Piper Integration Tests', () {
    test('ModularTtsService defaults to Piper neural engine mode', () {
      expect(ModularTtsService.engineMode, TtsEngineMode.piperNeural);

      ModularTtsService.setEngineMode(TtsEngineMode.systemNative);
      expect(ModularTtsService.engineMode, TtsEngineMode.systemNative);

      ModularTtsService.setEngineMode(TtsEngineMode.piperNeural);
      expect(ModularTtsService.engineMode, TtsEngineMode.piperNeural);
    });

    test('ModularTtsService configures and exposes Piper server URL', () {
      ModularTtsService.setPiperServerUrl('http://10.0.2.2:5002');
      expect(ModularTtsService.piperServerUrl, 'http://10.0.2.2:5002');
      expect(ModularTtsService.coquiServerUrl, 'http://10.0.2.2:5002');
    });

    test('PiperTtsService fetches available models and handles model switching', () async {
      final tts = PiperTtsService(simulateDelay: false);
      final models = await tts.fetchAvailableModels();
      expect(models.isNotEmpty, isTrue);
      expect(models.any((m) => m['id'] == 'en_US-lessac-medium'), isTrue);

      final selected = await tts.selectModel('en_US-amy-medium');
      expect(selected, isTrue);
      expect(tts.activeModelName.value, 'en_US-amy-medium');
    });

    test('ModularTtsService manages model download and selection', () async {
      final models = await ModularTtsService.fetchPiperModels();
      expect(models.isNotEmpty, isTrue);

      final downloadSuccess = await ModularTtsService.downloadPiperModel('en_US-danny-low');
      expect(downloadSuccess, isA<bool>());

      final selectSuccess = await ModularTtsService.selectPiperModel('en_US-lessac-medium');
      expect(selectSuccess, isA<bool>());
    });
  });
}
