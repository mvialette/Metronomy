import 'package:metronomy/screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        //MaterialPageRoute(builder: (context) => LoaderScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: [
      Image.asset('assets/images/intro_2.JPG', fit: BoxFit.cover),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset('assets/images/metronomy_icon_yellow.png',
            width: 100.0, height: 100.0),
        const SizedBox(height: 10.0),
        Text('metronomy',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ))
      ]),
      Positioned(
        bottom: 20.0,
        left: 0,
        right: 0,
        child: Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary))),
      )
    ]));
  }
}
