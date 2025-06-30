import 'dart:developer';
import 'dart:io';

import 'package:dropdown_sheet/src/constants/layout_constants.dart';
import 'package:dropdown_sheet/src/helpers/custom_bottom_sheet.dart';
import 'package:dropdown_sheet/src/extension/context_extension.dart';
import 'package:dropdown_sheet/src/extension/widget_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A customizable dropdown widget that displays a bottom sheet for item selection.
///
/// This widget provides a dropdown interface with extensive customization options
/// including colors, borders, search functionality, multi-selection, loading states,
/// and localization support. It's designed to be flexible and easy to integrate
/// into any Flutter application.
///
/// The widget automatically handles the display of selected values, loading states,
/// and empty data scenarios. For single selection, it shows the selected item's name.
/// For multi-selection, it displays all selected items separated by commas.
///
/// When tapped, it opens a bottom sheet with the list of available options.
/// The bottom sheet can include search functionality, custom headers/footers,
/// and supports both single and multiple item selection.
///
/// {@tool snippet}
///
/// This example shows a basic dropdown with search functionality:
///
/// ```dart
/// final ValueNotifier<SheetModel?> selectedCountry = ValueNotifier(null);
/// final List<SheetModel> countries = [
///   SheetModel(id: '1', name: 'Turkey'),
///   SheetModel(id: '2', name: 'Germany'),
///   SheetModel(id: '3', name: 'France'),
/// ];
///
/// DropdownSheet<SheetModel>(
///   title: 'Select Country',
///   values: countries,
///   notifier: selectedCountry,
///   showSearch: true,
///   onChanged: () => print('Country selected: ${selectedCountry.value?.name}'),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// This example shows a multi-select dropdown with custom styling:
///
/// ```dart
/// final ValueNotifier<List<SheetModel>> selectedLanguages = ValueNotifier([]);
/// final List<SheetModel> languages = [
///   SheetModel(id: '1', name: 'English'),
///   SheetModel(id: '2', name: 'German'),
///   SheetModel(id: '3', name: 'French'),
/// ];
///
/// DropdownSheet<SheetModel>(
///   title: 'Languages',
///   values: languages,
///   notifier: selectedLanguages,
///   isMultiSelect: true,
///   showSearch: true,
///   backgroundColor: Colors.white,
///   borderColor: Colors.blue,
///   borderRadius: 12,
///   onChanged: () => print('Languages selected: ${selectedLanguages.value.length}'),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// This example shows a dropdown with loading state and custom item builder:
///
/// ```dart
/// final ValueNotifier<bool> isLoading = ValueNotifier(false);
///
/// DropdownSheet<SheetModel>(
///   title: 'Cities',
///   values: cities,
///   notifier: selectedCity,
///   loadingNotifier: isLoading,
///   itemBuilder: (context, item, isSelected) => ListTile(
///     leading: Icon(Icons.location_city, color: isSelected ? Colors.blue : Colors.grey),
///     title: Text(item.name),
///     trailing: isSelected ? Icon(Icons.check, color: Colors.blue) : null,
///   ),
///   onChanged: () => print('City selected: ${selectedCity.value?.name}'),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [DropdownButton], a simpler dropdown that shows options in a menu.
///  * [BottomSheet], the underlying widget used to display the selection interface.
///  * [SearchBar], for implementing search functionality in other parts of your app.
///  * [ValueNotifier], for managing state in Flutter applications.
///  * [SheetModel], the data model used by this widget.
class DropdownSheet<T> extends StatelessWidget {
  /// Creates a DropdownSheet widget.
  ///
  /// The [title] parameter is required and displays the label above the dropdown.
  /// The [values] parameter contains the list of items to choose from.
  /// The [notifier] parameter is a ValueNotifier that holds the selected value(s).
  ///
  /// For single selection, use `ValueNotifier<SheetModel?>`.
  /// For multi-selection, use `ValueNotifier<List<SheetModel>>`.
  ///
  /// Optional parameters allow extensive customization of appearance and behavior.
  const DropdownSheet({
    super.key,
    required this.title,
    required this.values,
    this.dynamicValues,
    this.isRequired = false,
    required this.notifier,
    this.onChanged,
    this.isLoading = false,
    this.loadingNotifier,
    this.showSearch = false,
    // --- Customization params ---
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.titleTextStyle,
    this.selectedValueTextStyle,
    this.placeholderTextStyle,
    this.iconColor,
    this.iconSize,
    this.customIcon,
    this.padding,
    this.margin,
    this.itemHeight,
    this.dropdownHeight,
    this.titleDropdownSpacing,
    this.customLoadingWidget,
    this.emptyWidget,
    this.isMultiSelect = false,
    this.autoCloseOnSelect = true,
    this.closeOnTapOutside = true,
    this.itemBuilder,
    this.maxVisibleItems,
    this.customSheetHeader,
    this.customSheetFooter,
    this.itemBackgroundColor,
    this.selectedItemBackgroundColor,
    this.itemTextStyle,
    this.searchBoxDecoration,
    this.searchTextStyle,
    this.searchHintText,
    this.loadingTextStyle,
    this.overlayColor,
    this.animationDuration,
    this.animationCurve,
    this.dropdownDirection,
    // --- Localization params ---
    this.placeholderText,
    this.loadingText,
    this.noDataText,
    this.doneText,
  });

  /// The title/label displayed above the dropdown.
  ///
  /// This text appears as a label for the dropdown field and helps users
  /// understand what they are selecting.
  final String title;
  
  /// The list of items to choose from.
  ///
  /// Each item should have a `name` property that will be displayed in the list.
  /// If null or empty, the dropdown will show a "no data" message.
  final List<dynamic>? values;
  
  /// A function that returns dynamic values for async data loading.
  ///
  /// This is useful when you need to load data asynchronously, such as from
  /// an API. The function will be called when the dropdown is opened.
  final List<dynamic>? Function()? dynamicValues;
  
  /// Whether this field is required.
  ///
  /// This parameter can be used to show visual indicators that the field
  /// must be filled out, though the widget itself doesn't enforce validation.
  final bool isRequired;
  
  /// The ValueNotifier that holds the selected value(s).
  ///
  /// For single selection, use `ValueNotifier<SheetModel?>`.
  /// For multi-selection, use `ValueNotifier<List<SheetModel>>`.
  /// The widget will automatically update this notifier when selections change.
  final ValueNotifier<dynamic> notifier;
  
  /// Callback function called when selection changes.
  ///
  /// This function is called whenever the user makes a selection, allowing you
  /// to perform additional actions like validation or data processing.
  final Function? onChanged;
  
  /// Whether the dropdown is in loading state.
  ///
  /// When true, the dropdown will show a loading indicator instead of the
  /// selected value. This is useful for async operations.
  final bool isLoading;
  
  /// ValueNotifier for loading state (alternative to isLoading).
  ///
  /// This provides more control over loading states, especially when you need
  /// to manage loading state from outside the widget.
  final ValueNotifier<bool>? loadingNotifier;
  
  /// Whether to show search functionality in the dropdown sheet.
  ///
  /// When true, a search box will appear at the top of the bottom sheet,
  /// allowing users to filter the list of options.
  final bool showSearch;
  
  // --- Customization params ---
  
  /// Background color of the dropdown container.
  ///
  /// This sets the background color of the main dropdown field.
  final Color? backgroundColor;
  
  /// Border color of the dropdown container.
  ///
  /// This sets the color of the border around the dropdown field.
  final Color? borderColor;
  
  /// Border width of the dropdown container.
  ///
  /// This sets the thickness of the border around the dropdown field.
  final double? borderWidth;
  
  /// Border radius of the dropdown container.
  ///
  /// This sets the corner radius of the dropdown field for rounded corners.
  final double? borderRadius;
  
  /// Text style for the title/label.
  ///
  /// This allows you to customize the appearance of the title text.
  final TextStyle? titleTextStyle;
  
  /// Text style for the selected value.
  ///
  /// This allows you to customize the appearance of the selected value text.
  final TextStyle? selectedValueTextStyle;
  
  /// Text style for the placeholder text.
  ///
  /// This allows you to customize the appearance of the placeholder text
  /// when no item is selected.
  final TextStyle? placeholderTextStyle;
  
  /// Color of the dropdown arrow icon.
  ///
  /// This sets the color of the dropdown arrow that indicates the field
  /// can be expanded.
  final Color? iconColor;
  
  /// Size of the dropdown arrow icon.
  ///
  /// This sets the size of the dropdown arrow icon.
  final double? iconSize;
  
  /// Custom icon widget to replace the default arrow.
  ///
  /// This allows you to use a custom icon instead of the default dropdown arrow.
  final Widget? customIcon;
  
  /// Padding around the dropdown content.
  ///
  /// This sets the internal padding of the dropdown field.
  final EdgeInsetsGeometry? padding;
  
  /// Margin around the dropdown container.
  ///
  /// This sets the external margin around the dropdown field.
  final EdgeInsetsGeometry? margin;
  
  /// Height of each item in the dropdown list.
  ///
  /// This sets the height of individual items in the selection list.
  final double? itemHeight;
  
  /// Maximum height of the dropdown sheet.
  ///
  /// This sets the maximum height of the bottom sheet that appears when
  /// the dropdown is opened.
  final double? dropdownHeight;
  
  /// Spacing between title and dropdown content.
  ///
  /// This sets the vertical spacing between the title and the dropdown field.
  final double? titleDropdownSpacing;
  
  /// Custom widget to show during loading state.
  ///
  /// This allows you to use a custom loading widget instead of the default
  /// loading indicator.
  final Widget? customLoadingWidget;
  
  /// Custom widget to show when no data is available.
  ///
  /// This allows you to use a custom widget when the values list is empty
  /// or null.
  final Widget? emptyWidget;
  
  /// Whether to allow multiple selections.
  ///
  /// When true, users can select multiple items from the list. The notifier
  /// should be of type `ValueNotifier<List<SheetModel>>` for multi-selection.
  final bool isMultiSelect;
  
  /// Whether to automatically close the sheet after selection (single select only).
  ///
  /// When true, the bottom sheet will automatically close after a single
  /// selection is made. This only applies to single-selection mode.
  final bool autoCloseOnSelect;
  
  /// Whether to close the sheet when tapping outside.
  ///
  /// When true, the bottom sheet will close when the user taps outside
  /// of the sheet area.
  final bool closeOnTapOutside;
  
  /// Custom builder function for each item in the list.
  ///
  /// This allows you to completely customize the appearance of each item
  /// in the selection list. The function receives the context, item, and
  /// whether the item is selected.
  final Widget Function(BuildContext, dynamic, bool isSelected)? itemBuilder;
  
  /// Maximum number of visible items before scrolling.
  ///
  /// This sets the maximum number of items that can be visible at once
  /// before the list becomes scrollable.
  final int? maxVisibleItems;
  
  /// Custom header widget for the dropdown sheet.
  ///
  /// This allows you to add a custom header to the bottom sheet, such as
  /// additional information or instructions.
  final Widget? customSheetHeader;
  
  /// Custom footer widget for the dropdown sheet.
  ///
  /// This allows you to add a custom footer to the bottom sheet, such as
  /// additional actions or information.
  final Widget? customSheetFooter;
  
  /// Background color for items in the dropdown list.
  ///
  /// This sets the background color of items in the selection list.
  final Color? itemBackgroundColor;
  
  /// Background color for selected items in the dropdown list.
  ///
  /// This sets the background color of selected items in the selection list.
  final Color? selectedItemBackgroundColor;
  
  /// Text style for items in the dropdown list.
  ///
  /// This allows you to customize the appearance of item text in the
  /// selection list.
  final TextStyle? itemTextStyle;
  
  /// Decoration for the search box.
  ///
  /// This allows you to customize the appearance of the search box
  /// when search functionality is enabled.
  final InputDecoration? searchBoxDecoration;
  
  /// Text style for the search box.
  ///
  /// This allows you to customize the appearance of text in the search box.
  final TextStyle? searchTextStyle;
  
  /// Hint text for the search box.
  ///
  /// This sets the placeholder text that appears in the search box
  /// when it's empty.
  final String? searchHintText;
  
  /// Text style for loading text.
  ///
  /// This allows you to customize the appearance of the loading text.
  final TextStyle? loadingTextStyle;
  
  /// Color for the overlay when dropdown sheet is open.
  ///
  /// This sets the color of the overlay that appears behind the bottom sheet.
  final Color? overlayColor;
  
  /// Duration for dropdown sheet animations.
  ///
  /// This sets the duration of animations when opening and closing the
  /// bottom sheet.
  final Duration? animationDuration;
  
  /// Curve for dropdown sheet animations.
  ///
  /// This sets the animation curve for opening and closing animations.
  final Curve? animationCurve;
  
  /// Direction in which the dropdown opens.
  ///
  /// This determines whether the dropdown opens upward or downward.
  final AxisDirection? dropdownDirection;
  
  // --- Localization params ---
  
  /// Text shown when no item is selected.
  ///
  /// This sets the placeholder text that appears when no item is selected.
  /// Defaults to "Seçiniz" if not provided.
  final String? placeholderText;
  
  /// Text shown during loading state.
  ///
  /// This sets the text that appears during loading states.
  /// Defaults to "Yükleniyor..." if not provided.
  final String? loadingText;
  
  /// Text shown when no data is available.
  ///
  /// This sets the text that appears when the values list is empty.
  /// Defaults to "Sonuç bulunamadı." if not provided.
  final String? noDataText;
  
  /// Text for the done button in multi-select mode.
  ///
  /// This sets the text for the "Done" button in multi-selection mode.
  /// Defaults to "Bitti" if not provided.
  final String? doneText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLoading || (loadingNotifier != null && loadingNotifier!.value)) {
          return; // Yükleme durumunda tıklamayı engelle
        }

        log('$title $dynamicValues', name: 'DropdownSheet');
        FocusScope.of(context).requestFocus(FocusNode());
        CustomBottomSheet(context).show(
          body: SelectionBottomSheet(
            title: title,
            values: dynamicValues?.call() ?? values,
            value: notifier.value,
            showSearch: showSearch,
            onChanged: (val) {
              notifier.value = val;
              onChanged?.call();
            },
            isMultiSelect: isMultiSelect,
            autoCloseOnSelect: autoCloseOnSelect,
            itemBuilder: itemBuilder,
            customSheetHeader: customSheetHeader,
            customSheetFooter: customSheetFooter,
            itemBackgroundColor: itemBackgroundColor,
            selectedItemBackgroundColor: selectedItemBackgroundColor,
            itemTextStyle: itemTextStyle,
            searchBoxDecoration: searchBoxDecoration,
            searchTextStyle: searchTextStyle,
            searchHintText: searchHintText,
            emptyWidget: emptyWidget,
            dropdownHeight: dropdownHeight,
            maxVisibleItems: maxVisibleItems,
          ),
        );
      },
      child: Container(
        padding: padding ?? LayoutConstants.padding16All,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : LayoutConstants.border16Button,
          border: Border.all(
            color: borderColor ?? context.colorScheme.tertiary.withValues(alpha: 0.25),
            width: borderWidth ?? 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: titleTextStyle ?? const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
            SizedBox(height: titleDropdownSpacing ?? 4),
            loadingNotifier != null
                ? ValueListenableBuilder<bool>(
                  valueListenable: loadingNotifier!,
                  builder: (context, isLoading, child) {
                    return _buildDropdownContent(context, isLoading);
                  },
                )
                : _buildDropdownContent(context, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownContent(BuildContext context, bool loading) {
    if (!loading && (values?.isEmpty == true || values == null)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Seçim bulunamadı',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 17, color: const Color(0xFF98A2B3)),
          ).expanded,
          Icon(
            Icons.keyboard_arrow_down_sharp,
            size: iconSize ?? 20,
            color: iconColor ?? const Color(0xffD0D5DD),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        loading
            ? (customLoadingWidget ?? Text(
                "Yükleniyor...",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: loadingTextStyle ?? TextStyle(fontSize: 17, color: const Color(0xFF98A2B3)),
              ).expanded)
            : ValueListenableBuilder<dynamic>(
                valueListenable: notifier,
                builder: (context, value, child) =>
                    Text(
                      value is List 
                          ? (value.isEmpty 
                              ? 'Seçiniz' 
                              : value.map((item) => item.name).join(', '))
                          : (value?.name ?? 'Seçiniz'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: value != null
                          ? (selectedValueTextStyle ?? TextStyle(fontSize: 17, fontWeight: FontWeight.w400))
                          : (placeholderTextStyle ?? TextStyle(fontSize: 17, color: const Color(0xFF98A2B3))),
                    ).expanded,
              ),
        loading
            ? (customLoadingWidget ?? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xffD0D5DD)),
              ))
            : (customIcon ?? Icon(
                Icons.keyboard_arrow_down_sharp,
                size: iconSize ?? 20,
                color: iconColor ?? const Color(0xffD0D5DD),
              )),
      ],
    );
  }
}

/// A bottom sheet widget for item selection with extensive customization options.
///
/// This widget is used internally by [DropdownSheet] to display the selection interface
/// in a bottom sheet. It provides a comprehensive selection experience with support
/// for single and multi-selection, search functionality, custom styling, and localization.
///
/// The widget automatically handles the display of items, search filtering, selection
/// states, and empty data scenarios. It can be used independently or as part of the
/// [DropdownSheet] widget.
///
/// When used independently, you can create a custom selection interface with full
/// control over the appearance and behavior. The widget supports custom item builders,
/// headers, footers, and various styling options.
///
/// {@tool snippet}
///
/// This example shows how to use SelectionBottomSheet independently:
///
/// ```dart
/// void showCountrySelection(BuildContext context) {
///   final List<SheetModel> countries = [
///     SheetModel(id: '1', name: 'Turkey'),
///     SheetModel(id: '2', name: 'Germany'),
///     SheetModel(id: '3', name: 'France'),
///   ];
///
///   showModalBottomSheet(
///     context: context,
///     builder: (context) => SelectionBottomSheet(
///       title: 'Select Country',
///       values: countries,
///       showSearch: true,
///       onChanged: (selected) {
///         print('Selected: ${selected.name}');
///         Navigator.pop(context);
///       },
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// This example shows a multi-select bottom sheet with custom styling:
///
/// ```dart
/// void showLanguageSelection(BuildContext context) {
///   final List<SheetModel> languages = [
///     SheetModel(id: '1', name: 'English'),
///     SheetModel(id: '2', name: 'German'),
///     SheetModel(id: '3', name: 'French'),
///   ];
///
///   showModalBottomSheet(
///     context: context,
///     builder: (context) => SelectionBottomSheet(
///       title: 'Select Languages',
///       values: languages,
///       isMultiSelect: true,
///       showSearch: true,
///       itemBackgroundColor: Colors.white,
///       selectedItemBackgroundColor: Colors.blue.withOpacity(0.1),
///       itemBuilder: (context, item, isSelected) => ListTile(
///         leading: Icon(
///           isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
///           color: isSelected ? Colors.blue : Colors.grey,
///         ),
///         title: Text(item.name),
///         tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
///       ),
///       onChanged: (selected) {
///         print('Selected languages: ${selected.length}');
///         Navigator.pop(context);
///       },
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// This example shows a bottom sheet with custom header and footer:
///
/// ```dart
/// void showCustomSelection(BuildContext context) {
///   showModalBottomSheet(
///     context: context,
///     builder: (context) => SelectionBottomSheet(
///       title: 'Custom Selection',
///       values: items,
///       showSearch: true,
///       customSheetHeader: Container(
///         padding: EdgeInsets.all(16),
///         child: Text(
///           'This is a custom header with additional information',
///           style: TextStyle(fontSize: 14, color: Colors.grey),
///         ),
///       ),
///       customSheetFooter: Container(
///         padding: EdgeInsets.all(16),
///         child: Row(
///           children: [
///             TextButton(
///               onPressed: () => Navigator.pop(context),
///               child: Text('Cancel'),
///             ),
///             Spacer(),
///             ElevatedButton(
///               onPressed: () => Navigator.pop(context),
///               child: Text('Confirm'),
///             ),
///           ],
///         ),
///       ),
///       onChanged: (selected) => Navigator.pop(context),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [DropdownSheet], the main widget that uses this bottom sheet.
///  * [BottomSheet], the underlying Flutter widget for bottom sheets.
///  * [showModalBottomSheet], for displaying modal bottom sheets.
///  * [SheetModel], the data model used by this widget.
///  * [ValueNotifier], for managing state in Flutter applications.
class SelectionBottomSheet extends StatefulWidget {
  /// Creates a SelectionBottomSheet widget.
  ///
  /// The [title] parameter is required and displays the title in the sheet header.
  /// The [values] parameter contains the list of items to choose from.
  /// The [onChanged] parameter is called when the user makes a selection.
  ///
  /// For single selection, the [onChanged] callback receives a single [SheetModel].
  /// For multi-selection, it receives a [List<SheetModel>].
  ///
  /// Optional parameters allow extensive customization of appearance and behavior.
  SelectionBottomSheet({
    super.key,
    required this.title,
    this.values,
    this.value, // dynamic - List<dynamic> for multi-select, SheetModel? for single select
    this.onChanged,
    this.showSearch = false,
    // --- Customization params ---
    this.isMultiSelect = false,
    this.autoCloseOnSelect = true,
    this.itemBuilder,
    this.customSheetHeader,
    this.customSheetFooter,
    this.itemBackgroundColor,
    this.selectedItemBackgroundColor,
    this.itemTextStyle,
    this.searchBoxDecoration,
    this.searchTextStyle,
    this.searchHintText,
    this.emptyWidget,
    this.dropdownHeight,
    this.maxVisibleItems,
    // --- Localization params ---
    this.placeholderText,
    this.loadingText,
    this.noDataText,
    this.doneText,
  });

  /// The title displayed in the sheet header.
  ///
  /// This text appears at the top of the bottom sheet and helps users
  /// understand what they are selecting.
  final String title;
  
  /// The list of items to choose from.
  ///
  /// Each item should have a `name` property that will be displayed in the list.
  /// If null or empty, the sheet will show a "no data" message.
  final List<dynamic>? values;
  
  /// The currently selected value(s).
  ///
  /// For single selection, this should be a [SheetModel] or null.
  /// For multi-selection, this should be a [List<SheetModel>].
  /// This parameter is used to pre-select items when the sheet opens.
  dynamic value;
  
  /// Callback function called when selection changes.
  ///
  /// This function is called whenever the user makes a selection. For single
  /// selection, it receives the selected [SheetModel]. For multi-selection,
  /// it receives a [List<SheetModel>] containing all selected items.
  void Function(dynamic value)? onChanged;
  
  /// Whether to show search functionality in the sheet.
  ///
  /// When true, a search box will appear at the top of the sheet, allowing
  /// users to filter the list of options by typing.
  final bool showSearch;
  
  // --- Customization params ---
  
  /// Whether to allow multiple selections.
  ///
  /// When true, users can select multiple items from the list. The [onChanged]
  /// callback will receive a [List<SheetModel>] with all selected items.
  final bool isMultiSelect;
  
  /// Whether to automatically close the sheet after selection (single select only).
  ///
  /// When true, the bottom sheet will automatically close after a single
  /// selection is made. This only applies to single-selection mode.
  final bool autoCloseOnSelect;
  
  /// Custom builder function for each item in the list.
  ///
  /// This allows you to completely customize the appearance of each item
  /// in the selection list. The function receives the context, item, and
  /// whether the item is selected.
  ///
  /// If not provided, a default [ListTile] will be used.
  final Widget Function(BuildContext, dynamic, bool isSelected)? itemBuilder;
  
  /// Custom header widget for the sheet.
  ///
  /// This allows you to add a custom header to the bottom sheet, such as
  /// additional information, instructions, or branding elements.
  final Widget? customSheetHeader;
  
  /// Custom footer widget for the sheet.
  ///
  /// This allows you to add a custom footer to the bottom sheet, such as
  /// additional actions, buttons, or information.
  final Widget? customSheetFooter;
  
  /// Background color for items in the list.
  ///
  /// This sets the background color of unselected items in the selection list.
  final Color? itemBackgroundColor;
  
  /// Background color for selected items in the list.
  ///
  /// This sets the background color of selected items in the selection list.
  final Color? selectedItemBackgroundColor;
  
  /// Text style for items in the list.
  ///
  /// This allows you to customize the appearance of item text in the
  /// selection list.
  final TextStyle? itemTextStyle;
  
  /// Decoration for the search box.
  ///
  /// This allows you to customize the appearance of the search box
  /// when search functionality is enabled.
  final InputDecoration? searchBoxDecoration;
  
  /// Text style for the search box.
  ///
  /// This allows you to customize the appearance of text in the search box.
  final TextStyle? searchTextStyle;
  
  /// Hint text for the search box.
  ///
  /// This sets the placeholder text that appears in the search box
  /// when it's empty.
  final String? searchHintText;
  
  /// Custom widget to show when no data is available.
  ///
  /// This allows you to use a custom widget when the values list is empty
  /// or null.
  final Widget? emptyWidget;
  
  /// Maximum height of the sheet.
  ///
  /// This sets the maximum height of the bottom sheet. If not specified,
  /// the sheet will use a default height based on the content.
  final double? dropdownHeight;
  
  /// Maximum number of visible items before scrolling.
  ///
  /// This sets the maximum number of items that can be visible at once
  /// before the list becomes scrollable.
  final int? maxVisibleItems;
  
  // --- Localization params ---
  
  /// Text shown when no item is selected.
  ///
  /// This sets the placeholder text that appears when no item is selected.
  /// Defaults to "Seçiniz" if not provided.
  final String? placeholderText;
  
  /// Text shown during loading state.
  ///
  /// This sets the text that appears during loading states.
  /// Defaults to "Yükleniyor..." if not provided.
  final String? loadingText;
  
  /// Text shown when no data is available.
  ///
  /// This sets the text that appears when the values list is empty.
  /// Defaults to "Sonuç bulunamadı." if not provided.
  final String? noDataText;
  
  /// Text for the done button in multi-select mode.
  ///
  /// This sets the text for the "Done" button in multi-selection mode.
  /// Defaults to "Bitti" if not provided.
  final String? doneText;

  @override
  State<SelectionBottomSheet> createState() => _SelectionBottomSheetState();
}

class _SelectionBottomSheetState extends State<SelectionBottomSheet> {
  List<dynamic> selectedItems = [];
  bool isMultipleSelect = false;

  late TextEditingController _searchController;
  late ValueNotifier<String> _searchText;
  List<dynamic> filteredValues = [];
  dynamic _currentValue;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchText = ValueNotifier('');
    filteredValues = widget.values ?? [];
    _currentValue = widget.value;
    if (widget.isMultiSelect) {
      selectedItems = (widget.value as List<dynamic>?) ?? [];
    }
    _searchController.addListener(() {
      _searchText.value = _searchController.text;
      _filterValues();
    });
  }

  void _filterValues() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredValues = widget.values ?? [];
      } else {
        filteredValues = (widget.values ?? []).where((e) => (e.name?.toLowerCase() ?? '').contains(query)).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.customSheetHeader != null) widget.customSheetHeader!,
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ValueListenableBuilder<String>(
              valueListenable: _searchText,
              builder: (context, value, child) {
                return TextField(
                  controller: _searchController,
                  decoration: widget.searchBoxDecoration?.copyWith(
                    hintText: widget.searchHintText ?? 'Ara...',
                    hintStyle: widget.searchTextStyle ?? TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    suffixIcon: value.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              FocusScope.of(context).unfocus();
                            },
                            child: Icon(Icons.clear, color: Colors.grey),
                          )
                        : null,
                  ) ??
                  InputDecoration(
                    hintText: widget.searchHintText ?? 'Ara...',
                    hintStyle: widget.searchTextStyle ?? TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFECECEC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFECECEC)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFECECEC)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  ),
                  style: widget.searchTextStyle,
                );
              },
            ),
          ),
        if (widget.isMultiSelect)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedItems.clear();
                      selectedItems.addAll(widget.values ?? []);
                    });
                  },
                  child: const Text('Tümünü Seç'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedItems.clear();
                    });
                  },
                  child: const Text('Tümünü Kaldır'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    widget.onChanged?.call(selectedItems);
                    Navigator.pop(context);
                  },
                  child: const Text('Bitti'),
                ),
              ],
            ),
          ),
        StatefulBuilder(
          builder: (context, setState) {
            final bool isSearching = widget.showSearch && _searchController.text.isNotEmpty;
            final double listHeight = widget.dropdownHeight ?? (isSearching
                ? context.dynamicHeight(.5)
                : (filteredValues.length > (widget.maxVisibleItems ?? 8)
                    ? context.dynamicHeight(.5)
                    : filteredValues.length * context.dynamicHeight(
                        context.height < 700 ? .1 : Platform.isAndroid ? .1 : .065,
                      )));
            return SizedBox(
              height: listHeight,
              child: DraggableScrollableSheet(
                initialChildSize: 1,
                minChildSize: 0,
                snap: true,
                expand: false,
                builder: (context, scrollController) {
                  if (filteredValues.isEmpty) {
                    return widget.emptyWidget ?? Center(child: Text('Sonuç bulunamadı.'));
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children:
                          filteredValues
                              .map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    if (!widget.isMultiSelect) {
                                      setState(() {
                                        _currentValue = e;
                                      });
                                      widget.onChanged?.call(e);
                                      if (widget.autoCloseOnSelect) Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        if (selectedItems.contains(e)) {
                                          selectedItems.remove(e);
                                        } else {
                                          selectedItems.add(e);
                                        }
                                      });
                                    }
                                  },
                                  child: widget.itemBuilder != null
                                      ? widget.itemBuilder!(context, e, selectedItems.contains(e))
                                      : Container(
                                          color: widget.isMultiSelect && filteredValues.indexOf(e) % 2 == 0
                                              ? (widget.itemBackgroundColor ?? const Color(0xFFFAFAFA))
                                              : null,
                                          child: Padding(
                                            padding: LayoutConstants.padding16Horizontal,
                                            child: Container(
                                              padding: LayoutConstants.padding16Vertical,
                                              decoration: const BoxDecoration(
                                                border: Border(bottom: BorderSide(width: 1, color: Color(0xFFECECEC))),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    e.name,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: widget.itemTextStyle,
                                                  ).expanded,
                                                  radioOrCheckbox(
                                                    widget.isMultiSelect,
                                                    e,
                                                    _currentValue,
                                                    widget.onChanged,
                                                    setState,
                                                    context,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              )
                              .toList(),
                    ),
                  );
                },
              ),
            );
          },
        ),
        if (widget.customSheetFooter != null) widget.customSheetFooter!,
      ],
    );
  }

  Widget radioOrCheckbox(
    bool isMultipleSelect,
    e,
    value,
    void Function(dynamic value)? onChanged,
    StateSetter setState,
    BuildContext context,
  ) {
    if (isMultipleSelect) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CupertinoCheckbox(
          value: (selectedItems).any((element) => element.name == e.name),
          onChanged: (value) {
            setState(() {
              if (selectedItems.contains(e)) {
                selectedItems.remove(e);
              } else {
                selectedItems.add(e);
              }
            });
          },
          activeColor: context.colorScheme.primary,
        ),
      );
    }
    return Transform.scale(
      scale: 1.5,
      child: CupertinoRadio(
        value: e.name == value?.name,
        groupValue: true,
        inactiveColor: const Color(0xffF5F5F5),
        onChanged: (value) {
          onChanged?.call((e));
          setState(() {
            _currentValue = e;
          });
          Navigator.pop(context);
        },
        activeColor: context.colorScheme.primary,
      ),
    );
  }
}