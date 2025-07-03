import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:story_lab/core/themes/app_colors.dart';
import 'package:story_lab/core/utils/validators.dart';
import 'package:story_lab/core/widgets/custom_elevated_button.dart';
import 'package:story_lab/features/auth/presentation/pages/sign_up_page.dart';
import 'package:story_lab/features/auth/presentation/state_management/cubits/password_visibility_cubit.dart';
import 'package:story_lab/features/auth/presentation/widgets/auth_footer_text.dart';

class SignInPage extends StatefulWidget {
  final String? email;

  const SignInPage({super.key, this.email});

  static route({String? email}) {
    return CupertinoPageRoute(builder: (_) => SignInPage(email: email));
  }

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _globalKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController.text = widget.email ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordVisibilityCubit(),
      child: Scaffold(
        body: _buildSignInContent(),
      ),
    );
  }

  Widget _buildSignInContent () {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sign In.",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(HugeIcons.strokeRoundedMail01, color: AppColors.textSecondary, size: 22),
              ),
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 16),
            BlocBuilder<PasswordVisibilityCubit, bool>(
              builder: (context, isVisible) {
                return TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(HugeIcons.strokeRoundedSquareLockPassword, color: AppColors.textSecondary, size: 22,),
                    suffixIcon: IconButton(
                      onPressed: () {
                        context.read<PasswordVisibilityCubit>().toggleVisibility();
                      },
                      icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary, size: 22,),
                    ),
                  ),
                  obscureText: !isVisible,
                  obscuringCharacter: '*',
                  validator: Validators.validatePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                );
              },
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              onPressed: _submitButton,
              label: "Sign In",
            ),
            const SizedBox(height: 16),
            AuthFooterText(
              leadingText: 'Don\'t have an account? ',
              actionText: 'Sign Up',
              onTap: () {
                Navigator.pushReplacement(context, SignUpPage.route());
              },
            )
          ],
        ),
      ),
    );
  }

  _submitButton() {
    if (_globalKey.currentState?.validate() ?? false) {}
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
