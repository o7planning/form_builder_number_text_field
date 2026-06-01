
# Examples

Here are comprehensive, production-grade implementation examples demonstrating how to properly leverage this package within the `flutter_form_builder` architecture.

---

## Example 1: Basic Integration Inside a Stateful Form

This example demonstrates how to set up the field within a standard `FormBuilder` hierarchy, enforcing basic validation guardrails and handling value changes.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_number_text_field/form_builder_number_text_field.dart';

class FinancialEntryForm extends StatefulWidget {
  const FinancialEntryForm({super.key});

  @override
  State<FinancialEntryForm> createState() => _FinancialEntryFormState();
}

class _FinancialEntryFormState extends State<FinancialEntryForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Ledger Input')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderNumberTextField(
                name: 'retail_price',
                initialValue: 1500000, // Formats dynamically to 1,500,000
                integerDigits: 9,
                decimalDigits: 0, // Restricts input strictly to integer values
                allowNegative: false, // Disallows negative values
                decoration: const InputDecoration(
                  labelText: 'Product Retail Price',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                onChanged: (num? val) {
                  print('Reactive numerical value: $val'); // Returns a true Dart num, not a String!
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final Map<String, dynamic> formData = _formKey.currentState!.value;
                    print('Validated Form Payload: $formData');
                  }
                },
                child: const Text('Submit Ledger'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

---

## Example 2: Advanced Precision Mapping (Signed Float & Ceiling Constraints)

This example showcases how to utilize the field for scientific metrics, handling signed fractional numbers, custom alignment, and rigid upper-bound ceiling boundaries (`maxValue`).

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_number_text_field/form_builder_number_text_field.dart';

Widget buildScientificWeightInput(BuildContext context, GlobalKey<FormBuilderState> formKey) {
  return FormBuilderNumberTextField(
    name: 'chemical_net_weight',
    initialValue: -42.1250, // Formats cleanly maintaining signed structures
    integerDigits: 4,
    decimalDigits: 4, // Higher floating-point fractional precision
    allowNegative: true, // Enables signed input triggers
    maxValue: 250.0000,  // Enforces strict maximum limitation constraint
    textAlign: TextAlign.end, // Custom horizontal viewport alignment
    decoration: const InputDecoration(
      labelText: 'Compound Measurement Net Weight (Max: 250.0000)',
      hintText: '0.0000',
      suffixText: ' mg',
      border: OutlineInputBorder(),
    ),
  );
}

```
 