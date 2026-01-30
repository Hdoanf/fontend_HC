import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _CircleIconButton(
          icon: FontAwesomeIcons.google,
          color: Colors.white,
          iconColor: Colors.black,
        ),
        SizedBox(width: 16),
        _CircleIconButton(
          icon: FontAwesomeIcons.facebookF,
          color: Color(0xFF1877F2),
          iconColor: Colors.white,
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(child: FaIcon(icon, size: 20, color: iconColor)),
      ),
    );
  }
}
