import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';
import 'package:intl/intl.dart';

//Funcao que adiciona os lembretes no banco de dados
void AddEventBD(String colecao, Map _event){ //Recebe como parametros em qual colecao o lembrete sera inserido e o proprio lembrete
  DateTime _date = _event['dataI'];
  Firestore.instance.collection(colecao).add({
    'titulo': _event['name'],
    'descricao': _event['desc'],
    'check': false,
    'data': (DateFormat('dd/MM/yyyy').format(_date)),
    'hora': (_event['time'].minute < 10) ? (_event['time'].hour.toString()+":0"+_event['time'].minute.toString()) : (_event['time'].hour.toString()+':'+_event['time'].minute.toString()),
    'refUser': usuario.uid,
  });
}
