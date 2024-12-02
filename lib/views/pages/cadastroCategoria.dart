import 'package:flutter/material.dart';
import 'package:my_app/models/categoria.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para interagir com o Firebase
import 'package:my_app/widgets/drawer_menu.dart'; // Importando o DrawerMenu
import 'package:my_app/views/pages/cadastroReceitas.dart'; // Importando a tela CadastroReceitas
import 'package:firebase_auth/firebase_auth.dart'; // Importando o FirebaseAuth

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  // Função para adicionar a categoria no Firebase
  Future<void> addCategoryToFirebase(BuildContext context) async {
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
        await categoryCollection.add({
          'name': category.name,
          'monthlyLimits': category.monthlyLimits.map((limit) => {
            'month': limit.month,
            'year': limit.year,
            'limit': limit.limit,
          }).toList(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria criada com sucesso!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CadastroReceitas()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar categoria.')),
        );
      }
    }
  }

  // Função para buscar as categorias no Firebase
  Future<List<Category>> getCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final categoryCollection = FirebaseFirestore.instance
          .collection('Usuários')
          .doc(user.uid)
          .collection('Categoria');
      final snapshot = await categoryCollection.get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Category(
          name: data['name'],
          monthlyLimits: (data['monthlyLimits'] as List)
              .map((item) => MonthlyLimit(
                    month: item['month'],
                    year: item['year'],
                    limit: item['limit'],
                  ))
              .toList(),
        );
      }).toList();
    }
    return [];
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
      drawer: DrawerMenu(),
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
                  addCategoryToFirebase(context);
                },
                child: const Text('Salvar'),
              ),
              const SizedBox(height: 20),
              // Título para a lista de categorias
              const Text(
                'Suas categorias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Category>>(
                future: getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhuma categoria criada.');
                  }

                  final categories = snapshot.data!;

                  return Expanded(
                    child: ListView(
                      children: categories.map((category) {
                        return ExpansionTile(
                          title: Text(category.name),
                          children: category.monthlyLimits.map((limit) {
                            return ListTile(
                              title: Text(
                                  'Mês: ${limit.month}, Ano: ${limit.year}, Limite: R\$ ${limit.limit}'),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
