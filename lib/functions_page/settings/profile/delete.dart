import 'package:flutter/material.dart';

//
//Esta classe é responsável pelo Dialog de Exclusão de Perfil
//

class DeleteDialog extends StatefulWidget{
	DeleteDialogState createState() => DeleteDialogState();
}

class DeleteDialogState extends State<DeleteDialog>{

  //
  //Aqui criamos o Widget por assim dizer
  //


  Widget build(BuildContext context) => AlertDialog(
		title: Text('Tem certeza que quer excluir sua conta?'),
		actions: <Widget>[
          FlatButton(
            child: Text('NÃO'),
            onPressed: (){
              Navigator.pop(context);
            },
          ),

          FlatButton(
            child: Text('SIM'),
            onPressed: (){
                Navigator.pop(context);
            },
          )
        ],
	);
}