import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  handleArgs(createOptions(args));
}

Options createOptions(List<String> args) {
  final options = Options();
  createArgParserFromOptions(options).parse(args);
  return options;
}

ArgParser createArgParserFromOptions(Options? options) {
  return ArgParser()
    ..addOption('input-dir',
        abbr: 'I',
        defaultsTo: 'assets/dimens',
        callback: (String? arg) => options!.inputDir = arg,
        help: 'Input dir name')
    ..addOption('input-file',
        abbr: 'i',
        callback: (String? arg) => options!.inputFile = arg,
        help: 'Input file name')
    ..addOption('output-dir',
        abbr: 'O',
        defaultsTo: 'lib/generated',
        callback: (String? arg) => options!.outputDir = arg,
        help: 'Output dir name')
    ..addOption('output-file',
        abbr: 'o',
        defaultsTo: 'dimen_keys.g.dart',
        callback: (String? arg) => options!.outputFile = arg,
        help: 'Output file name')
    ..addOption('output-class-name',
        abbr: 'n',
        defaultsTo: 'ConstantKey',
        callback: (String? arg) => options!.outputClassName = arg,
        help: 'Output class name');
}

Future<void> handleArgs(Options options) async {
  final currentDir = Directory.current;
  final inputDir = Directory.fromUri(Uri.parse(options.inputDir!));
  final outputDir = Directory.fromUri(Uri.parse(options.outputDir!));
  final finalInputDir = Directory(path.join(currentDir.path, inputDir.path));
  final outputFile =
      Directory(path.join(currentDir.path, outputDir.path, options.outputFile));

  final bool inputDirExist = await finalInputDir.exists();
  if (!inputDirExist) {
    error('input dir does not exist');
    return;
  }

  var files = await getListFileFromInputDir(finalInputDir);
  if (options.inputFile != null) {
    final inputFile = File(path.join(inputDir.path, options.inputFile));
    final bool inputFileExist = await inputFile.exists();
    if (!inputFileExist) {
      error('input file does not exist (${inputFile.toString()})');
      return;
    }
    files = [inputFile];
  } else {
    files = files.where((file) => file.path.contains('.yaml')).toList();
  }

  if (files.isNotEmpty) {
    generateFile(files, outputFile, options);
  } else {
    error('Not found any .yaml file!');
  }
}

Future<List<FileSystemEntity>> getListFileFromInputDir(Directory dir) {
  final files = <FileSystemEntity>[];
  final completer = Completer<List<FileSystemEntity>>();
  final lister = dir.list();
  lister.listen((file) => files.add(file),
      onDone: () => completer.complete(files));
  return completer.future;
}

Future<void> generateFile(
    List<FileSystemEntity> files, Directory outputFile, Options options) async {
  final generatedFile = File(outputFile.path);
  if (!generatedFile.existsSync()) {
    generatedFile.createSync(recursive: true);
  }

  final classStringBuilder = StringBuffer();
  await generateFileContent(
      classStringBuilder, files, options.outputClassName!);
  generatedFile.writeAsStringSync(classStringBuilder.toString());

  success('All done! File generated in ${outputFile.path}');
}

Future generateFileContent(StringBuffer classStringBuilder,
    List<FileSystemEntity> files, String outputClassName) async {
  var contentString = '''
// DO NOT EDIT. This is code generated
abstract class  $outputClassName {
''';

  final file = File(files.first.path);

  final Map<String, dynamic> keyValue =
      json.decode(json.encode(loadYaml(await file.readAsString())))
          as Map<String, dynamic>;
  contentString += handleKeyValue(keyValue);

  classStringBuilder.writeln(contentString);
  classStringBuilder.writeln('}');
}

String handleKeyValue(Map<String, dynamic> keyValue, [String? parentKey]) {
  var contentString = '';

  final sortedKeys = keyValue.keys.toList();

  for (final key in sortedKeys) {
    if (keyValue[key] is Map) {
      var currentKey = key;
      if (parentKey != null) {
        currentKey = '$parentKey.$key';
      }
      contentString +=
          handleKeyValue(keyValue[key] as Map<String, dynamic>, currentKey);
    } else {
      parentKey != null
          ? contentString +=
              "  static const ${parentKey.replaceAll('.', '_')}${capitalizeFirstWord(key)} = '$parentKey.$key';\n"
          : contentString += "  static const $key = '$key';\n";
    }
  }

  return contentString;
}

String capitalizeFirstWord(String word) {
  return word.replaceFirst(word[0], word[0].toUpperCase());
}

void success(String outputPath) {
  print('\u001b[33mYaml To Key Dart Class Generator: $outputPath\u001b[0m');
}

void error(String error) {
  print('\u001b[31m[ERROR] Yaml To Key Dart Class Generator: $error\u001b[0m');
}

class Options {
  String? inputDir;
  String? inputFile;
  String? outputDir;
  String? outputFile;
  String? outputClassName;

  @override
  String toString() {
    return 'inputDir: $inputDir, sourceFile: $inputFile, outputDir: $outputDir, outputFile: $outputFile, outputClassName: $outputClassName';
  }
}
