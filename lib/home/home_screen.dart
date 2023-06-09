import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../preference/preference_screen.dart";
import "history_page.dart";
import "new_balance.dart";
import "top_page.dart";

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});

  final _controller = PageController();

  static const _pages = [
    (
      page: TopPage(),
      nav: NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: "ホーム",
      )
    ),
    (
      page: HistoryPage(),
      nav: NavigationDestination(
        icon: Icon(Icons.history_outlined),
        selectedIcon: Icon(Icons.history),
        label: "履歴",
      )
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = useState(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "かけーぼ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _controller,
          onPageChanged: (int index) {
            idx.value = index;
          },
          children: _pages.map((i) => i.page).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "追加",
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: const NewBalance(),
            ),
            isScrollControlled: true,
            showDragHandle: true,
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx.value,
        destinations: [
          ..._pages.map((i) => i.nav).toList(),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "設定",
          ),
        ],
        onDestinationSelected: (int index) {
          if (index == _pages.length) {
            Navigator.of(context).push(PreferenceScreen.route());
            return;
          }
          idx.value = index;
          _controller.jumpToPage(index);
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
