import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:mobx/mobx.dart';
import 'package:pdf_samples/core/download_util.dart';

part 'pdf_view_model.g.dart';

class PdfViewModel = PdfViewModelState with _$PdfViewModel;

abstract class PdfViewModelState with Store {

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
    await _download(true).whenComplete(() async {
      await fetch(
          _url,
          path,
          (doc) => _document = doc);
    });
  }

  /// download file to be share (only ios) or to be stored into local device document file
  Future downloadPdfFile(bool isPrivate) async {
    await _download(false);
  }

  Future _download(bool isPrivate) async {
    await downloadFile(
        url: _url,
        filename: _filename,
        isPrivate: isPrivate,
        onSuccess: (success, path) => {
          _isFailure = !success,
          _path = path,
          print('downloadFileFromUrl SUCCESS $success $path'),
        },
        onError: (error) => {
          _isFailure = true,
          print('downloadFileFromUrl FAILURE $_isFailure $error')
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