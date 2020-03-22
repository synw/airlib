import 'dart:async';

import 'package:airlib/airlib.dart';
import 'package:nodecommander/nodecommander.dart';

Future<void> runCommander(String ip) async {
// commander node
  final commander = AirlinkCommander.fromIp(ip,
      name: "airlib commander", port: 8088, verbose: true);
  await commander.init();
  // listen for command responses from the soldier nodes
  commander.listen((cmd) {
    switch (cmd.name) {
      case "ls":
        final listing = DirectoryListing.fromJson(cmd.payload);
        print(listing.format("-l"));
        break;
      default:
    }
  });
  commander.node.info();
  await commander.node.onReady;
  // discovery
  await commander.node.discoverNodes();
  await Future<dynamic>.delayed(const Duration(seconds: 1));
  if (commander.node.soldiers.isNotEmpty) {
    final s = commander.node.soldiers[0];
    print("Soldiers found: ${commander.node.soldiers}");
    // ping
    await commander.sendCommand(NodeCommand.ping(), s.address);
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    // ls
    final cmd = commander.cmd("ls").copyWithArguments(<dynamic>["."]);
    await commander.sendCommand(cmd, s.address);
    // wget
    await commander.sendCommand(
        commander
            .cmd("wget")
            .copyWithArguments(<dynamic>["./soldier/file.txt"]),
        s.address);
  } else {
    print("No soldiers found");
  }
}
