import 'dart:io';

void main(List<String> arguments) async {
  final libDir = Directory('lib');

  final folders = [
    'models',
    'services/api',
    'services/lokal',
    'viewmodels',
    'views',
    'utils',
    'widgets',
  ];

  // 1. Create folder structure inside /lib
  for (final folder in folders) {
    final dir = Directory('${libDir.path}/$folder');
    await dir.create(recursive: true);
  }

  // 2. Create template files
  final files = {
    'views/example_view.dart': """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/example_viewmodel.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleView();
}

class _ExampleView extends State<ExampleView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExampleViewModel>(
      create: (context) => ExampleViewModel(context),
      child: Builder(
        builder: (context) {
          return Consumer<ExampleViewModel>(
            builder: (context, viewModel, child) {
              return Container(
                child: Text(viewModel.title),
              );
            },
          );
        },
      ),
    );
  }
}
""",
    'viewmodels/example_viewmodel.dart': """
import 'package:flutter/material.dart';

class ExampleViewModel extends ChangeNotifier {
  String title = 'Hello ViewModel';

  ExampleViewModel(BuildContext context) {
    // Initialize your ViewModel here
  }

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }
}
""",
    'services/lokal/shared_preference.dart': """
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  void setStringSharedPref(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getStringSharedPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value.toString();
  }

  Future removeSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
""",
  };

  print('✅ Files example added');

  for (final entry in files.entries) {
    final file = File('${libDir.path}/${entry.key}');
    await file.writeAsString(entry.value);
  }

  // 3. Add dependencies if not present
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
      } else if (inDependencies && line.startsWith(RegExp(r'^[a-zA-Z]'))) {
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

  print('✅ MVVM structure & template files created in lib/');
}
