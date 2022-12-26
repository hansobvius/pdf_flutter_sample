import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



Future<bool> _checkPermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
  } else {
    return true;
  }
  return false;
}

Future<Directory> getApplicationDirectory() async => await getApplicationDocumentsDirectory();

Future<File> _saveIntoCacheMemory(
    String url,
    {String keyName,
    Map<String, String> headers,
    CacheManager cacheManager,
    Function(bool isError) error}) async {
  File file;
  try {
    file = await (cacheManager ?? DefaultCacheManager())
        .getSingleFile(url, key: keyName, headers: headers)
        .catchError((e) {
          debugPrint("CACHE DOWNLOAD FAILED ${e.message}");
          error(true);
        });
  } on FileSystemException catch(e) {
    debugPrint("CACHE DOWNLOAD FAILED ${e.message}");
  }
  return file;
}

Future<String> _findPublicPath() async {
  String directory;
  if(Platform.isAndroid)
    directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  else {
    var dir = await getApplicationDocumentsDirectory();
    directory = dir.path;
  }
  return directory;
}

Future<String> _findLocalPath() async =>
    await getApplicationDirectory().then((value) => value.path);

Future<String> _pathGenerator(bool isPrivate) async =>
    isPrivate ? await _findLocalPath() : await _findPublicPath();

Future executeFileRecord(File file, bool isPrivate, Uint8List readContent, [String url]) async {
  if(Platform.isIOS && !isPrivate) {
    return await _shareFile(url ?? '', file);
  }
  return await file.writeAsBytes(readContent);
}

Future _shareFile(String uri, File fileContent) async {
  await FlutterShare.shareFile(
    title: fileContent.path,
    text: 'Example share text',
    fileType: '.pdf',
    filePath: fileContent.path,
  );
}

Future downloadFile({String url,
    Map<String, dynamic> header,
    String filename,
    bool isPrivate,
    Function(bool syccess, String path) onSuccess,
    Function(bool isError) onError}) async {
  /// FIXME - permission checker seems broken, cause is called outside main isolate loop?
  var permissionReady = await _checkPermission();
  if (permissionReady) {
    var cachedFile = await _saveIntoCacheMemory(
        url,
        keyName: filename,
        headers: header,
        error: (isError) => onError(isError)
    );
    var path = await _pathGenerator(isPrivate);
    var readContent = await cachedFile.readAsBytes();
    await _createFileDir([path]);
    try {
      File file = await File(path + "/" + filename).create(recursive: true);
      await executeFileRecord(file, isPrivate, readContent).then((value) => {
        onSuccess(true, path),
        _deleteCachedFile(filename),
        debugPrint("DOWNLOAD SUCCESS")
      });
    } on FileSystemException catch(e){
      onError(true);
      debugPrint("DOWNLOAD FAILED: ${e.message}");
    }
  }
}

Future _createFileDir(List<String> paths) async =>
    paths.forEach((path) async {
      try {
        final savedDir = Directory(path);
        bool hasExisted = await savedDir.exists();
        if (!hasExisted) {
          savedDir.create();
        }
      } on FileSystemException catch(e) {
        debugPrint("CANNOT CREATE FILE DIRECTORY ${e.message}");
      }
    });

Future<List<String>> readFileContent() async {
  List<String> pathList = [];
  await getApplicationDirectory().then((files)async  => {
    await files.list().forEach((element) {
      pathList.add(element.path);
    }),
  });
  if(pathList.isEmpty) readFileContent();
  return pathList;
}

Future<List<Directory>> getRawDownloadCompleted() async {
  List<Directory> listOfDirs = [];
  var dir = await getApplicationDirectory();
  Stream<FileSystemEntity> Function({bool followLinks, bool recursive}) finalListDir = dir.list;
  var systemFiles = finalListDir();
  await systemFiles.forEach((element) => listOfDirs.add(element.parent));
  return listOfDirs;
}

Future deleteFileFromStorage(String filePath) async {
  try {
    return await File(filePath).delete();
  } on FileSystemException catch (e) {
    debugPrint("DELETE FILE FROM STORAGE FAIlED " + e.message);
  }
}

Future<double> getTotalFileSize(String path) async {
  var divider = 1024;
  File file = File(path);
  var readAsBytes = await file.readAsBytesSync().lengthInBytes;
  var mbTotal = (readAsBytes / (divider * divider));
  return mbTotal;
}

Future _deleteCachedFile(String key, {CacheManager cacheManager}) async =>
  await (cacheManager ?? DefaultCacheManager()).removeFile(key);

String removeSpecialChar(String str) {
  str = str.replaceAll('á', 'a');
  str = str.replaceAll('à', 'a');
  str = str.replaceAll('ã', 'a');
  str = str.replaceAll('â', 'a');
  str = str.replaceAll('ä', 'a');
  str = str.replaceAll('é', 'e');
  str = str.replaceAll('è', 'e');
  str = str.replaceAll('ê', 'e');
  str = str.replaceAll('ë', 'e');
  str = str.replaceAll('í', 'i');
  str = str.replaceAll('ì', 'i');
  str = str.replaceAll('î', 'i');
  str = str.replaceAll('ï', 'i');
  str = str.replaceAll('ó', 'o');
  str = str.replaceAll('ò', 'o');
  str = str.replaceAll('õ', 'o');
  str = str.replaceAll('ô', 'o');
  str = str.replaceAll('ö', 'o');
  str = str.replaceAll('ú', 'u');
  str = str.replaceAll('ù', 'u');
  str = str.replaceAll('û', 'u');
  str = str.replaceAll('ü', 'u');
  str = str.replaceAll('ç', 'c');
  return str;
}