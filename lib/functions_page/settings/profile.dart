import 'package:flutter/material.dart';
import 'profile/delete.dart';
import 'profile/name.dart';

//
//Esta classe é responsável pela aba Perfil
//

class SettingProfile extends StatefulWidget{
  SettingProfileState createState() => SettingProfileState();
}

//
//Aqui criamos o estado do Widget, ele é um Statefull, isto é, seus objetos mudam ao longo do tempo
//


class SettingProfileState extends State<SettingProfile>{

  //
  //Aqui criamos o Widget por assim dizer
  //

  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Configurar Perfil'),
      elevation: 0,
    ),
    body: Container(
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text('Editar Nome'),
                trailing: Text('Foca da Silva'),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>  NameDialog()
                  );
                },
              ),
              ListTile(
                title: Text('Foto de Perfil'),
                onTap: (){},
              ),
              ListTile(
                title: Text('Logout'),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.sentiment_dissatisfied, color: Colors.red),
                title: Text('Excluir Conta', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>  DeleteDialog()
                  );
                 
                },
              )
            ],
          ).toList()     
        )
      ),
  );
}