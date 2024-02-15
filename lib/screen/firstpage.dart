import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/user.dart';
import 'login.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              foregroundImage:
              NetworkImage(UserController.user?.photoURL ?? ''),
            ),
            Text(UserController.user?.displayName ?? ''),
            ElevatedButton(
                onPressed: () async {
                  await UserController.signOut();
                  if (mounted) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
                  }
                },
                child: const Text("Logout"))
          ],
        ),
      ),
    );
  }
}