import 'package:flutter/material.dart';
import 'package:foca_app/pages/financeiro/estilo/select.color.picker.dart';
import 'package:day_selector/day_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';


//
//Este arquivo é responsável pelo widget de formulario para adicionar Matérias
//

class AddClassesWidget extends StatefulWidget{
  _AddClassesWidgetState createState() => _AddClassesWidgetState();
}


//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//

class _AddClassesWidgetState extends State<AddClassesWidget>{

  final GlobalKey<FormState> _otherFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  Map _classes = new Map();

  Color _currentColor = Colors.blue;

  TimeOfDay _time = new TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _timeEnd = new TimeOfDay(hour: 9, minute: 0);

  //
  //TimePicker, surge o popup para escolher a hora inicial
  //

  Future<Null> selectTimeBegin(BuildContext context) async{

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null){
      setState((){
        _time = picked;
        _classes['time'] = picked;
      });
    }
  }


  //
  //TimePicker, surge o popup para escolher a hora final
  //
  Future<Null> selectTimeEnd(BuildContext context) async{

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _timeEnd,
    );

    if(picked != null){
      setState((){
          _timeEnd = picked;
        _classes['timeEnd'] = picked;
      });
    }
  }

  //
  //Aqui é onde é criado o Widget por assim dizer
  //

  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text("Adicionar Matéria"),
      backgroundColor: Colors.red,
    ),
    body: Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _otherFormKey,
        child: formUI(),
      ),
    ),
  );

  //
  //Aqui é criado o formulário por assim dizer
  //

  Widget formUI() => ListView(
    children: <Widget>[
      TextFormField(
        maxLength: 40,
        decoration: InputDecoration(
            labelText: 'Nome'
        ),

        // É aqui onde ocorrerá a validação do valor inserido pelo usuário.
        // Esta validação ocorre da seguinte forma:
        //1 - Verifica-se se o campo está vazio. Se ocorrer tudo corretamente
        // segue para salvar o dado.

        validator: (String value){
          if(value.length == 0){
            return 'Este campo não pode ficar vazio';
          }
          return null;
        },

        onSaved: (String value){
          _classes['name'] = value;
          _classes['time'] = _time;
          _classes['timeEnd'] = _timeEnd;
        },
      ),

      Row(
        children: <Widget>[
          Flexible(
              child:
              FlatButton(
                color: _currentColor,
                shape: CircleBorder(),
                child: null,
                onPressed: selectColor,
              )
          ),


          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
          ),

          Flexible(
              flex: 4,
              child:
              Text('Escolha uma cor'),
          ),
      ],
      ),


      TextFormField(
        maxLength: 20,
        decoration: InputDecoration(
            labelText: 'Professor'
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
          _classes['teacher'] = value;
        },
      ),

      TextFormField(
        maxLength: 10,
        decoration: InputDecoration(
            labelText: 'Sala'
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
          _classes['room'] = value;
        },
      ),

      //Escolher dias da semana


      // Botão Para Escolher a Hora
      Text(
        'Início',
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey
        ),
      ),

      FlatButton(
        splashColor: Colors.blueAccent,
        shape: Border.all(width: 0.5, color: Colors.black),
        child: Text( (_time.minute < 10) ? (_time.hour.toString()+":"+_time.minute.toString()+"0") : (_time.hour.toString()+':'+_time.minute.toString())),
        onPressed: (){
          selectTimeBegin(context);
        },
      ),

      Text(
        'Fim',
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey
        ),
      ),

      FlatButton(
        splashColor: Colors.blueAccent,
        shape: Border.all(width: 0.5, color: Colors.black),
        child: Text((_timeEnd.minute < 10) ? (_timeEnd.hour.toString()+":"+_timeEnd.minute.toString()+"0") : (_timeEnd.hour.toString()+':'+_timeEnd.minute.toString())), 
        onPressed: (){
          selectTimeEnd(context);
        },
      ),


      TextFormField(
        maxLength: 100,
        decoration: InputDecoration(
            labelText: 'Observações',
            hintMaxLines: 3,
        ),

        /* É aqui onde ocorrerá a validação do valor inserido pelo usuário.
            Esta validação ocorre da seguinte forma:
            1 - Verifica-se se o campo está vazio. Se ocorrer tudo corretamente
            segue para salvar o dado.
        */

        onSaved: (String value){
          if(value.length == 0){
            _classes['obs'] = "";
          }else {
            _classes['obs'] = value;
          }
        },
      ),

      DaySelector(
        value: 1,
        onChange: (value){
          _classes['days'] = value;
        },
        color: Colors.red,
        mode: DaySelector.modeWorkdays,
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
          if(_classes['days'] == double){
            _timeError();
          }else{
          _validateInputs();
          if(!_autoValidate) {
            Map classesFinshed = _classes;
            print("**********************");
            print(classesFinshed);
            print("**********************");
            AddClassesBD(_classes);//Adiciona a nova materia no Banco de Dados
            Navigator.pop(context, classesFinshed);
          }
          }
        }, //OnPressed
      ),
    ],
  );

  //
  //Esta função salva a Matéria criada no Banco de Dados
  //

  void AddClassesBD(Map _classes){
    String cor;
    print(_classes['color'] != null);
    if(_classes['color'] != null){
      cor = ((_classes['color']).value).toString();
      print("Cor do ususario");
    }else{
      print("Cor não escolhida");
      cor = Colors.blue.value.toString();
    }
    print(cor);
    Firestore.instance.collection('Materia').add({
      'disciplina': _classes['name'],
      'dia': _classes['days'],
      'professor': _classes['teacher'],
      'horaFim': (_classes['timeEnd'].minute < 10) ? (_classes['timeEnd'].hour.toString()+":0"+_classes['timeEnd'].minute.toString()) : (_classes['timeEnd'].hour.toString()+':'+_classes['timeEnd'].minute.toString()),
      'horaInicio': (_classes['time'].minute < 10) ? (_classes['time'].hour.toString()+":0"+_classes['time'].minute.toString()) : (_classes['time'].hour.toString()+':'+_classes['time'].minute.toString()),
      'obs': _classes['obs'],
      'sala':_classes['room'],
      'cor': cor,
      'refUser': usuario.uid
    });
  }

  //
  // Esta função é o selecionador de cor
  //

  void selectColor() async{
    final selectedColor = await showDialog<Color>(
        context: context,
        builder: (BuildContext context) => SelectColorPickerDialog(currentColor: _currentColor,)
    );

    if(selectedColor != null){
      setState((){
        _currentColor = selectedColor;
      });
    }
    _classes['color'] = _currentColor;
  }

  //
  //Esta função é uma mensagem de erro, caso o usuário não tenha escolhido dias da semana para a matéria
  //

  void _timeError(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('FOCA nos dias da aula'),
          duration: Duration(seconds: 3),
        ));
  }

  //
  //Esta função valida o formulário
  //

  void _validateInputs(){
    if(_otherFormKey.currentState.validate()){
      _otherFormKey.currentState.save();
      _autoValidate = false;

    }else{
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
