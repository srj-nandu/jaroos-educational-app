import 'piper_tts_service.dart';

/// Backwards compatibility alias for PiperTtsService.
/// Migrated to high-performance Piper TTS (rhasspy/piper) ONNX engine.
class CoquiTtsService extends PiperTtsService {
  CoquiTtsService({
    super.customServerUrl,
    super.simulateDelay = true,
  });
}
