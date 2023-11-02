import "package:flutter/material.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: Center(
          child: Container(
            child: Image.asset('assets/logo/logoMF-user.png'),
          ),
        ),
      ),
    );
  }
}
