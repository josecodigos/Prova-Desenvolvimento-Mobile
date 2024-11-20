import 'dart:io';
import 'package:app_despesas/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'receita_provider.dart';
import 'despesas_provider.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    databaseFactory = databaseFactoryFfi;
  }

runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DespesasProvider()),
        ChangeNotifierProvider(create: (_) => ReceitasProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda de Despesas',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: textColor),
        ),
      ),
      home: MainScreen(),
    );
  }
}
