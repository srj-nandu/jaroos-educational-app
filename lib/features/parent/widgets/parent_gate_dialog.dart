import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/parent_provider.dart';

/// Child-Safe Parent Gate Dialog.
/// Protects settings, external links, and the Parent Dashboard from accidental access by kids.
/// Supports both 4-digit PIN (default 1234) and dynamic Math challenges for grown-ups.
class ParentGateDialog extends StatefulWidget {
  final VoidCallback onSuccess;

  const ParentGateDialog({
    super.key,
    required this.onSuccess,
  });

  /// Convenient helper to prompt the parent gate anywhere in the app
  static Future<void> show(BuildContext context, {required VoidCallback onSuccess}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ParentGateDialog(onSuccess: onSuccess),
    );
  }

  @override
  State<ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<ParentGateDialog> {
  final TextEditingController _inputCtrl = TextEditingController();
  bool _isMathMode = false;
  String? _errorMessage;

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  void _verify(ParentProvider parent) {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    bool isValid = false;
    if (_isMathMode) {
      final answer = int.tryParse(text);
      if (answer != null) {
        isValid = parent.verifyMathAnswer(answer);
      }
    } else {
      isValid = parent.verifyPin(text);
    }

    if (isValid) {
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      setState(() {
        _errorMessage = _isMathMode
            ? 'Incorrect answer. Try again!'
            : 'Incorrect PIN. Default is 1234';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parent = context.watch<ParentProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Shield Icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: AppColors.primaryDark,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),

            // Title
            Text(
              'Grown-ups Only 👨‍👩‍👧',
              style: GoogleFonts.fredoka(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isMathMode
                  ? 'Please solve this math equation:'
                  : 'Enter your 4-digit Parent PIN:',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Challenge Area
            if (_isMathMode) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${parent.mathQuestion} = ?',
                      style: GoogleFonts.fredoka(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => parent.generateNewMathChallenge(),
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      tooltip: 'New Question',
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Default PIN: 1234',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryDark,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Text Input Field
            TextField(
              controller: _inputCtrl,
              autofocus: true,
              keyboardType: TextInputType.number,
              maxLength: _isMathMode ? 4 : 4,
              obscureText: !_isMathMode,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(fontSize: 22, letterSpacing: 6),
              decoration: InputDecoration(
                counterText: '',
                hintText: _isMathMode ? 'Answer' : '••••',
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onSubmitted: (_) => _verify(parent),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: () => _verify(parent),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Enter Parent Dashboard',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Mode Toggle & Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isMathMode = !_isMathMode;
                      _errorMessage = null;
                      _inputCtrl.clear();
                    });
                  },
                  child: Text(
                    _isMathMode ? 'Switch to PIN 🔢' : 'Switch to Math 🧮',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
