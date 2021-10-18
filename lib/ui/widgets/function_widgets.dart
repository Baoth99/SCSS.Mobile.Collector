import 'package:collector_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:flutter/material.dart';

class FunctionalWidgets {
  static Future<T?> showCustomDialog<T>(BuildContext context,
      [String text = 'Vui lòng đợi...', String? label]) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomProgressIndicatorDialog(
        text: text,
        semanticLabel: label,
      ),
    );
  }
}
