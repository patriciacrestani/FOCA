import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CriarTarefaWidget extends StatefulWidget{
  final idGrupo, widgetDoc;

  CriarTarefaWidget(this.idGrupo, this.widgetDoc);

  _CriarTarefaWidgetState createState() => _CriarTarefaWidgetState();
}

//Classe do formulario para a criacao de uma nova tarefa em um grupo

class _CriarTarefaWidgetState extends State<CriarTarefaWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String titulo;

  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar( 
      backgroundColor: Colors.purple,
      title: Text('Criar Tarefa'),
      actions: <Widget>[
        IconButton(
          icon: new Icon(Icons.more_vert),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
    body: Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child:
        formUI(),
      ),
    ),
  );

  Widget formUI() => ListView(
    children: <Widget>[
      TextFormField( //Campo especifico para nomear a nova tarefa
          maxLength: 30,
          decoration: InputDecoration(
              labelText: 'Nome da Tarefa' 
          ),

          validator: (String value){
            if(value.length == 0){ //Valida o tamanho do nome da tarefa
              return 'Este campo não pode ficar vazio';
            }
            return null;
          },

          onSaved: (String value){
            titulo = value;
          }
      ),

      FlatButton(
          color: Colors.purple,
          child: Text('Salvar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            _validateInputs();
            if(!_autoValidate){
              await createRecord();
              Navigator.pop(context,titulo);
            };
          }
      ),
    ],
  );

/*
  Função onde verifica se todos os valores foram inseridos
  de forma correta pelo usuário.
*/
  void _validateInputs(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      _autoValidate = false;

    }else{
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void createRecord() async{  //Salva tarefa no BD
    CollectionReference databaseReference = Firestore.instance.collection("TarefasGrupo");

    await databaseReference.add({
      'tarefa': titulo,
      'check': false,
      'criado': DateTime.now(),
      'idGrupo': widget.idGrupo,
    });
  }
}