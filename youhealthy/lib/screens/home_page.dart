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
  int selectedCategoryIndex = 0;

  final _service = FirestoreService();

  String _greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Bom dia';
    if (hour >= 12 && hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

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
                    context, MaterialPageRoute(builder: (_) => const AddArticlePage()));
              },
            )
          : null,
    );
  }

  Widget _buildHomeContent() {
    final today = _formattedDatePtBr();
    final greeting = _greetingMessage();

    return OrientationBuilder(
      builder: (context, orientation) {
        final bool isLandscape = orientation == Orientation.landscape;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(greeting, today, isLandscape),

              const SizedBox(height: 12),

              _buildCategorySelector(),

              const SizedBox(height: 12),
              Expanded(
                child: _buildArticlesResponsive(isLandscape),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String greeting, String today, bool isLandscape) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  fontSize: isLandscape ? 22 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                today,
                style: TextStyle(
                  fontSize: isLandscape ? 13 : 15,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Icon(Icons.wb_sunny, color: Colors.orange, size: 26),
              Text("28°C"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 48,
      child: StreamBuilder<List<Category>>(
        stream: _service.streamCategories(),
        builder: (context, snapshot) {
          final categories =
              <Category>[Category(id: 'all', name: 'Todos')] + (snapshot.data ?? []);

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final selected = selectedCategoryIndex == index;
              final cat = categories[index];

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
                    cat.name,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildArticlesResponsive(bool isLandscape) {
    return StreamBuilder<List<Article>>(
      stream: _service.streamArticles(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final articles = snapshot.data!;
        if (articles.isEmpty) {
          return const Center(child: Text("Nenhum artigo encontrado."));
        }

        return StreamBuilder<List<Category>>(
          stream: _service.streamCategories(),
          builder: (context, catSnap) {
            final cats =
                <Category>[Category(id: 'all', name: 'Todos')] + (catSnap.data ?? []);

            final selectedCat =
                cats.length > selectedCategoryIndex ? cats[selectedCategoryIndex] : cats.first;

            List<Article> filtered = selectedCat.id == 'all'
                ? articles
                : articles.where((a) => a.tag == selectedCat.name).toList();

            if (filtered.isEmpty) {
              return const Center(child: Text('Nenhum artigo encontrado.'));
            }

            final highlight = filtered.first;
            final rest = filtered.skip(1).toList();
            return isLandscape
                ? _buildLandscapeLayout(highlight, rest)
                : _buildPortraitLayout(highlight, rest);
          },
        );
      },
    );
  }

  Widget _buildPortraitLayout(Article highlight, List<Article> rest) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildHighlightCard(highlight, isLandscape: false),
        const SizedBox(height: 16),
        ...rest.map((a) => _buildListItem(a, isLandscape: false)),
      ],
    );
  }

  Widget _buildLandscapeLayout(Article highlight, List<Article> rest) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildHighlightCard(highlight, isLandscape: true),
          ),
        ),
        Expanded(
          flex: 5,
          child: ListView.builder(
            padding: const EdgeInsets.only(right: 16, left: 8),
            itemCount: rest.length,
            itemBuilder: (_, i) => _buildListItem(rest[i], isLandscape: true),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightCard(Article article, {required bool isLandscape}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => ArticlePage(article: article)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: isLandscape ? 16 / 6 : 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(article.image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            article.title,
            style: TextStyle(
              fontSize: isLandscape ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${article.time} • por ${article.author}',
            style: TextStyle(
              fontSize: isLandscape ? 12 : 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildListItem(Article article, {required bool isLandscape}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ArticlePage(article: article)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                article.image,
                width: isLandscape ? 110 : 100,
                height: isLandscape ? 80 : 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isLandscape ? 13 : 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${article.time} • por ${article.author}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
