import "package:flutter/material.dart";

class PreferenceScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => const PreferenceScreen(),
      );

  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.import_export),
              title: const Text("データのバックアップ"),
              onTap: () {
                const snackBar = SnackBar(
                  content: Text("未実装です。すみません。"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
          const Divider(),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text("オープンソースライセンス"),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
