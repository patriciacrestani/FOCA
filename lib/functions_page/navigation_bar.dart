import 'package:flutter/material.dart';
import 'package:foca_app/home.dart';
import 'package:foca_app/pages/academico/academic.dart';
import 'package:foca_app/functions_page/drawer.dart';
import 'package:foca_app/pages/financeiro/financial.widget.dart';
import 'package:foca_app/pages/pessoal/personal.dart';
import 'package:foca_app/pages/trabalho/work.dart';


//Classe responsável somente pelo NavigationBottomBar
//Essa classe chama a renderização das outras abas (classes states)

class NavigationBar extends StatefulWidget {
  //Tem que ser Stateful porque muda de estado
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<NavigationBar> {
  int _currentIndex = 2; //Aba em que o app abre isto é, a "Meu Dia"
  final List<Widget> _children = [
    //Classes das abas
    FinancialWidget(),
    AcademicWidget(),
    MeuDiaWidget(),
    PersonalWidget(),
    WorkWidget()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBar(),
      backgroundColor: Colors.white,
      body: _children[_currentIndex], //Corpo correspondente ao widget que será amostrado
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap:onTabTapped, //Chama OnTabTapped que pega o index da aba que é tocada
        currentIndex: _currentIndex, //Widget que será renderizado
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Icon(Icons.monetization_on),
            title: new Text('Finanças'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.school),
            title: new Text('Acadêmico'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Meu Dia'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Pessoal"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            title: Text("Trabalho"),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    //Função responsável por ver o que está sendo tocado e trocar o index
    setState(() {
      _currentIndex = index;
    });
  }
}
