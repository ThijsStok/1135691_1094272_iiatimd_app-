import 'package:flutter/material.dart';
import 'EditDialog.dart';
import 'ProfileModal.dart';
import './ProfileReposetory.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileRepository _profileRepository = ProfileRepository();
  late Profile _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      _profile = await _profileRepository.getProfile();
      print("USER UID FROM LOAD PROFILE: ${_profile.uid}");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Profile page   $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Profile', style: TextStyle(fontSize: 50)),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'First Name: ${_profile.firstName}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Last Name: ${_profile.lastName}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Email: ${_profile.email}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _editProfile(context);
                  },
                  child: const Text(
                    'Edit Profile',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    final result = await showDialog<Profile>(
      context: context,
      builder: (context) {
        return EditProfileDialog(profile: _profile);
      },
    );

    if (result != null) {
      setState(() {
        _profile = result;
      });
      await _profileRepository.updateProfile(result);
    }
  }
}