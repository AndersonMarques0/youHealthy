import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../models/artigo.dart';
import './article_page.dart';
import './add_article_page.dart';
import './favorites_page.dart';
import './notifications_page.dart';
import './settings_page.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;

  const HomePage({super.key, this.isAdmin = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<String> categories = [
    "Todos",
    "Saúde",
    "Treino",
    "Esporte",
  ];

  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  // Saudação dinâmica
  String _greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Bom dia';
    if (hour >= 12 && hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  // Data formatada PT-BR
  String _formattedDatePtBr() {
    try {
      final df = DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR');
      final formatted = df.format(DateTime.now());
      return formatted[0].toUpperCase() + formatted.substring(1);
    } catch (_) {
      final now = DateTime.now();
      return '${now.day}/${now.month}/${now.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      const FavoritesPage(),
      const NotificationsPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritos"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notificações"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Configurações"),
        ],
      ),
      floatingActionButton: widget.isAdmin && _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddArticlePage(),
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget _buildHomeContent() {
    final today = _formattedDatePtBr();
    final greeting = _greetingMessage();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      today,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Icon(Icons.wb_sunny, color: Colors.orange, size: 28),
                    Text("28°C"),
                  ],
                )
              ],
            ),
          ),

          // Categorias
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final selected = selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategoryIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? Colors.deepPurple : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Lista de artigos
          Expanded(
            child: StreamBuilder<List<Article>>(
              stream: FirestoreService().streamArticles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erro ao carregar: ${snapshot.error}"));
                }

                List<Article> articles = snapshot.data ?? [];

                // Filtragem
                final selectedCategory = categories[selectedCategoryIndex];

                if (selectedCategory != "Todos") {
                  articles = articles.where((a) => a.tag == selectedCategory).toList();
                }

                if (articles.isEmpty) {
                  return const Center(child: Text("Nenhum artigo encontrado."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticlePage(article: article),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                article.image,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${article.time} • por ${article.author}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
