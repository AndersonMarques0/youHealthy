import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youhealthy/services/firestore_service.dart';
import 'package:youhealthy/models/artigo.dart';
import 'article_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<List<Article>>(
      stream: FirestoreService().streamFavoriteArticles(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final articles = snapshot.data!;

        if (articles.isEmpty) {
          return const Center(
            child: Text(
              "Nenhum artigo favoritado ainda.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (_, i) {
            final a = articles[i];

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(a.image, width: 60, fit: BoxFit.cover),
              ),
              title: Text(a.title),
              subtitle: Text(a.author),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArticlePage(article: a),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
