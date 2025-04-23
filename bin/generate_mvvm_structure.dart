import 'dart:io';

void main(List<String> arguments) async {
  final projectName =
      arguments.isNotEmpty ? arguments.first : 'my_mvvm_project';
  final baseDir = Directory(projectName);

  final folders = [
    'lib/model',
    'lib/service/api',
    'lib/service/lokal',
    'lib/viewmodel',
    'lib/view',
    'lib/other',
    'lib/customwidget',
  ];

  for (final folder in folders) {
    final dir = Directory('${baseDir.path}/$folder');
    await dir.create(recursive: true);
  }

  final files = {
    'lib/model/example_model.dart': 'class ExampleModel {}',
    'lib/service/api/example_api.dart': 'class ExampleApi {}',
    'lib/service/lokal/shared_prefference.dart':
        """import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  void setStringSharedPref(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // note: get shared pref
  Future<String> getStringSharedPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value.toString();
  }

  // note: remove shared pref
  Future removeSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print('removed');
    prefs.clear();
  },
}""",
    'lib/viewmodel/example_viewmodel.dart':
        """import 'package:flutter/material.dart';

class ExampleViewModel extends ChangeNotifier {
  String title = 'Hello ViewModel';

  ExampleViewModel(BuildContext context) {
    // Initialize your ViewModel here
  };

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }
}
""",
    'lib/view/example_view.dart': """import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      child: Builder(builder: (context) {
        return Consumer<ExampleViewModel>(builder: (context, viewModel, child) {
          return Container(
           child: widget, 
          );
        });
      }),
    );
  }
}""",
  };

  for (final entry in files.entries) {
    final file = File('${baseDir.path}/${entry.key}');
    await file.writeAsString(entry.value);
  }

  final pubspec = File('${baseDir.path}/pubspec.yaml');
  await pubspec.writeAsString("""name: $projectName
description: A Flutter MVVM structured project generated via CLI
version: 0.0.1
environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  hexcolor: ^3.0.1
  provider: ^6.1.2
  intl: ^0.20.1
  dio: ^5.8.0
  shared_preferences: ^2.2.3

flutter:
  uses-material-design: true
""");

  print('✅ MVVM structure generated in ./$projectName');
}
