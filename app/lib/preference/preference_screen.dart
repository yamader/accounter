import "dart:convert";

import "package:accounter/data/models.dart";
import "package:accounter/data/providers.dart";
import "package:accounter/utils.dart";
import "package:accounter/widgets/money_icon.dart";
import "package:drift/drift.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";

class PreferenceScreen extends StatefulHookConsumerWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => const PreferenceScreen(),
      );

  const PreferenceScreen({super.key});

  @override
  PreferenceScreenState createState() => PreferenceScreenState();
}

class PreferenceScreenState extends ConsumerState {
  Future<int> importCSV() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["csv"],
      withReadStream: true,
    );
    if (res == null) return Future.error("file not selected");

    final db = ref.watch(dbProvider);
    final balances = await db.getBalances();

    var i = 0;
    await res.files.single.readStream
        ?.transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach((line) async {
      final [y, m, d, realTitle, abs, typ, person, ...desc] = line.split(",");
      final amount = (typ == "2" ? -1 : 1) * int.parse(abs),
          timestamp = DateTime(int.parse(y), int.parse(m), int.parse(d)),
          title = "$person $realTitle";

      if (balances.any((i) =>
          i.amount == amount && i.timestamp == timestamp && i.title == title)) {
        return;
      }
      i++;

      await db.addBalance(BalancesCompanion(
        amount: Value(amount),
        timestamp: Value(timestamp),
        title: Value(title),
        comment: Value(desc.join(" ").trim()),
      ));
    });
    return i;
  }

  @override
  Widget build(BuildContext context) {
    final pkginfo = ref.watch(pkgProvider);
    final prefs = ref.watch(prefProvider);
    final enableCloud = useState(prefs.getBool("enable_cloud") ?? true);
    final symbolRupee = useState(prefs.getBool("symbol_rupee") ?? false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: ListView(children: [
        SwitchListTile(
          value: enableCloud.value,
          onChanged: (value) async {
            await prefs.setBool("enable_cloud", value);
            enableCloud.value = value;
          },
          title: const Text("クラウドサービスの利用"),
          // todo: 詳細を書く
          subtitle: const Text("山Dのサーバーに一部データが行きます"),
          secondary: const Icon(LucideIcons.cloud),
        ),
        SwitchListTile(
          value: symbolRupee.value,
          onChanged: (value) async {
            await prefs.setBool("symbol_rupee", value);
            symbolRupee.value = value;
          },
          title: const Text("ルピー"),
          subtitle:
              const Text("भारतीय रुपये को धन प्रतीक के रूप में उपयोग करें"),
          secondary: const MoneyIcon(),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(LucideIcons.fileSpreadsheet),
          title: const Text("CSVのインポート"),
          onTap: () async {
            try {
              final n = await importCSV();
              context.showSnack(SnackBar(
                content: Text("$n件のデータをインポートしました"),
              ));
            } catch (e) {
              context.showSnack(SnackBar(
                content: Text("インポートに失敗しました。: $e"),
              ));
            }
          },
        ),
        ListTile(
          leading: const Icon(LucideIcons.databaseBackup),
          title: const Text("データのバックアップ"),
          onTap: () {
            context.showSnack(const SnackBar(
              content: Text("未実装です。すみません。"),
            ));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(LucideIcons.info),
          title: const Text("このアプリについて"),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: pkginfo.appName,
              applicationVersion: pkginfo.version,
              // todo: replace with image asset
              applicationIcon: const Icon(LucideIcons.wallet),
              applicationLegalese: "© 2023 山D",
              children: [],
            );
          },
        ),
      ]),
    );
  }
}
