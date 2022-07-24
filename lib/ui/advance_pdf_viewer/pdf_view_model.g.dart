// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PdfViewModel on PdfViewModelState, Store {
  final _$_documentAtom = Atom(name: 'PdfViewModelState._document');

  @override
  PDFDocument get _document {
    _$_documentAtom.reportRead();
    return super._document;
  }

  @override
  set _document(PDFDocument value) {
    _$_documentAtom.reportWrite(value, super._document, () {
      super._document = value;
    });
  }

  final _$_isFailureAtom = Atom(name: 'PdfViewModelState._isFailure');

  @override
  bool get _isFailure {
    _$_isFailureAtom.reportRead();
    return super._isFailure;
  }

  @override
  set _isFailure(bool value) {
    _$_isFailureAtom.reportWrite(value, super._isFailure, () {
      super._isFailure = value;
    });
  }

  final _$openPdfFileAsyncAction = AsyncAction('PdfViewModelState.openPdfFile');

  @override
  Future<dynamic> openPdfFile(String url) {
    return _$openPdfFileAsyncAction.run(() => super.openPdfFile(url));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
