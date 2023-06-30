import "package:accounter/data/providers.dart";
import "package:accounter/utils.dart";
import "package:accounter/widgets/money_icon.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";

class PreferenceScreen extends HookConsumerWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => const PreferenceScreen(),
      );

  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onTap: () {
            context.showSnack(const SnackBar(
              content: Text("未実装です。すみません。"),
            ));
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
