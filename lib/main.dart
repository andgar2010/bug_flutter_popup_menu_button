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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    CustomDropdownFormField(
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
                      child: const Text('Enviar'),
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

class DropdownItem {
  final String text;
  final IconData icon;

  DropdownItem({required this.text, required this.icon});
}

class CustomDropdownFormField extends FormField<DropdownItem> {
  CustomDropdownFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
  }) : super(
          builder: (FormFieldState<DropdownItem> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PopupMenuButton<DropdownItem>(
                  position: PopupMenuPosition.under,
                  onSelected: (DropdownItem value) {
                    field.didChange(value);
                  },
                  itemBuilder: (BuildContext context) {
                    List<DropdownItem> menuItems = List.generate(
                      50,
                      (index) => DropdownItem(
                        text: 'Ítem ${index + 1}',
                        icon: Icons.ac_unit_outlined,
                      ),
                    );

                    return [
                      for (DropdownItem item in menuItems)
                        PopupMenuItem<DropdownItem>(
                          value: item,
                          child: Row(
                            children: [
                              Text(item.text),
                              const SizedBox(width: 8),
                              Icon(item.icon),
                            ],
                          ),
                        ),
                    ];
                  },
                  // Limitar la altura del menú desplegable
                  constraints: const BoxConstraints(maxHeight: 230),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          field.value?.text ?? 'Selecciona un ítem',
                          style: const TextStyle(color: Colors.black),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
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
