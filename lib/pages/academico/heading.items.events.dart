import 'package:flutter/material.dart';

//
//Esta classe é responsável pelo Cabeçalho escrito: Lemrebtes na aba Academico
//

class HeadingItemsEvents extends StatefulWidget{
  HeadingItemsEventsState createState() => HeadingItemsEventsState();
}

//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//

class HeadingItemsEventsState extends State<HeadingItemsEvents>{

  //
  //Aqui é onde é criado o Widget por assim dizer
  //

  Widget build(BuildContext context){
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child:
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child:
            Text("Lembretes",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}