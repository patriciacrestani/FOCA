import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';
import 'package:foca_app/functions_page/ReturnMovementBD.dart';


import 'estilo/const.dart';
import 'estilo/info.dart';
import 'list.movement.dart';
import 'add.movement.dart';
import 'page.movement.dart';

/* 
  Classe de financias do app. Ele eh classe principal do app
  Nele contera as informacoes de todas as receitas e despesas
  ao longo do mes.

*/
class FinancialWidget extends StatefulWidget{
    FinancialWidget ({Key key}): super (key:key);
    _FinancialWidgetState createState() => _FinancialWidgetState();
}
class _FinancialWidgetState extends State<FinancialWidget>{
 

  double _totalEarnings = 0;                            // Valor do total de receitas
  double _totalExpanses = 0;                            // Valor do total de despesas

  List<Map> _listEarnings = new List();                 // Lista de todas as receitas
  int _amountNEEarnings = 0;                            // Indicdor de quantos receitas ainda nao foram efetivadas
  List<Map> _listExpanses = new List();                 // Lista de todas as despesas
  int _amountNEExpanses = 0;                            // Indicdor de quantas despesas ainda nao foram efetivadas

  // Lista de categorias de Receitas
  List<Map> _earnCategories = [
    {'id': '1', 'icon': Image(image: AssetImage('assets/icons/earnings/receive-cash.png'), width: 40, height: 40,), 'name': 'Salário'},
    {'id': '2', 'icon': Image(image: AssetImage('assets/icons/earnings/museum.png'), width: 40, height: 40,), 'name': 'Rendimentos'},
    {'id': '3', 'icon': Image(image: AssetImage('assets/icons/earnings/percentage.png'), width: 40, height: 40,), 'name': 'Comissão'},
  ];

  // Lista de categorias de Despesas
  List<Map> _expanseCategories = [
    {'id': '1', 'icon': Image(image: AssetImage('assets/icons/expanses/food.png'), width: 40, height: 40,), 'name': 'Alimentação'},
    {'id': '2', 'icon': Image(image: AssetImage('assets/icons/expanses/transportation.png'), width: 40, height: 40,), 'name': 'Transporte'},
    {'id': '3', 'icon': Image(image: AssetImage('assets/icons/expanses/clothes.png'), width: 40, height: 40,), 'name': 'Vestuário'},
    {'id': '4', 'icon': Image(image: AssetImage('assets/icons/expanses/heart.png'), width: 40, height: 40,), 'name': 'Saúde'},
    {'id': '5', 'icon': Image(image: AssetImage('assets/icons/expanses/reading.png'), width: 40, height: 40,), 'name': 'Educação'},
    {'id': '6', 'icon': Image(image: AssetImage('assets/icons/expanses/christmas-gift.png'), width: 40, height: 40,), 'name': 'Presentes'},
    {'id': '7', 'icon': Image(image: AssetImage('assets/icons/expanses/us-dollar.png'), width: 40, height: 40,), 'name': 'Pagamentos de Conta'},
    {'id': '8', 'icon': Image(image: AssetImage('assets/icons/expanses/toolbox.png'), width: 40, height: 40,), 'name': 'Serviços'},
  ];

  Color _backgroundDial = Colors.green[700];
  Color _foregroundDial = WHITE;
  Icon _iconDial = Icon(Icons.add);

  @override 
  void initState(){
    super.initState();
    initBD();
  }

// Funcao que pega todos os dados do financeiro do Firebase
  void initBD() async{
    
    Map map = new Map();

    // Pega as categorias personalizadas
    _earnCategories = await returnCategoriesFromBD(true, _earnCategories);
    _expanseCategories  = await returnCategoriesFromBD(false, _expanseCategories);

    // Pega as receitas e seu ponteiro de efetivada
    map = await returnMovement(true);
    _listEarnings = map['list'];
    _amountNEEarnings = map['pointer'];   

    // Pega as despesas e seu ponteiro de efetivada                     
    map = await returnMovement(false);
    _listExpanses = map['list'];
    _amountNEExpanses = map['ponter'];


    // Calcula as despesas e receitas
    _totalEarnings = initValues(_listEarnings, true);
    _totalExpanses = initValues(_listExpanses, false);
    
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
        // Aqui conterá os botões onde o usuário irá inserir suas receitas e despesas
        floatingActionButton: menuButton(),
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(  
                    padding: EdgeInsets.all(12.0), 
                    child: Column(                                              
                      children: <Widget>[
                            /* Chamo uma funcao para criar um card para mostrar visão geral de 
                            todas as receitas e despesas para o usuario.
                            */

                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Visão Geral",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    
                                    IconButton(
                                      icon: Icon(Icons.info,color: Colors.black,),
                                      iconSize: 20,
                                      onPressed: (){
                                        return showDialog(
                                          context: context,
                                          builder: (BuildContext context) => InformationWidget(text: 'É aqui onde você verá o somatório das receitas, despesas e o total economizado durante o mês.',)
                                        );
                                        
                                      },
                                    ),
                                  ]
                                ),
                                
                                Text(month(),
                                  style: TextStyle(
                                    color: BLUE,
                                    fontSize: 18
                                  ),
                                ),   
                              ]
                            ),

                            /* Chamo uma funcao para criar um card para mostrar visao geral de 
                            todas as receitas e despesas para o usuario.
                            */
                            overview(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                    flex: 4,
                                    child: Text("Economia Mensal",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ),
                                
                                Flexible(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(Icons.info,color: Colors.black,),
                                      iconSize: 20,
                                      onPressed: (){
                                        return showDialog(
                                          context: context,
                                          builder: (BuildContext context) => InformationWidget(text: 'É aqui onde você verá o percentual economizado em relação ao total de receitas durante o mês.',)
                                        );                             
                                      },
                                    )
                                ),
                    
                              ]
                            ),
                            
                            /* Chamo uma função para criar outro card para mostrar o percentual e valor
                            economizado durante o mes e frases para de motivção para o usuario.
                            */
                            graphic(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                    flex: 4,
                                    child: Text("Histórico",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ),
                                
                                Flexible(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(Icons.info,color: Colors.black,),
                                      iconSize: 20,
                                      onPressed: (){
                                        return showDialog(
                                          context: context,
                                          builder: (BuildContext context) => InformationWidget(text: 'É aqui onde você verá as últimas 5 despesas do mês.',)
                                        );                             
                                      },
                                    )
                                ),
                    
                              ]
                            ),

                            /* Chamo uma funcao para criar uma lista de cards 
                            onde mostra as 5 ultimas despesas efetivadas do mes.
                            */
                            history(),         
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 50),
                            ),
                          ] 
                            
                        ),
                  ),
                ]),
              ),
            ]
          ),
        ),    
   );
        
  }

/* 
  Esta funcao cria um objeto SpeedDial, que funciona como se fosse um  menu drop-up,
  onde conterá as opcoes de adicionar receita ou despesa.
*/
  SpeedDial menuButton(){
      

      return SpeedDial(
          
              animatedIcon: null,
              animatedIconTheme: IconThemeData(size: 30.0),
              
              child: _iconDial,
          
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,

              tooltip: 'Speed Dial',
              heroTag: 'speed-dial-hero-tag',
              backgroundColor: _backgroundDial,
              foregroundColor: _foregroundDial,
              elevation: 8.0,


              // As Funcoes onOpen e onClose fazem a animação de cores e icones do App 
              onOpen: (){
                  setState(() {
                      _backgroundDial = WHITE;
                      _foregroundDial = RED;
                      _iconDial = Icon(Icons.clear);
                  });
              },

              onClose: (){
                  setState(() {
                      _backgroundDial = Colors.green[700];
                      _foregroundDial = WHITE; 
                      _iconDial = Icon(Icons.add);
                  });
              },
              
              // Aqui fica a coleção de opcoes
              children: [
                // Botao para adicionar despesas
                SpeedDialChild(
                  child: Icon(Icons.add),
                  backgroundColor: RED,
                  label: EXPANSE,
                  onTap: () async { 
                          // Aqui chama a pagina onde contem o formulario para os gastos 
                          awaitValue(false, context);
                        },
                ),

                // Botão para adicionar receitas
                SpeedDialChild(
                  child: Icon(Icons.add),
                  backgroundColor: GREEN,
                  label: EARN,
                  
                  onTap: () async { 
                          // Aqui chama a pagina onde contem o formulario para as receitas                
                        
                          awaitValue(true, context);  
                        },
                ),
              ],
            );
  }

// Esta funcao cria uma lista de cards onde mostrarao todas ultimas 5 despesas do mes
  Widget history(){
    return Column(
      children: <Widget>[
        
        ListView.builder(
          
          itemCount: (_listExpanses==null?0:
                      (((_listExpanses.length - _amountNEExpanses) > 0) ? ( ((_listExpanses.length - _amountNEExpanses) > 5) ? 5 : (_listExpanses.length - _amountNEExpanses) ): 0)),  // Vê o tamanho da lista. Se for maior do que 5, mostrará apenas 5 elementos
          itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: _expanseCategories[int.parse(_listExpanses[index + _amountNEExpanses]['category'])-1]['icon'],   // Pega o icone da categoria da movimentação
                  title: Text(_listExpanses[index + _amountNEExpanses]['name']),                                            // Pega o nome da movimentação
                  subtitle: Text(_listExpanses[index + _amountNEExpanses]['date']),                                         // Pega a data da movimentação
                  trailing: Text(CURRENCY + _listExpanses[index + _amountNEExpanses]['moneyValue'].toStringAsFixed(2)),     // Pega o valor da movimentação
                  
                  // Aqui é onde ao tocar no card irá chamar a página para mostrar mais detalhes da despesa
                  onTap: () async { 
                    // Esta variavel local flag e uma bandeira onde indica se esta despesa sera removida ou nao
                    
                    bool flag = await Navigator.push(context, MaterialPageRoute(builder: (context) => Movement(_listExpanses[index], _expanseCategories, false)));
                    if(flag != null && flag){
                      setState((){
                        _listExpanses.removeAt(index);
                      });
                    }
                  }
                )
                
              );
          },
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        )
      ],
    );
  }
  // Função que cria um card onde contera o grafico e a um frase motivacional com uma imagem de uma foca
  Card graphic(){
      double value = percentage();
      value = (value < 0) ? 0 : value;
  
      Color _color = defcolors(value); 

      return Card(
                child: 
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child:   
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                
                                  Flexible(
                                      flex: 3,
                                      child: 
                                          /* Aqui crio um grafico do tipo circular radial 
                                            com animação de progresso que dura 5s. 
                                          */
                                          CircularPercentIndicator(
                                              radius: 140.0,
                                              animation: true,
                                              animationDuration: 2500,
                                              lineWidth: 13.0,
                                              percent: (value/100),
                                              center: Text(
                                                    value.toStringAsFixed(0)+'%',
                                                    style: TextStyle(color: _color, fontSize: 30.0)

                                              ),

                                              circularStrokeCap: CircularStrokeCap.round,
                                              progressColor: _color,
                                          )
                                    
                                  ),
                                  
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                  ),

                                  Flexible(
                                    flex: 2,
                                    child: Center(
                                        child: Column(
                                            children: economy(value),
                                        ),
                                      )
                                        
                                  ),
                                
                              ]
                          )
                  )       
                                  
            );

  }

  // Função que cria um card onde contera visão geral das receitas e despesas do usuário  
  Card overview(){
      return Card(                                    // Crio um Card para mostrar o fluxo de caixa              
          child: Column(                              // Crio uma coluna            
              mainAxisSize: MainAxisSize.min,         // Esta coluna tera o tamanho minimo de largura
              
              children: <Widget>[                      // Crio sub-widgets 
                  // Crio o visor de Receitas, nela contera o
                  // somatorio de todas as recitas no mes. 
                  
                  ListTile(
                    leading: Icon(Icons.add_circle, color: GREEN),                            // Insiro o icone e coloco na cor verde
                    title: Text(EARN + 's'),
                    trailing: Text(CURRENCY + _totalEarnings.toStringAsFixed(2), textAlign: RIGHT),
                    onTap: () async {
                      // Aceso a lsta e atualiza o valor
                      double value = await recalc(_listEarnings, _earnCategories, true);
                      _totalEarnings = value;
                      
                    }
                  ),

                  // Crio o visor de Despesas, nele contera o
                  // somatorio de todas as despesas do mes.
                  ListTile(
                    leading: Icon(Icons.remove_circle, color: RED),                            // Insiro o icone e coloco na cor vermelha 
                    title: Text(EXPANSE+'s'),
                    trailing: Text(CURRENCY + _totalExpanses.toStringAsFixed(2), textAlign: RIGHT),
                    onTap: () async {
                      // Acesso a lista e atualiza o valor
                      double value = await recalc(_listExpanses, _expanseCategories, false);
                      _totalExpanses = value;
                      
                    }
                  ),
                                    
              ],
          ),
      );
  }

  /* Função que verifica, de acordo com a porcentagem obtida,
  qual sera a cor mostrada no grafico.

  Se a porcentagem obtida for maior ou igual a 20% retornara
  a cor Verde, caso contrario retornara a cor Vermelha se for igual a 0 ou ambar se for entre 1 e 19
   */
  Color defcolors(double value) => (value >= 20) ? GREEN : (value > 0) ?  Colors.amber : RED;

  /* Função que calcula a porcentagem entre o valor total em relação
  ao total de receitas do mes.
  */
  double percentage() =>(_totalEarnings > 0) ? (((_totalEarnings- _totalExpanses) * 100) / _totalEarnings) : 0;


/* Função onde mostra frases de motivacao de acordo com o percentual
economizado durante o mes.
*/
  List<Widget> economy(double value){
      if(value > 20){
          return [
                  Container(
                    width: 100,
                    height: 100,
                    child: GOOD,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                  ),
                  
                  Text('UAU! Você está FOCAndo muito!', textAlign: TextAlign.center,),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                  ),

                  Text(CURRENCY + (_totalEarnings-_totalExpanses).toStringAsFixed(2), style: TextStyle(color: GREEN, fontWeight: FontWeight.bold, fontSize: 20.0,))
              ];          
      }
      return [
              
              Container(
                  width: 100,
                  height: 100,
                  child: BAD,
              ),

              Padding(
                  padding: EdgeInsets.symmetric(vertical: 1),
              ),
                  
              Text('Tô vendo que você não ta FOCAndo!', textAlign: TextAlign.center,),


              Padding(
                padding: EdgeInsets.symmetric(vertical: 1),
              ),

              (value > 0) ? Text(CURRENCY + (_totalEarnings-_totalExpanses).toStringAsFixed(2), style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 20.0,)) : Text(CURRENCY + (_totalEarnings-_totalExpanses).toStringAsFixed(2), style: TextStyle(color: RED, fontWeight: FontWeight.bold, fontSize: 20.0,))
              
          ];

  }

// Funcao que faz o calculo inicials
  double initValues(List listValues, bool flag){
    // Calcula o novo valor
    double value = 0;
    int amountNEffected = 0;
    for(var obj in listValues){
      if(obj['effected']){
        value += obj['moneyValue'];
      }else{
        amountNEffected += 1;
      }
    }
    setState((){
      if(flag){
        _amountNEEarnings = amountNEffected;
      }else{
        _amountNEExpanses = amountNEffected;
      }
    });
    return value;
  }

  // Funcao que recalcula os valores do total de receitas e despesas.
  Future<double> recalc(List listValues, List categories, bool flag) async{
    // Aqui faz a referencia a lista de movimentos. Se true faz a lista de ganhos, caso false faz a lista de despesa
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ListMovementsWidget(listValues, categories, flag)));
    
    // Calcula o novo valor
    double value = 0;
    int amountNEffected = 0;
    for(var obj in listValues){
      if(obj['effected']){
        value += obj['moneyValue'];
      }else{
        amountNEffected += 1;
      }
    }
    setState((){
      if(flag){
        _amountNEEarnings = amountNEffected;
      }else{
        _amountNEExpanses = amountNEffected;
      }
    });

    return value;
  }

  // Funcao que retorna o mes em PT-BR
  String month(){
    String date = DateFormat('MM').format(DateTime.now()).toString();
    int month = int.parse(date);
    switch(month){
      case 1: {
        return 'JANEIRO';
      }
      case 2: {
        return 'FEVEREIRO';
      }
      case 3: {
        return 'MARÇO';
      }
      case 4: {
        return 'ABRIL';
      }
      case 5: {
        return 'MAIO';
      }
      case 6: {
        return 'JUNHO';
      }
      case 7: {
        return 'JULHO';
      }
      case 8: {
        return 'AGOSTO';
      }
      case 9: {
        return 'SETEMBRO';
      }
      case 10: {
        return 'OUTUBRO';
      }
      case 11: {
        return 'NOVEMBRO';
      }
      case 12: {
        return 'DEZEMBRO';
      }
      default: {
        return 'Erro de Mês';
      }
    }
  }

  /* Funcao que busca os valores vindo do formulario para atualizar o 
  total de receitas e despesas. 
    A variavel a ser atualizada dependera do valor da flag. True se for receita, false se for despesa. 
  
  */
  void awaitValue(bool flag, BuildContext context) async{
      var result;
      if (flag){
        result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddMovementWidget(_earnCategories, flag)));
  
        setState(() {
          if(result != null && result['data']['effected']){
           _totalEarnings += result['data']['moneyValue'];
            _listEarnings.insert(_amountNEEarnings ,result['data']);
           _earnCategories = result['categories'];
          } else if(result != null && !result['data']['effected']){
            _listEarnings.insert(0,result['data']);
            _amountNEEarnings += 1;
            _earnCategories = result['categories'];
          }
        });
      }else{
        result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddMovementWidget(_expanseCategories, flag)));
        setState(() {
          if(result != null && result['data']['effected']){
           _totalExpanses += result['data']['moneyValue'];
           _listExpanses.insert(_amountNEExpanses,result['data']);
           _expanseCategories = result['categories'];

          } else if(result != null && !result['data']['effected']){
            _listExpanses.insert(0,result['data']);
            _amountNEExpanses += 1;
            _earnCategories = result['categories'];
          } 
        });
      }
      
      
  }
  
}