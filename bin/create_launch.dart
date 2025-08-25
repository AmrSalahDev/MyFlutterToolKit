import 'dart:io';

void main(List<String> args) {
  final vscodeDir = Directory('.vscode');
  final launchFile = File('.vscode/launch.json');

  if (!vscodeDir.existsSync()) {
    vscodeDir.createSync();
    print('Created .vscode folder.');
  }

  const defaultContent = '''
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter Run (No Debug)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "noDebug": true
    }
  ]
}
''';

  if (!launchFile.existsSync()) {
    launchFile.writeAsStringSync(defaultContent);
    print('Created launch.json');
  } else {
    print('launch.json already exists.');
  }
}
