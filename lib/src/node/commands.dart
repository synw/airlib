import 'dart:io';
import 'dart:typed_data';

import 'package:airlib/src/node/models/listing.dart';
import 'package:nodecommander/nodecommander.dart';
import 'package:path/path.dart';
import 'package:csv/csv.dart';

import 'dir/dir.dart' as cmds;

final List<NodeCommand> airlibCommands = <NodeCommand>[ls, wget];

final NodeCommand ls = NodeCommand.define(
  name: "ls",
  executor: (cmd) async {
    //print("LS exec: ${cmd.arguments} / ${cmd.payload}");
    if (cmd.arguments.isEmpty) {
      return cmd.copyWithError("No path provided");
    }
    final path = cmd.arguments[0].toString();
    DirectoryListing listing;
    try {
      listing = cmds.ls(path);
    } catch (e) {
      return cmd.copyWithError("Error in directory listing: $e");
    }
    return cmd.copyWithPayload(<String, dynamic>{"response": listing.toJson()});
  },
  responseProcessor: (cmd) async {
    //print("LS response: ${cmd.payload}");
    final resp = cmd.payload["response"] as Map<String, dynamic>;
    var dirs = <dynamic>[];
    var files = <dynamic>[];
    if (resp.containsKey("directories")) {
      dirs = resp["directories"] as List<dynamic>;
    }
    if (resp.containsKey("files")) {
      files = resp["files"] as List<dynamic>;
    }
    final res = <List<dynamic>>[];
    dirs.forEach((dynamic row) {
      final r = row as Map<String, dynamic>;
      res.add(<dynamic>[r["dirname"].toString()]);
    });
    files.forEach((dynamic row) {
      final r = row as Map<String, dynamic>;
      res.add(<dynamic>[r["filename"].toString(), r["filesize"].toString()]);
    });
    final csv = const ListToCsvConverter().convert(res, fieldDelimiter: "\t");
    print(csv);
  },
);

final NodeCommand wget = NodeCommand.define(
    name: "wget",
    executor: (cmd) async {
      if (cmd.arguments.isEmpty) {
        return cmd.copyWithError("No path provided");
      }
      final path = cmd.arguments[0].toString();
      final file = File(path);
      if (!file.existsSync()) {
        return cmd.copyWithError("The file ${file.path} does not exist");
      }
      final filename = basename(file.path);
      return cmd.copyWithPayload(<String, dynamic>{
        "filename": filename,
        "data": file.readAsBytesSync()
      });
    },
    responseProcessor: (cmd) async {
      //print(cmd.payload["data"]);
      final data = List<int>.from(cmd.payload["data"] as List<dynamic>);
      final bytes = Uint8List.fromList(data);
      final file = File(cmd.payload["filename"].toString());
      print("Writing file ${file.path}");
      file.writeAsBytesSync(bytes);
    });
