import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/common/utils/app_validator.dart';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/core/extensions/snack_bar_context_extension.dart';
import 'package:food_app/core/routing/routes.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_state.dart';

/// Shown when the user opens the password-reset deep-link from their email.
/// Supabase sets an active session automatically when the link is opened,
/// so calling [updateUser] here is enough to persist the new password.
class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _obscurePassword = ValueNotifier<bool>(true);
  final _obscureConfirm = ValueNotifier<bool>(true);

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().updatePassword(newPassword: _password.text);
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    _obscurePassword.dispose();
    _obscureConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UpdatePasswordLoading) {
            context.showLoadingDialog();
          } else if (state is UpdatePasswordSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
            context.showSuccessSnackBar(state.message);
            // Go back to login and clear stack
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.login, (route) => false);
          } else if (state is UpdatePasswordFailure) {
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
                    const SizedBox(height: 40),

                    // ── Icon ─────────────────────────────────
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: AppColor.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_open_outlined,
                          color: AppColor.primary,
                          size: 38,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      AppStrings.resetPasswordTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      AppStrings.resetPasswordSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppColor.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 36),

                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // New Password
                          const Text(
                            AppStrings.labelNewPassword,
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
                              textInputAction: TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.newPassword,
                              ],
                              autocorrect: false,
                              enableSuggestions: false,
                              validator: AppValidator.password,
                              decoration: InputDecoration(
                                hintText: AppStrings.hintNewPassword,
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

                          const SizedBox(height: 18),

                          // Confirm Password
                          const Text(
                            AppStrings.labelConfirmPassword,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ValueListenableBuilder<bool>(
                            valueListenable: _obscureConfirm,
                            builder: (context, obscure, _) => TextFormField(
                              controller: _confirm,
                              obscureText: obscure,
                              textInputAction: TextInputAction.done,
                              autocorrect: false,
                              enableSuggestions: false,
                              validator: (value) =>
                                  AppValidator.confirmPassword(
                                    value,
                                    _password.text,
                                  ),
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                hintText: AppStrings.hintConfirmPassword,
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      _obscureConfirm.value = !obscure,
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

                          const SizedBox(height: 32),

                          ElevatedButton(
                            onPressed: _submit,
                            child: const Text(AppStrings.updatePassword),
                          ),
                        ],
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
