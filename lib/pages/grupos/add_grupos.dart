import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';

class AdicionarGruposWidget extends StatefulWidget{
  _AdicionarGruposWidgetState createState() => _AdicionarGruposWidgetState();
}

//Formulario para entrar em algum grupo ja criado

class _AdicionarGruposWidgetState extends State<AdicionarGruposWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String codigo;

  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.purple,
      title: Text('Entrar em Grupo'),
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
        formUI(), //Exibe o formulario
      ),
    ),
  );

  Widget formUI() => ListView(
    children: <Widget>[
      TextFormField( //Campo especifico para inserir o codigo do grupo que o usuario deseja participar
          maxLength: 50,
          decoration: InputDecoration(
              labelText: 'Insira a chave do grupo'
          ),

          validator: (String value){
            if(value.length == 0){
              return 'Este campo não pode ficar vazio';
            }
            return null;
          },

          onSaved: (String value){ 
            codigo = value;
          }
      ),

      FlatButton(
          color: Colors.purple,
          child: Text('Entrar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            _validateInputs(); //Verifica validacao
            if(!_autoValidate){
              await updateRecord(); //Chama a funcao que adiciona o usuario em um grupo
              Navigator.pop(context, codigo);
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

  void updateRecord() async{  //Funcao que adiciona o usuario atual a um grupo existente
      List<String> idUser = [usuario.uid];
      int qtdParticipantes;
      DocumentReference databaseReference = Firestore.instance.collection("Grupos").document(codigo); //Procura o grupo que tem a chave primaria igual a codigo
      DocumentSnapshot documentSnapshot = await Firestore.instance.collection("Grupos").document(codigo).get(); //Recupera o contexto do grupo especificado
       if(documentSnapshot.data == null)
         _showDialogIfGroupDoesnExist();  //Se nao existe grupo com codigo informado chama o alertdialog
       else {
         print(idUser.toString());
         print(documentSnapshot.data.containsValue(idUser));
         if (!documentSnapshot.data.containsValue(idUser)) {  //Se grupo existir e o usuario ja nao estiver nele o adicionamos
           qtdParticipantes = documentSnapshot.data['participantes'] + 1;
           await databaseReference.updateData({
             "Membros": FieldValue.arrayUnion(idUser),
             "participantes": qtdParticipantes
           });
         }
         else
           _showDialogIfUserIsInGroup();  //Se o usuario ja estiver no grupo chama o alertdialog
       }

  }

  void _showDialogIfGroupDoesnExist() { //AlertDialog para quando o usuario tenta entrar num grupo que nao existe
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Erro ao entrar no grupo"),
          content: new Text("Parece que não existe nenhum grupo com o código indicado. Tente novamente."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogIfUserIsInGroup() { //AlertDialog para quando o usuario ja esta no grupo que ele quer entrar
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Erro ao entrar no grupo"),
          content: new Text("Parece que você já está inserido neste grupo!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}