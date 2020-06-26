import 'package:flutter/material.dart';


class HeadingHome extends StatefulWidget{
  HeadingHomeState createState() => HeadingHomeState();
}

class HeadingHomeState extends State<HeadingHome>{

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

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child:
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child:
            Text("Hoje",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child:
          Text(day,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}