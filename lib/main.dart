import 'package:flutter/material.dart';
import 'package:pdf_samples/ui/advance_pdf_viewer/ui/advance_pdf_viewer_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: AdvancePdfViewerView(),
    );
  }
}

