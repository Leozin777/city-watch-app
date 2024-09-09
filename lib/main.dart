import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import '../pages/problems_page.dart';
import '../repositories/problems_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(
    ChangeNotifierProvider<ProblemsRepository>(
      create: (_) => ProblemsRepository(),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Problemas Locais',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: ProblemsPage(),
    );
  }
}