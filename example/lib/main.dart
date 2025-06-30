import 'package:flutter/material.dart';
import 'package:dropdown_sheet/dropdown_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown Sheet Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

// Örnek ülke-il-ilçe JSON verisi
const List<Map<String, dynamic>> countryData = [
  {
    'id': '1',
    'name': 'Türkiye',
    'cities': [
      {
        'id': '1',
        'name': 'İstanbul',
        'districts': [
          {'id': '1', 'name': 'Kadıköy'},
          {'id': '2', 'name': 'Beşiktaş'},
          {'id': '3', 'name': 'Üsküdar'},
        ]
      },
      {
        'id': '2',
        'name': 'Ankara',
        'districts': [
          {'id': '1', 'name': 'Çankaya'},
          {'id': '2', 'name': 'Keçiören'},
        ]
      },
      {
        'id': '3',
        'name': 'İzmir',
        'districts': []
      },
      {
        'id': '4',
        'name': 'Bursa',
        'districts': []
      },
      {
        'id': '5',
        'name': 'Antalya',
        'districts': [
          {'id': '1', 'name': 'Muratpaşa'},
          {'id': '2', 'name': 'Kepez'},
        ]
      },
      {
        'id': '6',
        'name': 'Adana',
        'districts': []
      },
      {
        'id': '7',
        'name': 'Konya',
        'districts': []
      },
      {
        'id': '8',
        'name': 'Gaziantep',
        'districts': []
      },
      {
        'id': '9',
        'name': 'Mersin',
        'districts': []
      },
      {
        'id': '10',
        'name': 'Kayseri',
        'districts': []
      },
      {
        'id': '11',
        'name': 'Eskişehir',
        'districts': []
      },
    ]
  },
  {
    'id': '2',
    'name': 'Almanya',
    'cities': [
      {
        'id': '1',
        'name': 'Berlin',
        'districts': [
          {'id': '1', 'name': 'Mitte'},
          {'id': '2', 'name': 'Kreuzberg'},
        ]
      },
      {
        'id': '2',
        'name': 'Münih',
        'districts': [
          {'id': '1', 'name': 'Schwabing'},
          {'id': '2', 'name': 'Maxvorstadt'},
        ]
      },
    ]
  },
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<SheetModel?> selectedCountry = ValueNotifier(null);
  final ValueNotifier<SheetModel?> selectedCity = ValueNotifier(null);
  final ValueNotifier<SheetModel?> selectedDistrict = ValueNotifier(null);
  final ValueNotifier<bool> isCityLoading = ValueNotifier(false);
  final ValueNotifier<bool> isDistrictLoading = ValueNotifier(false);
  final ValueNotifier<List<SheetModel>> cityList = ValueNotifier([]);
  final ValueNotifier<List<SheetModel>> districtList = ValueNotifier([]);

  // Son kullanma tarihi için
  final ValueNotifier<SheetModel?> selectedMonth = ValueNotifier(null);
  final ValueNotifier<SheetModel?> selectedYear = ValueNotifier(null);
  final ValueNotifier<List<SheetModel>> selectedLanguages = ValueNotifier([]);
  final List<SheetModel> months = List.generate(12, (i) => SheetModel(id: '${i+1}', name: '${i+1}'.padLeft(2, '0')));
  final List<SheetModel> years = List.generate(10, (i) => SheetModel(id: '${2024+i}', name: '${2024+i}'));
  final List<SheetModel> languages = [
    SheetModel(id: '1', name: 'Türkçe'),
    SheetModel(id: '2', name: 'İngilizce'),
    SheetModel(id: '3', name: 'Almanca'),
    SheetModel(id: '4', name: 'Fransızca'),
    SheetModel(id: '5', name: 'İspanyolca'),
    SheetModel(id: '6', name: 'İtalyanca'),
    SheetModel(id: '7', name: 'Rusça'),
    SheetModel(id: '8', name: 'Arapça'),
  ];

  List<SheetModel> getCountries() {
    return countryData.map((e) => SheetModel(id: e['id'], name: e['name'])).toList();
  }

  List<SheetModel> getCities(String countryId) {
    final country = countryData.firstWhere(
      (e) => e['id'] == countryId,
      orElse: () => <String, Object>{},
    );
    if (country.isEmpty) return [];
    return (country['cities'] as List).map((c) => SheetModel(id: c['id'], name: c['name'])).toList();
  }

  List<SheetModel> getDistricts(String countryId, String cityId) {
    final country = countryData.firstWhere(
      (e) => e['id'] == countryId,
      orElse: () => <String, Object>{},
    );
    if (country.isEmpty) return [];
    final city = (country['cities'] as List).firstWhere(
      (c) => c['id'] == cityId,
      orElse: () => <String, Object>{},
    );
    if (city.isEmpty) return [];
    return (city['districts'] as List).map((d) => SheetModel(id: d['id'], name: d['name'])).toList();
  }

  // Canlı özelleştirme için state değişkenleri
  double borderRadius = 16;
  double borderWidth = 2;
  double iconSize = 24;
  Color borderColor = Colors.blue;
  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Dropdown Sheet Demo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Adres Seçimi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            DropdownSheet<SheetModel>(
              title: 'Ülke',
              values: getCountries(),
              notifier: selectedCountry,
              onChanged: () async {
                selectedCity.value = null;
                selectedDistrict.value = null;
                cityList.value = [];
                districtList.value = [];
                if (selectedCountry.value == null) return;
                isCityLoading.value = true;
                await Future.delayed(const Duration(seconds: 2));
                cityList.value = getCities(selectedCountry.value!.id);
                isCityLoading.value = false;
              },
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<List<SheetModel>>(
              valueListenable: cityList,
              builder: (context, cities, _) {
                return DropdownSheet<SheetModel>(
                  title: 'İl',
                  values: selectedCountry.value == null ? [] : cities,
                  notifier: selectedCity,
                  loadingNotifier: isCityLoading,
                  onChanged: () async {
                    selectedDistrict.value = null;
                    districtList.value = [];
                    if (selectedCity.value == null || selectedCountry.value == null) return;
                    isDistrictLoading.value = true;
                    await Future.delayed(const Duration(seconds: 2));
                    districtList.value = getDistricts(selectedCountry.value!.id, selectedCity.value!.id);
                    isDistrictLoading.value = false;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<List<SheetModel>>(
              valueListenable: districtList,
              builder: (context, districts, _) {
                return DropdownSheet<SheetModel>(
                  title: 'İlçe',
                  values: selectedCity.value == null ? [] : districts,
                  notifier: selectedDistrict,
                  loadingNotifier: isDistrictLoading,
                  showSearch: true,
                  emptyWidget: const Center(child: Text('İlçe bulunamadı.')),
                  onChanged: () {},
                );
              },
            ),
            const SizedBox(height: 32),
            const Text('Son Kullanma Tarihi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownSheet<SheetModel>(
                    title: 'Ay',
                    values: months,
                    notifier: selectedMonth,
                    onChanged: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownSheet<SheetModel>(
                    title: 'Yıl',
                    values: years,
                    notifier: selectedYear,
                    onChanged: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Çoklu Seçim', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownSheet<SheetModel>(
              title: 'Diller',
              values: languages,
              notifier: selectedLanguages,
              isMultiSelect: true,
              showSearch: true,
              onChanged: () {
                setState(() {});
              },
            ),
            const SizedBox(height: 32),
            const Text('Seçilenler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ValueListenableBuilder<SheetModel?>(
              valueListenable: selectedCountry,
              builder: (context, country, _) {
                return ValueListenableBuilder<SheetModel?>(
                  valueListenable: selectedCity,
                  builder: (context, city, _) {
                    return ValueListenableBuilder<SheetModel?>(
                      valueListenable: selectedDistrict,
                      builder: (context, district, _) {
                        return ValueListenableBuilder<List<SheetModel>>(
                          valueListenable: selectedLanguages,
                          builder: (context, languages, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ülke: ${country?.name ?? '-'}'),
                                Text('İl: ${city?.name ?? '-'}'),
                                Text('İlçe: ${district?.name ?? '-'}'),
                                Text('Diller: ${languages.isEmpty ? '-' : languages.map((l) => l.name).join(', ')}'),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            const Text('Son Kullanma Tarihi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ValueListenableBuilder<SheetModel?>(
              valueListenable: selectedMonth,
              builder: (context, month, _) {
                return ValueListenableBuilder<SheetModel?>(
                  valueListenable: selectedYear,
                  builder: (context, year, _) {
                    return Text('Ay/Yıl: ${month?.name ?? '-'} / ${year?.name ?? '-'}');
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            const Text('Canlı Özelleştirme', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Parametreleri Değiştir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    const Text('Border Radius'),
                    Slider(
                      min: 0,
                      max: 40,
                      value: borderRadius,
                      onChanged: (v) => setState(() => borderRadius = v),
                    ),
                    const Text('Border Width'),
                    Slider(
                      min: 0,
                      max: 8,
                      value: borderWidth,
                      onChanged: (v) => setState(() => borderWidth = v),
                    ),
                    const Text('Icon Size'),
                    Slider(
                      min: 16,
                      max: 48,
                      value: iconSize,
                      onChanged: (v) => setState(() => iconSize = v),
                    ),
                    const Text('Border Color'),
                    Row(
                      children: [
                        _ColorDot(Colors.blue, borderColor, (c) => setState(() => borderColor = c)),
                        _ColorDot(Colors.red, borderColor, (c) => setState(() => borderColor = c)),
                        _ColorDot(Colors.green, borderColor, (c) => setState(() => borderColor = c)),
                        _ColorDot(Colors.black, borderColor, (c) => setState(() => borderColor = c)),
                      ],
                    ),
                    const Text('Background Color'),
                    Row(
                      children: [
                        _ColorDot(Colors.white, backgroundColor, (c) => setState(() => backgroundColor = c)),
                        _ColorDot(Colors.grey.shade200, backgroundColor, (c) => setState(() => backgroundColor = c)),
                        _ColorDot(Colors.yellow.shade100, backgroundColor, (c) => setState(() => backgroundColor = c)),
                        _ColorDot(Colors.blue.shade50, backgroundColor, (c) => setState(() => backgroundColor = c)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownSheet<SheetModel>(
                      title: 'Canlı Özelleştir',
                      values: getCountries(),
                      notifier: ValueNotifier<SheetModel?>(null),
                      borderRadius: borderRadius,
                      borderWidth: borderWidth,
                      iconSize: iconSize,
                      borderColor: borderColor,
                      backgroundColor: backgroundColor,
                      onChanged: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final Color selected;
  final ValueChanged<Color> onTap;
  const _ColorDot(this.color, this.selected, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
} 