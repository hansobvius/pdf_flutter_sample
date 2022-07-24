import 'package:flutter/material.dart';

abstract class BaseStatefulWidget<T> extends StatefulWidget {

  final Widget baseWidget;

  BaseStatefulWidget(this.baseWidget);

  @override
  _BaseStatefulWidget<T> createState() {
    return _BaseStatefulWidget<T>();
  }
}

class _BaseStatefulWidget<T> extends State<BaseStatefulWidget<T>> {

  @override
  Widget build(BuildContext context) {
    return widget.baseWidget;
  }
}