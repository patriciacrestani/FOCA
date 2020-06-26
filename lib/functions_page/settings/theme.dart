import 'package:flutter/material.dart';

//
//Esta classe é responsável pela aba Notificação
//

class SettingTheme extends StatefulWidget{
  SettingThemeState createState() => SettingThemeState();
}

//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//


class SettingThemeState extends State<SettingTheme>{

  //
  //Aqui criamos o Widget por assim dizer
  //


  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Configurar Tema'),
      elevation: 0,
    ),
    body: Container(
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text('Cor de Fundo'),
                onTap: (){},
              ),
              ListTile(
                title: Text('Tamanho da Fonte'),
                trailing: Text('Padrão'),
                onTap: (){},
              ),
            ],
          ).toList()     
        )
      ),
  );
}