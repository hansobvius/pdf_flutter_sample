import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pdf_samples/core/download_util.dart';


class AdvancePdfViewerView extends StatefulWidget {

  @override
  _AdvancePdfViewerViewState createState() => _AdvancePdfViewerViewState();
}

class _AdvancePdfViewerViewState extends State<AdvancePdfViewerView> {

  final String pdf1 = 'https://componentsdev.edtech.com.br/api/files-api/v1/AzFiles/html/BancoDoBrasilV5/Conteudo/Certificados/Usuarios/226420/certificado-orientacao-profissional-autoconhecimento.pdf';
  final PageController _pageController = PageController();

  bool _isFailure = false;

  String _path;
  PDFDocument _document;


  @override
  void initState() {
    super.initState();
    downloadFileFromUrl(pdf1);
  }

  Future downloadFileFromUrl(String url) async {

    String filename = _generateFilename(url);

    await downloadFile(
        url: url,
        filename: filename,
        isPrivate: true,
        onSuccess: (success, path) => {
          _isFailure = !success,
          _path = path,
          print('downloadFileFromUrl SUCCESS $success $path'),
          _fetch(path),
        },
        onError: (error) => {
          _isFailure = true,
          print('downloadFileFromUrl FAILURE $_isFailure $error')
        }
    );
  }

  _fetch(String path) async {
    File file = await File(path + "/" + _generateFilename(pdf1)).create(recursive: true);
    PDFDocument doc = await PDFDocument.fromFile(file);
    setState(() {
      _document = doc..preloadPages();
    });
  }

  String _generateFilename(String fullUrl) {
    String split = fullUrl.split('/').last;
    String filename = removeSpecialChar(split).toLowerCase().replaceAll(" ", "");
    print('FILENAME $filename');
    return filename;
  }

  Future _shareFile() async {
    print('PRINT FILE');
    await shareFile();
  }

  Future shareFile() async {
    String fileTitle = pdf1
        .split('/').last
        .split('.').first
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');
    File file = File(_path + "/" + _generateFilename(pdf1));
    await FlutterShare.shareFile(
      title: pdf1.split('/').last,
      text: 'Example share text',
      fileType: '.pdf',
      filePath: file.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advance PDF Viewer'),
        actions: [
          IconButton(
              icon: Icon(Icons.share_outlined),
              onPressed: _shareFile
          )
        ]
      ),
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            if (_document != null) {
              return PDFViewer(
                document: _document,
                zoomSteps: 1,
                showPicker: true,
                lazyLoad: false,
                controller: _pageController,
                onPageChanged: (page) {
                  print('PDF PAGE CHANGED $page');
                },
              );
            }
            if(_isFailure) {
              return Container(
                child: Center(
                  child: Text('PDF unavailable!'),
                )
              );
            }
            return Container(
                child: CircularProgressIndicator(),
            );
          }
      ))
    );
  }
}