import "package:accounter/pb/hello.pbgrpc.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:grpc/grpc.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:shared_preferences/shared_preferences.dart";

import "models.dart";

final pkgProvider = Provider<PackageInfo>(
    (_) => throw UnimplementedError("PackageInfo is not instantiated yet."));

final prefProvider = Provider<SharedPreferences>((_) =>
    throw UnimplementedError("SharedPreferences is not instantiated yet."));

final dbProvider = Provider((ref) {
  final db = AccounterDB();
  ref.onDispose(() => db.close());
  return db;
});

final thisMonthProvider = StreamProvider((ref) {
  final db = ref.watch(dbProvider);
  return db.watchThisMonthBalances();
});

final helloProvider = Provider((ref) {
  final host = dotenv.get("API_HOST", fallback: "localhost"),
      port = dotenv.get("API_PORT", fallback: "50051"),
      secure = dotenv.get("API_SECURE", fallback: "false");
  final channel = ClientChannel(host,
      port: int.parse(port),
      options: ChannelOptions(
        credentials: bool.parse(secure)
            ? const ChannelCredentials.secure()
            : const ChannelCredentials.insecure(),
      ));
  ref.onDispose(() => channel.shutdown());
  return GreeterClient(channel);
});
