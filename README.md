<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Dropdown Sheet

A customizable, searchable, and multi-select dropdown sheet widget for Flutter.

---

## Features

- 🎨 Fully customizable design
- 🔍 Built-in search box
- ✅ Single and multiple selection support
- 📱 Responsive layout
- ⚡ Loading and empty data states
- 🔄 Dynamic (async) data support
- 🏷️ Detailed parameter documentation

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  dropdown_sheet: ^0.0.1
```

## Usage

### Basic Usage

```dart
import 'package:dropdown_sheet/dropdown_sheet.dart';

final ValueNotifier<SheetModel?> selectedCountry = ValueNotifier(null);
final List<SheetModel> countries = [
  SheetModel(id: '1', name: 'Turkey'),
  SheetModel(id: '2', name: 'Germany'),
  SheetModel(id: '3', name: 'France'),
];

DropdownSheet<SheetModel>(
  title: 'Select Country',
  values: countries,
  notifier: selectedCountry,
  onChanged: () {
    print('Selected country: \\${selectedCountry.value?.name}');
  },
)
```

## Media

### Single Selection

<p align="center">
  <img src="https://raw.githubusercontent.com/bilalozcan/dropdown_sheet/main/assets/example/selection_image_1.png" width="220"/>
  <img src="https://raw.githubusercontent.com/bilalozcan/dropdown_sheet/main/assets/example/single_selection.gif" width="220"/>
</p>

### Multiple Selection

<p align="center">
  <img src="https://raw.githubusercontent.com/bilalozcan/dropdown_sheet/main/assets/example/multiple_image_1.png" width="220"/>
  <img src="https://raw.githubusercontent.com/bilalozcan/dropdown_sheet/main/assets/example/multiple_selection.gif" width="220"/>
</p>

### Customizable

<p align="center">
  <img src="https://raw.githubusercontent.com/bilalozcan/dropdown_sheet/main/assets/example/customizable_image_1.png" width="220"/>
  <img src="https://raw.githubusercontent.com/bilalozcan/dropdown_sheet/main/assets/example/customizable.gif" width="220"/>
</p>

### Selection with Search Bar

<p align="center">
  <img src="https://raw.githubusercontent.com/bilalozcan/dropdown_sheet/main/assets/example/selection_image_2_with_search_bar.png" width="220"/>
</p>

### Single Selection with Loading

<p align="center">
  <img src="https://raw.githubusercontent.com/bilalozcan/dropdown_sheet/main/assets/example/single_selection_with_loading.gif" width="220"/>
</p>

### Other Selection Screen

<p align="center">
  <img src="https://raw.githubusercontent.com/bilalozcan/dropdown_sheet/main/assets/example/selection_image_3.png" width="220"/>
</p>

<!-- Add more media as needed using the same format. -->

### More usage examples below

### Multi-Select & Search

```dart
final ValueNotifier<List<SheetModel>> selectedLanguages = ValueNotifier([]);
final List<SheetModel> languages = [
  SheetModel(id: '1', name: 'Turkish'),
  SheetModel(id: '2', name: 'English'),
  SheetModel(id: '3', name: 'German'),
];

DropdownSheet<SheetModel>(
  title: 'Languages',
  values: languages,
  notifier: selectedLanguages,
  isMultiSelect: true,
  showSearch: true,
  onChanged: () {
    print('Selected languages: \\${selectedLanguages.value.map((e) => e.name).join(", ")}');
  },
)
```

### Loading State

```dart
final ValueNotifier<bool> isLoading = ValueNotifier(false);

DropdownSheet<SheetModel>(
  title: 'Cities',
  values: cities,
  notifier: selectedCity,
  loadingNotifier: isLoading,
  onChanged: () {
    print('Selected city: \\${selectedCity.value?.name}');
  },
)
```

### Dynamic Values

```dart
DropdownSheet<SheetModel>(
  title: 'Districts',
  dynamicValues: () => fetchDistricts(),
  notifier: selectedDistrict,
  onChanged: () {
    print('Selected district: \\${selectedDistrict.value?.name}');
  },
)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `String` | Dropdown title |
| `values` | `List<dynamic>?` | List of options |
| `dynamicValues` | `List<dynamic>? Function()?` | Dynamic values function |
| `notifier` | `ValueNotifier` | Holds selected value(s) |
| `onChanged` | `Function?` | Called on selection change |
| `isMultiSelect` | `bool` | Multi-select |
| `showSearch` | `bool` | Show search box |
| `isLoading` | `bool` | Loading state |
| `loadingNotifier` | `ValueNotifier<bool>?` | Loading notifier |
| ... | ... | See code for more |

## SheetModel

```dart
class SheetModel {
  final String id;
  final String name;
  SheetModel({required this.id, required this.name});
}
```

## Advanced Usage

### Standalone SelectionBottomSheet

```dart
showModalBottomSheet(
  context: context,
  builder: (context) => SelectionBottomSheet(
    title: 'Select a country',
    values: countries,
    showSearch: true,
    onChanged: (selected) {
      print('Selected: \\${selected.name}');
      Navigator.pop(context);
    },
  ),
);
```

## See also

- [DropdownButton](https://api.flutter.dev/flutter/material/DropdownButton-class.html)
- [BottomSheet](https://api.flutter.dev/flutter/material/BottomSheet-class.html)
- [showModalBottomSheet](https://api.flutter.dev/flutter/material/showModalBottomSheet.html)
- [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html)

## License

MIT

---

## Türkçe

Flutter için özelleştirilebilir, arama destekli ve çoklu seçimli modern bir dropdown sheet bileşeni.

### Özellikler

- Tamamen özelleştirilebilir tasarım
- Dahili arama kutusu
- Tekli ve çoklu seçim desteği
- Responsive yapı
- Yükleniyor ve boş veri durumları
- Dinamik veri desteği (async)
- Parametreler için detaylı dokümantasyon

### Kurulum

`pubspec.yaml` dosyanıza ekleyin:

```yaml
dependencies:
  dropdown_sheet: ^0.0.1
```
