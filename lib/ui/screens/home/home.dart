import "package:accounter/ui/screens/home/pages/history.dart";
import "package:accounter/ui/screens/home/pages/top.dart";
import "package:accounter/ui/screens/home/widgets/new_balance.dart";
import "package:accounter/ui/screens/preference/preference.dart";
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // refresh

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PageController();
  var _index = 0;

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
  Widget build(BuildContext context) {
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
            setState(() => _index = index);
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
        selectedIndex: _index,
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
          setState(() => _index = index);
          _controller.jumpToPage(index);
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
