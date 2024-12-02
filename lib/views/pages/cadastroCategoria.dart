import 'package:flutter/material.dart';
import 'package:my_app/models/categoria.dart';
import 'package:my_app/widgets/drawer_menu.dart'; // Importando o DrawerMenu

class AddCategoryScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Categoria'),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
      drawer: DrawerMenu(), // Usando o DrawerMenu aqui
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome da Categoria'),
              ),
              TextField(
                controller: monthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Mês (1 a 12)'),
              ),
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Ano'),
              ),
              TextField(
                controller: limitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Limite de Gasto'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final category = Category(name: nameController.text, monthlyLimits: [
                    MonthlyLimit(
                      month: int.parse(monthController.text),
                      year: int.parse(yearController.text),
                      limit: double.tryParse(limitController.text) ?? 0.0,
                    )
                  ]);
                  print('Categoria salva: ${category.name}');
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
