import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'Classes.dart';

//
//Este arquivo é responsável pela tela que mostra os detalhes da Matéria selecionada
//

class ClassesPage extends StatefulWidget{

  String color;
  int day;
  String discipline;
  String timeBegin;
  String timeEnd;
  String obs;
  String teacher;
  String room;
  bool flag;

  ClassesPage(this.color, this.day, this.discipline, this.timeBegin, this.timeEnd, this.obs, this.teacher, this.room,this.flag);

  _ClassesPageState createState() => _ClassesPageState();
}


//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//

class _ClassesPageState extends State<ClassesPage> {

  //
  //O initState insere esta aba na árvore de renderização, ou seja, pede para renderizar esta página, assim que ela é instanciada.
  //

  void initState(){
    super.initState();
  }

  Map dates(int days){   //Verifica quais dias foram selecionados e retorna um Map com True ou False
    Map newClass = {'SUN':false, 'SAT':false, 'FRI':false, 'THU':false, 'WED':false, 'TUE':false, 'MON':false};
    days = days-1;
    for(int i= 128; i>=2; i= (i~/2)){
      days -= i;
      if(days < 0){
        days += i;
      } else {
        if(i == 128){
          newClass['SUN'] = true;
        }else if(i==64){
          newClass['SAT'] = true;
        }else if(i==32){
          newClass['FRI'] = true;
        }else if(i==16){
          newClass['THU'] = true;
        }else if(i==8){
          newClass['WED'] = true;
        }else if(i==4){
          newClass['TUE'] = true;
        }else if(i==2){
          newClass['MON'] = true;
        }
      }
    }
    return newClass;
  }

  //
  // Este Widget é o que mostra os dias da semana da Matéria
  //
  Widget daysSelected(Map weekdays){
    final days = <Widget>[];
    if(weekdays['MON']) {
      days.add(Text('SEG ', style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold)));
    }
    if(weekdays['TUE']) {
      days.add(Text('TER ', style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['WED']) {
      days.add(Text('QUA ', style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['THU']) {
      days.add(Text('QUI ', style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['FRI']) {
      days.add(Text('SEX ', style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['SAT']) {
      days.add(Text('SAB ', style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['SUN']) {
      days.add(Text('DOM '),);
    }
    return Row(
      children: days,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  //
  //Aqui é onde é criado o Widget por assim dizer
  //


  @override
  Widget build(BuildContext context) {
    Map weekdays = dates(widget.day);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(int.parse(widget.color)),
        child: Icon(Icons.delete),
        onPressed: () async {
            Navigator.pop(context, true);
        },
      ),
      body: Stack(
        children: <Widget>[
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
              SliverAppBar(
                backgroundColor: Color(int.parse(widget.color)),
                expandedHeight: 120,
                floating: false,
                pinned: true,
                snap: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget.discipline, overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
              ),
            ),
            ],
            body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: <Widget>[

                  //Professor
                  new Row(
                    children: <Widget>[

                      new Column(
                          children: <Widget>[
                            new Icon(Icons.account_circle, size: 17, color: Colors.blueGrey),
                          ]
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),),

                      new Column(
                        children: <Widget>[
                          new Text(widget.teacher, style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                        ],
                      ),

                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),),

                  //Sala
                  new Row(
                    children: <Widget>[

                      new Column(
                        children: <Widget>[
                          new Icon(Icons.place, size: 17, color: Colors.blueGrey),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),),

                      new Column(
                        children: <Widget>[
                          new Text(widget.room, style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),),

                  //Hora da Aula
                  new Row(
                    children: <Widget>[
                      new Column(                                    //Hora da Aula
                        children: <Widget>[
                          new Icon(Icons.access_time, size: 14, color: Colors.blueGrey),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),),

                      new Column(
                        children: <Widget>[
                          new Text(widget.timeBegin+'  -  '+widget.timeEnd,
                              style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),),

                  //Dias da Semana
                  new Row(
                    children: <Widget>[

                      new Column(                                    //Hora da Aula
                        children: <Widget>[
                          new Icon(Icons.calendar_today, size: 14, color: Colors.blueGrey),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),),

                      new Column(
                        children: <Widget>[
                          daysSelected(weekdays),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),),


                      Text(widget.obs, overflow: TextOverflow.clip,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}