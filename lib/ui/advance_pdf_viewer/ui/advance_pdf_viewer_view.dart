import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../view_model/pdf_view_model.dart';


class AdvancePdfViewerView extends StatefulWidget {

  @override
  _AdvancePdfViewerViewState createState() => _AdvancePdfViewerViewState();
}

class _AdvancePdfViewerViewState extends State<AdvancePdfViewerView> {

  /// Put a PDF valid url path
  final String pdf = '';

  final PageController _pageController = PageController();
  final PdfViewModel _pdfViewModel = PdfViewModel();

  @override
  void initState() {
    super.initState();
    _pdfViewModel.openPdfFile(pdf);
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