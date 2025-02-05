import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Converts the design points to Flutter logical pixels
double designToLp(final double designPoints) => designPoints * PlanDimens().designToLpRatio;

extension DoubleDimensExtension on double {
  ///Converts the design points to Flutter logical pixels
  double get toLp => designToLp(this);
}

extension IntDimensExtension on int {
  ///Converts the design points to Flutter logical pixels
  double get toLp => designToLp(toDouble());
}

/// Widget that handles difference between the planned dimensions on design and flutter logical pixels
class PlanDimensionsWidget extends StatelessWidget {
  const PlanDimensionsWidget({
    super.key,
    required this.child,
    this.phoneMinSideDesignPoints = 608.0,
    this.tabletMinSideDesignPoints = 1080.0,
    this.desktopMinSideDesignPoints = 1444.0,
  });

  final Widget child;

  /// The size in of the smallest side of the phone screen. Provided as "design points"
  final double phoneMinSideDesignPoints;

  /// The size of the smallest side of the tablet screen. Provided as "design points"
  final double tabletMinSideDesignPoints;

  /// The size of the smallest side of the desktop screen. Provided as "design points"
  final double desktopMinSideDesignPoints;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final BuildContext context, final BoxConstraints constraints) {
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;
          final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

          final bool isLandscape = screenWidth > screenHeight;
          final double minSide = min(screenWidth, screenHeight);
          double minSideDesignPoints = 0.0;

          if (minSide < 600.0) {
            _log("AppDimensions is running on phone");
            minSideDesignPoints = phoneMinSideDesignPoints;
          } else if (minSide < 1000.0) {
            _log("AppDimensions is running on tablet");
            minSideDesignPoints = tabletMinSideDesignPoints;
          } else {
            _log("AppDimensions is running on desktop or TV");
            minSideDesignPoints = desktopMinSideDesignPoints;
          }

          final double ratio = screenWidth / screenHeight;
          final double designPointsWidth = isLandscape ? minSideDesignPoints * ratio : minSideDesignPoints;
          final double designPointsHeight = isLandscape ? minSideDesignPoints : minSideDesignPoints / ratio;
          final double designToLpRatio = screenHeight / designPointsHeight;

          _log("AppDimensions measured\n"
              "width: $screenWidth height: $screenHeight\n"
              "pixelRatio: $devicePixelRatio\n"
              "isLandscape: $isLandscape\n"
              "minSide: $minSide\n"
              "minSideDesignPoints: $minSideDesignPoints\n"
              "designPointsWidth: $designPointsWidth\n"
              "designPointsHeight: $designPointsHeight\n"
              "designToLpRatio: $designToLpRatio\n");

          // We don't need inherited widget here, as we will not be able to use number extensions (like 36.0.toPlan),
          // so using AppDimens singleton instead to store the data.
          //
          // return AppDimensions(
          //   planWidth: planWidth,
          //   planHeight: planHeight,
          //   screenWidth: screenWidth,
          //   screenHeight: screenHeight,
          //   planFactRatio: planFactRatio,
          //   child: child,
          // );
          PlanDimens()._init(designPointsWidth, designPointsHeight, screenWidth, screenHeight, designToLpRatio);
          return child;
        },
      );

  void _log(final String message) {
    if (kDebugMode) print(message);
  }
}

// extension ContextDimensExtension on BuildContext {
//   double planToFact(final double value) => AppDimensions.of(this)?.planToFact(value) ?? 0.0;
//
//   double get screenWidth => AppDimensions.of(this)?.screenWidth ?? 0.0;
//
//   double get screenHeight => AppDimensions.of(this)?.screenHeight ?? 0.0;
//
//   double get designPointsWidth => AppDimensions.of(this)?.designPointsWidth ?? 0.0;
//
//   double get designPointsHeight => AppDimensions.of(this)?.designPointsHeight ?? 0.0;
//
//   double get designToLpRatio => AppDimensions.of(this)?.designToLpRatio ?? 0.0;
// }

// class AppDimensions extends InheritedWidget {
//   const AppDimensions({
//     super.key,
//     required this.designPointsWidth,
//     required this.designPointsHeight,
//     required this.screenWidth,
//     required this.screenHeight,
//     required this.designToLpRatio,
//     required super.child,
//   });
//
//   final double designPointsWidth;
//   final double designPointsHeight;
//   final double screenWidth;
//   final double screenHeight;
//   final double designToLpRatio;
//
//   double planToFact(final double plan) => plan * designToLpRatio;
//
//   static AppDimensions? of(final BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppDimensions>();
//
//   @override
//   bool updateShouldNotify(final AppDimensions oldWidget) =>
//       (oldWidget.designPointsWidth != designPointsWidth) ||
//       (oldWidget.designPointsHeight != designPointsHeight) ||
//       (oldWidget.screenWidth != screenWidth) ||
//       (oldWidget.screenHeight != screenHeight);
// }

class PlanDimens {
  factory PlanDimens() => _inst;

  PlanDimens._constructor();

  static final PlanDimens _inst = PlanDimens._constructor();

  double _designPointsWidth = 0.0;
  double _designPointsHeight = 0.0;
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;
  double _designToLpRatio = 0.0;

  /// The width of the screen in design points
  double get designPointsWidth => _designPointsWidth;

  /// The height of the screen in design points
  double get designPointsHeight => _designPointsHeight;

  /// The width of the screen in Flutter logical pixels
  double get screenWidth => _screenWidth;

  /// The height of the screen in Flutter logical pixels
  double get screenHeight => _screenHeight;

  /// The ratio of the design points to Flutter logical pixels
  double get designToLpRatio => _designToLpRatio;

  void _init(
    final double designPointsWidth,
    final double designPointsHeight,
    final double screenWidth,
    final double screenHeight,
    final double designToLpRatio,
  ) {
    _designPointsWidth = designPointsWidth;
    _designPointsHeight = designPointsHeight;
    _screenWidth = screenWidth;
    _screenHeight = screenHeight;
    _designToLpRatio = designToLpRatio;
  }
}
