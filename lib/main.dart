import "package:accounter/data/db.dart";
import "package:accounter/ui/screens/home/home.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:yaru/yaru.dart";

void main() {
  runApp(Provider<AccounterDB>(
    create: (_) => AccounterDB(),
    child: const AccounterApp(),
    dispose: (_, db) => db.close(),
  ));
}

class AccounterApp extends StatelessWidget {
  const AccounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ));

    return YaruTheme(
      data: const YaruThemeData(variant: YaruVariant.red),
      builder: (context, yaru, child) => MaterialApp(
        title: "かけーぼ (仮)",
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
