import 'dart:io';

void main(List<String> arguments) async {
  final libDir = Directory('lib');

  final folders = [
    'model',
    'service/api',
    'service/lokal',
    'viewmodel',
    'view',
    'other',
    'customwidget',
  ];

  for (final folder in folders) {
    final dir = Directory('${libDir.path}/$folder');
    await dir.create(recursive: true);
  }

  final dependenciesToAdd = {
    'hexcolor': '^3.0.1',
    'provider': '^6.1.2',
    'intl': '^0.20.1',
    'dio': '^5.8.0',
    'shared_preferences': '^2.2.3',
  };

  final pubspecFile = File('pubspec.yaml');
  if (await pubspecFile.exists()) {
    final lines = await pubspecFile.readAsLines();

    final newLines = <String>[];
    bool inDependencies = false;
    final existingDependencies = <String>{};

    for (final line in lines) {
      newLines.add(line);
      if (line.trim() == 'dependencies:') {
        inDependencies = true;
      } else if (inDependencies && (line.startsWith(RegExp(r'^[a-zA-Z]')))) {
        final depName = line.split(':').first.trim();
        existingDependencies.add(depName);
      } else if (inDependencies && line.trim().isEmpty) {
        inDependencies = false;
      }
    }

    final toInsert = dependenciesToAdd.entries
        .where((entry) => !existingDependencies.contains(entry.key))
        .map((entry) => '  ${entry.key}: ${entry.value}')
        .toList();

    if (toInsert.isNotEmpty) {
      final insertIndex =
          newLines.indexWhere((line) => line.trim() == 'dependencies:') + 1;
      newLines.insertAll(insertIndex, toInsert);
      await pubspecFile.writeAsString(newLines.join('\n'));
      print('✅ Dependencies added to pubspec.yaml');
    } else {
      print('ℹ️  All dependencies already present in pubspec.yaml');
    }
  } else {
    print('❌ pubspec.yaml not found in root directory.');
  }

  print('✅ MVVM structure generated under lib/');
}
