import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';

final databaseReference = Firestore.instance.collection("Grupos");

class CriarGruposWidget extends StatefulWidget{
  _CriarGruposWidgetState createState() => _CriarGruposWidgetState();
}

//Classe do formulario para a criacao de um novo grupo

class _CriarGruposWidgetState extends State<CriarGruposWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String titulo;
  
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text('Criar um grupo'),
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
      TextFormField( //Campo especifico para nomear o novo grupo
        maxLength: 20,
        decoration: InputDecoration(
            labelText: 'Nome do Grupo'
        ),

        validator: (String value){
            if(value.length == 0){ //Valida o tamanho do nome do grupo
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
        child: Text('Criar',
              style: TextStyle(
                color: Colors.white,
              ),
        ),
        onPressed: () async {
          _validateInputs(); //Verifica 
          if(!_autoValidate){
            await createRecord(); //Chama a funcao para criar novo grupo
            Navigator.pop(context,titulo);
          };
        } 
      ),
    ],
  );


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

  void createRecord() async { //Funcao para adicionar um novo grupo no BD
    String idGrupo;

    await databaseReference.add({ //Adiciona um novo grupo no BD
      'Membros': [usuario.uid],
      'nome': titulo,
      'participantes': 1,
      'idGrupo': "a",
    }).then((value){idGrupo  = value.documentID;}); 

    await databaseReference.document(idGrupo).updateData({"idGrupo": idGrupo}); //Atualiza a identificacao do grupo
  }
}


