import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:req_res_flutter/app/theme.dart';
import 'package:req_res_flutter/constants/icons.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';

class HomeLayout extends StatefulWidget {
  final Widget child;

  const HomeLayout({super.key, required this.child});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    // Handle navigation based on index
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 4:
        context.go('/account');
        break;
      // Other cases (1, 2, 3) are placeholders for now as per instructions
    }

    // Update local state for UI highlight
    // Note: In a real app with GoRouter, you might calculate index from location
    setState(() {
      _currentIndex = index;
    });
  }

  // Calculate current index based on route to keep UI in sync
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/account')) {
      return 4;
    }
    if (location == '/') {
      return 0;
    }
    return 0; // Default to home
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha(12),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    index: 0,
                    icon: AppIcons.home,
                    label: l10n.tabHome,
                    isSelected: selectedIndex == 0,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 1,
                    icon: AppIcons.videos,
                    label: l10n.tabVideos,
                    isSelected: selectedIndex == 1,
                  ),
                ),
                _buildCenterButton(),
                Expanded(
                  child: _buildNavItem(
                    index: 3,
                    icon: AppIcons.message,
                    label: l10n.tabMessage,
                    isSelected: selectedIndex == 3,
                    hasBadge: true,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 4,
                    icon: AppIcons.account,
                    label: l10n.tabAccount,
                    isSelected: selectedIndex == 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String label,
    required bool isSelected,
    bool hasBadge = false,
  }) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              if (hasBadge)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? AppColors.primaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => _onItemTapped(2),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
