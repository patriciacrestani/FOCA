import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:foca_app/functions_page/AddEventCategoryBD.dart';

/*
  Classe que gera a tela de criação do evento e a salva no banco de dados.
*/

class AddEventWidget extends StatefulWidget{
  AddEventWidget (this.categories);
  List categories;
  _AddEventWidgetState createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget>{
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  List<DropdownMenuItem<String>> _categories;
  String _categorySelected = 'Reunião Presencial';

  Map _event = new Map();

  DateTime _date  = new DateTime.now();
  DateTime _dateI = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();


  //DatePicker, surge o popup para escolher a data
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

  //TimePicker, surge o popup para escolher a hora
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

  //Cria o Dropdown menu com as categorias.
  List<DropdownMenuItem<String>> _buildCategories() {
    List<DropdownMenuItem<String>> list = new List<DropdownMenuItem<String>>();
    for(int i = 0; i < widget.categories.length; i++){
      list.add(
        DropdownMenuItem(
            value: widget.categories[i]['id'],
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24,
                  child: widget.categories[i]['icon'],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                ),
                Text(widget.categories[i]['name']),
              ],
            )
        ),
      );
    }
    return list;
  }

  void initState(){
    super.initState();
    this._categories = this._buildCategories();
  }

  //Chama o formulário de criação de evento e cria um botão para salvá-lo
  Widget build(BuildContext context) {
    _event['dataI'] = _dateI;
    _event['time'] = _time;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Adicionar Evento"),
        backgroundColor: Colors.amber,
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

  //Cria o formulário de criação do evento.
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
        splashColor: Colors.amber,
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
        splashColor: Colors.amber,
        shape: Border.all(width: 0.5, color: Colors.black),
        child: Text( (_time.minute < 10) ? (_time.hour.toString()+":0"+_time.minute.toString()) : (_time.hour.toString()+':'+_time.minute.toString())),
        onPressed: (){
          selectTime(context);
        },
      ),
      //Chamada do Dropdown Menu de categorias
      Row(
          children: <Widget>[
            Flexible(
                flex: 4,
                child: selectCategory(),
                )
          ],
          ),

      FlatButton(//Botão para salvar
        shape: Border.all(width: 0.5, color: Colors.amber),
        color: Colors.amber,
        child: Text('Salvar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          _event['category'] = _categorySelected;
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
              AddEventCategoryBD('LembreteProfissional',_event);
              Navigator.pop(context, eventFinshed);
            }
          }
        }, //OnPressed
      ),
    ],
  );

  //Função que muda o valor da variãvel da categoria de acordo com a categoria selecionada no dropdown menu
  DropdownButton selectCategory() => DropdownButton<String>(
    items: _categories,

    onChanged: (value) {
      setState(() {
        _categorySelected = value;
      });
    },
    value: _categorySelected,
    isExpanded: true,
    elevation: 2,

  );

  void _timeError(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('FOCA no horário inválido'),
        duration: Duration(seconds: 1),
    ));
  }

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

  String correctionMinute(int minute){
    if(minute < 10){
      String s = '0' + minute.toString();
      return s;
    }
    return minute.toString();
  }
}
