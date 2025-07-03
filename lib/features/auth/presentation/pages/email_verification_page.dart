import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:story_lab/core/themes/app_colors.dart';
import 'package:story_lab/core/widgets/custom_elevated_button.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  static Route route({required String email}) {
    return MaterialPageRoute(
      builder: (_) => EmailVerificationPage(email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
              onPressed: () {
                // TODO: Dispatch Bloc event to check email verification status
                // context.read<AuthBloc>().add(CheckEmailVerificationStatus());
              },
              label: "Yes, I verified",
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // TODO: Dispatch Bloc event to resend email
                // context.read<AuthBloc>().add(ResendEmailVerificationRequested());
              },
              child: const Text("Resend verification email"),
            ),
          ],
        ),
      ),
    );
  }
}
