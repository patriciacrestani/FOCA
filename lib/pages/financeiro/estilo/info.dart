import 'package:flutter/material.dart';

class InformationWidget extends StatefulWidget{
  final String text;
  InformationWidget({Key key, this.text}) : super (key:key);

  _InformationWidgetState createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget>{
  
  String _text;

  void initState(){
    super.initState();
    _text = widget.text;
  }

  Widget build(BuildContext context){
    return AlertDialog(
        content: SingleChildScrollView(
          child: Text(_text),
        ),
    );
  }
  
  
}