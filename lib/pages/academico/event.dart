import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//
//Esta classe é a classe Evento
//

class EventWidget{
  //Classe de cada evento

  String _title; //Título do Evento
  String _obs; //Observações
  bool _isCheck; //Verifica se o evento está checado ou não
  DateTime _dateBegin;
  TimeOfDay _time;

  EventWidget(this._title, this._obs, this._isCheck, this._dateBegin,this._time);

  //Getters e Setters
  String get title => _title;

  String get obs => _obs;

  bool get checked => _isCheck;

  DateTime get date => _dateBegin;

  TimeOfDay get time => _time;

  set checking(bool e) => _isCheck = e;

}