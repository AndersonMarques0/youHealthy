import 'package:flutter/material.dart';
import 'package:youhealthy/data/articles_data.dart';
import 'package:youhealthy/models/artigo.dart';
import 'article_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> availableTags = const ['Todos', 'Saúde', 'Treino', 'Esporte'];
  
  String _selectedTag = 'Todos';

  List<Article> _filteredArticles = allArticles;

  @override
  void initState() {
    super.initState();
    _filteredArticles = allArticles;
  }

  void _filterArticles(String tag) {
    setState(() {
      _selectedTag = tag;
      if (tag == 'Todos') {
        _filteredArticles = allArticles;
      } else {
        _filteredArticles = allArticles.where((article) => article.tag == tag).toList();
      }
    });
  }

  Widget _buildCategoryChip(String text) {
    final bool isSelected = text == _selectedTag;
    
    return GestureDetector(
      onTap: () => _filterArticles(text),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _navigateToArticle(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlePage(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Article? featuredArticle = _filteredArticles.isNotEmpty ? _filteredArticles.first : null;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple, // Cor para o ícone selecionado
        unselectedItemColor: Colors.grey, 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bom dia",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Segunda-feira, 25 de Janeiro de 2021",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: const [
                      Icon(Icons.wb_sunny, color: Colors.orange),
                      Text("28°C"),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: availableTags.length,
                itemBuilder: (context, index) {
                  return _buildCategoryChip(availableTags[index]);
                },
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: _filteredArticles.isEmpty
                  ? const Center(child: Text("Nenhum artigo encontrado nesta categoria."))
                  : ListView.builder(
                      itemCount: _filteredArticles.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final article = _filteredArticles[index];
                        
                        if (index == 0 && featuredArticle != null && _selectedTag != 'Todos') {
                          return GestureDetector(
                            onTap: () => _navigateToArticle(article),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    article.image,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${article.time} • by ${article.author}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        } else if (index == 0 && _selectedTag == 'Todos' && featuredArticle != null) {
                          return GestureDetector(
                            onTap: () => _navigateToArticle(article),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    article.image,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${article.time} • by ${article.author}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            onTap: () => _navigateToArticle(article),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  article.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                article.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Text(
                                "${article.time} • by ${article.author}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
