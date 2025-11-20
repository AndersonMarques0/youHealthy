import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artigo.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<Article>> streamArticles() {
    return _db
        .collection('articles')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Article.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addArticle(Article article) async {
    await _db.collection('articles').add({
      'title': article.title,
      'description': article.description,
      'author': article.author,
      'time': article.time,
      'image': article.image,
      'tag': article.tag,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateArticle(String id, Article updated) async {
    await _db.collection('articles').doc(id).update({
      'title': updated.title,
      'description': updated.description,
      'author': updated.author,
      'time': updated.time,
      'image': updated.image,
      'tag': updated.tag,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteArticle(String id) async {
    await _db.collection('articles').doc(id).delete();
  }

  Stream<List<Category>> streamCategories() {
    return _db.collection('categories').orderBy('name').snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => Category.fromMap(doc.id, doc.data()))
            .toList();
      },
    );
  }

  Future<DocumentReference> addCategory(String name) async {
    return _db.collection('categories').add({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateCategory(String id, String name) async {
    await _db.collection('categories').doc(id).update({
      'name': name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCategory(String id) async {
    await _db.collection('categories').doc(id).delete();
  }

  Stream<List<String>> streamFavoriteIds(String uid) {
    return _db
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toList());
  }

  Future<void> toggleFavorite(String uid, String articleId) async {
    final ref = _db
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(articleId);

    final doc = await ref.get();

    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set({"createdAt": FieldValue.serverTimestamp()});
    }
  }

  Future<bool> isFavorite(String uid, String articleId) async {
    final doc = await _db
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(articleId)
        .get();

    return doc.exists;
  }

  Stream<List<Article>> streamFavoriteArticles(String uid) {
    return streamFavoriteIds(uid).asyncMap((ids) async {
      if (ids.isEmpty) return [];

      final snap = await _db
          .collection("articles")
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      return snap.docs
          .map((doc) => Article.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}

class Category {
  final String id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  factory Category.fromMap(String id, Map<String, dynamic> map) {
    return Category(
      id: id,
      name: map['name'] ?? '',
    );
  }
}