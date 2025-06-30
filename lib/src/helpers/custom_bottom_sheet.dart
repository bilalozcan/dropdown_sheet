import 'package:dropdown_sheet/src/constants/layout_constants.dart';
import 'package:dropdown_sheet/src/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBottomSheet {
  final BuildContext context;

  const CustomBottomSheet(this.context);

  Future<T?> show<T>({Widget? body, bool isDismissible = true, Function(bool didPop)? callback}) {
    HapticFeedback.lightImpact();
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: context.colorScheme.onPrimary,
      barrierColor: context.colorScheme.onSecondary.withValues(alpha: 0.85),
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      constraints: BoxConstraints(maxHeight: context.height * 0.9),
      shape: RoundedRectangleBorder(borderRadius: LayoutConstants.topBorder14Button),
      builder: (newContext) {
        final Widget child = PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (callback != null) {
              callback.call(didPop);
            }
          },
          child: Wrap(
            children: [
              SizedBox(
                width: context.width,
                child: SafeArea(child: Padding(padding: LayoutConstants.padding24All, child: body ?? const SizedBox())),
              ),
            ],
          ),
        );
        return child;
      },
    );
  }
}
