import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';
import 'providers/grocery_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroceryProvider(),
      child: MaterialApp(
        title: 'GrocerGo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: AppColors.black,
            secondary: AppColors.gray50,
            background: AppColors.white,
          ),
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
