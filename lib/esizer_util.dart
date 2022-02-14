/// MIT License
/// Copyright (c) [2021] Extreme Viet Nam
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

part of esizer;

class ESizerUtil {
  static late ESizerUtil _instance;

  /// Device's screen orientation
  late Orientation _screenOrientation;

  Orientation get screenOrientation => _screenOrientation;

  /// Device's screen height
  late double _screenHeight;

  double get screenHeight => _screenHeight;

  /// Device's screen width
  late double _screenWidth;

  double get screenWidth => _screenWidth;

  /// Default for design size
  static const Size _defaultDesignSize = Size(360, 690);

  /// Size of the screen in UI Design
  late Size _screenSizeInDesign;

  /// Size data which load from size file
  static late Map<String, double> sizeMap;

  ESizerUtil._();

  factory ESizerUtil() {
    return _instance;
  }

  /// Sets the screen's size and Device's orientation,
  /// BoxConstraints, Height, and Width
  static void init(
    BoxConstraints constraints, {
    Orientation orientation = Orientation.portrait,
    Size? designSize = _defaultDesignSize,
  }) {
    _instance = ESizerUtil._()
      // Sets box constraints and orientation
      .._screenOrientation = orientation
      .._screenSizeInDesign = designSize ?? _defaultDesignSize;
    // Sets screen width and height
    if (orientation == Orientation.portrait) {
      _instance._screenWidth = constraints.maxWidth;
      _instance._screenHeight = constraints.maxHeight;
    } else {
      _instance._screenWidth = constraints.maxHeight;
      _instance._screenHeight = constraints.maxWidth;
    }
  }

  /// The ratio of actual screen width to screen design width
  double get scaleWidth => screenWidth / _screenSizeInDesign.width;

  /// The ratio of actual screen height to screen design height
  double get scaleHeight => screenHeight / _screenSizeInDesign.height;

  double get scaleText => scaleWidth;

  /// Return responsive, adapted size base on width
  double getResponsiveWidth(num width) => width * scaleWidth;

  /// Return responsive, adapted size base on height
  double getResponsiveHeight(num height) => height * scaleHeight;

  /// Return responsive, adapted [fontSize] which is the size of the font on the design
  double getResponsiveFontSize(num fontSize) => fontSize * scaleText;

  ///Adapt according to the smaller of width or height
  double getResponsiveRadius(num r) => r * min(scaleWidth, scaleHeight);

  static Future<void> _loadSizeMapFromFile(
      String pathDir, String fileName) async {
    final data = await services.rootBundle.loadString('$pathDir/$fileName');
    final sizeByKeyMap =
        json.decode(json.encode(loadYaml(data))) as Map<String, dynamic>;
    sizeMap = _simplifySizeMap({}, sizeByKeyMap);
  }

  static Map<String, double> _simplifySizeMap(
      Map<String, double> result, Map<String, dynamic> sizeMap,
      [String? parentKey]) {
    final sortedKeys = sizeMap.keys.toList();
    for (final key in sortedKeys) {
      final value = sizeMap[key];
      var currentKey = key;
      if (parentKey != null) {
        currentKey = '$parentKey.$key';
      }
      if (value is Map) {
        _simplifySizeMap(result, value as Map<String, dynamic>, currentKey);
      } else {
        result.putIfAbsent(currentKey, () => (value as num).toDouble());
      }
    }
    return result;
  }
}
