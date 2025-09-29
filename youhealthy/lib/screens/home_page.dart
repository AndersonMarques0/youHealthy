// home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _filterArticles(String tag) {
    setState(() {
      _selectedTag = tag;
      if (tag == 'Todos') {
        _filteredArticles = allArticles;
      } else {
        _filteredArticles =
            allArticles.where((article) => article.tag == tag).toList();
      }
    });
  }

  void _navigateToArticle(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlePage(article: article),
      ),
    );
  }

  Widget _buildCategoryChip(String text) {
    final bool isSelected = text == _selectedTag;
    final chipTheme = Theme.of(context).chipTheme;

    return GestureDetector(
      onTap: () => _filterArticles(text),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipTheme.selectedColor : chipTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: isSelected ? chipTheme.secondaryLabelStyle : chipTheme.labelStyle,
        ),
      ),
    );
  }

  Widget _buildFeaturedArticleCard(Article article) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => _navigateToArticle(article),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              article.image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            article.title,
            style: textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${article.time} • by ${article.author}",
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildListTileArticle(Article article) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => _navigateToArticle(article),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            article.image,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          article.title,
          style: textTheme.titleSmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${article.time} • por ${article.author}",
          style: textTheme.labelSmall,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    const double landscapeBreakpoint = 600.0;
    final bool isNarrowView = screenWidth < landscapeBreakpoint;
    final double titleFontSize = isNarrowView ? 24 : 28;
    final double subtitleFontSize = isNarrowView ? 14 : 16;
    final bool showBottomNav = isNarrowView;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      bottomNavigationBar: showBottomNav
          ? BottomNavigationBar(
              currentIndex: 0,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
              ],
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bom dia",
                          style: textTheme.headlineSmall?.copyWith(
                            fontSize: titleFontSize,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Segunda-feira, 25 de Janeiro de 2021",
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: subtitleFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(Icons.wb_sunny,
                          color: Colors.orange, size: titleFontSize),
                      Text(
                        "28°C",
                        style: textTheme.bodyMedium
                            ?.copyWith(fontSize: subtitleFontSize),
                      ),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double availableWidth = constraints.maxWidth;

                  if (_filteredArticles.isEmpty) {
                    return const Center(
                        child:
                            Text("Nenhum artigo encontrado nesta categoria."));
                  }

                  if (availableWidth >= landscapeBreakpoint) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _filteredArticles.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        mainAxisExtent: 250,
                      ),
                      itemBuilder: (context, index) {
                        final article = _filteredArticles[index];
                        return _buildFeaturedArticleCard(article);
                      },
                    );
                  }

                  return ListView.builder(
                    itemCount: _filteredArticles.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final article = _filteredArticles[index];

                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildFeaturedArticleCard(article),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildListTileArticle(article),
                      );
                    },
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