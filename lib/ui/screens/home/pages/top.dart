import "package:accounter/ui/screens/home/widgets/monthly_amount.dart";
import "package:flutter/material.dart";

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        MonthlyAmount(),
      ],
    );
  }
}
