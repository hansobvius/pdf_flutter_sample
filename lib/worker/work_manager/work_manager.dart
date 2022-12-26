import 'dart:async';
import 'dart:isolate';

import 'package:pdf_samples/core/pdf_object.dart';


class WorkerManager {

  static final WorkerManager instance = WorkerManager();

  Future runIsolate({PdfObject obj, Function fun}) async {
    await Isolate.spawn(fun, obj);
  }
}