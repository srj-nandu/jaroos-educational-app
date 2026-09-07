import 'package:flutter/material.dart';

/// Responsive design utility for the JAROOS application.
/// Ensures touch targets, grid columns, padding, and font scales adapt
/// seamlessly across small phones, standard phones, large displays, and tablets.
class ResponsiveUtil {
  // Breakpoints
  static const double smallPhoneBreakpoint = 360.0;
  static const double tabletBreakpoint = 600.0;
  static const double desktopBreakpoint = 900.0;

  // Minimum touch target size for young children (Accessibility: 48–56dp)
  static const double minChildTouchTarget = 52.0;

  /// Returns true if device width is less than 360dp
  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < smallPhoneBreakpoint;
  }

  /// Returns true if device is considered a tablet (width >= 600dp)
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= tabletBreakpoint;
  }

  /// Returns true if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Screen Width
  static double width(BuildContext context) => MediaQuery.of(context).size.width;

  /// Screen Height
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  /// Dynamic grid column count for learning module cards
  /// Phones: 2 columns | Tablets: 3 or 4 columns
  static int getModuleGridColumns(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    if (shortest >= tabletBreakpoint) {
      return 3;
    }
    return 2;
  }

  /// Grid column count for learning item grids (e.g. Alphabets A-Z, Numbers)
  static int getLearningGridColumns(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    if (shortest >= tabletBreakpoint) {
      return 4;
    }
    return 2;
  }

  /// Dynamic horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    final screenWidth = width(context);
    if (screenWidth > tabletBreakpoint) {
      return 32.0;
    } else if (screenWidth < smallPhoneBreakpoint) {
      return 12.0;
    }
    return 18.0;
  }

  /// Scale factor for font sizes, clamped to maintain child readability
  static double textScaleFactor(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    return textScaler.scale(1.0).clamp(0.85, 1.25);
  }

  ResponsiveUtil._();
}
