import 'dart:io';

import '../models/listing.dart';

DirectoryListing ls(String path) {
  //print("LS path: $path");
  final dir = Directory(path);

  if (!dir.existsSync()) {
    throw "The directory ${dir.path} does not exist";
  }
  final entities = dir.listSync();
  return DirectoryListing.fromFileSystemEntities(entities);
}
