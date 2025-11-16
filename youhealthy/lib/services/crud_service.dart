import 'package:cloud_firestore/cloud_firestore.dart';

class CrudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createItem(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  Future<QuerySnapshot> readItems(String collection) async {
    return await _firestore.collection(collection).get();
  }

  Future<void> updateItem(String collection, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteItem(String collection, String docId) async {
    await _firestore.collection(collection).doc(docId).delete();
  }
}