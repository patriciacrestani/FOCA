/*
Classe responsavel para obter os dados do
nome da categoria e a cor que a representará.
*/

import 'package:flutter/material.dart';
import 'package:foca_app/pages/financeiro/estilo/const.dart';
import 'package:foca_app/pages/financeiro/estilo/select.color.picker.dart';

class CreateCategory extends StatefulWidget{
  CreateCategory ({Key key}) : super (key: key);
  _CreateCategoryState createState() => _CreateCategoryState();

}

class _CreateCategoryState extends State<CreateCategory>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  String _name = '';
  Color _currentColor = BLUE;

  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child:
      AlertDialog(
        title: Text('Nova Categoria'),
        content: Row(
          children: <Widget>[
            Flexible(
                flex: 4,
                child:
                TextFormField(
                  maxLength: 30,
                  decoration: InputDecoration(
                      labelText: 'Nome'
                  ),
                  validator: (String value){
                    if(value.length == 0){
                      return 'Este campo não pode ficar vazio';
                    }
                    return null;
                  },
                  onSaved: (String value){
                    _name = value;
                  },
                )
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
            ),

            Flexible(
                child:
                FlatButton(
                  color: _currentColor,
                  shape: CircleBorder(),
                  child: null,
                  onPressed: selectColor,
                )
            )
          ],
        ),

        actions: <Widget>[
          FlatButton(
            child: Text('CANCELAR'),
            onPressed: (){
              Navigator.pop(context, null);
            },
          ),

          FlatButton(
            child: Text('OK'),
            onPressed: (){
              _validateInputs();

              if(!_autovalidate) {
                Navigator.pop(context, [_name, _currentColor]);
              }
            },
          )
        ],
      ),
    );
  }

  //Função que seleciona a cor
  void selectColor() async{
    final selectedColor = await showDialog<Color>(
        context: context,
        builder: (BuildContext context) => SelectColorPickerDialog(currentColor: _currentColor,)
    );

    if(selectedColor != null){
      setState((){
        _currentColor = selectedColor;
      });
    }
  }

  void _validateInputs(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      _autovalidate = false;

    }else{
      setState(() {
        _autovalidate = true;
      });
    }
  }

}