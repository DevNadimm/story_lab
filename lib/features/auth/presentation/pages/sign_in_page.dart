import 'package:flutter/material.dart';
import 'package:story_lab/core/widgets/loading_indicator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingIndicator(),
    );
  }
}
