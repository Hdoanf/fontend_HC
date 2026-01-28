import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_text_field.dart';

class ProfileEditDesktop extends StatelessWidget {
  const ProfileEditDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Container(
          width: 520,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(),
              const SizedBox(height: 24),
              _avatar(),
              const SizedBox(height: 24),
              _form(),
              const SizedBox(height: 32),
              _actions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: const [
        Text(
          'Profile Edit',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Icon(Icons.more_vert),
      ],
    );
  }

  Widget _avatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipOval(
          child: Image.network(
            'https://i.pravatar.cc/300?img=12',
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 96,
                height: 96,
                color: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 40),
              );
            },
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          padding: const EdgeInsets.all(6),
          child: const Icon(Icons.edit, size: 16, color: Colors.white),
        ),
      ],
    );
  }
  

  Widget _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Name', style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        AppTextField(hint: 'Linh'),

        SizedBox(height: 16),
        Text('Email', style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        AppTextField(hint: 'Linh@gmail.com'),

        SizedBox(height: 16),
        Text('Address', style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        AppTextField(hint: 'abc'),

        SizedBox(height: 16),
        Text('Home Name', style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        AppTextField(hint: 'ngoi nha hanh puc'),
      ],
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppButton(
            text: 'Save',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
