import 'dart:io';

import 'package:filesize/filesize.dart' as fs;
import 'package:path/path.dart';

class ListedFile {
  /// Default constructor
  ListedFile.fromFilesystemEntity(FileSystemEntity entity) {
    _file = File(entity.path);
    _filesize = _getFilesize(_file);
    _filename = basename(entity.path);
  }

  File _file;
  String _filename;
  String _filesize;

  /// Get the file object
  File get file => _file;

  /// The path of the entity
  String get path => _file.path;

  /// The name of the file
  String get name => _filename;

  /// The parent directory
  Directory get parent => _file.parent;

  /// The humanized size of the file
  String get filesize => _filesize;

  /// The filesize in bytes
  String get rawFilesize => _getFilesize(_file, raw: true);

  /// Serialialize to json
  Map<String, dynamic> toJson() => <String, dynamic>{
        "path": _file.path,
        "filename": _filename,
        "parent_path": _file.parent.path,
        "filesize": _filesize,
        "raw_filesize": _getFilesize(_file, raw: true)
      };

  /// Deserialize from json
  ListedFile.fromJson(Map<String, dynamic> map)
      : _file = File(map["path"].toString()),
        _filename = basename(map["path"].toString());

  String _getFilesize(FileSystemEntity _item, {bool raw = false}) {
    if (_item is File) {
      final s = _item.lengthSync();
      String size;
      if (raw == false) {
        size = fs.filesize(s);
      } else {
        size = "$s";
      }
      return size;
    } else {
      return "";
    }
  }
}
