import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: RichText(
        text: const TextSpan(
          text: 'Pro',
          style: TextStyle(
            fontFamily: 'Poppins-Bold',
            color: Colors.black87,
            fontSize: 22,
          ),
          children: [
            TextSpan(
              text: 'Gen',
              style: TextStyle(
                color: Color(
                  0xffFA5A2A,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
