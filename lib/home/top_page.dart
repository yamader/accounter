import "package:flutter/material.dart";

import "category_amount.dart";
import "monthly_amount.dart";

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(children: [
        MonthlyAmount(),
        CategoryAmount(),
      ]),
    );
  }
}
