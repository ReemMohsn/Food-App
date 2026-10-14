import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/core/extensions/snack_bar_context_extension.dart';
import 'package:food_app/core/routing/routes.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_state.dart';

class AuthSocialOptions extends StatelessWidget {
  const AuthSocialOptions({super.key, this.isSignUp = false});

  final bool isSignUp;

  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is GoogleSignInLoading) {
            context.showLoadingDialog();
          } else if (state is GoogleSignInSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.home, (route) => false);
          } else if (state is GoogleSignInFailure) {
            Navigator.of(context, rootNavigator: true).pop();
            context.showErrorSnackBar(state.errorMessage);
          }
        },
        child: Column(
          children: [
            // ── Divider ────────────────────────────────────────
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    isSignUp
                        ? AppStrings.orSignUpWith
                        : AppStrings.orContinueWith,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),

            // ── Social Buttons ─────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    label: AppStrings.google,
                    icon: CustomPaint(
                      size: const Size.square(22),
                      painter: const _GoogleLogo(),
                    ),
                    onTap: () =>
                        context.read<AuthCubit>().signInWithGoogle(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SocialButton(
                    label: AppStrings.apple,
                    icon: const Icon(
                      Icons.apple,
                      size: 22,
                      color: Colors.black,
                    ),
                    onTap: null, // Apple Sign-In — coming soon
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.textPrimary,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColor.inputBorder),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledForegroundColor:
              AppColor.textPrimary.withValues(alpha: 0.87),
          disabledBackgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
          ],
        ),
      );
}

class _GoogleLogo extends CustomPainter {
  const _GoogleLogo();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    const bounds = Rect.fromLTWH(3, 3, 18, 18);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawArc(
        bounds, 0, math.pi * 0.25, false, paint..color = const Color(0xFF4285F4));
    canvas.drawArc(
        bounds, math.pi * 0.25, math.pi * 0.55, false, paint..color = const Color(0xFF34A853));
    canvas.drawArc(
        bounds, math.pi * 0.8, math.pi * 0.4, false, paint..color = const Color(0xFFFBBC05));
    canvas.drawArc(
        bounds, math.pi * 1.2, math.pi * 0.55, false, paint..color = const Color(0xFFEA4335));
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4285F4);
    canvas.drawRect(const Rect.fromLTWH(12, 10, 11.5, 4.5), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GoogleLogo oldDelegate) => false;
}
