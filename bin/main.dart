import 'package:nodecommander/nodecommander.dart';
import 'package:airlib/airlib.dart';

void main() {
  final node = CommanderNode(
      name: "cli", port: 8185, commands: airlibCommands, verbose: true);
  NodeCommanderCli(node).run();
}
