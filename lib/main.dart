import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/adapters/local_storage_adapter.dart';
import 'data/models/stocks_model.dart';
import 'presentation/dashboard.dart';


final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CompanyAdapter());
    await     Hive.openBox<Company>('companyBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Brains',
      scaffoldMessengerKey: snackbarKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashBoard(),
    );
  }
}
