import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

const String _decimalSeparator = '.';
const String _groupSeparator = ',';

/// A specialized [FormBuilder] field for structured numeric input.
///
/// Features automatic data type casting, strict formatters, and full multi-platform compatibility.
class FormBuilderNumberTextField extends FormBuilderField<num> {
  /// The decoration to show around the text field.
  final InputDecoration decoration;

  /// The text style to use for the text being edited.
  final TextStyle? style;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Configures padding for the text field content.
  final EdgeInsets scrollPadding;

  /// Clean deselect or reset callback event.
  final VoidCallback? onReset;

  /// Maximum allowed fractional decimal digits.
  final int decimalDigits;

  /// Maximum allowed integer digits.
  final int integerDigits;

  /// Grouping of 2 or more digits with groupSeparator.
  final int? groupDigits;

  /// Whether to allow input of negative numbers.
  final bool allowNegative;

  /// Upper bound limitation ceiling constraint.
  final double maxValue;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// Callback when the user submits the field (e.g., presses the keyboard action button).
  final ValueChanged<String>? onSubmitted;

  /// Callback when editing is complete.
  final VoidCallback? onEditingComplete;

  FormBuilderNumberTextField({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.onChanged,
    super.onSaved,
    super.enabled,
    super.autovalidateMode,
    this.decoration = const InputDecoration(),
    this.style,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.onReset,
    this.groupDigits = 3,
    this.decimalDigits = 0,
    this.integerDigits = 14,
    this.allowNegative = true,
    this.maxValue = 9223372036854775807.0,
    this.readOnly = false,
    super.focusNode,
    this.onSubmitted,
    this.onEditingComplete,
  }) : super(
         builder: (FormFieldState<num?> field) {
           final state = field as _FormBuilderNumberTextFieldState;
           return TextField(
             controller: state.controller,
             focusNode: state.effectiveFocusNode,
             decoration: decoration.copyWith(errorText: field.errorText),
             style: style,
             textInputAction: textInputAction,
             textAlign: textAlign,
             scrollPadding: scrollPadding,
             enabled: state.enabled,
             readOnly: readOnly || !state.enabled,
             minLines: 1,
             maxLines: 1,
             keyboardType: TextInputType.numberWithOptions(
               decimal: decimalDigits > 0,
               signed: allowNegative,
             ),
             inputFormatters: [state.formatter],
             onChanged: (String text) {
               final numValue = _toNumber(text);
               field.didChange(numValue);
             },
             onSubmitted: onSubmitted,
             onEditingComplete: onEditingComplete,
           );
         },
       );

  @override
  FormBuilderFieldState<FormBuilderNumberTextField, num> createState() =>
      _FormBuilderNumberTextFieldState();
}

class _FormBuilderNumberTextFieldState
    extends FormBuilderFieldState<FormBuilderNumberTextField, num> {
  late final TextEditingController controller;
  late final NumberTextInputFormatter formatter;

  @override
  void initState() {
    super.initState();

    formatter = NumberTextInputFormatter(
      integerDigits: widget.integerDigits,
      decimalDigits: widget.decimalDigits,
      maxValue: widget.maxValue.toString(),
      decimalSeparator: _decimalSeparator,
      groupDigits: widget.groupDigits,
      groupSeparator: _groupSeparator,
      allowNegative: widget.allowNegative,
      overrideDecimalPoint: true,
      insertDecimalPoint: false,
      insertDecimalDigits: true,
    );

    final initialString = _toText(initialValue);
    controller = TextEditingController(text: initialString);
  }

  @override
  void didUpdateWidget(covariant FormBuilderNumberTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      final updatedText = _toText(widget.initialValue);
      if (controller.text != updatedText) {
        controller.text = updatedText;
      }
    }
  }

  @override
  void reset() {
    super.reset();
    final resetText = _toText(initialValue);
    controller.text = resetText;
    widget.onReset?.call();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// =============================================================================
// PARSING UTILITIES
// =============================================================================

num? _toNumber(String? s) {
  if (s == null || s.isEmpty) return null;

  String cleanString = s.replaceAll(_groupSeparator, '');

  if (cleanString == '-') return null;

  if (cleanString.endsWith(_decimalSeparator)) {
    cleanString = cleanString.substring(0, cleanString.length - 1);
  }

  return num.tryParse(cleanString);
}

String _toText(num? value) {
  if (value == null) return '';

  final String s = value.toString();
  if (!s.contains('.')) {
    return _toIntegerText(s);
  }

  final List<String> parts = s.split('.');
  final String intPart = _toIntegerText(parts[0]);
  return '$intPart$_decimalSeparator${parts[1]}';
}

String _toIntegerText(String s) {
  if (s.isEmpty) return s;

  final bool isNegative = s.startsWith('-');
  final String cleanDigits = isNegative ? s.substring(1) : s;

  final StringBuffer buffer = StringBuffer();
  final int len = cleanDigits.length;

  for (int i = 0; i < len; i++) {
    buffer.write(cleanDigits[i]);
    final int remaining = len - i - 1;
    if (remaining > 0 && remaining % 3 == 0) {
      buffer.write(_groupSeparator);
    }
  }

  return isNegative ? '-$buffer' : buffer.toString();
}
