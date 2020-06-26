import 'package:flutter/material.dart';

class Classes extends StatefulWidget{
  

  String _name;
  String _room;
  String _teacher;
  TimeOfDay _timeBegin;
  TimeOfDay _timeEnd;
  String _notes;
  Color _color;
  int _daysOfTheWeek;

  Classes(this._name, this._room, this._teacher, this._notes, this._color, this._daysOfTheWeek, this._timeBegin, this._timeEnd);


  String get name => _name;
  String get room => _room;
  String get teacher => _teacher;
  TimeOfDay get timeBegin => _timeBegin;
  TimeOfDay get timeEnd => _timeEnd;
  String get note => _notes;
  Color get color => _color;
  int get dayOfTheWeek => _daysOfTheWeek;


  @override
  _ClassesState createState() => _ClassesState();

}

class _ClassesState extends State<Classes>{

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

  Widget daysSelected(Map weekdays){
    final days = <Widget>[];
    if(weekdays['MON']) {
      days.add(Text('SEG ', style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold)));
    }
    if(weekdays['TUE']) {
      days.add(Text('TER ', style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['WED']) {
      days.add(Text('QUA ', style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['THU']) {
      days.add(Text('QUI ', style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['FRI']) {
      days.add(Text('SEX ', style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['SAT']) {
      days.add(Text('SAB ', style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold)),);
    }
    if(weekdays['SUN']) {
      days.add(Text('DOM '),);
    }
    return Row(
      children: days,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  @override
  Widget build(BuildContext context) {
    Map weekdays = dates(widget._daysOfTheWeek);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),),

          new Row(                                    //Cor da Matéria
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),),

              new Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget._color,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),),
              
              new Text(                                    //Nome da matéria
                widget._name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
            ],
          ),


          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),),

          new Row(                                    //Professor
            children: <Widget>[

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),),

              new Column(
                children: <Widget>[
                  new Icon(Icons.account_circle, size: 17, color: Colors.blueGrey),
                  ]
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),),

              new Column(
                children: <Widget>[
                  new Text(widget._teacher, style: TextStyle(color: Colors.blueGrey, fontSize: 17)),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),),

              new Column(                                    //Sala
                children: <Widget>[
                    new Icon(Icons.place, size: 17, color: Colors.blueGrey),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),),

              new Column(
                children: <Widget>[
                  new Text(widget._room, style: TextStyle(color: Colors.blueGrey, fontSize: 17)),
                ],
              ),

            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),),

          new Row(                                    //Dias da Semana
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),),

              new Column(
                children: <Widget>[
                  daysSelected(weekdays),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),),

              new Column(                                    //Hora da Aula
                children: <Widget>[
                  new Icon(Icons.access_time, size: 14, color: Colors.blueGrey),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),),

              new Column(
                children: <Widget>[
                  new Text((widget._timeBegin.hour.toString())+':'+(widget._timeBegin.minute.toString())+'  -  '+(widget._timeEnd.hour.toString())+':'+(widget._timeEnd.minute.toString()),
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14)),
                ],
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),),

        ],
      ),
    );
  }
}