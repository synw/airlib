import 'dart:io';

import 'package:path/path.dart';

class ListedDirectory {
  /// Default constructor
  ListedDirectory.fromFilesystemEntity(FileSystemEntity entity) {
    _directory = Directory(entity.path);
    _dirname = basename(entity.path);
  }

  Directory _directory;
  String _dirname;

  /// Get the file object
  Directory get directory => _directory;

  /// The path of the entity
  String get path => _directory.path;

  /// The name of the directory
  String get name => _dirname;

  /// The parent directory
  Directory get parent => _directory.parent;

  /// Serialialize to json
  Map<String, dynamic> toJson() => <String, dynamic>{
        "path": _directory.path,
        "dirname": _dirname,
        "parent_path": _directory.parent.path,
      };

  /// Deserialize from json
  ListedDirectory.fromJson(Map<String, dynamic> map)
      : _directory = Directory(map["path"].toString()),
        _dirname = basename(map["path"].toString());
}
