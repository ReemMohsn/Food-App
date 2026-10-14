import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/common/utils/app_validator.dart';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/core/extensions/snack_bar_context_extension.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_state.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().resetPassword(email: _email.text);
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordLoading) {
            context.showLoadingDialog();
          } else if (state is ForgotPasswordSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
            _showSuccessSheet(context);
          } else if (state is ForgotPasswordFailure) {
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
                    const SizedBox(height: 16),

                    // ── Back Button ──────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        style: IconButton.styleFrom(
                          foregroundColor: AppColor.textPrimary,
                          backgroundColor: AppColor.inputField,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

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
                          Icons.lock_reset_outlined,
                          color: AppColor.primary,
                          size: 38,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      AppStrings.forgotPasswordTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      AppStrings.forgotPasswordSubtitle,
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
                          const Text(
                            AppStrings.labelEmailAddress,
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
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.email],
                            validator: AppValidator.email,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: const InputDecoration(
                              hintText: AppStrings.hintEmail,
                              prefixIcon: Icon(Icons.mail_outline, size: 20),
                            ),
                          ),

                          const SizedBox(height: 32),

                          ElevatedButton(
                            onPressed: _submit,
                            child: const Text(AppStrings.sendResetLink),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                size: 16,
                                color: AppColor.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColor.primary,
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(AppStrings.backToSignIn),
                              ),
                            ],
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

  void _showSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                color: AppColor.success,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              AppStrings.checkYourEmail,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              AppStrings.passwordResetEmailSent,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColor.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            // Instruction
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColor.primary, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Click the link in the email to set your new password.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.primary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close sheet
                  Navigator.of(context).pop(); // back to login
                },
                child: const Text(AppStrings.backToSignIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
