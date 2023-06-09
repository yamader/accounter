import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "home/home_screen.dart";

void main() {
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString("assets/fonts/ZenKakuGothicNew/OFL.txt");
    yield LicenseEntryWithLineBreaks(["ZenKakuGothicNew"], license);
  });

  runApp(
    const ProviderScope(
      child: AccounterApp(),
    ),
  );
}

class AccounterApp extends StatelessWidget {
  const AccounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Colors.red;
    const font = "ZenKakuGothicNew";

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      title: "かけーぼ (仮)",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        fontFamily: font,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: seed,
        fontFamily: font,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
