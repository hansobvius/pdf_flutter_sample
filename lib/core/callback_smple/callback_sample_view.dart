import 'package:flutter/material.dart';

typedef void ReturnCallback<T>(T value);

class TestTest extends StatefulWidget {

  @override
  _TestTestState createState() => _TestTestState();
}

class _TestTestState extends State<TestTest> {

  bool _booleanValue = false;

  _action() {
    _booleanValue = !_booleanValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'value $_booleanValue'
        ),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: TestTestA()),
          Expanded(
              flex: 1,
              child: TestTestB(
                 callback: (value) {
                   print('CLICKED CLICKED CALLBACK');
                   _action();
                 },
              ))
        ],
      ),
    );
  }
}

class TestTestA extends StatefulWidget {

  @override
  _TestTestStateA createState() => _TestTestStateA();
}

class _TestTestStateA extends State<TestTestA> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Text(
            'TestTestStateA',
              style: TextStyle(
                color: Colors.white
              ),
        ),
      ),
    );
  }
}

class TestTestB extends StatefulWidget {

  final ReturnCallback<bool> callback;

  TestTestB({this.callback});

  @override
  _TestTestStateB createState() => _TestTestStateB();
}

class _TestTestStateB extends State<TestTestB> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('CLICKED CLICKED TAP');
        widget.callback(true);
      },
      child: Container(
        color: Colors.black,
        child: Center(
          child: Text(
              'TestTestStateB',
              style: TextStyle(
                  color: Colors.white
              ),
          ),
        ),
      ),
    );
  }
}


