/// # TypeAheadGroup
/// A TypeAheadGroup widget for Flutter, where you can show suggestionsGroup to
/// users as they type
///
/// ## Features
/// * Shows suggestionsGroup in an overlay that floats on top of other widgets
/// * Allows you to specify what the suggestionsGroup will look like through a
/// builder function
/// * Allows you to specify what happens when the user taps a suggestion
/// * Accepts all the parameters that traditional TextFields accept, like
/// decoration, custom TextEditingController, text styling, etc.
/// * Provides two versions, a normal version and a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// version that accepts validation, submitting, etc.
/// * Provides high customizability; you can customize the suggestion box decoration,
/// the loading bar, the animation, the debounce duration, etc.
///
/// ## Installation
/// See the [installation instructions on pub](https://pub.dartlang.org/packages/typeahead_group#-installing-tab-).
///
/// ## Usage examples
/// You can import the package with:
/// ```dart
/// import 'package:typeahead_group/typeahead_group.dart';
/// ```
///
/// and then use it as follows:
///
/// ### Example 1:
/// ```dart
/// TypeAheadGroupField(
///   typeAheadGroupConfiguration: TypeAheadGroupConfiguration(
///     autofocus: true,
///     style: DefaultTextStyle.of(context).style.copyWith(
///       fontStyle: FontStyle.italic
///     ),
///     decoration: InputDecoration(
///       border: OutlineInputBorder()
///     )
///   ),
///   suggestionsGroupCallback: (pattern) async {
///     return await BackendService.getSuggestionsGroup(pattern);
///   },
///   itemBuilder: (context, suggestion) {
///     return ListTile(
///       leading: Icon(Icons.shopping_cart),
///       title: Text(suggestion['name']),
///       subtitle: Text('\$${suggestion['price']}'),
///     );
///   },
///   onSuggestionGroupSelected: (suggestion) {
///     Navigator.of(context).push(MaterialPageRoute(
///       builder: (context) => ProductPage(product: suggestion)
///     ));
///   },
/// )
/// ```
/// In the code above, the `typeAheadGroupConfiguration` property allows us to
/// configure the displayed `TextField` as we want. In this example, we are
/// configuring the `autofocus`, `style` and `decoration` properties.
///
/// The `suggestionsGroupCallback` is called with the search string that the user
/// types, and is expected to return a `List` of data either synchronously or
/// asynchronously. In this example, we are calling an asynchronous function
/// called `BackendService.getSuggestionsGroup` which fetches the list of
/// suggestionsGroup.
///
/// The `itemBuilder` is called to build a widget for each suggestion.
/// In this example, we build a simple `ListTile` that shows the name and the
/// price of the item. Please note that you shouldn't provide an `onTap`
/// callback here. The TypeAheadGroup widget takes care of that.
///
/// The `onSuggestionGroupSelected` is a callback called when the user taps a
/// suggestion. In this example, when the user taps a
/// suggestion, we navigate to a page that shows us the information of the
/// tapped product.
///
/// ### Example 2:
/// Here's another example, where we use the TypeAheadGroupFormField inside a `Form`:
/// ```dart
/// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
/// final TextEditingController _typeAheadController = TextEditingController();
/// String _selectedCity;
/// ...
/// Form(
///   key: this._formKey,
///   child: Padding(
///     padding: EdgeInsets.all(32.0),
///     child: Column(
///       children: <Widget>[
///         Text(
///           'What is your favorite city?'
///         ),
///         TypeAheadGroupFormField(
///           typeAheadGroupConfiguration: TypeAheadGroupConfiguration(
///             controller: this._typeAheadController,
///             decoration: InputDecoration(
///               labelText: 'City'
///             )
///           ),
///           suggestionsGroupCallback: (pattern) {
///             return CitiesService.getSuggestionsGroup(pattern);
///           },
///           itemBuilder: (context, suggestion) {
///             return ListTile(
///               title: Text(suggestion),
///             );
///           },
///           transitionBuilder: (context, suggestionsGroupBox, controller) {
///             return suggestionsGroupBox;
///           },
///           onSuggestionGroupSelected: (suggestion) {
///             this._typeAheadController.text = suggestion;
///           },
///           validator: (value) {
///             if (value.isEmpty) {
///               return 'Please select a city';
///             }
///           },
///           onSaved: (value) => this._selectedCity = value,
///         ),
///         SizedBox(height: 10.0,),
///         RaisedButton(
///           child: Text('Submit'),
///           onPressed: () {
///             if (this._formKey.currentState.validate()) {
///               this._formKey.currentState.save();
///               Scaffold.of(context).showSnackBar(SnackBar(
///                 content: Text('Your Favorite City is ${this._selectedCity}')
///               ));
///             }
///           },
///         )
///       ],
///     ),
///   ),
/// )
/// ```
/// Here, we assign to the `controller` property of the `typeAheadGroupConfiguration`
/// a `TextEditingController` that we call `_typeAheadController`.
/// We use this controller in the `onSuggestionGroupSelected` callback to set the
/// value of the `TextField` to the selected suggestion.
///
/// The `validator` callback can be used like any `FormField.validator`
/// function. In our example, it checks whether a value has been entered,
/// and displays an error message if not. The `onSaved` callback is used to
/// save the value of the field to the `_selectedCity` member variable.
///
/// The `transitionBuilder` allows us to customize the animation of the
/// suggestion box. In this example, we are returning the suggestionsGroupBox
/// immediately, meaning that we don't want any animation.
///
/// ## Customizations
/// TypeAheadGroup widgets consist of a TextField and a suggestion box that shows
/// as the user types. Both are highly customizable
///
/// ### Customizing the TextField
/// You can customize the text field using the `typeAheadGroupConfiguration` property.
/// You provide this property with an instance of `TypeAheadGroupConfiguration`,
/// which allows you to configure all the usual properties of `TextField`, like
/// `decoration`, `style`, `controller`, `focusNode`, `autofocus`, `enabled`,
/// etc.
///
/// ### Customizing the SuggestionsGroup Box
/// TypeAheadGroup provides default configurations for the suggestionsGroup box. You can,
/// however, override most of them.
///
/// #### Customizing the loader, the error and the "no items found" message
/// You can use the [loadingBuilder], [errorBuilder] and [noItemsFoundBuilder] to
/// customize their corresponding widgets. For example, to show a custom error
/// widget:
/// ```dart
/// errorBuilder: (BuildContext context, Object error) =>
///   Text(
///     '$error',
///     style: TextStyle(
///       color: Theme.of(context).errorColor
///     )
///   )
/// ```
/// #### Customizing the animation
/// You can customize the suggestion box animation through 3 parameters: the
/// `animationDuration`, the `animationStart`, and the `transitionBuilder`.
///
/// The `animationDuration` specifies how long the animation should take, while the
/// `animationStart` specified what point (between 0.0 and 1.0) the animation
/// should start from. The `transitionBuilder` accepts the `suggestionsGroupBox` and
/// `animationController` as parameters, and should return a widget that uses
/// the `animationController` to animate the display of the `suggestionsGroupBox`.
/// For example:
/// ```dart
/// transitionBuilder: (context, suggestionsGroupBox, animationController) =>
///   FadeTransition(
///     child: suggestionsGroupBox,
///     opacity: CurvedAnimation(
///       parent: animationController,
///       curve: Curves.fastOutSlowIn
///     ),
///   )
/// ```
/// This uses [FadeTransition](https://docs.flutter.io/flutter/widgets/FadeTransition-class.html)
/// to fade the `suggestionsGroupBox` into the view. Note how the
/// `animationController` was provided as the parent of the animation.
///
/// In order to fully remove the animation, `transitionBuilder` should simply
/// return the `suggestionsGroupBox`. This callback could also be used to wrap the
/// `suggestionsGroupBox` with any desired widgets, not necessarily for animation.
///
/// #### Customizing the debounce duration
/// The suggestionsGroup box does not fire for each character the user types. Instead,
/// we wait until the user is idle for a duration of time, and then call the
/// `suggestionsGroupCallback`. The duration defaults to 300 milliseconds, but can be
/// configured using the `debounceDuration` parameter.
///
/// #### Customizing the offset of the suggestionsGroup box
/// By default, the suggestionsGroup box is displayed 5 pixels below the `TextField`.
/// You can change this by changing the `suggestionsGroupBoxVerticalOffset` property.
///
/// #### Customizing the decoration of the suggestionsGroup box
/// You can also customize the decoration of the suggestionsGroup box using the
/// `suggestionsGroupBoxDecoration` property. For example, to remove the elevation
/// of the suggestionsGroup box, you can write:
/// ```dart
/// suggestionsGroupBoxDecoration: SuggestionsGroupBoxDecoration(
///   elevation: 0.0
/// )
/// ```
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:typeahead_group/src/keyboard_suggestion_group_selection_notifier.dart';
import 'package:typeahead_group/src/should_refresh_suggestion_group_focus_index_notifier.dart';

import 'typeahead_data_group.dart';
import 'typedef.dart';
import 'utils.dart';

/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadGroupField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadGroupField], A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestionsGroup as the user types
class TypeAheadGroupFormField<T> extends FormField<String> {
  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAheadGroup widget displays
  final TypeAheadGroupConfiguration typeAheadGroupConfiguration;

  // Adds a callback for resetting the form field
  void Function()? onReset;

  /// Creates a [TypeAheadGroupFormField]
  TypeAheadGroupFormField(
      {Key? key,
      String? initialValue,
      bool getImmediateSuggestionsGroup = false,
      @Deprecated('Use autovalidateMode parameter which provides more specific '
          'behavior related to auto validation. '
          'This feature was deprecated after Flutter v1.19.0.')
      bool autovalidate = false,
      bool enabled = true,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      FormFieldSetter<String>? onSaved,
      this.onReset,
      FormFieldValidator<String>? validator,
      ErrorBuilder? errorBuilder,
      WidgetBuilder? noItemsFoundBuilder,
      WidgetBuilder? loadingBuilder,
      void Function(bool)? onSuggestionGroupsGroupBoxToggle,
      Duration debounceDuration = const Duration(milliseconds: 300),
      SuggestionsGroupBoxDecoration suggestionsGroupBoxDecoration = const SuggestionsGroupBoxDecoration(),
      SuggestionsGroupBoxController? suggestionsGroupBoxController,
      required SuggestionGroupSelectionCallback<T> onSuggestionGroupSelected,
      required ItemBuilder<T> itemBuilder,
      required TitleGroupBuilder<String> titleGroupBuilder,
      required SuggestionsGroupCallback<T> suggestionsGroupCallback,
      double suggestionsGroupBoxVerticalOffset = 5.0,
      this.typeAheadGroupConfiguration = const TypeAheadGroupConfiguration(),
      AnimationTransitionBuilder? transitionBuilder,
      Duration animationDuration = const Duration(milliseconds: 500),
      double animationStart = 0.25,
      AxisDirection direction = AxisDirection.down,
      bool hideOnLoading = false,
      bool hideOnEmpty = false,
      bool hideOnError = false,
      bool hideSuggestionsGroupOnKeyboardHide = true,
      bool keepSuggestionsGroupOnLoading = true,
      bool keepSuggestionsGroupOnSuggestionSelected = false,
      bool autoFlipDirection = false,
      bool autoFlipListDirection = true,
      bool hideKeyboard = false,
      int minCharsForSuggestionsGroup = 0,
      bool hideKeyboardOnDrag = false})
      : assert(initialValue == null || typeAheadGroupConfiguration.controller == null),
        assert(minCharsForSuggestionsGroup >= 0),
        super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: typeAheadGroupConfiguration.controller != null
                ? typeAheadGroupConfiguration.controller!.text
                : (initialValue ?? ''),
            enabled: enabled,
            autovalidateMode: autovalidateMode,
            builder: (FormFieldState<String> field) {
              final _TypeAheadGroupFormFieldState state = field as _TypeAheadGroupFormFieldState<dynamic>;

              return TypeAheadGroupField(
                getImmediateSuggestionsGroup: getImmediateSuggestionsGroup,
                transitionBuilder: transitionBuilder,
                errorBuilder: errorBuilder,
                noItemsFoundBuilder: noItemsFoundBuilder,
                loadingBuilder: loadingBuilder,
                debounceDuration: debounceDuration,
                suggestionsGroupBoxDecoration: suggestionsGroupBoxDecoration,
                suggestionsGroupBoxController: suggestionsGroupBoxController,
                typeAheadGroupConfiguration: typeAheadGroupConfiguration.copyWith(
                  decoration: typeAheadGroupConfiguration.decoration.copyWith(errorText: state.errorText),
                  onChanged: (text) {
                    state.didChange(text);
                    typeAheadGroupConfiguration.onChanged?.call(text);
                  },
                  controller: state._effectiveController,
                ),
                suggestionsGroupBoxVerticalOffset: suggestionsGroupBoxVerticalOffset,
                onSuggestionGroupSelected: onSuggestionGroupSelected,
                onSuggestionGroupsGroupBoxToggle: onSuggestionGroupsGroupBoxToggle,
                itemBuilder: itemBuilder,
                titleGroupBuilder: titleGroupBuilder,
                suggestionsGroupCallback: suggestionsGroupCallback,
                animationStart: animationStart,
                animationDuration: animationDuration,
                direction: direction,
                hideOnLoading: hideOnLoading,
                hideOnEmpty: hideOnEmpty,
                hideOnError: hideOnError,
                hideSuggestionsGroupOnKeyboardHide: hideSuggestionsGroupOnKeyboardHide,
                keepSuggestionsGroupOnLoading: keepSuggestionsGroupOnLoading,
                keepSuggestionsGroupOnSuggestionSelected: keepSuggestionsGroupOnSuggestionSelected,
                autoFlipDirection: autoFlipDirection,
                autoFlipListDirection: autoFlipListDirection,
                hideKeyboard: hideKeyboard,
                minCharsForSuggestionsGroup: minCharsForSuggestionsGroup,
                hideKeyboardOnDrag: hideKeyboardOnDrag,
              );
            });

  @override
  _TypeAheadGroupFormFieldState<T> createState() => _TypeAheadGroupFormFieldState<T>();
}

class _TypeAheadGroupFormFieldState<T> extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.typeAheadGroupConfiguration.controller ?? _controller;

  @override
  TypeAheadGroupFormField get widget => super.widget as TypeAheadGroupFormField<dynamic>;

  @override
  void initState() {
    super.initState();
    if (widget.typeAheadGroupConfiguration.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.typeAheadGroupConfiguration.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(TypeAheadGroupFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.typeAheadGroupConfiguration.controller != oldWidget.typeAheadGroupConfiguration.controller) {
      oldWidget.typeAheadGroupConfiguration.controller?.removeListener(_handleControllerChanged);
      widget.typeAheadGroupConfiguration.controller?.addListener(_handleControllerChanged);

      if (oldWidget.typeAheadGroupConfiguration.controller != null &&
          widget.typeAheadGroupConfiguration.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.typeAheadGroupConfiguration.controller!.value);
      if (widget.typeAheadGroupConfiguration.controller != null) {
        setValue(widget.typeAheadGroupConfiguration.controller!.text);
        if (oldWidget.typeAheadGroupConfiguration.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.typeAheadGroupConfiguration.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = widget.initialValue!;
      if (widget.onReset != null) {
        widget.onReset!();
      }
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != value) didChange(_effectiveController!.text);
  }
}

/// A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestionsGroup as the user types
///
/// See also:
///
/// * [TypeAheadGroupFormField], a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadGroupField] that allows the value to be saved,
/// validated, etc.
class TypeAheadGroupField<T> extends StatefulWidget {
  /// Called with the search pattern to get the search suggestionsGroup.
  ///
  /// This callback must not be null. It is be called by the TypeAheadGroup widget
  /// and provided with the search pattern. It should return a [List](https://api.dartlang.org/stable/2.0.0/dart-core/List-class.html)
  /// of suggestionsGroup either synchronously, or asynchronously (as the result of a
  /// [Future](https://api.dartlang.org/stable/dart-async/Future-class.html)).
  /// Typically, the list of suggestionsGroup should not contain more than 4 or 5
  /// entries. These entries will then be provided to [itemBuilder] to display
  /// the suggestionsGroup.
  ///
  /// Example:
  /// ```dart
  /// suggestionsGroupCallback: (pattern) async {
  ///   return await _getSuggestionsGroup(pattern);
  /// }
  /// ```
  final SuggestionsGroupCallback<T> suggestionsGroupCallback;

  /// Called when a suggestion is tapped.
  ///
  /// This callback must not be null. It is called by the TypeAheadGroup widget and
  /// provided with the value of the tapped suggestion.
  ///
  /// For example, you might want to navigate to a specific view when the user
  /// tabs a suggestion:
  /// ```dart
  /// onSuggestionGroupSelected: (suggestion) {
  ///   Navigator.of(context).push(MaterialPageRoute(
  ///     builder: (context) => SearchResult(
  ///       searchItem: suggestion
  ///     )
  ///   ));
  /// }
  /// ```
  ///
  /// Or to set the value of the text field:
  /// ```dart
  /// onSuggestionGroupSelected: (suggestion) {
  ///   _controller.text = suggestion['name'];
  /// }
  /// ```
  final SuggestionGroupSelectionCallback<T> onSuggestionGroupSelected;

  /// Called for each suggestion returned by [suggestionsGroupCallback] to build the
  /// corresponding widget.
  ///
  /// This callback must not be null. It is called by the TypeAheadGroup widget for
  /// each suggestion, and expected to build a widget to display this
  /// suggestion's info. For example:
  ///
  /// ```dart
  /// itemBuilder: (context, suggestion) {
  ///   return ListTile(
  ///     title: Text(suggestion['name']),
  ///     subtitle: Text('USD' + suggestion['price'].toString())
  ///   );
  /// }
  /// ```
  final ItemBuilder<T> itemBuilder;

  final TitleGroupBuilder<String> titleGroupBuilder;

  /// used to control the scroll behavior of item-builder list
  final ScrollController? scrollController;

  /// The decoration of the material sheet that contains the suggestionsGroup.
  ///
  /// If null, default decoration with an elevation of 4.0 is used
  ///

  final SuggestionsGroupBoxDecoration suggestionsGroupBoxDecoration;

  /// Used to control the `_SuggestionsGroupBox`. Allows manual control to
  /// open, close, toggle, or resize the `_SuggestionsGroupBox`.
  final SuggestionsGroupBoxController? suggestionsGroupBoxController;

  /// The duration to wait after the user stops typing before calling
  /// [suggestionsGroupCallback]
  ///
  /// This is useful, because, if not set, a request for suggestionsGroup will be
  /// sent for every character that the user types.
  ///
  /// This duration is set by default to 300 milliseconds
  final Duration debounceDuration;

  /// Called when waiting for [suggestionsGroupCallback] to return.
  ///
  /// It is expected to return a widget to display while waiting.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('Loading...');
  /// }
  /// ```
  ///
  /// If not specified, a [CircularProgressIndicator](https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html) is shown
  final WidgetBuilder? loadingBuilder;

  /// Called when [suggestionsGroupCallback] returns an empty array.
  ///
  /// It is expected to return a widget to display when no suggestionsGroup are
  /// avaiable.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('No Items Found!');
  /// }
  /// ```
  ///
  /// If not specified, a simple text is shown
  final WidgetBuilder? noItemsFoundBuilder;

  /// Called when [suggestionsGroupCallback] throws an exception.
  ///
  /// It is called with the error object, and expected to return a widget to
  /// display when an exception is thrown
  /// For example:
  /// ```dart
  /// (BuildContext context, error) {
  ///   return Text('$error');
  /// }
  /// ```
  ///
  /// If not specified, the error is shown in [ThemeData.errorColor](https://docs.flutter.io/flutter/material/ThemeData/errorColor.html)
  final ErrorBuilder? errorBuilder;

  /// Called to display animations when [suggestionsGroupCallback] returns suggestionsGroup
  ///
  /// It is provided with the suggestionsGroup box instance and the animation
  /// controller, and expected to return some animation that uses the controller
  /// to display the suggestion box.
  ///
  /// For example:
  /// ```dart
  /// transitionBuilder: (context, suggestionsGroupBox, animationController) {
  ///   return FadeTransition(
  ///     child: suggestionsGroupBox,
  ///     opacity: CurvedAnimation(
  ///       parent: animationController,
  ///       curve: Curves.fastOutSlowIn
  ///     ),
  ///   );
  /// }
  /// ```
  /// This argument is best used with [animationDuration] and [animationStart]
  /// to fully control the animation.
  ///
  /// To fully remove the animation, just return `suggestionsGroupBox`
  ///
  /// If not specified, a [SizeTransition](https://docs.flutter.io/flutter/widgets/SizeTransition-class.html) is shown.
  final AnimationTransitionBuilder? transitionBuilder;

  /// The duration that [transitionBuilder] animation takes.
  ///
  /// This argument is best used with [transitionBuilder] and [animationStart]
  /// to fully control the animation.
  ///
  /// Defaults to 500 milliseconds.
  final Duration animationDuration;

  /// Determine the [SuggestionGroupBox]'s direction.
  ///
  /// If [AxisDirection.down], the [SuggestionGroupBox] will be below the [TextField]
  /// and the [_SuggestionsGroupList] will grow **down**.
  ///
  /// If [AxisDirection.up], the [SuggestionGroupBox] will be above the [TextField]
  /// and the [_SuggestionsGroupList] will grow **up**.
  ///
  /// [AxisDirection.left] and [AxisDirection.right] are not allowed.
  final AxisDirection direction;

  /// The value at which the [transitionBuilder] animation starts.
  ///
  /// This argument is best used with [transitionBuilder] and [animationDuration]
  /// to fully control the animation.
  ///
  /// Defaults to 0.25.
  final double animationStart;

  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAheadGroup widget displays
  final TypeAheadGroupConfiguration typeAheadGroupConfiguration;

  /// How far below the text field should the suggestionsGroup box be
  ///
  /// Defaults to 5.0
  final double suggestionsGroupBoxVerticalOffset;

  /// If set to true, suggestionsGroup will be fetched immediately when the field is
  /// added to the view.
  ///
  /// But the suggestionsGroup box will only be shown when the field receives focus.
  /// To make the field receive focus immediately, you can set the `autofocus`
  /// property in the [typeAheadGroupConfiguration] to true
  ///
  /// Defaults to false
  final bool getImmediateSuggestionsGroup;

  /// If set to true, no loading box will be shown while suggestionsGroup are
  /// being fetched. [loadingBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnLoading;

  /// If set to true, nothing will be shown if there are no results.
  /// [noItemsFoundBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnEmpty;

  /// If set to true, nothing will be shown if there is an error.
  /// [errorBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnError;

  /// If set to false, the suggestionsGroup box will stay opened after
  /// the keyboard is closed.
  ///
  /// Defaults to true.
  final bool hideSuggestionsGroupOnKeyboardHide;

  /// If set to false, the suggestionsGroup box will show a circular
  /// progress indicator when retrieving suggestionsGroup.
  ///
  /// Defaults to true.
  final bool keepSuggestionsGroupOnLoading;

  /// If set to true, the suggestionsGroup box will remain opened even after
  /// selecting a suggestion.
  ///
  /// Note that if this is enabled, the only way
  /// to close the suggestionsGroup box is either manually via the
  /// `SuggestionsGroupBoxController` or when the user closes the software
  /// keyboard if `hideSuggestionsGroupOnKeyboardHide` is set to true. Users
  /// with a physical keyboard will be unable to close the
  /// box without a manual way via `SuggestionsGroupBoxController`.
  ///
  /// Defaults to false.
  final bool keepSuggestionsGroupOnSuggestionSelected;

  /// If set to true, in the case where the suggestionsGroup box has less than
  /// _SuggestionsGroupBoxController.minOverlaySpace to grow in the desired [direction], the direction axis
  /// will be temporarily flipped if there's more room available in the opposite
  /// direction.
  ///
  /// Defaults to false
  final bool autoFlipDirection;

  /// If set to false, suggestion list will not be reversed according to the
  /// [autoFlipDirection] property.
  ///
  /// Defaults to true.
  final bool autoFlipListDirection;

  final bool hideKeyboard;

  /// The minimum number of characters which must be entered before
  /// [suggestionsGroupCallback] is triggered.
  ///
  /// Defaults to 0.
  final int minCharsForSuggestionsGroup;

  /// If set to true and if the user scrolls through the suggestion list, hide the keyboard automatically.
  /// If set to false, the keyboard remains visible.
  /// Throws an exception, if hideKeyboardOnDrag and hideSuggestionsGroupOnKeyboardHide are both set to true as
  /// they are mutual exclusive.
  ///
  /// Defaults to false
  final bool hideKeyboardOnDrag;

  // Adds a callback for the suggestion box opening or closing
  final void Function(bool)? onSuggestionGroupsGroupBoxToggle;

  /// Creates a [TypeAheadGroupField]
  TypeAheadGroupField({
    Key? key,
    required this.suggestionsGroupCallback,
    required this.itemBuilder,
    required this.titleGroupBuilder,
    required this.onSuggestionGroupSelected,
    this.typeAheadGroupConfiguration = const TypeAheadGroupConfiguration(),
    this.suggestionsGroupBoxDecoration = const SuggestionsGroupBoxDecoration(),
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsGroupBoxController,
    this.scrollController,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationStart = 0.25,
    this.animationDuration = const Duration(milliseconds: 500),
    this.getImmediateSuggestionsGroup = false,
    this.suggestionsGroupBoxVerticalOffset = 5.0,
    this.direction = AxisDirection.down,
    this.hideOnLoading = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideSuggestionsGroupOnKeyboardHide = true,
    this.keepSuggestionsGroupOnLoading = true,
    this.keepSuggestionsGroupOnSuggestionSelected = false,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.hideKeyboard = false,
    this.minCharsForSuggestionsGroup = 0,
    this.onSuggestionGroupsGroupBoxToggle,
    this.hideKeyboardOnDrag = false,
  })  : assert(animationStart >= 0.0 && animationStart <= 1.0),
        assert(direction == AxisDirection.down || direction == AxisDirection.up),
        assert(minCharsForSuggestionsGroup >= 0),
        assert(!hideKeyboardOnDrag || hideKeyboardOnDrag && !hideSuggestionsGroupOnKeyboardHide),
        super(key: key);

  @override
  _TypeAheadGroupFieldState<T> createState() => _TypeAheadGroupFieldState<T>();
}

class _TypeAheadGroupFieldState<T> extends State<TypeAheadGroupField<T>> with WidgetsBindingObserver {
  FocusNode? _focusNode;
  final KeyboardSuggestionGroupSelectionNotifier _keyboardSuggestionGroupSelectionNotifier =
      KeyboardSuggestionGroupSelectionNotifier();
  TextEditingController? _textEditingController;
  _SuggestionsGroupBox? _suggestionsGroupBox;

  TextEditingController? get _effectiveController =>
      widget.typeAheadGroupConfiguration.controller ?? _textEditingController;

  FocusNode? get _effectiveFocusNode => widget.typeAheadGroupConfiguration.focusNode ?? _focusNode;
  late VoidCallback _focusNodeListener;

  final LayerLink _layerLink = LayerLink();

  // Timer that resizes the suggestion box on each tick. Only active when the user is scrolling.
  Timer? _resizeOnScrollTimer;

  // The rate at which the suggestion box will resize when the user is scrolling
  final Duration _resizeOnScrollRefreshRate = const Duration(milliseconds: 500);

  // Will have a value if the typeahead is inside a scrollable widget
  ScrollPosition? _scrollPosition;

  // Keyboard detection
  final Stream<bool>? _keyboardVisibility =
      (supportedPlatform) ? KeyboardVisibilityController().onChange : null;
  late StreamSubscription<bool>? _keyboardVisibilitySubscription;

  bool _areSuggestionsGroupFocused = false;
  late final _shouldRefreshSuggestionsGroupFocusIndex =
      ShouldRefreshSuggestionGroupFocusIndexNotifier(textFieldFocusNode: _effectiveFocusNode);

  @override
  void didChangeMetrics() {
    // Catch keyboard event and orientation change; resize suggestionsGroup list
    this._suggestionsGroupBox!.onChangeMetrics();
  }

  @override
  void dispose() {
    this._suggestionsGroupBox!.close();
    this._suggestionsGroupBox!.widgetMounted = false;
    WidgetsBinding.instance.removeObserver(this);
    _keyboardVisibilitySubscription?.cancel();
    _effectiveFocusNode!.removeListener(_focusNodeListener);
    _focusNode?.dispose();
    _resizeOnScrollTimer?.cancel();
    _scrollPosition?.removeListener(_scrollResizeListener);
    _textEditingController?.dispose();
    _keyboardSuggestionGroupSelectionNotifier.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode _, RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) || event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      // do nothing to avoid puzzling users until keyboard arrow nav is implemented
    } else {
      _keyboardSuggestionGroupSelectionNotifier.onKeyboardEvent(event);
    }
    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.typeAheadGroupConfiguration.controller == null) {
      this._textEditingController = TextEditingController();
    }

    final typeAheadGroupConfigurationFocusNode = widget.typeAheadGroupConfiguration.focusNode;
    if (typeAheadGroupConfigurationFocusNode == null) {
      this._focusNode = FocusNode(onKey: _onKeyEvent);
    } else if (typeAheadGroupConfigurationFocusNode.onKey == null) {
      // * we add the _onKeyEvent callback to the typeAheadGroupConfiguration focusNode
      typeAheadGroupConfigurationFocusNode.onKey = ((node, event) {
        final keyEventResult = _onKeyEvent(node, event);
        return keyEventResult;
      });
    } else {
      final onKeyCopy = typeAheadGroupConfigurationFocusNode.onKey!;
      typeAheadGroupConfigurationFocusNode.onKey = ((node, event) {
        _onKeyEvent(node, event);
        return onKeyCopy(node, event);
      });
    }

    this._suggestionsGroupBox = _SuggestionsGroupBox(
      context,
      widget.direction,
      widget.autoFlipDirection,
      widget.autoFlipListDirection,
    );

    widget.suggestionsGroupBoxController?._suggestionsGroupBox = this._suggestionsGroupBox;
    widget.suggestionsGroupBoxController?._effectiveFocusNode = this._effectiveFocusNode;

    this._focusNodeListener = () {
      if (_effectiveFocusNode!.hasFocus) {
        this._suggestionsGroupBox!.open();
      } else if (!_areSuggestionsGroupFocused) {
        if (widget.hideSuggestionsGroupOnKeyboardHide) {
          this._suggestionsGroupBox!.close();
        }
      }

      widget.onSuggestionGroupsGroupBoxToggle?.call(this._suggestionsGroupBox!.isOpened);
    };

    this._effectiveFocusNode!.addListener(_focusNodeListener);

    // hide suggestionsGroup box on keyboard closed
    this._keyboardVisibilitySubscription = _keyboardVisibility?.listen((bool isVisible) {
      if (widget.hideSuggestionsGroupOnKeyboardHide && !isVisible) {
        _effectiveFocusNode!.unfocus();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (mounted) {
        this._initOverlayEntry();
        // calculate initial suggestionsGroup list size
        this._suggestionsGroupBox!.resize();

        // in case we already missed the focus event
        if (this._effectiveFocusNode!.hasFocus) {
          this._suggestionsGroupBox!.open();
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollableState = Scrollable.maybeOf(context);
    if (scrollableState != null) {
      // The TypeAheadGroupField is inside a scrollable widget
      _scrollPosition = scrollableState.position;

      _scrollPosition!.removeListener(_scrollResizeListener);
      _scrollPosition!.isScrollingNotifier.addListener(_scrollResizeListener);
    }
  }

  void _scrollResizeListener() {
    bool isScrolling = _scrollPosition!.isScrollingNotifier.value;
    _resizeOnScrollTimer?.cancel();
    if (isScrolling) {
      // Scroll started
      _resizeOnScrollTimer = Timer.periodic(_resizeOnScrollRefreshRate, (timer) {
        _suggestionsGroupBox!.resize();
      });
    } else {
      // Scroll finished
      _suggestionsGroupBox!.resize();
    }
  }

  void _initOverlayEntry() {
    this._suggestionsGroupBox!._overlayEntry = OverlayEntry(builder: (context) {
      void giveTextFieldFocus() {
        _effectiveFocusNode?.requestFocus();
        _areSuggestionsGroupFocused = false;
      }

      void onSuggestionGroupFocus() {
        if (!_areSuggestionsGroupFocused) {
          _areSuggestionsGroupFocused = true;
        }
      }

      final suggestionsGroupList = _SuggestionsGroupList<T>(
          suggestionsGroupBox: _suggestionsGroupBox,
          decoration: widget.suggestionsGroupBoxDecoration,
          debounceDuration: widget.debounceDuration,
          controller: this._effectiveController,
          loadingBuilder: widget.loadingBuilder,
          scrollController: widget.scrollController,
          noItemsFoundBuilder: widget.noItemsFoundBuilder,
          errorBuilder: widget.errorBuilder,
          transitionBuilder: widget.transitionBuilder,
          suggestionsGroupCallback: widget.suggestionsGroupCallback,
          animationDuration: widget.animationDuration,
          animationStart: widget.animationStart,
          getImmediateSuggestionsGroup: widget.getImmediateSuggestionsGroup,
          onSuggestionGroupSelected: (T selection) {
            if (!widget.keepSuggestionsGroupOnSuggestionSelected) {
              this._effectiveFocusNode!.unfocus();
              this._suggestionsGroupBox!.close();
            }
            widget.onSuggestionGroupSelected(selection);
          },
          titleGroupBuilder: widget.titleGroupBuilder,
          itemBuilder: widget.itemBuilder,
          direction: _suggestionsGroupBox!.direction,
          hideOnLoading: widget.hideOnLoading,
          hideOnEmpty: widget.hideOnEmpty,
          hideOnError: widget.hideOnError,
          keepSuggestionsGroupOnLoading: widget.keepSuggestionsGroupOnLoading,
          minCharsForSuggestionsGroup: widget.minCharsForSuggestionsGroup,
          keyboardSuggestionGroupSelectionNotifier: _keyboardSuggestionGroupSelectionNotifier,
          shouldRefreshSuggestionGroupFocusIndexNotifier: _shouldRefreshSuggestionsGroupFocusIndex,
          giveTextFieldFocus: giveTextFieldFocus,
          onSuggestionGroupFocus: onSuggestionGroupFocus,
          onKeyEvent: _onKeyEvent,
          hideKeyboardOnDrag: widget.hideKeyboardOnDrag);

      double w = _suggestionsGroupBox!.textBoxWidth;
      if (widget.suggestionsGroupBoxDecoration.constraints != null) {
        if (widget.suggestionsGroupBoxDecoration.constraints!.minWidth != 0.0 &&
            widget.suggestionsGroupBoxDecoration.constraints!.maxWidth != double.infinity) {
          w = (widget.suggestionsGroupBoxDecoration.constraints!.minWidth +
                  widget.suggestionsGroupBoxDecoration.constraints!.maxWidth) /
              2;
        } else if (widget.suggestionsGroupBoxDecoration.constraints!.minWidth != 0.0 &&
            widget.suggestionsGroupBoxDecoration.constraints!.minWidth > w) {
          w = widget.suggestionsGroupBoxDecoration.constraints!.minWidth;
        } else if (widget.suggestionsGroupBoxDecoration.constraints!.maxWidth != double.infinity &&
            widget.suggestionsGroupBoxDecoration.constraints!.maxWidth < w) {
          w = widget.suggestionsGroupBoxDecoration.constraints!.maxWidth;
        }
      }

      final Widget compositedFollower = CompositedTransformFollower(
        link: this._layerLink,
        showWhenUnlinked: false,
        offset: Offset(
            widget.suggestionsGroupBoxDecoration.offsetX,
            _suggestionsGroupBox!.direction == AxisDirection.down
                ? _suggestionsGroupBox!.textBoxHeight + widget.suggestionsGroupBoxVerticalOffset
                : _suggestionsGroupBox!.directionUpOffset),
        child: _suggestionsGroupBox!.direction == AxisDirection.down
            ? suggestionsGroupList
            : FractionalTranslation(
                translation: Offset(0.0, -1.0), // visually flips list to go up
                child: suggestionsGroupList,
              ),
      );

      // When wrapped in the Positioned widget, the suggestionsGroup box widget
      // is placed before the Scaffold semantically. In order to have the
      // suggestionsGroup box navigable from the search input or keyboard,
      // Semantics > Align > ConstrainedBox are needed. This does not change
      // the style visually. However, when VO/TB are not enabled it is
      // necessary to use the Positioned widget to allow the elements to be
      // properly tappable.
      return MediaQuery.of(context).accessibleNavigation
          ? Semantics(
              container: true,
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: w),
                  child: compositedFollower,
                ),
              ),
            )
          : Positioned(
              width: w,
              child: compositedFollower,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextField(
        key: TestKeysGroup.textFieldKey,
        focusNode: this._effectiveFocusNode,
        controller: this._effectiveController,
        decoration: widget.typeAheadGroupConfiguration.decoration,
        style: widget.typeAheadGroupConfiguration.style,
        textAlign: widget.typeAheadGroupConfiguration.textAlign,
        enabled: widget.typeAheadGroupConfiguration.enabled,
        keyboardType: widget.typeAheadGroupConfiguration.keyboardType,
        autofocus: widget.typeAheadGroupConfiguration.autofocus,
        inputFormatters: widget.typeAheadGroupConfiguration.inputFormatters,
        autocorrect: widget.typeAheadGroupConfiguration.autocorrect,
        maxLines: widget.typeAheadGroupConfiguration.maxLines,
        textAlignVertical: widget.typeAheadGroupConfiguration.textAlignVertical,
        minLines: widget.typeAheadGroupConfiguration.minLines,
        maxLength: widget.typeAheadGroupConfiguration.maxLength,
        maxLengthEnforcement: widget.typeAheadGroupConfiguration.maxLengthEnforcement,
        obscureText: widget.typeAheadGroupConfiguration.obscureText,
        onChanged: widget.typeAheadGroupConfiguration.onChanged,
        onSubmitted: widget.typeAheadGroupConfiguration.onSubmitted,
        onEditingComplete: widget.typeAheadGroupConfiguration.onEditingComplete,
        onTap: widget.typeAheadGroupConfiguration.onTap,
//         onTapOutside: (_) {},
        scrollPadding: widget.typeAheadGroupConfiguration.scrollPadding,
        textInputAction: widget.typeAheadGroupConfiguration.textInputAction,
        textCapitalization: widget.typeAheadGroupConfiguration.textCapitalization,
        keyboardAppearance: widget.typeAheadGroupConfiguration.keyboardAppearance,
        cursorWidth: widget.typeAheadGroupConfiguration.cursorWidth,
        cursorRadius: widget.typeAheadGroupConfiguration.cursorRadius,
        cursorColor: widget.typeAheadGroupConfiguration.cursorColor,
        textDirection: widget.typeAheadGroupConfiguration.textDirection,
        enableInteractiveSelection: widget.typeAheadGroupConfiguration.enableInteractiveSelection,
        readOnly: widget.hideKeyboard,
      ),
    );
  }
}

class _SuggestionsGroupList<T> extends StatefulWidget {
  final _SuggestionsGroupBox? suggestionsGroupBox;
  final TextEditingController? controller;
  final bool getImmediateSuggestionsGroup;
  final SuggestionGroupSelectionCallback<T>? onSuggestionGroupSelected;
  final SuggestionsGroupCallback<T>? suggestionsGroupCallback;
  final ItemBuilder<T>? itemBuilder;
  final TitleGroupBuilder<String>? titleGroupBuilder;
  final ScrollController? scrollController;
  final SuggestionsGroupBoxDecoration? decoration;
  final Duration? debounceDuration;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? noItemsFoundBuilder;
  final ErrorBuilder? errorBuilder;
  final AnimationTransitionBuilder? transitionBuilder;
  final Duration? animationDuration;
  final double? animationStart;
  final AxisDirection? direction;
  final bool? hideOnLoading;
  final bool? hideOnEmpty;
  final bool? hideOnError;
  final bool? keepSuggestionsGroupOnLoading;
  final int? minCharsForSuggestionsGroup;
  final KeyboardSuggestionGroupSelectionNotifier keyboardSuggestionGroupSelectionNotifier;
  final ShouldRefreshSuggestionGroupFocusIndexNotifier shouldRefreshSuggestionGroupFocusIndexNotifier;
  final VoidCallback giveTextFieldFocus;
  final VoidCallback onSuggestionGroupFocus;
  final KeyEventResult Function(FocusNode _, RawKeyEvent event) onKeyEvent;
  final bool hideKeyboardOnDrag;

  _SuggestionsGroupList({
    required this.suggestionsGroupBox,
    this.controller,
    this.getImmediateSuggestionsGroup = false,
    this.onSuggestionGroupSelected,
    this.suggestionsGroupCallback,
    this.itemBuilder,
    this.titleGroupBuilder,
    this.scrollController,
    this.decoration,
    this.debounceDuration,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationDuration,
    this.animationStart,
    this.direction,
    this.hideOnLoading,
    this.hideOnEmpty,
    this.hideOnError,
    this.keepSuggestionsGroupOnLoading,
    this.minCharsForSuggestionsGroup,
    required this.keyboardSuggestionGroupSelectionNotifier,
    required this.shouldRefreshSuggestionGroupFocusIndexNotifier,
    required this.giveTextFieldFocus,
    required this.onSuggestionGroupFocus,
    required this.onKeyEvent,
    required this.hideKeyboardOnDrag,
  });

  @override
  _SuggestionsGroupListState<T> createState() => _SuggestionsGroupListState<T>();
}

class _SuggestionsGroupListState<T> extends State<_SuggestionsGroupList<T>>
    with SingleTickerProviderStateMixin {
  Iterable<TypeAheadDataGroup<T>>? _groupSuggestionsGroup;
  late bool _suggestionsGroupValid;
  late VoidCallback _controllerListener;
  Timer? _debounceTimer;
  bool? _isLoading, _isQueued;
  Object? _error;
  AnimationController? _animationController;
  String? _lastTextValue;
  late final ScrollController _scrollController = widget.scrollController ?? ScrollController();
  // List<FocusNode> _focusNodes = [];
  // int _suggestionIndex = -1;

  _SuggestionsGroupListState() {
    this._controllerListener = () {
      // If we came here because of a change in selected text, not because of
      // actual change in text
      if (widget.controller!.text == this._lastTextValue) return;

      this._lastTextValue = widget.controller!.text;

      this._debounceTimer?.cancel();
      if (widget.controller!.text.length < widget.minCharsForSuggestionsGroup!) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _groupSuggestionsGroup = null;
            _suggestionsGroupValid = true;
          });
        }
        return;
      } else {
        this._debounceTimer = Timer(widget.debounceDuration!, () async {
          if (this._debounceTimer!.isActive) return;
          if (_isLoading!) {
            _isQueued = true;
            return;
          }

          await this.invalidateSuggestionsGroup();
          while (_isQueued!) {
            _isQueued = false;
            await this.invalidateSuggestionsGroup();
          }
        });
      }
    };
  }

  @override
  void didUpdateWidget(_SuggestionsGroupList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller!.addListener(this._controllerListener);
    _getSuggestionsGroup();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getSuggestionsGroup();
  }

  @override
  void initState() {
    super.initState();

    this._animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    this._suggestionsGroupValid = widget.minCharsForSuggestionsGroup! > 0 ? true : false;
    this._isLoading = false;
    this._isQueued = false;
    this._lastTextValue = widget.controller!.text;

    if (widget.getImmediateSuggestionsGroup) {
      this._getSuggestionsGroup();
    }

    widget.controller!.addListener(this._controllerListener);

    widget.keyboardSuggestionGroupSelectionNotifier.addListener(() {
      // final suggestionsGroupLength = _groupSuggestionsGroup?.length;
      // final event = widget.keyboardSuggestionGroupSelectionNotifier.value;
      // if (event == null || suggestionsGroupLength == null) return;
      //
      // if (event == LogicalKeyboardKey.arrowDown && _suggestionIndex < suggestionsGroupLength - 1) {
      //   _suggestionIndex++;
      // } else if (event == LogicalKeyboardKey.arrowUp && _suggestionIndex > -1) {
      //   _suggestionIndex--;
      // }
      //
      // if (_suggestionIndex > -1 && _suggestionIndex < _focusNodes.length) {
      //   final focusNode = _focusNodes[_suggestionIndex];
      //   focusNode.requestFocus();
      //   widget.onSuggestionGroupFocus();
      // } else {
      //   widget.giveTextFieldFocus();
      // }
    });

    widget.shouldRefreshSuggestionGroupFocusIndexNotifier.addListener(() {
      // if (_suggestionIndex != -1) {
      //   _suggestionIndex = -1;
      // }
    });
  }

  Future<void> invalidateSuggestionsGroup() async {
    _suggestionsGroupValid = false;
    await _getSuggestionsGroup();
  }

  Future<void> _getSuggestionsGroup() async {
    if (_suggestionsGroupValid) return;
    _suggestionsGroupValid = true;

    if (mounted) {
      setState(() {
        this._animationController!.forward(from: 1.0);

        this._isLoading = true;
        this._error = null;
      });

      Iterable<TypeAheadDataGroup<T>>? suggestionsGroup;
      Object? error;

      try {
        suggestionsGroup = await widget.suggestionsGroupCallback!(widget.controller!.text);
      } catch (e) {
        error = e;
      }

      if (this.mounted) {
        // if it wasn't removed in the meantime
        setState(() {
          double? animationStart = widget.animationStart;
          // allow suggestionsGroupCallback to return null and not throw error here
          if (error != null || suggestionsGroup?.isEmpty == true) {
            animationStart = 1.0;
          }
          this._animationController!.forward(from: animationStart);

          this._error = error;
          this._isLoading = false;
          this._groupSuggestionsGroup = suggestionsGroup;
          // _focusNodes = List.generate(
          //   _groupSuggestionsGroup?.length ?? 0,
          //   (index) => FocusNode(onKey: (_, event) {
          //     return widget.onKeyEvent(_, event);
          //   }),
          // );
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    _debounceTimer?.cancel();
    // for (final focusNode in _focusNodes) {
    //   focusNode.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = this._groupSuggestionsGroup?.length == 0 && widget.controller!.text == "";
    if ((this._groupSuggestionsGroup == null || isEmpty) && this._isLoading == false && this._error == null)
      return Container();

    Widget child;
    if (this._isLoading!) {
      if (widget.hideOnLoading!) {
        child = Container(height: 0);
      } else {
        child = createLoadingWidget();
      }
    } else if (this._error != null) {
      if (widget.hideOnError!) {
        child = Container(height: 0);
      } else {
        child = createErrorWidget();
      }
    } else if (this._groupSuggestionsGroup!.isEmpty) {
      if (widget.hideOnEmpty!) {
        child = Container(height: 0);
      } else {
        child = createNoItemsFoundWidget();
      }
    } else {
      child = createSuggestionsGroupWidget();
    }

    final animationChild = widget.transitionBuilder != null
        ? widget.transitionBuilder!(context, child, this._animationController)
        : SizeTransition(
            axisAlignment: -1.0,
            sizeFactor: CurvedAnimation(parent: this._animationController!, curve: Curves.fastOutSlowIn),
            child: child,
          );

    BoxConstraints constraints;
    if (widget.decoration!.constraints == null) {
      constraints = BoxConstraints(
        maxHeight: widget.suggestionsGroupBox!.maxHeight,
      );
    } else {
      double maxHeight =
          min(widget.decoration!.constraints!.maxHeight, widget.suggestionsGroupBox!.maxHeight);
      constraints = widget.decoration!.constraints!.copyWith(
        minHeight: min(widget.decoration!.constraints!.minHeight, maxHeight),
        maxHeight: maxHeight,
      );
    }

    var container = Material(
      elevation: widget.decoration!.elevation,
      color: widget.decoration!.color,
      shape: widget.decoration!.shape,
      borderRadius: widget.decoration!.borderRadius,
      shadowColor: widget.decoration!.shadowColor,
      clipBehavior: widget.decoration!.clipBehavior,
      child: ConstrainedBox(
        constraints: constraints,
        child: animationChild,
      ),
    );

    return container;
  }

  Widget createLoadingWidget() {
    Widget child;

    if (widget.keepSuggestionsGroupOnLoading! && this._groupSuggestionsGroup != null) {
      if (this._groupSuggestionsGroup!.isEmpty) {
        child = createNoItemsFoundWidget();
      } else {
        child = createSuggestionsGroupWidget();
      }
    } else {
      child = widget.loadingBuilder != null
          ? widget.loadingBuilder!(context)
          : Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              ),
            );
    }

    return child;
  }

  Widget createErrorWidget() {
    return widget.errorBuilder != null
        ? widget.errorBuilder!(context, this._error)
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${this._error}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
  }

  Widget createNoItemsFoundWidget() {
    return widget.noItemsFoundBuilder != null
        ? widget.noItemsFoundBuilder!(context)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No Items Found!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).disabledColor, fontSize: 18.0),
            ),
          );
  }

  Widget createSuggestionsGroupWidget() {
    Widget child = CustomScrollView(
      primary: false,
      shrinkWrap: true,
      keyboardDismissBehavior: widget.hideKeyboardOnDrag
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      controller: _scrollController,
      reverse: widget.suggestionsGroupBox!.direction == AxisDirection.down
          ? false
          : widget.suggestionsGroupBox!.autoFlipListDirection,
      slivers: List.generate(this._groupSuggestionsGroup!.length, (index) {
        final groupSuggestionsGroup = _groupSuggestionsGroup!.elementAt(index);
        return SliverStickyHeader(
          header: widget.titleGroupBuilder!(context, groupSuggestionsGroup.title),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                // final focusNode = _focusNodes[i];
                final T item = groupSuggestionsGroup.items[i];
                return TextFieldTapRegion(
                  child: InkWell(
                    key: TestKeysGroup.getSuggestionKey(i),
                    focusColor: Theme.of(context).hoverColor,
                    // focusNode: focusNode,
                    child: widget.itemBuilder!(context, item),
                    onTap: () {
                      // * we give the focus back to the text field
                      widget.giveTextFieldFocus();

                      widget.onSuggestionGroupSelected!(item);
                    },
                  ),
                );
              },
              childCount: groupSuggestionsGroup.items.length,
            ),
          ),
        );
      }),
    );
    if (widget.decoration!.hasScrollbar) {
      child = Scrollbar(
        controller: _scrollController,
        child: child,
      );
    }

    return child;
  }
}

/// Supply an instance of this class to the [TypeAheadGroup.suggestionsGroupBoxDecoration]
/// property to configure the suggestionsGroup box decoration
class SuggestionsGroupBoxDecoration {
  /// The z-coordinate at which to place the suggestionsGroup box. This controls the size
  /// of the shadow below the box.
  ///
  /// Same as [Material.elevation](https://docs.flutter.io/flutter/material/Material/elevation.html)
  final double elevation;

  /// The color to paint the suggestionsGroup box.
  ///
  /// Same as [Material.color](https://docs.flutter.io/flutter/material/Material/color.html)
  final Color? color;

  /// Defines the material's shape as well its shadow.
  ///
  /// Same as [Material.shape](https://docs.flutter.io/flutter/material/Material/shape.html)
  final ShapeBorder? shape;

  /// Defines if a scrollbar will be displayed or not.
  final bool hasScrollbar;

  /// If non-null, the corners of this box are rounded by this [BorderRadius](https://docs.flutter.io/flutter/painting/BorderRadius-class.html).
  ///
  /// Same as [Material.borderRadius](https://docs.flutter.io/flutter/material/Material/borderRadius.html)
  final BorderRadius? borderRadius;

  /// The color to paint the shadow below the material.
  ///
  /// Same as [Material.shadowColor](https://docs.flutter.io/flutter/material/Material/shadowColor.html)
  final Color shadowColor;

  /// The constraints to be applied to the suggestionsGroup box
  final BoxConstraints? constraints;

  /// Adds an offset to the suggestionsGroup box
  final double offsetX;

  /// The content will be clipped (or not) according to this option.
  ///
  /// Same as [Material.clipBehavior](https://api.flutter.dev/flutter/material/Material/clipBehavior.html)
  final Clip clipBehavior;

  /// Creates a SuggestionsGroupBoxDecoration
  const SuggestionsGroupBoxDecoration(
      {this.elevation = 4.0,
      this.color,
      this.shape,
      this.hasScrollbar = true,
      this.borderRadius,
      this.shadowColor = const Color(0xFF000000),
      this.constraints,
      this.clipBehavior = Clip.none,
      this.offsetX = 0.0});
}

/// Supply an instance of this class to the [TypeAheadGroup.typeAheadGroupConfiguration]
/// property to configure the displayed text field
class TypeAheadGroupConfiguration {
  /// The decoration to show around the text field.
  ///
  /// Same as [TextField.decoration](https://docs.flutter.io/flutter/material/TextField/decoration.html)
  final InputDecoration decoration;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html).
  /// A typical use case for this field in the TypeAheadGroup widget is to set the
  /// text of the widget when a suggestion is selected. For example:
  ///
  /// ```dart
  /// final _controller = TextEditingController();
  /// ...
  /// ...
  /// TypeAheadGroupField(
  ///   controller: _controller,
  ///   ...
  ///   ...
  ///   onSuggestionGroupSelected: (suggestion) {
  ///     _controller.text = suggestion['city_name'];
  ///   }
  /// )
  /// ```
  final TextEditingController? controller;

  /// Controls whether this widget has keyboard focus.
  ///
  /// Same as [TextField.focusNode](https://docs.flutter.io/flutter/material/TextField/focusNode.html)
  final FocusNode? focusNode;

  /// The style to use for the text being edited.
  ///
  /// Same as [TextField.style](https://docs.flutter.io/flutter/material/TextField/style.html)
  final TextStyle? style;

  /// How the text being edited should be aligned horizontally.
  ///
  /// Same as [TextField.textAlign](https://docs.flutter.io/flutter/material/TextField/textAlign.html)
  final TextAlign textAlign;

  /// Same as [TextField.textDirection](https://docs.flutter.io/flutter/material/TextField/textDirection.html)
  ///
  /// Defaults to null
  final TextDirection? textDirection;

  /// Same as [TextField.textAlignVertical](https://api.flutter.dev/flutter/material/TextField/textAlignVertical.html)
  final TextAlignVertical? textAlignVertical;

  /// If false the textfield is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// Same as [TextField.enabled](https://docs.flutter.io/flutter/material/TextField/enabled.html)
  final bool enabled;

  /// Whether to show input suggestionsGroup as the user types.
  ///
  /// Same as [TextField.enableSuggestionsGroup](https://api.flutter.dev/flutter/material/TextField/enableSuggestionsGroup.html)
  final bool enableSuggestionsGroup;

  /// The type of keyboard to use for editing the text.
  ///
  /// Same as [TextField.keyboardType](https://docs.flutter.io/flutter/material/TextField/keyboardType.html)
  final TextInputType keyboardType;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  ///
  /// Same as [TextField.autofocus](https://docs.flutter.io/flutter/material/TextField/autofocus.html)
  final bool autofocus;

  /// Optional input validation and formatting overrides.
  ///
  /// Same as [TextField.inputFormatters](https://docs.flutter.io/flutter/material/TextField/inputFormatters.html)
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to enable autocorrection.
  ///
  /// Same as [TextField.autocorrect](https://docs.flutter.io/flutter/material/TextField/autocorrect.html)
  final bool autocorrect;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  ///
  /// Same as [TextField.maxLines](https://docs.flutter.io/flutter/material/TextField/maxLines.html)
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  ///
  /// Same as [TextField.minLines](https://docs.flutter.io/flutter/material/TextField/minLines.html)
  final int? minLines;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// Same as [TextField.maxLength](https://docs.flutter.io/flutter/material/TextField/maxLength.html)
  final int? maxLength;

  /// If true, prevents the field from allowing more than [maxLength]
  /// characters.
  ///
  /// Same as [TextField.maxLengthEnforcement](https://api.flutter.dev/flutter/material/TextField/maxLengthEnforcement.html)
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://docs.flutter.io/flutter/material/TextField/obscureText.html)
  final bool obscureText;

  /// Called when the text being edited changes.
  ///
  /// Same as [TextField.onChanged](https://docs.flutter.io/flutter/material/TextField/onChanged.html)
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  ///
  /// Same as [TextField.onSubmitted](https://docs.flutter.io/flutter/material/TextField/onSubmitted.html)
  final ValueChanged<String>? onSubmitted;

  /// The color to use when painting the cursor.
  ///
  /// Same as [TextField.cursorColor](https://docs.flutter.io/flutter/material/TextField/cursorColor.html)
  final Color? cursorColor;

  /// How rounded the corners of the cursor should be. By default, the cursor has a null Radius
  ///
  /// Same as [TextField.cursorRadius](https://docs.flutter.io/flutter/material/TextField/cursorRadius.html)
  final Radius? cursorRadius;

  /// How thick the cursor will be.
  ///
  /// Same as [TextField.cursorWidth](https://docs.flutter.io/flutter/material/TextField/cursorWidth.html)
  final double cursorWidth;

  /// The appearance of the keyboard.
  ///
  /// Same as [TextField.keyboardAppearance](https://docs.flutter.io/flutter/material/TextField/keyboardAppearance.html)
  final Brightness? keyboardAppearance;

  /// Called when the user submits editable content (e.g., user presses the "done" button on the keyboard).
  ///
  /// Same as [TextField.onEditingComplete](https://docs.flutter.io/flutter/material/TextField/onEditingComplete.html)
  final VoidCallback? onEditingComplete;

  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// Same as [TextField.onTap](https://docs.flutter.io/flutter/material/TextField/onTap.html)
  final GestureTapCallback? onTap;

  /// Configures padding to edges surrounding a Scrollable when the Textfield scrolls into view.
  ///
  /// Same as [TextField.scrollPadding](https://docs.flutter.io/flutter/material/TextField/scrollPadding.html)
  final EdgeInsets scrollPadding;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///
  /// Same as [TextField.TextCapitalization](https://docs.flutter.io/flutter/material/TextField/textCapitalization.html)
  final TextCapitalization textCapitalization;

  /// The type of action button to use for the keyboard.
  ///
  /// Same as [TextField.textInputAction](https://docs.flutter.io/flutter/material/TextField/textInputAction.html)
  final TextInputAction? textInputAction;

  final bool enableInteractiveSelection;

  /// Creates a TypeAheadGroupConfiguration
  const TypeAheadGroupConfiguration({
    this.decoration = const InputDecoration(),
    this.style,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.maxLengthEnforcement,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.textAlignVertical,
    this.autocorrect = true,
    this.inputFormatters,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.enableSuggestionsGroup = true,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.cursorColor,
    this.cursorRadius,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.cursorWidth = 2.0,
    this.keyboardAppearance,
    this.onEditingComplete,
    this.onTap,
    this.textDirection,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
  });

  /// Copies the [TypeAheadGroupConfiguration] and only changes the specified
  /// properties
  TypeAheadGroupConfiguration copyWith(
      {InputDecoration? decoration,
      TextStyle? style,
      TextEditingController? controller,
      ValueChanged<String>? onChanged,
      ValueChanged<String>? onSubmitted,
      bool? obscureText,
      MaxLengthEnforcement? maxLengthEnforcement,
      int? maxLength,
      int? maxLines,
      int? minLines,
      bool? autocorrect,
      List<TextInputFormatter>? inputFormatters,
      bool? autofocus,
      TextInputType? keyboardType,
      bool? enabled,
      bool? enableSuggestionsGroup,
      TextAlign? textAlign,
      FocusNode? focusNode,
      Color? cursorColor,
      TextAlignVertical? textAlignVertical,
      Radius? cursorRadius,
      double? cursorWidth,
      Brightness? keyboardAppearance,
      VoidCallback? onEditingComplete,
      GestureTapCallback? onTap,
      EdgeInsets? scrollPadding,
      TextCapitalization? textCapitalization,
      TextDirection? textDirection,
      TextInputAction? textInputAction,
      bool? enableInteractiveSelection}) {
    return TypeAheadGroupConfiguration(
      decoration: decoration ?? this.decoration,
      style: style ?? this.style,
      controller: controller ?? this.controller,
      onChanged: onChanged ?? this.onChanged,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      obscureText: obscureText ?? this.obscureText,
      maxLengthEnforcement: maxLengthEnforcement ?? this.maxLengthEnforcement,
      maxLength: maxLength ?? this.maxLength,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      autocorrect: autocorrect ?? this.autocorrect,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      autofocus: autofocus ?? this.autofocus,
      keyboardType: keyboardType ?? this.keyboardType,
      enabled: enabled ?? this.enabled,
      enableSuggestionsGroup: enableSuggestionsGroup ?? this.enableSuggestionsGroup,
      textAlign: textAlign ?? this.textAlign,
      textAlignVertical: textAlignVertical ?? this.textAlignVertical,
      focusNode: focusNode ?? this.focusNode,
      cursorColor: cursorColor ?? this.cursorColor,
      cursorRadius: cursorRadius ?? this.cursorRadius,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
      onEditingComplete: onEditingComplete ?? this.onEditingComplete,
      onTap: onTap ?? this.onTap,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      textCapitalization: textCapitalization ?? this.textCapitalization,
      textInputAction: textInputAction ?? this.textInputAction,
      textDirection: textDirection ?? this.textDirection,
      enableInteractiveSelection: enableInteractiveSelection ?? this.enableInteractiveSelection,
    );
  }
}

class _SuggestionsGroupBox {
  static const int waitMetricsTimeoutMillis = 1000;
  static const double minOverlaySpace = 64.0;

  final BuildContext context;
  final AxisDirection desiredDirection;
  final bool autoFlipDirection;
  final bool autoFlipListDirection;

  OverlayEntry? _overlayEntry;
  AxisDirection direction;

  bool isOpened = false;
  bool widgetMounted = true;
  double maxHeight = 300.0;
  double textBoxWidth = 100.0;
  double textBoxHeight = 100.0;
  late double directionUpOffset;

  _SuggestionsGroupBox(
    this.context,
    this.direction,
    this.autoFlipDirection,
    this.autoFlipListDirection,
  ) : desiredDirection = direction;

  void open() {
    if (this.isOpened) return;
    assert(this._overlayEntry != null);
    resize();
    Overlay.of(context).insert(this._overlayEntry!);
    this.isOpened = true;
  }

  void close() {
    if (!this.isOpened) return;
    assert(this._overlayEntry != null);
    this._overlayEntry!.remove();
    this.isOpened = false;
  }

  void toggle() {
    if (this.isOpened) {
      this.close();
    } else {
      this.open();
    }
  }

  MediaQuery? _findRootMediaQuery() {
    MediaQuery? rootMediaQuery;
    context.visitAncestorElements((element) {
      if (element.widget is MediaQuery) {
        rootMediaQuery = element.widget as MediaQuery;
      }
      return true;
    });

    return rootMediaQuery;
  }

  /// Delays until the keyboard has toggled or the orientation has fully changed
  Future<bool> _waitChangeMetrics() async {
    if (widgetMounted) {
      // initial viewInsets which are before the keyboard is toggled
      EdgeInsets initial = MediaQuery.of(context).viewInsets;
      // initial MediaQuery for orientation change
      MediaQuery? initialRootMediaQuery = _findRootMediaQuery();

      int timer = 0;
      // viewInsets or MediaQuery have changed once keyboard has toggled or orientation has changed
      while (widgetMounted && timer < waitMetricsTimeoutMillis) {
        // TODO: reduce delay if showDialog ever exposes detection of animation end
        await Future<void>.delayed(const Duration(milliseconds: 170));
        timer += 170;

        if (widgetMounted &&
            (MediaQuery.of(context).viewInsets != initial ||
                _findRootMediaQuery() != initialRootMediaQuery)) {
          return true;
        }
      }
    }

    return false;
  }

  void resize() {
    // check to see if widget is still mounted
    // user may have closed the widget with the keyboard still open
    if (widgetMounted) {
      _adjustMaxHeightAndOrientation();
      _overlayEntry!.markNeedsBuild();
    }
  }

  // See if there's enough room in the desired direction for the overlay to display
  // correctly. If not, try the opposite direction if things look more roomy there
  void _adjustMaxHeightAndOrientation() {
    TypeAheadGroupField widget = context.widget as TypeAheadGroupField;

    RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null || box.hasSize == false) {
      return;
    }

    textBoxWidth = box.size.width;
    textBoxHeight = box.size.height;

    // top of text box
    double textBoxAbsY = box.localToGlobal(Offset.zero).dy;

    // height of window
    double windowHeight = MediaQuery.of(context).size.height;

    // we need to find the root MediaQuery for the unsafe area height
    // we cannot use BuildContext.ancestorWidgetOfExactType because
    // widgets like SafeArea creates a new MediaQuery with the padding removed
    MediaQuery rootMediaQuery = _findRootMediaQuery()!;

    // height of keyboard
    double keyboardHeight = rootMediaQuery.data.viewInsets.bottom;

    double maxHDesired = _calculateMaxHeight(
        desiredDirection, box, widget, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);

    // if there's enough room in the desired direction, update the direction and the max height
    if (maxHDesired >= minOverlaySpace || !autoFlipDirection) {
      direction = desiredDirection;
      maxHeight = maxHDesired;
    } else {
      // There's not enough room in the desired direction so see how much room is in the opposite direction
      AxisDirection flipped = flipAxisDirection(desiredDirection);
      double maxHFlipped = _calculateMaxHeight(
          flipped, box, widget, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);

      // if there's more room in this opposite direction, update the direction and maxHeight
      if (maxHFlipped > maxHDesired) {
        direction = flipped;
        maxHeight = maxHFlipped;
      }
    }

    if (maxHeight < 0) maxHeight = 0;
  }

  double _calculateMaxHeight(AxisDirection direction, RenderBox box, TypeAheadGroupField widget,
      double windowHeight, MediaQuery rootMediaQuery, double keyboardHeight, double textBoxAbsY) {
    return direction == AxisDirection.down
        ? _calculateMaxHeightDown(box, widget, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY)
        : _calculateMaxHeightUp(box, widget, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);
  }

  double _calculateMaxHeightDown(RenderBox box, TypeAheadGroupField widget, double windowHeight,
      MediaQuery rootMediaQuery, double keyboardHeight, double textBoxAbsY) {
    // unsafe area, ie: iPhone X 'home button'
    // keyboardHeight includes unsafeAreaHeight, if keyboard is showing, set to 0
    double unsafeAreaHeight = keyboardHeight == 0 ? rootMediaQuery.data.padding.bottom : 0;

    return windowHeight -
        keyboardHeight -
        unsafeAreaHeight -
        textBoxHeight -
        textBoxAbsY -
        2 * widget.suggestionsGroupBoxVerticalOffset;
  }

  double _calculateMaxHeightUp(RenderBox box, TypeAheadGroupField widget, double windowHeight,
      MediaQuery rootMediaQuery, double keyboardHeight, double textBoxAbsY) {
    // recalculate keyboard absolute y value
    double keyboardAbsY = windowHeight - keyboardHeight;

    directionUpOffset = textBoxAbsY > keyboardAbsY
        ? keyboardAbsY - textBoxAbsY - widget.suggestionsGroupBoxVerticalOffset
        : -widget.suggestionsGroupBoxVerticalOffset;

    // unsafe area, ie: iPhone X notch
    double unsafeAreaHeight = rootMediaQuery.data.padding.top;

    return textBoxAbsY > keyboardAbsY
        ? keyboardAbsY - unsafeAreaHeight - 2 * widget.suggestionsGroupBoxVerticalOffset
        : textBoxAbsY - unsafeAreaHeight - 2 * widget.suggestionsGroupBoxVerticalOffset;
  }

  Future<void> onChangeMetrics() async {
    if (await _waitChangeMetrics()) {
      resize();
    }
  }
}

/// Supply an instance of this class to the [TypeAheadGroup.suggestionsGroupBoxController]
/// property to manually control the suggestionsGroup box
class SuggestionsGroupBoxController {
  _SuggestionsGroupBox? _suggestionsGroupBox;
  FocusNode? _effectiveFocusNode;

  /// Opens the suggestionsGroup box
  void open() {
    _effectiveFocusNode?.requestFocus();
  }

  bool isOpened() {
    return _suggestionsGroupBox?.isOpened ?? false;
  }

  /// Closes the suggestionsGroup box
  void close() {
    _effectiveFocusNode?.unfocus();
  }

  /// Opens the suggestionsGroup box if closed and vice-versa
  void toggle() {
    if (_suggestionsGroupBox?.isOpened ?? false) {
      close();
    } else {
      open();
    }
  }

  /// Recalculates the height of the suggestionsGroup box
  void resize() {
    _suggestionsGroupBox!.resize();
  }
}

@visibleForTesting
class TestKeysGroup {
  TestKeysGroup._();

  static const textFieldKey = ValueKey("text-field-group");

  static ValueKey<String> getSuggestionKey(int index) => ValueKey<String>("suggestion-$index");
}
