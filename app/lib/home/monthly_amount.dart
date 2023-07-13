import "package:accounter/data/providers.dart";
import "package:accounter/widgets/my_circular_progress_indicator.dart";
import "package:accounter/widgets/outlined_card.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:shimmer/shimmer.dart";

class MonthlyAmount extends HookConsumerWidget {
  const MonthlyAmount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesStream = ref.watch(thisMonthProvider);

    return OutlinedCard(
      child: balancesStream.when(
        data: (balances) {
          final sum = balances.fold(0, (p, e) => p + e.amount);
          final limit = 100000;
          final usage = -sum / limit;

          return Container(
            padding: const EdgeInsets.all(24),
            height: 128,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: usage),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.fastOutSlowIn,
                    builder: (_, value, __) => MyCircularProgressIndicator(
                      value: value,
                      backColor: Colors.red.withOpacity(.2),
                      strokeWidth: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "支出: ￥${-sum}",
                  style: TextStyle(
                    color: usage > 1
                        ? Colors.red
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text("今月の予算: ￥$limit"),
                Text("記録件数: n=${balances.length}"),
              ]),
            ]),
          );
        },
        loading: () => Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade200,
          child: Container(
            padding: const EdgeInsets.all(24),
            height: 125,
            child: Row(children: [
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
            ]),
          ),
        ),
        error: (err, stack) => const Text("Oops!"),
      ),
    );
  }
}
