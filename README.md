# ESizer

A Flutter package provide responsive, dynamic, configurable size for each device screen size.

## Features

- Responsive, adaptive size
- Dynamic load size data from predefined files from assets

## Getting Started

This package is use to develop app which use Bloc pattern clearer, quicker, easier by wrapping
complicated bloc usage.

## Usage

### Create size resource data file and add to pubspec

- Create size resource data files (currently support only yaml format)  in default folder : "
  assets/dimens". For example:

```yaml
homeScreen:
  contentPadding: 10
  iconSize: 50
  titleTextSize: 24
  descriptionTextSize: 16
  widgetSpaceSize: 16
```

- Add assets folder path to pubspec.yaml file:

```yaml
flutter:
  # ... 
  assets:
    - assets/dimens/
```

### Config and use in application

- Make sure `WidgetsFlutterBinding.ensureInitialized();` main function before application start:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
```

### Using widget

```dart
ESizer(
  builder: (BuildContext context) {
    return const ResponsiveHomePage();
  },
  sizeFileResolver: ({BoxConstraints? boxConstraints, Orientation? orientation}) => "phone.yaml",
)
```

Above code for `sizeFileResolver` function use very simple logic: return name of resource file. You
can also add more logic to specify how to choose which size data files to load in.

For example: load 'phone.yaml' or 'table.yaml' depend on width and orientation of device

```dart
  String _resolveSizeDataFile({BoxConstraints? boxConstraints, Orientation? orientation}) {
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
```

# Code generation for size data

By using command 'esizer:generate' you can generate dart code for more convenient

```shell
flutter pub run esizer:generate -I assets/dimens -o dimen_keys.g.dart -n DimenKeys 
```

Then we have class like:

```dart
abstract class DimenKeys {
  static const homeScreenIconSize = 'homeScreen.icon_size';
  static const homeScreenTitleTextSize = 'homeScreen.titleTextSize';
  static const homeScreenDescriptionTextSize = 'homeScreen.descriptionTextSize';
  static const homeScreenWidgetSpaceSize = 'homeScreen.widgetSpaceSize';
  static const homeScreenContentPadding = 'homeScreen.contentPadding';
}
```

After that, in any where in application we use it as bellow:

```dart
Container (
  padding:EdgeInsets.all(DimenKeys.homeScreen_content_padding.sw),
  color: Colors.white)
```

## Issues and feedback
Create issues and add appropriate label on Github issues or into our [mailing list]
For more detail see [CONTRIBUTING](CONTRIBUTING.md)

## Contributor

- [Justin Lewis](https://github.com/justin-lewis) (Maintainer)
- [dung95bk](https://github.com/dung95bk) (Developer)

## License

[MIT](LICENSE)

[mailing list]: https://groups.google.com/g/esizer_group