import 'package:flutter/material.dart';
import 'package:pdf_samples/ui/advance_pdf_viewer/advance_pdf_viewer_view.dart';

import 'core/callback_smple/callback_sample_view.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Samples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestTest(),
    );
  }
}

