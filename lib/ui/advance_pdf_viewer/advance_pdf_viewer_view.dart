import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'pdf_view_model.dart';


class AdvancePdfViewerView extends StatefulWidget {

  @override
  _AdvancePdfViewerViewState createState() => _AdvancePdfViewerViewState();
}

class _AdvancePdfViewerViewState extends State<AdvancePdfViewerView> {

  final String pdf1 = 'https://componentsdev.edtech.com.br/api/files-api/v1/AzFiles/html/BancoDoBrasilV5/Conteudo/Certificados/Usuarios/226420/certificado-orientacao-profissional-autoconhecimento.pdf';
  final String pdf2 = 'https://appatena.atenalms.com.br/certificadoflash/modelo.asp?chave=391B70497F0CECE291C5C571114221103799F2B9249CA5EC2726B015F23F51E3FDD2BF47204DCFD154F371F890';

  final PageController _pageController = PageController();
  final PdfViewModel _pdfViewModel = PdfViewModel();

  @override
  void initState() {
    super.initState();
    _pdfViewModel.openPdfFile(pdf1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advance PDF Viewer'),
        actions: [
          IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () => _pdfViewModel.downloadPdfFile(false)
          )
        ]
      ),
      body: Center(
        child: Observer(
          builder: (BuildContext context) {
            if (_pdfViewModel.pdfDocument != null) {
              return PDFViewer(
                document: _pdfViewModel.pdfDocument,
                zoomSteps: 1,
                showPicker: true,
                lazyLoad: false,
                controller: _pageController,
                onPageChanged: (page) {
                  print('PDF PAGE CHANGED $page');
                },
              );
            }
            if(_pdfViewModel.isFailure) {
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
    _pdfViewModel.dispose();
    super.dispose();
  }
}