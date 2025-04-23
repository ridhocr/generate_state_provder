// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('feature', abbr: 'f', help: 'Generate MVVM files for a feature');

  final argResults = parser.parse(arguments);
  final featureName = argResults['feature'];

  if (featureName == null || featureName.isEmpty) {
    print('⚠️  Please provide a feature name using --feature <name>');
    return;
  }

  final className = featureName[0].toUpperCase() + featureName.substring(1);
  final baseDir = Directory('lib');

  final structure = {
    'model/\${featureName}_model.dart': 'class \${className}Model {}',
    'view/\${featureName}_view.dart': """import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/\${featureName}_viewmodel.dart';

class \${className}View extends StatelessWidget {
  const \${className}View({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => \${className}ViewModel(),
      child: Consumer<\${className}ViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            body: Center(child: Text(vm.title)),
          );
        },
      ),
    );
  }
}
""",
    'viewmodel/\${featureName}_viewmodel.dart': """import 'package:flutter/material.dart';

class \${className}ViewModel extends ChangeNotifier {
  String title = '\${className} ViewModel';

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }
}
"""
  };

  for (var path in structure.keys) {
    final file = File('\${baseDir.path}/\$path');
    await file.parent.create(recursive: true);
    await file.writeAsString(structure[path]!
        .replaceAll('\${featureName}', featureName)
        .replaceAll('\${className}', className));
  }

  print('✅ Feature "\$featureName" generated successfully.');
}
