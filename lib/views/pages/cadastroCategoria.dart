import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/categoria.dart';

class AddCategoryScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Categoria')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome da Categoria'),
            ),
            TextField(
              controller: monthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Mês (1 a 12)'),
            ),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ano'),
            ),
            TextField(
              controller: limitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Limite de Gasto'),
            ),
            SizedBox(height: 20),
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
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
