import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:typeahead_group/typeahead_group.dart';

typedef FutureOr<Iterable<TypeAheadDataGroup<T>>> SuggestionsGroupCallback<T>(String pattern);
typedef Widget ItemBuilder<T>(BuildContext context, T itemData);
typedef Widget TitleGroupBuilder<String>(BuildContext context, String title);
typedef void SuggestionGroupSelectionCallback<T>(T suggestion);
typedef Widget ErrorBuilder(BuildContext context, Object? error);

typedef Widget AnimationTransitionBuilder(
    BuildContext context, Widget child, AnimationController? controller);
