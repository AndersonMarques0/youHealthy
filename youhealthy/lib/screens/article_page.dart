import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youhealthy/models/artigo.dart';
import 'package:youhealthy/services/auth_service.dart';
import 'package:youhealthy/services/firestore_service.dart';
import './add_article_page.dart';

class ArticlePage extends StatefulWidget {
  final Article article;

  const ArticlePage({
    super.key,
    required this.article,
  });

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  bool isAdmin = false;
  late final String uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final admin = await AuthService().isAdmin();
    setState(() => isAdmin = admin);
  }

  Future<void> _deleteArticle() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir artigo"),
        content: const Text("Tem certeza que deseja excluir este artigo?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirestoreService().deleteArticle(widget.article.id);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Artigo excluído.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isAdmin
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "editBtn",
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddArticlePage(
                          articleToEdit: widget.article,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: "deleteBtn",
                  backgroundColor: Colors.red,
                  onPressed: _deleteArticle,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: StreamBuilder<List<String>>(
          stream: FirestoreService().streamFavoriteIds(uid),
          builder: (context, snapshot) {
            final favIds = snapshot.data ?? [];
            final isFav = favIds.contains(widget.article.id);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black54),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                        onPressed: () {
                          FirestoreService().toggleFavorite(uid, widget.article.id);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    widget.article.tag.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "por ${widget.article.author} • ${widget.article.time}",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.article.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    widget.article.description,
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
