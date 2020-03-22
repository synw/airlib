import 'dart:async';

import 'package:nodecommander/nodecommander.dart';

import 'commander/commander.dart';
import 'soldier/soldier.dart';

enum NodeType { commander, soldier }

Future<void> main(List<String> args) async {
  var nodeType = NodeType.soldier;
  if (args.isNotEmpty && args[0] == "-c") {
    nodeType = NodeType.commander;
  }
  print("Running $nodeType");
  // grab the ip
  final ip = await getHost();
  if (nodeType == NodeType.soldier) {
    // soldier node
    await runSoldier(ip);
  } else {
    await runCommander(ip);
  }
  // idle
  await Completer<void>().future;
}
