import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/favorites/presentation/views/favorites_view.dart';
import 'package:food_app/features/home/presentation/views/home_view.dart';
import 'package:food_app/features/main_home/data/models/navigation_item_model.dart';
import 'package:food_app/features/main_home/presentation/view_model/main_home_cubit.dart';
import 'package:food_app/features/profile/presentation/views/profile_view.dart';

class MainHomeView extends StatelessWidget {
  const MainHomeView({super.key});

  static final List<NavigationItemModel> _items = [
    NavigationItemModel(
      label: 'HOME',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      page: const HomeView(),
    ),
    NavigationItemModel(
      label: 'FAVORITES',
      icon: Icons.favorite_outline_rounded,
      selectedIcon: Icons.favorite_rounded,
      page: const FavoritesView(),
    ),
    NavigationItemModel(
      label: 'PROFILE',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      page: const ProfileView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainHomeCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: _items.map((item) => item.page).toList(growable: false),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                FocusScope.of(context).unfocus();
                context.read<MainHomeCubit>().changeIndex(index);
              },
              backgroundColor: Colors.white,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColor.primary,
              unselectedItemColor: const Color(0xFF9E9E9E),
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              items: _items
                  .map(
                    (item) => BottomNavigationBarItem(
                      label: item.label,
                      icon: Icon(item.icon),
                      activeIcon: Icon(item.selectedIcon),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        );
      },
    );
  }
}


