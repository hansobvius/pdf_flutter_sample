import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdf_samples/core/download_util.dart';
import 'package:permission_handler/permission_handler.dart';


class AdvancePdfViewerView extends StatefulWidget {

  @override
  _AdvancePdfViewerViewState createState() => _AdvancePdfViewerViewState();
}

class _AdvancePdfViewerViewState extends State<AdvancePdfViewerView> {

  PDFDocument _document;
  PageController _pageController = PageController();

  String pdf1 = 'https://componentsdev.edtech.com.br/api/files-api/v1/AzFiles/html/BancoDoBrasilV5/Conteudo/Certificados/Usuarios/226420/certificado-orientacao-profissional-autoconhecimento.pdf';
  String pdf2 = 'http://conorlastowka.com/book/CitationNeededBook-Sample.pdf';
  String pdf3 = 'https://web.archive.org/web/20150415215806/http://www.objectmentor.com/resources/articles/ocp.pdf';
  String pdf4 = 'https:lmsed.atenalms.com.br:443/api/main/appatena/media/download?mediaId=115&ignoreHistory=true&forceView=true&accessToken=0156417B760BA0B794C9C865154C0B300AAD82CE5490A2F73456D57487492B9683A4B7422A2CB4A72DE26182CAD6CB98A07E41DD707CB46CE7F5D785A42324FB014EF2B8FA71F8249BCA3E17D7774CB1DD2E88FAC0A6&AuthorizationToken=424D2D74224FB7BA9AC5C2710335';

  @override
  void initState() {
    super.initState();
    downloadFileFromUrl(pdf1);
  }

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

  Future downloadFileFromUrl(String url) async {

    String filename = removeSpecialChar('certificado').toLowerCase().replaceAll(" ", "") + ".pdf";

    bool isSuccess;

    bool verifyPermission = await _checkPermission();

    if (!verifyPermission) {
      return;
    }

    await downloadFile(
        url: url,
        filename: filename,
        isPrivate: true,
        onSuccess: (success, path) => {
          isSuccess = true,
          print('downloadFileFromUrl SUCCESS $success $path'),
          _fetch(path),
        },
        onError: (error) => {
          isSuccess = false,
          print('downloadFileFromUrl SUCCESS $isSuccess $error')
        }
    );
  }

  _fetch(String path) async {
    String filename = removeSpecialChar('certificado').toLowerCase().replaceAll(" ", "") + ".pdf";
    File file = await File(path + "/" + filename).create(recursive: true);
    PDFDocument doc = await PDFDocument.fromFile(file);
    setState(() {
      _document = doc..preloadPages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advance PDF Viewer')
      ),
      body: Center(
        child: _document == null
            ? Container(
              child: CircularProgressIndicator(),
            )
             : PDFViewer(
                 document: _document,
                 zoomSteps: 1,
                 showPicker: true,
                 lazyLoad: false,
                 controller: _pageController,
                 onPageChanged: (page) {
                  print('PDF PAGE CHANGED $page');
           },
         )
      ),
    );
  }
}