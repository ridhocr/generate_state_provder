# generate_mvvm_structure

A Dart CLI tool to generate a complete MVVM folder structure for Flutter projects, including `pubspec.yaml` and example files.

## 📦 Features

- 📁 Creates MVVM directory structure
- 📄 Auto-generates `pubspec.yaml` with common Flutter dependencies
- 🧠 Includes default `example_viewmodel.dart` using `ChangeNotifier`
- 🚀 Ready to expand for your features

## 🚀 Usage

```bash
dart run generate_mvvm_structure
```

This will create the following structure:

```
my_project/
├── lib/
│   ├── models/
│   ├── services/
│   │   ├── api/
│   │   └── lokal/
│   ├── utils/
│   ├── views/
│   ├── viewmodels/
│   │   └── example_viewmodel.dart
│   └── widgets/
└── pubspec.yaml
```

## 📜 License

MIT — see [LICENSE](LICENSE)
