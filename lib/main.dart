import 'package:flutter/material.dart';
import 'package:marvel_what_if/core/config/constant/constant.dart';
import 'package:marvel_what_if/core/config/style/app_theme.dart';
import 'package:marvel_what_if/router.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: WhatIf.appName,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppTheme.theme,
        routerConfig: router,
      );
  }
}
