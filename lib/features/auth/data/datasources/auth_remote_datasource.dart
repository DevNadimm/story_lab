import 'package:flutter/cupertino.dart';
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

  Future<void> resendEmailVerification({
    required String email,
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
        debugPrint('[❌ ERROR] Login failed. Please check your credentials.');
        throw ServerException('Login failed. Please check your credentials.');
      }

      return response.user!.id;
    } catch (e) {
      debugPrint('[❌ ERROR] ${e.toString()}');
      throw ServerException('Unable to sign in. Please try again later.');
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
          // Optional fields can be added here
          // 'phone': '01812345678',
          // 'avatarUrl': '',
          // 'dateOfBirth': '2004-05-17',
          // 'interestedIn': ['Tech', 'Art'],
        },
      );

      if (response.user == null) {
        debugPrint('[❌ ERROR] Sign up failed. Please try again.');
        throw ServerException('Sign up failed. Please try again.');
      }

      return response.user!.id;
    } catch (e) {
      debugPrint('[❌ ERROR] ${e.toString()}');
      throw ServerException('Unable to sign up. Please try again later.');
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
      debugPrint('[❌ ERROR] ${e.toString()}');
      throw ServerException('Unable to check username availability at the moment.');
    }
  }

  @override
  Future<void> resendEmailVerification({required String email}) async {
    try {
      await supabaseClient.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } catch (e) {
      debugPrint('[❌ ERROR] ${e.toString()}');
      throw ServerException('Failed to resend email verification. Please try again.');
    }
  }
}
