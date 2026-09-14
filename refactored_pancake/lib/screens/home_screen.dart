import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Welcome to M3'),
          FilledButton(onPressed: () {}, child: Text("Hello")),
        ],
      ),
    );
  }
}
