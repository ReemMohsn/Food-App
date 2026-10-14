import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/routing/routes.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/main_home/presentation/view_model/main_home_cubit.dart';
import 'package:food_app/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:food_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:food_app/features/profile/presentation/views/widgets/logout_button.dart';
import 'package:food_app/features/profile/presentation/views/widgets/profile_header.dart';
import 'package:food_app/features/profile/presentation/views/widgets/profile_menu_item.dart';
import 'package:food_app/features/profile/presentation/views/widgets/profile_section_title.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    if (cubit.state is ProfileInitial) {
      cubit.getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColor.textPrimary,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.read<MainHomeCubit>().changeIndex(0);
            }
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSignOutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            );
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppColor.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          }

          if (state is ProfileFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColor.danger,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    style: const TextStyle(color: AppColor.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: cubit.getProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final user = state is ProfileSuccess ? state.user : null;
          final isDarkMode = state is ProfileSuccess ? state.isDarkMode : false;
          final isSigningOut = state is ProfileSignOutLoading;

          if (user == null) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ProfileHeader(user: user),
                ),
                const SizedBox(height: 18),

                // ── ACCOUNT SECTION ──────────────────────────────────
                const ProfileSectionTitle(title: 'ACCOUNT'),
                ProfileMenuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit Profile coming soon')),
                    );
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.forgotPassword);
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notification Settings',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification settings coming soon')),
                    );
                  },
                ),

                // ── PREFERENCES SECTION ──────────────────────────────
                const ProfileSectionTitle(title: 'PREFERENCES'),
                ProfileMenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch.adaptive(
                    value: isDarkMode,
                    activeTrackColor: AppColor.primary,
                    onChanged: cubit.toggleDarkMode,
                  ),
                ),
                ProfileMenuItem(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'English',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Color(0xFFB0B0B8),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),

                // ── SUPPORT SECTION ──────────────────────────────────
                const ProfileSectionTitle(title: 'SUPPORT'),
                ProfileMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.shield_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),

                const SizedBox(height: 24),

                // ── LOGOUT BUTTON ────────────────────────────────────
                LogoutButton(
                  isLoading: isSigningOut,
                  onTap: () => _showLogoutDialog(context, cubit),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileCubit cubit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColor.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
