import 'package:flutter/material.dart';

//
//Esta classe é responsável pela aba Notificação
//


class SettingNotification extends StatefulWidget{
  SettingNotificationState createState() => SettingNotificationState();
}

//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//

class SettingNotificationState extends State<SettingNotification>{

  //
  //Aqui criamos o Widget por assim dizer
  //

  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Configurar Notificações'),
      elevation: 0,
    ),
    body: Container(
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(                
                title: Text('Vibração'),
                trailing: Text('Ativado'),
                onTap: (){},
              ),
              ListTile(
                title: Text('Som'),
                trailing: Text('Ativado'),
                onTap: (){},
              ),
            ],
          ).toList()     
        )
      ),
  );
}