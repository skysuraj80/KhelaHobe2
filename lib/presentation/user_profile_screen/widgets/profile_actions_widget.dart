import 'package:flutter/material.dart';

class ProfileActionsWidget extends StatelessWidget {
  final VoidCallback onDeleteAccount;

  const ProfileActionsWidget({super.key, required this.onDeleteAccount});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onDeleteAccount,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: const Text('Delete Account'),
    );
  }
}
