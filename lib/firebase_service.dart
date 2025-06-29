import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new user
  Future<void> addUser({required String userId, required String name, String? email}) async {
    await _db.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Add card details for a user
  Future<void> addCard({required String userId, required Map<String, dynamic> cardData}) async {
    await _db.collection('users').doc(userId).collection('cards').add(cardData);
  }

  // Add an expense
  Future<void> addExpense({required Map<String, dynamic> expenseData}) async {
    await _db.collection('expenses').add(expenseData);
  }

  // Fetch all expenses from Firestore
  Future<List<Map<String, dynamic>>> getExpenses() async {
    final snapshot = await _db.collection('expenses').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
