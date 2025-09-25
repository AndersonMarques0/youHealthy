import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> articles = const [
    {
      'title': 'Alimentação saudável',
      'description': 'Descubra como montar pratos balanceados para o dia a dia.'
    },
    {
      'title': 'Treino para iniciantes',
      'description': 'Um guia básico para começar na musculação com segurança.'
    },
    {
      'title': 'Importância do sono',
      'description': 'Entenda como o descanso influencia seus resultados.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('youHealthy - Artigos')),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(article['title']!),
              subtitle: Text(article['description']!),
            ),
          );
        },
      ),
    );
  }
}