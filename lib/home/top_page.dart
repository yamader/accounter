import "package:flutter/material.dart";

import "monthly_amount.dart";

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthlyAmount(),
      ],
    );
  }
}
