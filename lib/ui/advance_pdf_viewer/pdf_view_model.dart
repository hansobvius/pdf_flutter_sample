import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdf_samples/core/download_util.dart';

class PdfViewModel {

  final PdfViewModel instance = PdfViewModel();
  PdfViewModel get pdfViewModel => this.instance;

  PDFDocument _document;
  PDFDocument get pdfDocument => _document;

  File _file;
  File get file => _file;

  String _url = '';
  String get url => _url;

  String _path = '';
  String get path => _path;

  String _filename = '';
  String get filename => _filename;

  bool _isFailure = false;
  bool get isFailure => _isFailure;

  Future openPdfFile(String url) async {
    _url = url;
    _file = await File(path + "/" + _generateFilename(_url)).create(recursive: true);
    _filename = _generateFilename(url);
    await _download(true).whenComplete(() async {
      await fetch(url, path, (doc) => _document = doc);
    });
  }

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
    PDFDocument doc = await PDFDocument.fromFile(_file);
    document(doc);
  }

  Future fetch(String url, String path, Function(PDFDocument doc) pdfDocument) async =>
      await _fetch(url, path, (document) => pdfDocument(document));

  String _generateFilename(String fullUrl) {
    String split = fullUrl.split('/').last;
    String filename = removeSpecialChar(split).toLowerCase().replaceAll(" ", "").split('.')[0] + '.pdf';
    print('FILENAME $filename');
    return filename;
  }

  void dispose() async {
    await _file.delete();
  }
}