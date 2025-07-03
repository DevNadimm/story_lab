import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:story_lab/core/themes/app_colors.dart';
import 'package:story_lab/core/utils/show_message.dart';
import 'package:story_lab/core/utils/validators.dart';
import 'package:story_lab/core/widgets/custom_elevated_button.dart';
import 'package:story_lab/core/widgets/loading_indicator.dart';
import 'package:story_lab/features/auth/presentation/state_management/blocs/auth_bloc.dart';
import 'package:story_lab/features/auth/presentation/pages/sign_in_page.dart';
import 'package:story_lab/features/auth/presentation/state_management/cubits/password_visibility_cubit.dart';
import 'package:story_lab/features/auth/presentation/widgets/auth_footer_text.dart';

class SignUpPage extends StatefulWidget {
  static route() => CupertinoPageRoute(builder: (_) => const SignUpPage());

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _globalKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _usernameController = TextEditingController();
  // String? _message;
  // IconData? _icon;
  // Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => PasswordVisibilityCubit(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthFailure) {
              MessageUtils.showToast(state.errorMessage, type: MessageType.error);
            }

            // if (state is UsernameTaken) {
            //   _message = "Username taken.";
            //   _icon = Icons.close;
            // }
            //
            // if (state is UsernameAvailable) {
            //   _message = "Username available!";
            //   _icon = Icons.check;
            // }

            if (state is AuthSuccess) {
              final email = _emailController.text.trim();
              MessageUtils.showSnackBar(context, "📬 Email sent to $email. Please verify.", type: MessageType.success);
              await Future.delayed(const Duration(seconds: 2));
              Navigator.pushReplacement(context, SignInPage.route(email: email));
            }
          },
          builder: (BuildContext context, AuthState state) {
            final isLoading = state is AuthLoading;

            return Stack(
              children: [
                _buildSignUpContent(),
                if (isLoading)
                  Container(
                    color: AppColors.black.withOpacity(0.7),
                    child: const LoadingIndicator(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSignUpContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Sign Up.",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _fullNameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: "Full Name",
                prefixIcon: Icon(HugeIcons.strokeRoundedUser03, color: AppColors.textSecondary, size: 22),
              ),
              validator: (value) => Validators.validateRequired(value, fieldName: "Full name"),
            ),
            //  const SizedBox(height: 16),
            //   TextFormField(
            //     controller: _usernameController,
            //     keyboardType: TextInputType.text,
            //     textInputAction: TextInputAction.next,
            //     decoration: const InputDecoration(
            //       hintText: "Username",
            //     ),
            //     onChanged: (value) {
            //       if (_debounce?.isActive ?? false) _debounce!.cancel();
            //
            //       _debounce = Timer(const Duration(milliseconds: 500), () {
            //         if (value.isNotEmpty) {
            //           context.read<AuthBloc>().add(CheckUsernameEvent(value));
            //         }
            //       });
            //     },
            //     validator: (value) => Validators.validateRequired(value, fieldName: "Username"),
            //   ),
            // if (_message != null)
            //     Padding(
            //       padding: const EdgeInsets.only(top: 4),
            //       child: Row(
            //         children: [
            //           Icon(_icon, size: 16, color: Colors.grey),
            //           const SizedBox(width: 4),
            //           Text(
            //             textAlign: TextAlign.start,
            //             _message!,
            //             style: const TextStyle(
            //               color: Colors.grey,
            //               fontSize: 12,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            const SizedBox(height: 16),
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
                      onPressed: () => context.read<PasswordVisibilityCubit>().toggleVisibility(),
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
              label: "Sign Up",
            ),
            const SizedBox(height: 16),
            AuthFooterText(
              leadingText: 'Already have an account? ',
              actionText: 'Sign In',
              onTap: () {
                Navigator.pushReplacement(context, SignInPage.route());
              },
            )
          ],
        ),
      ),
    );
  }

  _submitButton() {
    if (_globalKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthSignUp(fullName: _fullNameController.text.trim(), email: _emailController.text.trim(), password: _passwordController.text.trim()));
    }
  }

  @override
  void dispose() {
    //_debounce?.cancel();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    //_usernameController.dispose();
    super.dispose();
  }
}
