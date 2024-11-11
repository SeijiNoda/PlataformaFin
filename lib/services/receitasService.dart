import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import '../models/receita.dart';
// import '../models/despesa.dart';

CollectionReference receitasCollection =
    FirebaseFirestore.instance.collection('Receitas');
CollectionReference despesasCollection =
    FirebaseFirestore.instance.collection('Despesas');

Future<List<Map<String, dynamic>>> getReceitasDespesas() async {
  List<Map<String, dynamic>> receitas = [];
  List<Map<String, dynamic>> despesas = [];

  QuerySnapshot receitasSnapshot = await receitasCollection.get();
  receitas = receitasSnapshot.docs.map((doc) {
    return {
      'id': doc.id,
      'descricao': doc['descricao'],
      'valor': doc['valor'],
      'categoria': doc['categoria'],
      'tipo': 'Receita',
    };
  }).toList();

  QuerySnapshot despesasSnapshot = await despesasCollection.get();
  despesas = despesasSnapshot.docs.map((doc) {
    return {
      'id': doc.id,
      'descricao': doc['descricao'],
      'valor': doc['valor'],
      'categoria': doc['categoria'],
      'tipo': 'Despesa',
    };
  }).toList();

  return [...receitas, ...despesas];
}

Future<List<Map<String, dynamic>>> adicionarReceitaOuDespesa(
    String descricao, double valor, String tipo, String categoria) async {
  if (tipo == 'Receita') {
    await receitasCollection.add({
      'descricao': descricao,
      'valor': valor,
      'categoria': categoria,
    });
  } else if (tipo == 'Despesa') {
    await despesasCollection.add({
      'descricao': descricao,
      'valor': valor,
      'categoria': categoria,
    });
  }

  // Return updated list
  return getReceitasDespesas();
}

Future<List<Map<String, dynamic>>> removerReceitaOuDespesa(
    String id, String tipo) async {
  if (tipo == 'Receita') {
    await receitasCollection.doc(id).delete();
  } else if (tipo == 'Despesa') {
    await despesasCollection.doc(id).delete();
  }

  // Return updated list
  return getReceitasDespesas();
}
