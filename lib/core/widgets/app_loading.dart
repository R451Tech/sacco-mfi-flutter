import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppLoading extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const AppLoading({
    super.key,
    this.height = 16,
    this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
      highlightColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class AppLoadingCard extends StatelessWidget {
  const AppLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppLoading(height: 20, width: 120),
            const SizedBox(height: 12),
            AppLoading(height: 14),
            const SizedBox(height: 8),
            AppLoading(height: 14, width: 180),
          ],
        ),
      ),
    );
  }
}

class AppLoadingPage extends StatelessWidget {
  const AppLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          AppLoadingCard(),
          SizedBox(height: 8),
          AppLoadingCard(),
          SizedBox(height: 8),
          AppLoadingCard(),
        ],
      ),
    );
  }
}
