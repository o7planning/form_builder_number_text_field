
# form_builder_number_text_field

A highly optimized, type-safe numeric input extension widget for the `flutter_form_builder` ecosystem.

Unlike standard text input fields that handle numbers as raw strings, this package wraps a granular numeric parsing infrastructure. It provides structural input formatting, locale-aware separating tokens, and automatically enforces integer or decimal type casting straight into the form control state layers.

---

##  Key Functional Features

* **Atomic Data Type Casting:** Automatically filters input strings and commits true Dart `num` properties (`int` or `double`) directly into the parent `FormBuilder` state map.
* **Granular Separator Formatting:** Leverages strict text editing formatters to inject real-time thousand grouping separators (`,`) and fractional decimal points (`.`) seamlessly as the user types.
* **Comprehensive Guardrails:** Features strict numeric validation configuration tracks including integer/decimal digit length limits, negative value locks, and ceiling boundaries (`maxValue`).
* **Decoupled Configuration Platform:** Inherits standard Material `TextField` characteristics, allowing engineering teams to seamlessly pass customized `FocusNode`, `InputDecoration`, or typography `TextStyle` properties.

---

##  Installation Manifest

Add this parameter segment directly into your target project's `pubspec.yaml` dependency descriptor tracking file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_form_builder: ^latest_version
  form_builder_number_text_field: ^latest_version

```

---

## Implementational Setup Guide

The component functions as a modular element within any standard `FormBuilder` hierarchy. It requires an explicit semantic `name` token to bind its type-safe payload values.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_number_text_field/form_builder_number_text_field.dart';

Widget buildFinancialFormWorkspace(BuildContext context) {
  return FormBuilderNumberTextField(
    name: 'transaction_amount',
    initialValue: 1250500.75, // Safely parses clean numeric data
    integerDigits: 9,        // Limits integer block capacity
    decimalDigits: 2,        // Allows controlled floating point precision
    allowNegative: false,    // Disallows negative value triggers
    maxValue: 5000000.00,    // Hard ceiling constraint boundaries
    decoration: const InputDecoration(
      labelText: "Transfer Amount",
      prefixText: "\$ ",
      border: OutlineInputBorder(),
    ),
    onChanged: (num? val) {
      print("Reactive parsed type-safe number: \$val"); // Prints true num, not String!
    },
  );
}

``` 

---

### Examples

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_number_text_field/form_builder_number_text_field.dart';

void main() {
  runApp(const FaNumberTextFieldExampleApp());
}

class FaNumberTextFieldExampleApp extends StatelessWidget {
  const FaNumberTextFieldExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormBuilder Number TextField Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const FormBuilderNumberPlayground(),
    );
  }
}

class FormBuilderNumberPlayground extends StatefulWidget {
  const FormBuilderNumberPlayground({super.key});

  @override
  State<FormBuilderNumberPlayground> createState() => _FormBuilderNumberPlaygroundState();
}

class _FormBuilderNumberPlaygroundState extends State<FormBuilderNumberPlayground> {
  final _formKey = GlobalKey<FormBuilderState>();
  num? _extractedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numeric Input Form Control'),
        centerTitle: true,
        backgroundColor: Colors.indigo.withValues(alpha: 0.1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      // Example 1: Pure Integer/Currency Configuration
                      FormBuilderNumberTextField(
                        name: 'item_price',
                        initialValue: 4500000, // Formats natively to 4,500,000
                        integerDigits: 10,
                        decimalDigits: 0, // Enforces integer properties only
                        allowNegative: false, // Invalidate negative inputs
                        decoration: const InputDecoration(
                          labelText: 'Product Cost (Integer Only)',
                          hintText: 'Enter retail price...',
                          prefixText: '₫ ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Example 2: Precision Float/Decimal Metric Field
                      FormBuilderNumberTextField(
                        name: 'scientific_weight',
                        initialValue: -12.3456, // Formats cleanly with negative signs
                        integerDigits: 4,
                        decimalDigits: 4, // Higher floating accuracy
                        allowNegative: true,
                        maxValue: 100.0000,
                        textAlign: TextAlign.end, // Customized structural text alignment
                        decoration: const InputDecoration(
                          labelText: 'Laboratory Material Weight (Max: 100.0000)',
                          hintText: '0.0000',
                          suffixText: ' kg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Operational Trigger Panel
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.analytics_outlined),
                        label: const Text('Submit Form State'),
                        onPressed: () {
                          if (_formKey.currentState?.saveAndValidate() ?? false) {
                            // Extract raw map properties
                            final values = _formKey.currentState!.value;
                            setState(() {
                              // Extracted value is dynamically resolved into standard num!
                              _extractedValue = values['item_price'];
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        _formKey.currentState?.reset();
                        setState(() {
                          _extractedValue = null;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                
                if (_extractedValue != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OUTPUT RESULT FROM FORM STATE:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.green),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Value: $_extractedValue',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Runtime Data Type: ${_extractedValue.runtimeType}',
                          style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
```
 