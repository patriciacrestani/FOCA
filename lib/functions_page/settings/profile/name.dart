import 'package:flutter/material.dart';

//
//Esta classe é responsável pelo AlertDialog de troca de nome
//

class NameDialog extends StatefulWidget{
	NameDialogState createState() => NameDialogState();
}

class NameDialogState extends State<NameDialog>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  String _name = '';

  //
  //Aqui criamos o Widget por assim dizer
  //

	Widget build(BuildContext context) => Form(
    key: _formKey,
    autovalidate: _autovalidate,
    child:
      AlertDialog(
          title: Text('Editar Nome:'),
          content: Row(
          children: <Widget>[
            Flexible(
                child:
                TextFormField(
                  maxLength: 100,
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
          ],
        ),
          actions: <Widget>[
                FlatButton(
                  child: Text('CANCELAR'),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),

                FlatButton(
                  child: Text('OK'),
                  onPressed: (){
                      Navigator.pop(context);
                  },
                )
              ],
        )
  );
  
}