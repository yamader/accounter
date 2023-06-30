import "package:accounter/preference/preference_screen.dart";
import "package:accounter/utils.dart";
import "package:flutter/material.dart";
import "package:flutter_expandable_fab/flutter_expandable_fab.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:lucide_icons/lucide_icons.dart";

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
        icon: Icon(LucideIcons.home),
        label: "ホーム",
      )
    ),
    (
      page: HistoryPage(),
      nav: NavigationDestination(
        icon: Icon(LucideIcons.history),
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
              icon: const Icon(LucideIcons.calendarClock),
              onPressed: () {
                // timemachine
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(0),
                  lastDate: DateTime.now(),
                  helpText: "タイムマシン",
                  cancelText: "キャンセル",
                  confirmText: "Go",
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
        child: const Icon(LucideIcons.plus),
        children: [
          FloatingActionButton(
            tooltip: "追加",
            heroTag: "addFab",
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
            child: const Icon(LucideIcons.edit3),
          ),
          FloatingActionButton(
            tooltip: "画像読み取り",
            heroTag: "cameraFab",
            onPressed: () {
              _fabKey.currentState?.toggle();
              context.showSnack(const SnackBar(
                content: Text("未実装です。すんまへん。"),
              ));
            },
            child: const Icon(LucideIcons.scanLine),
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx.value,
        destinations: [
          ..._pages.map((i) => i.nav).toList(),
          const NavigationDestination(
            icon: Icon(LucideIcons.settings),
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
