import 'dart:async';

import 'package:airlib/airlib.dart';

Future<void> runSoldier(String ip) async {
  final soldier = AirlinkSoldier.fromIp(ip, name: "node1", verbose: true);
  await soldier.init();
  // show the executed commands on the soldier node
  soldier.listen((cmd) => print("[command] $cmd"));
}
