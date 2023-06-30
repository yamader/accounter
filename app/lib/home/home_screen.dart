import "package:accounter/preference/preference_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_expandable_fab/flutter_expandable_fab.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "history_page.dart";
import "new_balance.dart";
import "top_page.dart";

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});

  final _controller = PageController();
  final _fabKey = GlobalKey<ExpandableFabState>();

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
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                // timemachine
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(0),
                  lastDate: DateTime.now(),
                );
              },
            )
          ]),
      body: SafeArea(
        child: PageView(
          controller: _controller,
          onPageChanged: (int index) {
            idx.value = index;
          },
          children: _pages.map((i) => i.page).toList(),
        ),
      ),
      // todo: 開いたときにグレーアウトする
      floatingActionButton: ExpandableFab(
        key: _fabKey,
        distance: 72,
        type: ExpandableFabType.up,
        child: const Icon(Icons.add),
        children: [
          FloatingActionButton(
            tooltip: "追加",
            onPressed: () {
              _fabKey.currentState?.toggle();
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
            child: const Icon(Icons.edit),
          ),
          FloatingActionButton(
            tooltip: "画像読み取り",
            onPressed: () {
              _fabKey.currentState?.toggle();
              Fluttertoast.showToast(msg: "未実装です。すんまへん。");
            },
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
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
