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

extension ESizerNumExtension on num {
  /// Calculates the height depending on the device's screen size
  ///
  /// Eg: 20.sh -> will take 20% of the screen's height
  double get sh => this * ESizerUtil().screenHeight / 100;

  /// Calculates the width depending on the device's screen size
  ///
  /// Eg: 20.sw -> will take 20% of the screen's width
  double get sw => this * ESizerUtil().screenWidth / 100;

  /// Calculates the real width depending on the design's screen size
  ///
  /// Eg: 20.w -> will be 30 if design width is 300 && device width is 450
  double get w => ESizerUtil().getResponsiveWidth(this);

  /// Calculates the real height depending on the design's screen size
  ///
  /// Eg: 20.h -> will be 30 if design height is 300 && device height is 450
  double get h => ESizerUtil().getResponsiveHeight(this);

  /// Calculates the radius depending on minimum between .w and .h
  ///
  /// Eg: 20.r -> will be 30 if design size is (300, 600) and device size is (450, 1000)
  double get r => ESizerUtil().getResponsiveRadius(this);

  /// Calculates the font size
  double get sp => ESizerUtil().getResponsiveFontSize(this);
}

extension ESizerStringExtension on String {
  /// Calculates the height depending on the device's screen size
  ///
  /// Eg: 20.sh -> will take 20% of the screen's height
  double get sh => ESizerUtil.getValueOf(this).sh;

  /// Calculates the width depending on the device's screen size
  ///
  /// Eg: 20.sw -> will take 20% of the screen's width
  double get sw => ESizerUtil.getValueOf(this).sw;

  /// Calculates the real width depending on the design's screen size
  ///
  /// Eg: 20.w -> will be 30 if design width is 300 && device width is 450
  double get w => ESizerUtil.getValueOf(this).w;

  /// Calculates the real height depending on the design's screen size
  ///
  /// Eg: 20.h -> will be 30 if design height is 300 && device height is 450
  double get h => ESizerUtil.getValueOf(this).h;

  /// Calculates the radius depending on minimum between .w and .h
  ///
  /// Eg: 20.r -> will be 30 if design size is (300, 600) and device size is (450, 1000)
  double get r => ESizerUtil.getValueOf(this).r;

  /// Calculates the font size
  double get sp => ESizerUtil.getValueOf(this).sp;
}
