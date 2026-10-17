import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/core/routing/routes.dart';
import 'package:food_app/core/themes/app_color.dart';
import 'package:food_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:food_app/features/home/presentation/view_model/home_state.dart';
import 'package:food_app/features/home/presentation/views/widgets/category_card.dart';
import 'package:food_app/features/home/presentation/views/widgets/home_header.dart';
import 'package:food_app/features/home/presentation/views/widgets/home_status.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();
    if (cubit.state is HomeInitial) {
      cubit.getCategories();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Scaffold(
      body: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: cubit.getCategories,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(
                searchController: _searchController,
                onSearchChanged: cubit.searchCategories,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      AppStrings.exploreCategories,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading || state is HomeInitial) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColor.primary),
                    ),
                  );
                }

                if (state is HomeFailure) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: HomeStatus(
                      icon: Icons.cloud_off_rounded,
                      message: state.errorMessage,
                      onRetry: cubit.getCategories,
                    ),
                  );
                }

                if (state is HomeSuccess) {
                  if (state.categories.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: HomeStatus(
                        icon: Icons.search_off_rounded,
                        message: AppStrings.noCategoriesFound,
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.85,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final category = state.categories[index];
                        return CategoryCard(
                          category: category,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.categoryMeals,
                              arguments: {
                                'name': category.name,
                                'description': category.description,
                              },
                            );
                          },
                        );
                      }, childCount: state.categories.length),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
