import 'package:story_lab/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDatasource {
  Future<String> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  });

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<bool> isUsernameTaken({
    required String username,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient supabaseClient;

  AuthRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException('Login failed. Please check your credentials.');
      }

      return response.user!.id;
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<String> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final defaultUsername = email.split('@').first;

      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'fullName': fullName,
          'username': defaultUsername,
          // 'phone': '01812345678',
          // 'avatarUrl': 'https://shorturl.at/x54PH',
          // 'dateOfBirth': '2004-5-17',
          // 'interestedIn': ['Tech', 'Art'].join(','),
        },
      );

      if (response.user == null) {
        throw ServerException('Sign up failed. Please try again.');
      }

      return response.user!.id;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isUsernameTaken({required String username}) async {
    try {
      final response = await supabaseClient
          .from('usernames')
          .select('username')
          .eq('username', username)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
