/*
  Classe responsável pela seleção da cor
  que representará a nova categoria.
*/

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';

class SelectColorPickerDialog extends StatefulWidget{
  final Color currentColor;

  SelectColorPickerDialog ({Key key, this.currentColor}): super (key: key);

  @override
  _SelectColorPickerDialogState createState() => _SelectColorPickerDialogState();
}

class _SelectColorPickerDialogState extends State<SelectColorPickerDialog>{
  Color _color;

  @override
  void initState(){
    super.initState();
    _color = widget.currentColor;
  }

  Widget build(BuildContext context){
    return AlertDialog(
      title: Text('Selecionar Cor'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: _color,
          onColorChanged: (Color color){
            setState(() {
              _color = color;
            });
          },
        ),
      ),
      actions: <Widget>[

        FlatButton(
          child: Text('OK'),
          onPressed: (){
            Navigator.pop(context,_color);
          },
        )
      ],

    );
  }
}