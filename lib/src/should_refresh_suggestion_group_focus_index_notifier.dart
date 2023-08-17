import 'package:flutter/material.dart';

class ShouldRefreshSuggestionGroupFocusIndexNotifier extends ValueNotifier<void> {
  ShouldRefreshSuggestionGroupFocusIndexNotifier({required FocusNode? textFieldFocusNode}) : super(null) {
    textFieldFocusNode?.addListener(() {
      if (textFieldFocusNode.hasFocus) {
        notifyListeners();
      }
    });
  }
}
