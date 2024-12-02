import 'package:flutter/material.dart';
import 'package:my_app/models/categoria.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para interagir com o Firebase
import 'package:my_app/widgets/drawer_menu.dart'; // Importando o DrawerMenu
import 'package:my_app/views/pages/cadastroReceitas.dart'; // Importando a tela CadastroReceitas
import 'package:cloud_firestore/cloud_firestore.dart'; // Importando o Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Importando o FirebaseAuth

class AddCategoryScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  // Função para adicionar a categoria no Firebase
  Future<void> addCategoryToFirebase(BuildContext context) async {
    // Acessando o usuário atual
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      final categoryCollection = FirebaseFirestore.instance
          .collection('Usuários')
          .doc(user.uid)
          .collection('Categoria');
      
      final category = Category(
        name: nameController.text,
        monthlyLimits: [
          MonthlyLimit(
            month: int.parse(monthController.text),
            year: int.parse(yearController.text),
            limit: double.tryParse(limitController.text) ?? 0.0,
          )
        ]
      );

      try {
        // Adiciona a categoria na subcoleção
        await categoryCollection.add({
          'name': category.name,
          'monthlyLimits': category.monthlyLimits.map((limit) => {
            'month': limit.month,
            'year': limit.year,
            'limit': limit.limit,
          }).toList(),
        });

        // Exibe o snackbar de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria criada com sucesso!')),
        );

        // Redireciona para a tela CadastroReceitas
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CadastroReceitas()),
        );
      } catch (e) {
        // Exibe o erro se houver
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar categoria.')),
        );
      }
    }
  }

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
                  // Chama a função para adicionar a categoria e redirecionar
                  addCategoryToFirebase(context);
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
