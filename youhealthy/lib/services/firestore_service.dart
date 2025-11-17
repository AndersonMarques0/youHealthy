import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artigo.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Article>> streamArticles() {
    return _db.collection('articles').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Article(
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          author: data['author'] ?? '',
          time: data['time'] ?? '',
          image: data['image'] ?? '',
          tag: data['tag'] ?? '',
        );
      }).toList();
    });
  }
}
