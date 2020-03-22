import 'dart:io';

import 'package:meta/meta.dart';

import 'directory.dart';
import 'file.dart';

@immutable
class DirectoryListing {
  const DirectoryListing._({@required this.directories, @required this.files});

  factory DirectoryListing.fromFileSystemEntities(
      List<FileSystemEntity> entities) {
    final _d = <ListedDirectory>[];
    final _f = <ListedFile>[];
    entities.forEach((entity) {
      if (!FileSystemEntity.isLinkSync(entity.path)) {
        if (entity is Directory) {
          _d.add(ListedDirectory.fromFilesystemEntity(entity));
        } else if (entity is File) {
          _f.add(ListedFile.fromFilesystemEntity(entity));
        }
      }
    });
    return DirectoryListing._(directories: _d, files: _f);
  }

  final List<ListedDirectory> directories;
  final List<ListedFile> files;

  /// Serialialize to json
  Map<String, dynamic> toJson() {
    final _d = <Map<String, dynamic>>[];
    directories.forEach((d) => _d.add(d.toJson()));
    final _f = <Map<String, dynamic>>[];
    files.forEach((f) => _f.add(f.toJson()));
    return <String, List<Map<String, dynamic>>>{"files": _f, "directories": _d};
  }

  /// Deserialize from json
  factory DirectoryListing.fromJson(dynamic map) {
    final _dm = map["directories"] as List<dynamic> ?? <dynamic>[];
    final _fm = map["files"] as List<dynamic> ?? <dynamic>[];
    final _d = <ListedDirectory>[];
    final _f = <ListedFile>[];
    _dm.forEach((dynamic dm) =>
        _d.add(ListedDirectory.fromJson(dm as Map<String, dynamic>)));
    _fm.forEach((dynamic fm) =>
        _f.add(ListedFile.fromJson(fm as Map<String, dynamic>)));
    return DirectoryListing._(directories: _d, files: _f);
  }

  String format([String param]) {
    final buf = StringBuffer();
    var sep = " ";
    if (param != null) {
      if (param == "-l") {
        sep = "\n";
      }
    }
    var i = 1;
    for (final dir in directories) {
      buf.write(dir.name);
      if (i < directories.length) {
        buf.write(sep);
      }
      ++i;
    }
    i = 1;
    for (final file in files) {
      buf.write(file.name);
      if (i < files.length) {
        buf.write(sep);
      }
      ++i;
    }
    return buf.toString();
  }
}
