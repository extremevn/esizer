import 'dart:io';

import 'package:esizer/esizer.dart';
import 'package:example/responsive_home_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESizer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ESizer(
        builder: (BuildContext context) {
          return const ResponsiveHomePage();
        },
        sizeFileResolver: _resolveSizeDataFile,
      ),
    );
  }

  String _resolveSizeDataFile(
      {BoxConstraints? boxConstraints, Orientation? orientation}) {
    if (boxConstraints != null) {
      if (Platform.isAndroid || Platform.isIOS) {
        if (orientation == Orientation.portrait) {
          if (boxConstraints.maxWidth < 600) {
            return "phone.yaml";
          } else {
            return "tablet.yaml";
          }
        } else if (orientation == Orientation.landscape) {
          if (boxConstraints.maxHeight < 600) {
            return "phone.yaml";
          } else {
            return "tablet.yaml";
          }
        } else {
          return "phone.yaml";
        }
      } else {
        return "phone.yaml";
      }
    }
    return "phone.yaml";
  }
}
