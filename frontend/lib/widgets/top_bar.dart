import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;

  const TopBar({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'KhelMitra',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          color: Colors.white,
          onPressed: onRefresh,
        ),
      ],
      backgroundColor: Colors.green, // You can replace with your brand color
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
