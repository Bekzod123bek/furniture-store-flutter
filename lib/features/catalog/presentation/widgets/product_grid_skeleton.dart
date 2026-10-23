import 'package:flutter/material.dart';
import 'package:furniture_store/core/widgets/skeleton.dart';

const productGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 240,
  mainAxisSpacing: 16,
  crossAxisSpacing: 14,
  childAspectRatio: 0.62,
);

/// Grid of product-shaped skeletons shown while the catalog loads.
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid.builder(
        gridDelegate: productGridDelegate,
        itemCount: 6,
        itemBuilder: (_, _) => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Skeleton(radius: 20)),
            SizedBox(height: 10),
            Skeleton(height: 14, width: 120, radius: 6),
            SizedBox(height: 6),
            Skeleton(height: 14, width: 70, radius: 6),
          ],
        ),
      ),
    );
  }
}
