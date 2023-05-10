import "package:accounter/data/db.dart";
import "package:accounter/ui/widgets/outlined_card.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:shimmer/shimmer.dart";

class MonthlyAmount extends StatefulWidget {
  const MonthlyAmount({super.key});

  @override
  State<MonthlyAmount> createState() => _MonthlyAmountState();
}

class _MonthlyAmountState extends State<MonthlyAmount> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AccounterDB>(context);

    final future = (() async {
      await Future.delayed(const Duration(seconds: 3));
      return db.allBalances();
    })();

    return OutlinedCard(
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Shimmer.fromColors(
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
                          strokeCap: StrokeCap.round,
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
            );
          }

          return Container(
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
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "収支: +${snapshot.data?.fold(0, (p, e) => p + e.amount)}円",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("今月の記録: ${snapshot.data?.length}件"),
                    const Text("ほげほげ"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
