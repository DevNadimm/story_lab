import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:story_lab/core/themes/app_colors.dart';
import 'package:story_lab/core/utils/show_message.dart';
import 'package:story_lab/core/widgets/custom_elevated_button.dart';
import 'package:story_lab/core/widgets/loading_indicator.dart';
import 'package:story_lab/features/auth/presentation/pages/sign_in_page.dart';
import 'package:story_lab/features/auth/presentation/state_management/blocs/auth_bloc.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  static Route route({required String email}) {
    return CupertinoPageRoute(builder: (_) => EmailVerificationPage(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is EmailVerified) {
              Navigator.pushReplacement(context, SignInPage.route());
            }

            if (state is EmailNotVerified) {
              MessageUtils.showToast(
                'Your email is not verified yet. Please check your inbox.',
                type: MessageType.error,
              );
            }

            if (state is AuthFailure) {
              MessageUtils.showToast(
                state.errorMessage,
                type: MessageType.error,
              );
            }

            if (state is EmailVerificationResent) {
              MessageUtils.showToast(
                'A new verification email has been sent. Please check your inbox.',
                type: MessageType.info,
              );
            }
          },
          builder: (BuildContext context, state) {
          final isLoading = state is EmailVerificationChecking;

          return Stack(
            children: [
              _buildContent(context),
              if (isLoading)
                Container(
                  color: AppColors.black.withOpacity(0.7),
                  child: const LoadingIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/illustrations/verify_email.svg',
            height: 250,
          ),
          const SizedBox(height: 24),
          Text(
            "Verify your email address!",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            email,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: AppColors.textPrimary.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Congratulations! Your account has been created. Please verify your email to explore StoryLab — where you can create and read amazing blogs.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            onPressed: () => context.read<AuthBloc>().add(CheckEmailVerificationStatus()),
            label: "Yes, I verified",
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.read<AuthBloc>().add(ResendEmailVerificationRequested(email: email)),
            child: const Text("Resend verification email"),
          ),
        ],
      ),
    );
  }
}
