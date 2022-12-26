import 'dart:io';
import 'dart:isolate';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:mobx/mobx.dart';
import 'package:pdf_samples/core/download_util.dart';
import 'package:pdf_samples/core/pdf_object.dart';
import 'package:pdf_samples/worker/work_manager/work_manager.dart';

part 'pdf_view_model.g.dart';

class PdfViewModel = PdfViewModelState with _$PdfViewModel;

abstract class PdfViewModelState with Store {

  static const bool SUCCESS = true;
  static const bool FAILURE = false;

  File _file;
  File get file => _file;

  String _url = '';
  String get url => _url;

  String _path = '';
  String get path => _path;

  String _filename = '';
  String get filename => _filename;

  @observable
  PDFDocument _document;
  PDFDocument get pdfDocument => _document;

  @observable
  bool _isFailure = false;
  bool get isFailure => _isFailure;

  /// download file and initialize pdf document obj to be rendered
  @action
  Future openPdfFile(String url) async {
    _url = url;
    _filename = _generateFilename(_url);

    _download(true);

    await _download(true).whenComplete(() async {

    });
  }

  /// download file to be share (only ios) or to be stored into local device document file
  Future downloadPdfFile(bool isPrivate) async {
    await _download(false);
  }

  Future _download(bool isPrivate) async {

    var worker = WorkerManager.instance;

    var port = ReceivePort();
    var pdfObject = PdfObject('PDF_SAMPLE', _url, _filename, isPrivate, port.sendPort);

    worker.runIsolate(obj: pdfObject, fun: pdfRunnable);

    port.listen((message) async {
      if (message == SUCCESS) {
        _path = pdfObject.path;
        _isFailure = false;
        await fetch(_url, path, (doc) => _document = doc);
        print('downloadFileFromUrl SUCCESS');
      }

      if (message == FAILURE) {
        _isFailure = true;
        print('downloadFileFromUrl FAILURE');
      }
    });
  }

  static void pdfRunnable(PdfObject pdfObject) {
    downloadFile(
        url: pdfObject.url,
        filename: pdfObject.filename,
        isPrivate: pdfObject.isPrivate,
        onSuccess: (success, path) => {
          pdfObject
            ..path = path
            ..sendPort.send(SUCCESS)
        },
        onError: (error) => {
          pdfObject.sendPort.send(FAILURE)
        });
  }

  Future _fetch(String url, String path, Function(PDFDocument doc) document) async {
    File file = await File(path + "/" + _generateFilename(url)).create(recursive: true);
    _file = file;
    PDFDocument doc = await PDFDocument.fromFile(_file)..preloadPages();
    document(doc);
  }

  Future fetch(String url, String path, Function(PDFDocument doc) pdfDocument) async =>
      await _fetch(url, path, (document) {
        pdfDocument(document);
      });

  String _generateFilename(String fullUrl) {
    String split = fullUrl.split('/').last;
    String filename = removeSpecialChar(split).toLowerCase().replaceAll(" ", "").split('.')[0] + '.pdf';
    print('FILENAME $filename');
    return filename;
  }

  void dispose() async {
    await _file.delete();
    _file = null;
  }
}