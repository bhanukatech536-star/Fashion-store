import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Base shimmer box used by all skeleton widgets
class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

/// Wraps any child in a Shimmer wave effect
Widget shimmerWrap({required Widget child}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade200,
    highlightColor: Colors.grey.shade50,
    period: const Duration(milliseconds: 1200),
    child: child,
  );
}

// ─── Product Card Skeleton ──────────────────────────────────────────────────

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerWrap(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: 110, height: 12, borderRadius: BorderRadius.circular(6)),
                  const SizedBox(height: 8),
                  _ShimmerBox(width: 70, height: 16, borderRadius: BorderRadius.circular(6)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Product Grid Skeleton (full screen) ────────────────────────────────────

class ProductGridSkeleton extends StatelessWidget {
  final int count;
  const ProductGridSkeleton({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: count,
      itemBuilder: (_, __) => const ProductCardSkeleton(),
    );
  }
}

// ─── Banner Skeleton ─────────────────────────────────────────────────────────

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerWrap(
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

// ─── Cart Item Skeleton ───────────────────────────────────────────────────────

class CartItemSkeleton extends StatelessWidget {
  const CartItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerWrap(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: double.infinity, height: 14, borderRadius: BorderRadius.circular(6)),
                  const SizedBox(height: 8),
                  _ShimmerBox(width: 80, height: 14, borderRadius: BorderRadius.circular(6)),
                  const SizedBox(height: 12),
                  _ShimmerBox(width: 100, height: 28, borderRadius: BorderRadius.circular(8)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Order Item Skeleton ─────────────────────────────────────────────────────

class OrderItemSkeleton extends StatelessWidget {
  const OrderItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerWrap(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(width: 140, height: 16, borderRadius: BorderRadius.circular(6)),
                _ShimmerBox(width: 70, height: 16, borderRadius: BorderRadius.circular(6)),
              ],
            ),
            const SizedBox(height: 10),
            _ShimmerBox(width: 100, height: 12, borderRadius: BorderRadius.circular(6)),
            const SizedBox(height: 20),
            const Divider(color: Colors.white),
            const SizedBox(height: 12),
            Row(
              children: [
                _ShimmerBox(width: 80, height: 12, borderRadius: BorderRadius.circular(6)),
                const Spacer(),
                _ShimmerBox(width: 80, height: 12, borderRadius: BorderRadius.circular(6)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Header Skeleton ──────────────────────────────────────────────────

class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerWrap(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 16),
          _ShimmerBox(width: 160, height: 20, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 10),
          _ShimmerBox(width: 200, height: 14, borderRadius: BorderRadius.circular(6)),
        ],
      ),
    );
  }
}

// ─── Category Chip Skeleton ─────────────────────────────────────────────────

class CategoryChipsSkeleton extends StatelessWidget {
  const CategoryChipsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return shimmerWrap(
      child: Row(
        children: List.generate(
          5,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 80,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
