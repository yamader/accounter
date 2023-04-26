import "package:flutter/material.dart";

class NewBalance extends StatefulWidget {
  const NewBalance({super.key});

  @override
  State<NewBalance> createState() => _NewBalanceState();
}

class _NewBalanceState extends State<NewBalance> {
  String _title = "";
  int _amount = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              label: Text("タイトル"),
            ),
            onChanged: (String value) {
              setState(() => _title = value);
            },
          ),
          TextField(
            decoration: const InputDecoration(
              label: Text("金額?"),
            ),
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(() => _amount = int.parse(value));
            },
          )
        ],
      ),
    );
  }
}
