import 'package:flutter/material.dart';
import 'settings/notifications.dart';
import 'settings/theme.dart';
import 'settings/profile.dart';
import 'settings/about.dart';


class SettingWidget extends StatefulWidget{
	SettingWidgetState createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {

	Widget build(BuildContext context) => Scaffold(
			appBar: AppBar(
				title: Text('Configurações'),
				elevation: 0,				
			),
      body: Container(
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Perfil'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SettingProfile()));
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notificações'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SettingNotification()));
                },
              ),
              ListTile(
                leading: Icon(Icons.color_lens),
                title: Text('Tema'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SettingTheme()));
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Sobre o App'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => About()));
                },
              )
            ],
          ).toList()     
        )
      ),

		);
}