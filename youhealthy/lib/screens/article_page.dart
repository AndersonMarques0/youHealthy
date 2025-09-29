import 'package:flutter/material.dart';
import 'package:youhealthy/models/artigo.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 8),
              Text(
                article.tag.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "por ${article.author} • ${article.time}",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),

              const SizedBox(height: 16),
              Text(
                article.description,
                style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
