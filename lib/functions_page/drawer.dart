import 'package:flutter/material.dart';
import 'package:foca_app/pages/grupos/grupos.dart';
import 'navigation_bar.dart';
import 'settings.dart';
import 'package:foca_app/pages/login/login.dart';
import 'calendar.dart';
import 'package:foca_app/pages/academico/all.classes.dart';

class DrawerBar extends StatelessWidget {
  
  Widget build(BuildContext context) {
    return Drawer(
      //Slide Panel do app
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            //Informacoes do usuario
            accountName: Text(usuario.displayName), //Exibe o nome do usuario
            accountEmail: Text(usuario.email),      //Exibe o email do usuario
            currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                    backgroundImage: NetworkImage(usuario.photoUrl), //Exibe a imagem de perfil do usuario
            )),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                      "http://papers.co/wallpaper/papers.co-nx59-water-pattern-wave-blue-summer-nature-29-wallpaper.jpg"),
                  )
              ),
          ),
          //Paginas da lista do slide panel
          new ListTile(
            title: new Text("Pessoal"),
            trailing: new Icon(Icons.person),
            onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationBar())),
          ),
          new ListTile(
            title: new Text("Grupos"),
            trailing: new Icon(Icons.group),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Groups())),
          ),
          new ListTile(
            title: new Text("Calendário"),
            trailing: new Icon(Icons.today),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarWidget())),
          ),
          new ListTile(
            title: new Text("Disciplinas"),
            trailing: new Icon(Icons.book),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllClasses())),
          ),
          new Divider(),
          new ListTile(
            title: new Text("Configurações"),
            trailing: new Icon(Icons.settings),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingWidget())),
          )
        ],
      ),
    );
  }
}
