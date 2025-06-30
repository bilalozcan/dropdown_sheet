import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dropdown_sheet/dropdown_sheet.dart';

void main() {
  group('DropdownSheet Widget Tests', () {
    late ValueNotifier<SheetModel?> testNotifier;
    late List<SheetModel> testValues;

    setUp(() {
      testNotifier = ValueNotifier(null);
      testValues = [
        SheetModel(id: '1', name: 'Test Option 1'),
        SheetModel(id: '2', name: 'Test Option 2'),
        SheetModel(id: '3', name: 'Test Option 3'),
      ];
    });

    tearDown(() {
      testNotifier.dispose();
    });

    testWidgets('should render with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownSheet<SheetModel>(
              title: 'Test Title',
              values: testValues,
              notifier: testNotifier,
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('should show placeholder text when no value selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownSheet<SheetModel>(
              title: 'Test Title',
              values: testValues,
              notifier: testNotifier,
            ),
          ),
        ),
      );

      expect(find.text('Seçiniz'), findsOneWidget);
    });

    testWidgets('should show selected value when value is set', (WidgetTester tester) async {
      testNotifier.value = testValues[0];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownSheet<SheetModel>(
              title: 'Test Title',
              values: testValues,
              notifier: testNotifier,
            ),
          ),
        ),
      );

      expect(find.text('Test Option 1'), findsOneWidget);
    });

    testWidgets('should show loading text when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownSheet<SheetModel>(
              title: 'Test Title',
              values: testValues,
              notifier: testNotifier,
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.text('Yükleniyor...'), findsOneWidget);
    });

    testWidgets('should show loading indicator when loadingNotifier is true', (WidgetTester tester) async {
      final loadingNotifier = ValueNotifier(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownSheet<SheetModel>(
              title: 'Test Title',
              values: testValues,
              notifier: testNotifier,
              loadingNotifier: loadingNotifier,
            ),
          ),
        ),
      );

      expect(find.text('Yükleniyor...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      loadingNotifier.dispose();
    });

    testWidgets('should be tappable when not loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownSheet<SheetModel>(
              title: 'Test Title',
              values: testValues,
              notifier: testNotifier,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      
      // Bottom sheet should appear
      expect(find.byType(SelectionBottomSheet), findsOneWidget);
    });

    testWidgets('should not be tappable when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownSheet<SheetModel>(
              title: 'Test Title',
              values: testValues,
              notifier: testNotifier,
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      
      // Bottom sheet should not appear
      expect(find.byType(SelectionBottomSheet), findsNothing);
    });
  });

  group('SheetModel Tests', () {
    test('should create SheetModel with required parameters', () {
      final model = SheetModel(id: '1', name: 'Test');
      
      expect(model.id, '1');
      expect(model.name, 'Test');
      expect(model.val, isNull);
    });

    test('should create SheetModel with optional val parameter', () {
      final model = SheetModel(id: '1', name: 'Test', val: 'value');
      
      expect(model.id, '1');
      expect(model.name, 'Test');
      expect(model.val, 'value');
    });

    test('should have correct toString representation', () {
      final model = SheetModel(id: '1', name: 'Test', val: 'value');
      
      expect(model.toString(), 'SheetModel(id: 1, name: Test, val: value)');
    });

    test('should have correct equality', () {
      final model1 = SheetModel(id: '1', name: 'Test');
      final model2 = SheetModel(id: '1', name: 'Test');
      final model3 = SheetModel(id: '2', name: 'Test');
      
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
    });

    test('should have correct hashCode', () {
      final model1 = SheetModel(id: '1', name: 'Test');
      final model2 = SheetModel(id: '1', name: 'Test');
      
      expect(model1.hashCode, equals(model2.hashCode));
    });
  });
}
