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

typedef SizeDataFileNameResolver = String Function(
    {BoxConstraints? boxConstraints, Orientation? orientation});

/// A widget that gets the device's details like orientation and constraints
///
/// Usage: Wrap MaterialApp with this widget
class ESizer extends StatelessWidget {
  const ESizer(
      {Key? key,
      required this.builder,
      required this.sizeFileResolver,
      this.designSize,
      this.path,
      this.loadingWidget,
      this.errorWidget})
      : super(key: key);

  /// Default asset folder which size data files are in
  static const defaultPath = "assets/dimens";

  /// Builds the widget whenever the orientation changes
  final WidgetBuilder builder;

  /// Widget display when load size data from files
  final Widget? loadingWidget;

  /// Widget display when error occurs
  final Widget? errorWidget;

  /// The [Size] of the screen in the design
  final Size? designSize;

  /// Asset folder path which size data files are in
  final String? path;

  final SizeDataFileNameResolver sizeFileResolver;

  Future<bool> ensureInitialized(SizeDataFileNameResolver sizeFileResolver,
      {String path = defaultPath,
      BoxConstraints? boxConstraints,
      Orientation? orientation}) async {
    await ESizerUtil._loadSizeMapFromFile(
        path,
        sizeFileResolver.call(
            boxConstraints: boxConstraints, orientation: orientation));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window),
      child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          return FutureBuilder(
            future: ensureInitialized(sizeFileResolver,
                path: path ?? defaultPath,
                boxConstraints: constraints,
                orientation: orientation),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                ESizerUtil.init(constraints,
                    orientation: orientation, designSize: designSize);
                return builder(context);
              } else if (snapshot.hasError) {
                return errorWidget ??
                    Scaffold(
                        body: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: const Text(
                              'Opp! There is something wrong!\n Maybe loading size data files is root cause, please check error log',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            )));
              } else {
                return loadingWidget ??
                    Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator());
              }
            },
          );
        });
      }),
    );
  }
}
