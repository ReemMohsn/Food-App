import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/common/utils/app_validator.dart';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/core/extensions/snack_bar_context_extension.dart';
import 'package:food_app/core/routing/routes.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_state.dart';
import 'package:food_app/features/auth/presentation/views/widgets/auth_social_options.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _obscurePassword = ValueNotifier<bool>(true);

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().signUp(
          fullName: _name.text,
          email: _email.text,
          password: _password.text,
        );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignUpLoading) {
            context.showLoadingDialog();
          } else if (state is SignUpSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
            context.showSuccessSnackBar(state.message);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.login, (route) => false);
          } else if (state is SignUpFailure) {
            Navigator.of(context, rootNavigator: true).pop();
            context.showErrorSnackBar(state.errorMessage);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 36),

                    // ── Logo ─────────────────────────────────
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: AppColor.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          color: AppColor.primary,
                          size: 34,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      AppStrings.createAccount,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      AppStrings.createAccountSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    AutofillGroup(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Full Name
                            const Text(
                              AppStrings.labelFullName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _name,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              autofillHints: const [AutofillHints.name],
                              validator: AppValidator.fullName,
                              decoration: const InputDecoration(
                                hintText: AppStrings.hintFullName,
                                prefixIcon:
                                    Icon(Icons.person_outline, size: 20),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Email
                            const Text(
                              AppStrings.labelEmail,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              validator: AppValidator.email,
                              decoration: const InputDecoration(
                                hintText: AppStrings.hintEmailSignUp,
                                prefixIcon:
                                    Icon(Icons.mail_outline, size: 20),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Password
                            const Text(
                              AppStrings.labelPassword,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<bool>(
                              valueListenable: _obscurePassword,
                              builder: (context, obscure, _) => TextFormField(
                                controller: _password,
                                obscureText: obscure,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [
                                  AutofillHints.newPassword,
                                ],
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: AppValidator.password,
                                onFieldSubmitted: (_) => _submit(),
                                decoration: InputDecoration(
                                  hintText: AppStrings.hintPasswordSignUp,
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    size: 20,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        _obscurePassword.value = !obscure,
                                    icon: Icon(
                                      obscure
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 20,
                                      color: AppColor.hint,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            ElevatedButton(
                              onPressed: _submit,
                              child: const Text(AppStrings.signUp),
                            ),

                            const SizedBox(height: 24),

                            const AuthSocialOptions(isSignUp: true),

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  AppStrings.alreadyHaveAccount,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushReplacementNamed(Routes.login),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColor.primary,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    padding:
                                        const EdgeInsets.only(left: 4),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(AppStrings.signIn),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
