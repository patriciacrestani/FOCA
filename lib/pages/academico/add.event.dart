import 'package:flutter/material.dart';
import 'package:foca_app/functions_page/AddEventBD.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:foca_app/functions_page/AddEventBD.dart';

//
//Este arquivo é responsável pelo widget de formulario para adicionar Lembretes
//

class AddEventWidget extends StatefulWidget{
  _AddEventWidgetState createState() => _AddEventWidgetState();
}


//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//

class _AddEventWidgetState extends State<AddEventWidget>{
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  Map _event = new Map();

  DateTime _date  = new DateTime.now();

  DateTime _dateI = new DateTime.now();

  TimeOfDay _time = new TimeOfDay.now();


  //
  //DatePicker, surge o popup para escolher a data
  //
  Future<Null> selectDate(BuildContext context, bool flag) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dateI,
      firstDate: ((flag) ? (_date.subtract(new Duration(days: 1))): _dateI),
      lastDate: DateTime(3000),
      builder: (BuildContext context, Widget child) {
        return SingleChildScrollView(
          child: child,
        );
      },
    );

    if(picked != null){
      setState((){
        _dateI = picked;
        _event['dataI'] = picked;
      });
    }
  }

  //
  //TimePicker, surge o popup para escolher a hora inicial
  //
  Future<Null> selectTime(BuildContext context) async{

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null){
      setState((){
        _time = picked;
        _event['time'] = picked;
      });
    }
  }

  //
  //Aqui é onde é criado o Widget por assim dizer
  //
  Widget build(BuildContext context) {
    _event['dataI'] = _dateI;
    _event['time'] = _time;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Adicionar Evento"),
        backgroundColor: Colors.red,
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
  }

  //
  //Aqui é criado o formulário por assim dizer
  //

  Widget formUI() => ListView(
    children: <Widget>[
      TextFormField(
        maxLength: 20,
        decoration: InputDecoration(
            labelText: 'Título'
        ),

        /* É aqui onde ocorrerá a validação do valor inserido pelo usuário.
            Esta validação ocorre da seguinte forma:
            1 - Verifica-se se o campo está vazio. Se ocorrer tudo corretamente 
            segue para salvar o dado.
        */
        validator: (String value){
            if(value.length == 0){
                return 'Este campo não pode ficar vazio';
            }
            return null;
        },

        onSaved: (String value){
          _event['name'] = value;
        },
      ),

      TextFormField(
        maxLength: 25,
        decoration: InputDecoration(
            labelText: 'Descrição'
        ),

        /* É aqui onde ocorrerá a validação do valor inserido pelo usuário.
            Esta validação ocorre da seguinte forma:
            1 - Verifica-se se o campo está vazio. Se ocorrer tudo corretamente 
            segue para salvar o dado.
        */
        validator: (String value){
            if(value.length == 0){
                return 'Este campo não pode ficar vazio.';
            }
            return null;
        },

        onSaved: (String value){
            _event['desc'] = value;
        },
      ),


      // Botão Para Escolher a Data Inicial
      Text(
        'Data',
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey
        ),
      ),
      FlatButton(
        splashColor: Colors.blueAccent,
        shape: Border.all(width: 0.5, color: Colors.black),
        child: Text(DateFormat('dd/MM/yyyy').format(_dateI)),
        onPressed: (){
          selectDate(context, true);
        },
      ),


     // Botão Para Escolher a Hora
      Text(
        'Hora',
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey
        ),
      ),

      FlatButton(
        splashColor: Colors.blueAccent,
        shape: Border.all(width: 0.5, color: Colors.black),
        child: Text( (_time.minute < 10) ? (_time.hour.toString()+":0"+_time.minute.toString()) : (_time.hour.toString()+':'+_time.minute.toString())),
        onPressed: (){
          selectTime(context);
        },
      ),

      FlatButton(
        shape: Border.all(width: 0.5, color: Colors.red),
        color: Colors.red,
        child: Text('Salvar',
              style: TextStyle(
                color: Colors.white,
              ),
        ),
        onPressed: () {
          print(_event['time'].minute <= TimeOfDay.now().minute);
          print(_event['dataI'].day == DateTime.now().day);
          print(_event['time'].hour <= TimeOfDay.now().hour);
          print(_event['dataI'].month == DateTime.now().month);
          print(_event['dataI'].year == DateTime.now().year);
          if((_event['time'].minute <= TimeOfDay.now().minute && _event['dataI'].day == DateTime.now().day && _event['time'].hour <= TimeOfDay.now().hour)
              && _event['dataI'].month == DateTime.now().month && _event['dataI'].year == DateTime.now().year){
            _timeError();
          }else{
            _validateInputs();
            if(!_autoValidate){
              Map eventFinshed = _event;
              print("**********************");
              print(eventFinshed);
              print("**********************");
              AddEventBD('LembreteAcademico',_event);
              Navigator.pop(context, eventFinshed);
            }
          }
        }, //OnPressed
      ),
    ],
  );


  //
  //Esta função é uma mensagem de erro, caso o usuário não tenha escolhido dias da semana para a matéria
  //

  void _timeError(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('FOCA no horário inválido'),
          duration: Duration(seconds: 3),
        ));
  }


  //
  //Esta função valida o formulário
  //

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
}
