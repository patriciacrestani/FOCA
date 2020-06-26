import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EventWidget extends StatefulWidget{

  String _title;
  String _obs;
  bool _isCheck; //Verifica se o evento está checado ou não
  DateTime _date;
  TimeOfDay _time;
  String _categorySelected;

  EventWidget(this._title, this._obs, this._isCheck, this._date, this._time, this._categorySelected);

  String get title => _title;

  String get obs => _obs;

  bool get checked => _isCheck;

  String get categorie => _categorySelected;



  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<EventWidget>{

  String passToString(DateTime date){
    String day = DateFormat.yMMMd().format(date);
    return day;
  }

  //UI do evento

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        children: <Widget>[
          new Checkbox(value: widget._isCheck, onChanged: (bool e){ //Verifica se está checado ou não
            setState(() {
              widget._isCheck = e;
            });
          }),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //textDirection: TextDirection.LTR,
            children: <Widget>[
                Text(widget._title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                ),
                Text(widget._obs,
                style: TextStyle(
                    fontSize: 15.0,
                ),
                ),
                Text('Data: ${(DateFormat('dd/MM/yyyy').format(widget._date))}',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
                Text('Hora: ${(widget._time.hour.toString())+':'+(correctionMinute(widget._time.minute))}',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ],
          ),
            ],
          )
      );
  }

  String correctionMinute(int minute){
    if(minute < 10){
      String s = '0' + minute.toString();
      return s;
    }
    return minute.toString();
  }
}