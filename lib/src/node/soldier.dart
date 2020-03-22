import 'dart:async';

import 'package:emodebug/emodebug.dart';
import 'package:meta/meta.dart';
import 'package:nodecommander/nodecommander.dart';

import '../types.dart';
import 'commands.dart' as cmds;

const _ = EmoDebug(level: "airlink soldier", deactivatePrint: false);

class AirlinkSoldier {
  factory AirlinkSoldier.fromIp(String ip,
      {@required String name, bool verbose = false}) {
    final n = SoldierNode(
        name: name, host: ip, commands: cmds.airlibCommands, verbose: verbose);
    return AirlinkSoldier._(n);
  }

  AirlinkSoldier._(this.node) : host = node.host;

  final String host;

  SoldierNode node;
  StreamSubscription<NodeCommand> _sub;

  Future<SoldierNode> init({bool start = true}) async {
    await node.init(ip: host, start: start);
    if (node.verbose) {
      _.init("The node is initialized");
      node.info();
    }
    return node;
  }

  void listen(OnCommandExecuted onCommandExecuted) {
    _sub = node.commandsExecuted
        .listen((NodeCommand cmd) => onCommandExecuted(cmd));
  }

  void dispose() {
    _sub.cancel();
  }
}
