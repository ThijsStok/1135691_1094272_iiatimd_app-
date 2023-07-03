import 'package:flutter/material.dart';
import 'ProfileModal.dart';

class EditProfileDialog extends StatefulWidget {
  final Profile profile;

  EditProfileDialog({required this.profile});

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.profile.firstName);
    _lastNameController = TextEditingController(text: widget.profile.lastName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            print('Profile UID Edit dialog: ${widget.profile.uid}');
            final updatedProfile = Profile(
              uid: widget.profile.uid,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: widget.profile.email,
            );
            Navigator.pop(context, updatedProfile);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
