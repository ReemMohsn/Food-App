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

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _obscurePassword = ValueNotifier<bool>(true);

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().signIn(
          email: _email.text,
          password: _password.text,
        );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            context.showLoadingDialog();
          } else if (state is LoginSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
            context.showSuccessSnackBar(state.message);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.home, (route) => false);
          } else if (state is LoginFailure) {
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
                    const SizedBox(height: 24),

                    // ── Top Bar ──────────────────────────────
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColor.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            color: AppColor.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          AppStrings.appName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Hero Image ───────────────────────────
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          height: 200,
                          color: AppColor.inputField,
                          child: const Icon(
                            Icons.restaurant,
                            size: 60,
                            color: AppColor.hint,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Title ────────────────────────────────
                    const Text(
                      AppStrings.loginTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      AppStrings.loginSubtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Form ─────────────────────────────────
                    AutofillGroup(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
                                hintText: AppStrings.hintEmail,
                              ),
                            ),

                            const SizedBox(height: 18),

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
                                autofillHints: const [AutofillHints.password],
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: AppValidator.requiredField,
                                onFieldSubmitted: (_) => _submit(),
                                decoration: InputDecoration(
                                  hintText: AppStrings.hintPassword,
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

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(Routes.forgotPassword),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColor.primary,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child:
                                    const Text(AppStrings.forgotPassword),
                              ),
                            ),

                            const SizedBox(height: 8),

                            ElevatedButton(
                              onPressed: _submit,
                              child: const Text(AppStrings.signIn),
                            ),

                            const SizedBox(height: 24),

                            const AuthSocialOptions(isSignUp: false),

                            const SizedBox(height: 28),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  AppStrings.dontHaveAccount,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushReplacementNamed(Routes.signUp),
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
                                  child: const Text(AppStrings.signUp),
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
