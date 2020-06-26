import 'package:flutter/material.dart';

//
//Esta classe eh responsável pela aba do Sobre
//

class About extends StatefulWidget{
  AboutState createState() => AboutState();
}


//
//Aqui criamos o estado do Widget, ele eh um Statefull, isto eh, seus objetos mudam ao longo do tempo
//

class AboutState extends State<About>{

  //
  //Aqui criamos o Widget por assim dizer
  //

  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Sobre o App'),
      elevation: 0,
    ),
    body: Container(
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(                
                title: Text('Versão'),
                onTap: (){
                  _showTheVersion();
                },
              ),
              ListTile(                
                title: Text('Termos de Uso'),
                onTap: (){
                  _showTermsOfUsage();
                },
              ),
            ],
          ).toList()     
        )
      ),
  );

  //
  //AlertDialog para mostrar a versao
  //

  void _showTheVersion() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Versão da FOCA", style: TextStyle(fontWeight: FontWeight.bold),),
          content: new Text("Apenas começamos, então a versão é 1.0"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //
  //AlertDialog para mostrar os termos de uso
  //

  void _showTermsOfUsage() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Termos de Uso", style: TextStyle(fontWeight: FontWeight.bold),),
          content: new Text("Você nos vendeu sua alma, de agora em diante, está destinado a fazer nossas vontades. Vamos começar com você nos comprando um café.",
            overflow: TextOverflow.clip,),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}