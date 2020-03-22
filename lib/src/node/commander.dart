import 'dart:async';

import 'package:emodebug/emodebug.dart';
import 'package:nodecommander/nodecommander.dart';
import 'package:meta/meta.dart';

import '../types.dart';
import 'commands.dart' as cmds;

const _ = EmoDebug(deactivatePrint: false);

class AirlinkCommander {
  AirlinkCommander._(this.node, this.host);

  final String host;

  CommanderNode node;

  StreamSubscription<NodeCommand> _sub;

  factory AirlinkCommander.fromIp(String ip,
      {@required String name, int port, bool verbose = false}) {
    final n = CommanderNode(
        name: name,
        host: ip,
        port: port ?? 8098,
        commands: cmds.airlibCommands,
        verbose: verbose);
    return AirlinkCommander._(n, ip);
  }

  Future<void> sendCommand(NodeCommand command, String to) async =>
      node.sendCommand(command, to);

  Future<void> sendCommandFromName(String name, String to) async =>
      node.sendCommand(cmd(name), to);

  NodeCommand cmd(String name) =>
      cmds.airlibCommands.firstWhere((c) => c.name == name);

  Future<void> init({bool start = true}) async {
    await node.init(ip: host, start: start);
    if (node.verbose) {
      node.info();
    }
  }

  void listen(OnCommandExecuted onCommandExecuted) {
    _sub = node.commandsResponse
        .listen((NodeCommand cmd) => onCommandExecuted(cmd));
  }

  void dispose() {
    _sub.cancel();
    node.dispose();
  }
}
