import 'package:flutter/material.dart';
import 'package:thuctap/features/profile/desktop/profile_edit_desktop.dart';
import '../../../../core/constants/app_colors.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(child: const ProfileEditDesktop()),
    );
  }
}

