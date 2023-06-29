import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ProfileModal.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Profile> getProfile() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(user.uid).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> profileData =
          documentSnapshot.data() as Map<String, dynamic>;
      profileData['uid'] = user.uid;

      return Profile.fromMap(profileData);
    } else {
      // Create a new profile document for the user
      Profile newProfile = Profile(
        uid: user.uid,
        firstName: '',
        lastName: '',
        email: user.email ?? '',
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(newProfile.toMap());
      return newProfile;
    }
  }

  Future<void> updateProfile(Profile profile) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(profile.uid)
        .update(profile.toMap());
  }
}
