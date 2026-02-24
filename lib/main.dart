import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importe o provider
import 'controllers/player_controller.dart';
import 'views/dashboard_view.dart';

void main() {
  runApp(
    // O MultiProvider facilita a adição de novos Controllers no futuro
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PlayerController())],
      child: const EvolutionManApp(),
    ),
  );
}

class EvolutionManApp extends StatelessWidget {
  const EvolutionManApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evolution Man',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
      ),
      home: const DashboardView(),
    );
  }
}
