import 'package:flutter/material.dart';
import 'NavItem.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF0B0F19),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              Icons.home,
              "Home",
              currentIndex == 0,
              onTap: () => onTap(0),
            ),
            NavItem(
              Icons.folder,
              "Docs",
              currentIndex == 1,
              onTap: () => onTap(1),
            ),
            const SizedBox(width: 40),
            NavItem(
              Icons.chat_bubble_outline,
              "Chat",
              currentIndex == 2,
              onTap: () => onTap(2),
            ),
            NavItem(
              Icons.person_outline,
              "Profile",
              currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}