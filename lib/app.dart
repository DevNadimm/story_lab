import 'package:flutter/material.dart';
import 'package:story_lab/core/themes/app_theme.dart';
import 'package:story_lab/features/auth/presentation/pages/sign_in_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story Lab',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SignInPage(),
    );
  }
}
