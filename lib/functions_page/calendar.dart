import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:foca_app/functions_page/today.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';
import 'package:foca_app/functions_page/Spinner.dart';
import 'package:foca_app/pages/academico/classes.page.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;


// Pagina onde mostra o calendario, busca todas as materias e lembretes do Firebase
// e mostra de acordo com o dia selecionado no calendario
class CalendarWidget extends StatefulWidget{
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _currentDate = DateTime.now();

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
                        ListView(
                        children: <Widget>[
                            CalendarCarousel(
                            markedDateIconMaxShown: 1,
                            todayButtonColor: Colors.red[200],
                            thisMonthDayBorderColor: Colors.grey,
                            selectedDateTime: _currentDate,
                            height: 420.0,
                            daysHaveCircularBorder: null,
                            selectedDayButtonColor: Colors.red,
                            onDayPressed: (DateTime date, List<Events> events) {
                              this.setState(() => _currentDate = date);
                            },
                            ),
                          ],
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                        ),
                        _loadClassesOfDay(_currentDate.weekday),
                        Divider(),
                        _buildEventsAcademic(_currentDate),
                        Divider(),
                        _buildEventsPersonal(_currentDate),
                        Divider(),
                        _buildEventsWork(_currentDate),
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


  //compareTheDates

  bool compareDates(int dia, int diaComparar) {
    if(dia != null){
      bool today = compareTheDates(dia, diaComparar);
      if (today) {
        return true;
      }
    }
    return false;
  }

  Widget _loadClassesOfDay(int day){
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
                      if(compareDates(doc['dia'], day) ){
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


  Widget _buildEventsAcademic(DateTime compareDate) {
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
                  if(doc['data'] == (DateFormat('dd/MM/yyyy').format(compareDate)).toString()){
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
                            child: Container(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
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

  Widget _buildEventsPersonal(DateTime compareDate) {
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
                  if(doc['data'] == (DateFormat('dd/MM/yyyy').format(compareDate)).toString()){
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
                            child: Container(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Column(
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

  Widget _buildEventsWork(DateTime compareDate) {
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
                  if(doc['data'] == (DateFormat('dd/MM/yyyy').format(compareDate)).toString()){
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
                            child: Container(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
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


class Events{
  String testando;
  Events(this.testando);
}

