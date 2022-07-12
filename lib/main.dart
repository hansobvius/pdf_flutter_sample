import 'package:flutter/material.dart';

import 'advance_pdf_viewer/advance_pdf_viewer_view.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Samples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdvancePdfViewerView(),
    );
  }
}

