import 'package:flutter/material.dart';
import 'package:thuctap/features/profile/mobile/profile_edit_mobile.dart';
import 'package:thuctap/core/utils/responsive_layout.dart';
import 'package:thuctap/features/profile/desktop/profile_edit_desktop.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: ProfileEditMobile(),
      tablet: ProfileEditDesktop(),
      web: ProfileEditDesktop(),
    );
  }
}
