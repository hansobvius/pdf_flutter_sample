import 'dart:io';
import 'dart:isolate';

import 'download_util.dart';

class PdfObject {

  String message;
  String url;
  String filename;
  File file;
  bool isPrivate;
  String path;
  SendPort sendPort;

  PdfObject(this.message, this.url, filename, this.isPrivate, this.sendPort);
}