import 'package:flutter/material.dart';
import 'item.home.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:foca_app/notification/firebase_notification_handler.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';
import 'package:foca_app/functions_page/Spinner.dart';
import 'package:foca_app/functions_page/today.dart';
import 'package:foca_app/pages/academico/classes.page.dart';

class MeuDiaWidget extends StatefulWidget{
  MeuDiaWidget ({Key key}): super (key:key);
  _MeuDiaWidgetState createState() => _MeuDiaWidgetState();
}

class _MeuDiaWidgetState extends State<MeuDiaWidget> {

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                    children: <Widget>[
                      HeadingHome(),
                      _loadClassesOfDay(),
                      Divider(),
                      _buildEventsAcademic(),
                      Divider(),
                      _buildEventsPersonal(),
                      Divider(),
                      _buildEventsWork()
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

  bool isToday(int dia) {
    if(dia != null){
      bool today = isItToday (dia);
      if (today) {
        return true;
      }
    }
    return false;
  }

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
                    itemBuilder: (context, index) {
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

  Widget _buildEventsAcademic() {
    return StreamBuilder(
      stream: Firestore.instance.collection('LembreteAcademico').where('refUser', isEqualTo: usuario.uid).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) { //Builder: O que fazer com os dados
        if(snapshot.data == null){
          return Spinner();
        }else if (!snapshot.hasData || snapshot.data.documents.length == 0) {
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
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data.documents[index];// Retorna a lista de elementos
                  if(doc['data'] == (DateFormat('dd/MM/yyyy').format(new DateTime.now())).toString()){
                    return AnimatedOpacity(
                      opacity: !doc['check'] ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(1.0),
                              border: Border(left: BorderSide(color: Colors.red,width: 4))
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
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
                                        updateEvent('LembreteAcademico',doc, context);
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
            ],
          );
        }
      },
    );
  }

  Widget _buildEventsPersonal() {
    return StreamBuilder(
      stream: Firestore.instance.collection('LembretePessoal').where('refUser', isEqualTo: usuario.uid).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) { //Builder: O que fazer com os dados
        if(snapshot.data == null){
          return Spinner();
        }else if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Container(
              constraints: BoxConstraints.expand(height: 200),
              alignment: Alignment.topCenter,
              child: Image.asset('assets/foquinhas/focavetorizadapessoal.png',
                  fit: BoxFit.cover)
          );
        }else if(snapshot.data != null){
          return Column(
            children: <Widget>[
              ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data.documents[index];// Retorna a lista de elementos
                  if(doc['data'] == (DateFormat('dd/MM/yyyy').format(new DateTime.now())).toString()){
                    return AnimatedOpacity(
                    opacity: !doc['check'] ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(1.0),
                          border: Border(left: BorderSide(color: Colors.blue,width: 4))
                        ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
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
                                        'LembretePessoal').document(
                                        doc.documentID).updateData(
                                        {'check': true});
                                  });
                                  if (e) {
                                    updateEvent('LembretePessoal',doc, context);
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
                                    Text(' '+ doc['hora'],
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
                                Text(doc['category'],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
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
            ],
          );
        }
      },
    );
  }

  Widget _buildEventsWork() {
    return StreamBuilder(
      stream: Firestore.instance.collection('LembreteProfissional').where('refUser', isEqualTo: usuario.uid).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) { //Builder: O que fazer com os dados
        if(snapshot.data == null){
          return Spinner();
        }else if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Container(
              constraints: BoxConstraints.expand(height: 200),
              alignment: Alignment.topCenter,
              child: Image.asset('assets/foquinhas/focavetorizadaprofissional.png',
                  fit: BoxFit.cover)
          );
        }else if(snapshot.data != null){
          return Column(
            children: <Widget>[
              ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data.documents[index];// Retorna a lista de elementos
                  if(doc['data'] == (DateFormat('dd/MM/yyyy').format(new DateTime.now())).toString()){
                    return AnimatedOpacity(
                      opacity: !doc['check'] ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(1.0),
                              border: Border(left: BorderSide(color: Colors.amber,width: 4))
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
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
                                            'LembreteProfissional').document(
                                            doc.documentID).updateData(
                                            {'check': true});
                                      });
                                      if (e) {
                                        updateEvent('LembreteProfissional',doc, context);
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
                                    Text(doc['category'],
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
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
            ],
          );
        }
      },
    );
  }


}

void updateEvent(String nome, DocumentSnapshot doc, BuildContext context) async {
  Future.delayed(Duration(milliseconds: 950),(){
    Firestore.instance.collection(nome).document(doc.documentID).delete();
  });
}

