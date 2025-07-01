import 'package:flutter/material.dart';
import 'package:story_lab/core/secrets/app_secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:story_lab/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.asupabaseAnonKey,
  );
  runApp(const MyApp());
}
