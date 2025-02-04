import 'package:flutter/material.dart';
import 'package:flutter_practical_12/ui/cocktail_list_screen.dart';  // Import Dio package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drinks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CocktailListScreen(),
    );
  }
}
