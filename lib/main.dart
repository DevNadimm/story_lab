import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_lab/core/secrets/app_secrets.dart';
import 'package:story_lab/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:story_lab/features/auth/data/repository/auth_repository_impl.dart';
import 'package:story_lab/features/auth/domain/usecases/check_username_available.dart';
import 'package:story_lab/features/auth/domain/usecases/user_sign_up.dart';
import 'package:story_lab/features/auth/presentation/state_management/blocs/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:story_lab/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            userSignUp: UserSignUp(
              AuthRepositoryImpl(
                AuthRemoteDatasourceImpl(supabase.client),
              ),
            ),
            checkUsernameAvailable: CheckUsernameAvailable(
              AuthRepositoryImpl(
                AuthRemoteDatasourceImpl(supabase.client),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
