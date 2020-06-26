import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Classes.dart';
import 'all.classes.dart';
import 'package:intl/date_symbol_data_local.dart';

//
//Esta classe é responsável pelo Cabeçalho escrito: Disciplinas na aba Academico
//

class HeadingItemsClasses extends StatefulWidget{
    HeadingItemsClassesState createState() => HeadingItemsClassesState();
}


//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//

class HeadingItemsClassesState extends State<HeadingItemsClasses>{

    //
    //Esta função retorna o dia da semana em português
    //
    static String dayOfTheWeek(int i){
      if(i == 1){
        return "SEGUNDA";
      }if(i == 2){
        return "TERÇA";
      }if(i==3){
        return "QUARTA";
      }if(i==4){
        return "QUINTA";
      }if(i==5){
        return "SEXTA";
      }if(i==6){
        return "SÁBADO";
      }if(i==7){
        return "DOMINGO";
      }
      return "";
    }


    static int today = DateTime.now().weekday;
    String day = dayOfTheWeek(today);

    //
    //Aqui é onde é criado o Widget por assim dizer
    //

    Widget build(BuildContext context){
        return  Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
                Expanded(
                  child: ListTile(
                  title: Text("Disciplinas",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                      ),
                  ),
                    onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => AllClasses()));},
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child:
                    Text(day,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                        ),
                    ),
                ),
            ],
        );
    }
}