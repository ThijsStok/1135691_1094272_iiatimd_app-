import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> storeUserData(String uid, String email) async {
  final userRef = _firestore.collection('users').doc(uid);
  await userRef.set({
    'email': email,
    // Additional user data can be added here
  });
}

// Usage example
void onLoginSuccess(UserCredential userCredential) async {
  final User? userInfo = userCredential.user;
  if (userInfo != null) {
    await storeUserData(userInfo.uid, userInfo.email);
    // Proceed with app navigation or other actions
  }
}
