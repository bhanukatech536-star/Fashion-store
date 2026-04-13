import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';
import 'home/home_screen.dart';
import 'product/product_list_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';
import '../core/theme.dart';
import '../widgets/animations.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  // Keep pages alive across tab switches
  final List<Widget> _pages = const [
    HomeScreen(),
    ProductListScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  // Per-page fade controllers so each tab cross-fades in
  late final List<AnimationController> _tabControllers;
  late final List<Animation<double>> _tabFades;

  @override
  void initState() {
    super.initState();
    _tabControllers = List.generate(
      _pages.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: i == 0 ? 1.0 : 0.0, // first tab starts visible
      ),
    );
    _tabFades = _tabControllers
        .map((c) =>
            CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _tabControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTabTap(int index) {
    if (index == _currentIndex) return;
    // Fade out current, fade in new
    _tabControllers[_currentIndex].reverse();
    setState(() => _currentIndex = index);
    _tabControllers[index].forward();
  }

  @override
  Widget build(BuildContext context) {
    final cartItemCount = context.watch<CartController>().itemCount;

    return Scaffold(
      body: Stack(
        children: List.generate(_pages.length, (i) {
          return FadeTransition(
            opacity: _tabFades[i],
            child: IgnorePointer(
              ignoring: _currentIndex != i,
              child: _pages[i],
            ),
          );
        }),
      ),
      bottomNavigationBar: _AnimatedNavBar(
        currentIndex: _currentIndex,
        cartBadge: cartItemCount,
        onTap: _onTabTap,
      ),
    );
  }
}

// ── Custom animated nav bar ───────────────────────────────────────────────────
class _AnimatedNavBar extends StatelessWidget {
  final int currentIndex;
  final int cartBadge;
  final ValueChanged<int> onTap;

  const _AnimatedNavBar({
    required this.currentIndex,
    required this.cartBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'Shop', 'Cart', 'Profile'];
    const icons = [
      [Icons.home_outlined, Icons.home],
      [Icons.search_outlined, Icons.search],
      [Icons.shopping_bag_outlined, Icons.shopping_bag],
      [Icons.person_outline, Icons.person],
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(labels.length, (i) {
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppTheme.primaryColor.withOpacity(0.10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Badge for cart
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, anim) =>
                                ScaleTransition(scale: anim, child: child),
                            child: Icon(
                              (icons[i][selected ? 1 : 0]) as IconData,
                              key: ValueKey(selected),
                              color: selected
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                              size: 22,
                            ),
                          ),
                          if (i == 2 && cartBadge > 0)
                            Positioned(
                              right: -6,
                              top: -6,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  key: ValueKey(cartBadge),
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.errorColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$cartBadge',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Label slides in when selected
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: selected
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  labels[i],
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
