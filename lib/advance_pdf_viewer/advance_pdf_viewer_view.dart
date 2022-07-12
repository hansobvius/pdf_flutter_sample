import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

import '../download_util.dart';

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
  String pdf4 = 'https://lmsed.atenalms.com.br:443/api/main/appatena/media/download?mediaId=115&ignoreHistory=true&forceView=true&accessToken=0156417B760BA0B794C9C865154C0B300AAD82CE5490A2F73456D57487492B9683A4B7422A2CB4A72DE26182CAD6CB98A07E41DD707CB46CE7F5D785A42324FB014EF2B8FA71F8249BCA3E17D7774CB1DD2E88FAC0A6&AuthorizationToken=424D2D74224FB7BA9AC5C2710335';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  _fetch() async {
    PDFDocument doc = await PDFDocument.fromURL(pdf1);
    await downloadFileFromUrl(pdf1);
    setState(() {
      _document = doc..preloadPages();
    });
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

  Future downloadFileFromUrl(String url) async {

    String filename = removeSpecialChar('certificado').toLowerCase().replaceAll(" ", "") + ".pdf";

    print('downloadFileFromUrl');

    bool isSuccess;

    bool verifyPermission = await _checkPermission();

    if (!verifyPermission) {
      return;
    }

    await downloadFile(
        url: url,
        filename: filename,
        isPrivate: false,
        onSuccess: (success, path) => {
          isSuccess = true,
          print('downloadFileFromUrl SUCCESS $isSuccess')
        },
        onError: (error) => {
          isSuccess = false,
          print('downloadFileFromUrl SUCCESS $isSuccess')
        }
    );
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
        //     : PDFViewer(
        //         document: _document,
        //         zoomSteps: 1,
        //         showPicker: true,
        //         lazyLoad: false,
        //         controller: _pageController,
        //         onPageChanged: (page) {
        //          print('PDF PAGE CHANGED $page');
        //   },
        // )
            : PdfView(path: pdf4)
      ),
    );
  }
}