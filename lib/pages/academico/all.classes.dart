import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:foca_app/pages/academico/add.classes.dart';
import 'package:foca_app/pages/login/login.dart';
import 'Classes.dart';
import 'classes.page.dart';

//
//Este arquivo é responsável pelo widget que mostra todas as matérias do Usuário
//

class AllClasses extends StatefulWidget{

  _AllClassesState createState() => _AllClassesState();
}

//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//

class _AllClassesState extends State<AllClasses> {

  //
  //O initState insere esta aba na árvore de renderização, ou seja, pede para renderizar esta página, assim que ela é instanciada.
  //


  void initState(){
    super.initState();
  }

  //
  //Aqui é onde é criado o Widget por assim dizer
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disciplinas"),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: (){
          awaitValue(context);
        },
      ),
      body: StreamBuilder(
    stream: Firestore.instance.collection('Materia').where(
        'refUser', isEqualTo: usuario.uid).snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) { //Builder: O que fazer com os dados
    if (!snapshot.hasData || snapshot.data.documents.length == 0) {
    return Container(
    constraints: BoxConstraints.expand(height: 200),
    alignment: Alignment.topCenter,
    child: Image.asset('assets/foquinhas/focavetorizadaacademica.png',
    fit: BoxFit.cover)
    );
    } else {
    return ListView.builder(
    itemCount: snapshot.data.documents.length,
    itemBuilder: (context, index) {
    DocumentSnapshot doc = snapshot.data
        .documents[index]; // Retorna a lista de elementos
    String s = doc['horaInicio'];
    String s1 = doc['horaFim'];

    return Card(
      child: ListTile(
      leading: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(int.parse(doc['cor'])),
            ),
            ),
      title: Text(doc['disciplina'], overflow: TextOverflow.clip,
      style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(s + '  -  ' + s1 + ', ' + doc['sala'],
      style: TextStyle(color: Colors.blueGrey, fontSize: 14)
      ),
      onTap: () async {
          bool flag = await Navigator.push(
          context, MaterialPageRoute(builder: (context) =>
          ClassesPage(
          doc['cor'],
          doc['dia'],
          doc['disciplina'],
          doc['horaInicio'],
          doc['horaFim'],
          doc['obs'],
          doc['professor'],
          doc['sala'],
          true)));
      if (flag) {
      Firestore.instance.collection('Materia').document(
      doc.documentID).delete();
      }
      },
      ),
      );
      },
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      );
      }
      }
      ),
    );
  }

  //
  //Esta função adiciona uma nova classe
  //

  void awaitValue(BuildContext context) async {
    var result;
    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddClassesWidget()));
  }


}