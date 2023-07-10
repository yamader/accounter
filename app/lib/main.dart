import "package:accounter/data/providers.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:shared_preferences/shared_preferences.dart";

import "home/home_screen.dart";

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString("assets/fonts/ZenKakuGothicNew/OFL.txt");
    yield LicenseEntryWithLineBreaks(["ZenKakuGothicNew"], license);
  });

  await dotenv.load(fileName: ".env");

  runApp(
    ProviderScope(
      overrides: [
        pkgProvider.overrideWithValue(await PackageInfo.fromPlatform()),
        prefProvider.overrideWithValue(await SharedPreferences.getInstance()),
      ],
      child: const AccounterApp(),
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
