import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class DropdownItem {
  DropdownItem({required this.text, required this.icon});

  final IconData icon;
  final String text;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  DropdownItem? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Dropdown Demo'),
        actions: const [DropdownSimple()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomDropdownFormField(
                      onSaved: (value) => selectedValue = value,
                      validator: (DropdownItem? value) {
                        if (value == null || value.text.isEmpty) {
                          return 'Por favor selecciona un ítem';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Procesar datos del formulario
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdownFormField extends FormField<DropdownItem> {
  CustomDropdownFormField({
    Key? key,
    FormFieldSetter<DropdownItem>? onSaved,
    FormFieldValidator<DropdownItem>? validator,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: null,
          builder: (FormFieldState<DropdownItem> field) {
            List<DropdownItem> menuItems = List.generate(
              50,
              (index) => DropdownItem(
                text: 'Item ${index + 1}',
                icon: Icons.ac_unit_outlined,
              ),
            );

            return Column(
              children: [
                PopupMenuButton<DropdownItem>(
                  onSelected: field.didChange,
                  constraints: const BoxConstraints(maxHeight: 200),
                  itemBuilder: (BuildContext context) {
                    return menuItems.map((item) {
                      return PopupMenuItem<DropdownItem>(
                        value: item,
                        child: ListTile(
                          leading: Icon(item.icon),
                          title: Text(item.text),
                        ),
                      );
                    }).toList();
                  },
                  child: ListTile(
                    title: Text(field.value?.text ?? 'Select an item'),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      field.errorText ?? '',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}

class DropdownSimple extends StatelessWidget {
  const DropdownSimple({super.key});

  @override
  Widget build(BuildContext context) {
    List<DropdownItem> menuItems = List.generate(
      50,
      (index) => DropdownItem(
        text: 'Item ${index + 1}',
        icon: Icons.ac_unit_outlined,
      ),
    );

    return PopupMenuButton<DropdownItem>(
      onSelected: (DropdownItem value) {
        log(value.text);
        // Handle the selection
      },
      itemBuilder: (BuildContext context) {
        return menuItems.map((DropdownItem item) {
          return PopupMenuItem<DropdownItem>(
            value: item,
            child: Row(
              children: <Widget>[
                Icon(item.icon),
                const SizedBox(width: 8),
                Text(item.text),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
