import "package:accounter/data/providers.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:shimmer/shimmer.dart";

import "../widgets/outlined_card.dart";

class MonthlyAmount extends HookConsumerWidget {
  const MonthlyAmount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesStream = ref.watch(balancesProvider);

    return OutlinedCard(
      child: balancesStream.when(
        data: (balances) => Container(
          padding: const EdgeInsets.all(24),
          height: 125,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: 0.8,
                    strokeWidth: 16,
                    // strokeCap: StrokeCap.round,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "収支: +${balances.fold(0, (p, e) => p + e.amount)}円",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("今月の記録: ${balances.length}件"),
                  const Text("ほげほげ"),
                ],
              ),
            ],
          ),
        ),
        loading: () => Shimmer.fromColors(
          baseColor: const Color(0xFFEBEBF4),
          highlightColor: const Color(0xFFF4F4F4),
          child: Container(
            padding: const EdgeInsets.all(24),
            height: 125,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 16,
                      // strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 8,
                  children: [
                    Container(width: 160, height: 24, color: Colors.black),
                    Container(width: 80, height: 16, color: Colors.black),
                    Container(width: 100, height: 16, color: Colors.black),
                  ],
                ),
              ],
            ),
          ),
        ),
        error: (err, stack) => const Text("Oops!"),
      ),
    );
  }
}
