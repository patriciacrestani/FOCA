import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


import 'package:foca_app/functions_page/Spinner.dart';
import 'package:foca_app/pages/login/login.dart';
import 'Classes.dart';
import 'package:foca_app/functions_page/today.dart';
import 'add.classes.dart';
import 'event.dart';
import 'add.event.dart';
import 'heading.items.events.dart';
import 'classes.page.dart';
import 'heading.items.classes.dart';

//
//Este arquivo é responsável pelo widget do Academico
//

class AcademicWidget extends StatefulWidget{
  AcademicWidget ({Key key}): super (key:key);
  _AcademicWidgetState createState() => _AcademicWidgetState();
}

//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//

class _AcademicWidgetState extends State<AcademicWidget> {

  Color _backgroundDial = Colors.red;
  Color _foregroundDial = Colors.white;
  Icon _iconDial = Icon(Icons.add);
  String day = DateFormat.yMMMd().format(new DateTime.now());

  //
  //O initState insere esta aba na árvore de renderização, ou seja, pede para renderizar esta página, assim que ela é instanciada.
  //

  @override
  void initState() {
    super.initState();
  }


  //
  //Aqui é onde é criado o Widget por assim dizer
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: menuButton(),
      body: SafeArea(
        child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        HeadingItemsClasses(),
                        _loadClassesOfDay(),
                        //_buildClasses(),
                        HeadingItemsEvents(),
                        _buildEvents(),
                      ],
                    ),
                  ),
                ]),
              ),
            ]
        ),
      ),
    );
  }

  //
  //Aqui é criado o botão flutuante de adicionar matéria ou lembrete
  //

  SpeedDial menuButton() {
    return SpeedDial(

      animatedIcon: null,
      animatedIconTheme: IconThemeData(size: 30.0),

      child: _iconDial,

      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,

      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: _backgroundDial,
      foregroundColor: _foregroundDial,
      elevation: 8.0,


      // As Funções onOpen e onClose fazem a animação de cores e ícones do App
      onOpen: () {
        setState(() {
          _backgroundDial = Colors.white;
          _foregroundDial = Colors.red;
          _iconDial = Icon(Icons.clear);
        });
      },

      onClose: () {
        setState(() {
          _backgroundDial = Colors.red;
          _foregroundDial = Colors.white;
          _iconDial = Icon(Icons.add);
        });
      },

      // Aqui fica a coleção de opções
      children: [

        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.redAccent,
          label: 'Lembrete',

          onTap: () async {
            awaitValue(false, context);
          },
        ),


        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
          label: 'Matéria',

          onTap: () async {
            awaitValue(true, context);
          },
        ),
      ],
    );
  }

  //
  //Aqui é a rota é encaminhada para o formulário
  //

  void awaitValue(bool flag, BuildContext context) async {
    var result;
    if (flag) {
      result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddClassesWidget()));
    } else {
      result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddEventWidget()));
    }
  }

  //
  //Aqui é verificado se o dia da semana é igual ao dia da matéria e retorna true se for, e false senão
  //

  bool isToday(int dia) {
    if(dia != null){
      bool today = isItToday (dia);
      if (today) {
        return true;
      }
    }
    return false;
  }

  //
  //Aqui é criado o Widget das classes do dia, somente as dos dias
  //

  Widget _loadClassesOfDay(){
    return StreamBuilder(
      stream: Firestore.instance.collection('Materia').where('refUser', isEqualTo: usuario.uid).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.data == null) {
          return Spinner();
        }else if(!snapshot.hasData || snapshot.data.documents.length == 0){
          return Container(
              constraints: BoxConstraints.expand(height: 200),
              alignment: Alignment.topCenter,
              child: Image.asset('assets/foquinhas/focavetorizadaacademica.png',
                  fit: BoxFit.cover)
          );
        }else if(snapshot.data != null){
          return Column(
              children: <Widget>[
              ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext  context, int index) {
                  DocumentSnapshot doc = snapshot.data.documents[index];
                  if(isToday(doc['dia'])){
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
                  }else{
                    return Container(
                      height: 0.0,
                      width: 0.0,
                    );
                  }
                },
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
             ]
          );
        }
      }
    );

  }

  //
  //Aqui é criado o Widget dos lembretes, todos os lembretes do Academico
  //

  Widget _buildEvents() {
    return StreamBuilder(
      stream: Firestore.instance.collection('LembreteAcademico').where('refUser', isEqualTo: usuario.uid).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) { //Builder: O que fazer com os dados
        if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Container(
              constraints: BoxConstraints.expand(height: 200),
              alignment: Alignment.topCenter,
              child: Image.asset('assets/foquinhas/focavetorizadaacademica.png',
                  fit: BoxFit.cover)
          );
        }else{
          return Column(
            children: <Widget>[
              ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data.documents[index]; // Retorna a lista de elementos

                  return AnimatedOpacity(
                    opacity: !doc['check'] ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                                value: doc['check'],
                                activeColor: Colors.red,
                                checkColor: Colors.white,
                                onChanged: (
                                    bool e) { //Verifica se está checado ou não
                                  setState(() {
                                    Firestore.instance.collection(
                                        'LembreteAcademico').document(
                                        doc.documentID).updateData(
                                        {'check': true});
                                  });
                                  if (e) {
                                    updateEvent(doc, context);
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'FOCA no lembrete concluído!'),
                                          duration: Duration(seconds: 1),
                                          backgroundColor: Colors.red,
                                        ));
                                  }
                                }),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(doc['titulo'],
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(' '+doc['hora'],
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(doc['data'],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(doc['descricao'],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.clip,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ],
          );
        }
      },
    );
  }

}

//
//Esta função espera 950 milisegundos (tempo para finalizar a animção) e retira o dado do banco de dados
//

void updateEvent(DocumentSnapshot doc, BuildContext context) async {
    Future.delayed(Duration(milliseconds: 950),(){
      Firestore.instance.collection('LembreteAcademico').document(doc.documentID).delete();
    });
}

