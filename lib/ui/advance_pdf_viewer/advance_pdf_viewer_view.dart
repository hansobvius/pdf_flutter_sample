import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pdf_samples/core/download_util.dart';

import 'pdf_view_model.dart';


class AdvancePdfViewerView extends StatefulWidget {

  @override
  _AdvancePdfViewerViewState createState() => _AdvancePdfViewerViewState();
}

class _AdvancePdfViewerViewState extends State<AdvancePdfViewerView> {

  final String pdf1 = 'https://componentsdev.edtech.com.br/api/files-api/v1/AzFiles/html/BancoDoBrasilV5/Conteudo/Certificados/Usuarios/226420/certificado-orientacao-profissional-autoconhecimento.pdf';
  final String pdf2 = 'https://appatena.atenalms.com.br/certificadoflash/modelo.asp?chave=391B70497F0CECE291C5C571114221103799F2B9249CA5EC2726B015F23F51E3FDD2BF47204DCFD154F371F890';
  final PageController _pageController = PageController();

  // final PdfViewModel _pdfViewModel = PdfViewModel(this.AdvancePdfViewerView());

  bool _isFailure = false;

  String _path;
  PDFDocument _document;

  @override
  void initState() {
    super.initState();
    downloadFileFromUrl(pdf1, true);
  }

  void rebuild() {
    this.setState(() {
      print('STATE REBUILD');
    });
  }

  Future downloadFileFromUrl(String url, bool isPrivate) async {

    String filename = _generateFilename(url);

    await downloadFile(
        url: url,
        filename: filename,
        isPrivate: isPrivate,
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
    String filename = removeSpecialChar(split).toLowerCase().replaceAll(" ", "").split('.')[0] + '.pdf';
    print('FILENAME $filename');
    return filename;
  }

  Future _shareFile() async {
    print('PRINT FILE');
    if(Platform.isAndroid) {
      _downloadFile();
    } else await shareFile();
  }

  Future shareFile() async {
    String fileTitle = pdf1
        .split('/').last
        .split('.').first
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');
    File file = File(_path + "/" + _generateFilename(pdf1));
    print('FILE_SHARE ${file.toString()}');
    await FlutterShare.shareFile(
      title: fileTitle,
      text: 'Example share text',
      fileType: '.pdf',
      filePath: file.path,
    );
  }

  Future _downloadFile() async {
    downloadFileFromUrl(pdf1, false);
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

  @override
  void dispose() {
    super.dispose();
  }
}