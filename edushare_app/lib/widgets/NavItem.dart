import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const NavItem(
      this.icon,
      this.label,
      this.active, {
        super.key,
        required this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? Colors.green : Colors.white54,
          ),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.green : Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}