import 'package:flutter/material.dart';
import 'estilo/const.dart';
import 'page.movement.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';
import 'package:foca_app/functions_page/Spinner.dart';



/*
  Esta pagina eh onde o usuario ira visualizar todas as movimentacoes.
  Se a flag for true sera as receitas, caso contrario sera as despesas 
 */

class ListMovementsWidget extends StatefulWidget{
  
  const ListMovementsWidget(this.list, this.categories, this.flag);
  final List list, categories;
  final bool flag; 
  _ListMovementsWidgetState createState() => _ListMovementsWidgetState();
}

class _ListMovementsWidgetState extends State<ListMovementsWidget>{
  String movement;

  @override
  void initState(){
    super.initState();
    movement = (widget.flag)? "Receita" : "Despesa";
  }

  // Esta funcao cria uma lista de cards onde mostrarao todas as movimentacoes do mes
    Widget _buildValues(List listValues) {
      return StreamBuilder(
            stream: Firestore.instance.collection(movement).where('refUser', isEqualTo: usuario.uid).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.data != null){
              return Column( 
          children: <Widget>[ 
              ListView.builder(
                        itemCount: listValues.length,     // Ve o tamanho da lista
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data.documents[index];
                          print(snapshot);
                            return Card(
                              child: FlatButton(
                                child: 
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Column(     
                                            children: <Widget>[ widget.categories[int.parse(listValues[index]['category'])-1]['icon'],], 
                                          ),
                                        ),
                                        
                                        Flexible(

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 5),
                                              ),
                                              Text(listValues[index]['name']),    // Pega o nome da movimentacao
                                              Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 3),
                                              ),
                                              Text(listValues[index]['date'], style: TextStyle(color: Colors.grey),),    // Pega a data da movimentacao
                                              Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 3),
                                              ),
                                              Visibility(
                                                visible: (!listValues[index]['effected']),
                                                
                                                child: Container(
                                                  child: Text('  Não Efetivada  ', style: TextStyle(color: RED, fontSize: 10),),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: RED,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                )
                                              ),
                                              Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 5),
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            children: <Widget>[
                                              Text(CURRENCY + listValues[index]['moneyValue'].toStringAsFixed(2)),      // Pega o valor da movimentacao
                                            ],
                                          ),
                                        )
                                        
                                      ],
                                    ),
                                
                                onPressed: () async {
                                  // Esta variavel local flag eh uma bandeira onde indica se esta movimentacao sera removida ou nao
                                    bool flag = await Navigator.push(context, MaterialPageRoute(builder: (context) => Movement(listValues[index], widget.categories, widget.flag)));
                                    if(flag != null && flag){

                                      setState((){
                                        listValues.removeAt(index);   // Remove o item da lista
                                      
                                      });
                                      Firestore.instance.collection(movement).document(doc.documentID).delete();    // Remove o item no Firestore

                                    }
                                }
                              ),
                              
                            );
                        },
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      )
          ]);
              }else{
                return Spinner();
              }
            },
          
        
      );
    
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: (widget.flag) ? Text('Todas as Receitas') : Text('Todas as Despesas'),
          backgroundColor: (widget.flag) ? GREEN : RED,
      ),

      body: ListView(
         children: <Widget>[
            Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  _buildValues(widget.list)
                ]
              )
            )
         ]
      )
      
      
  );

  

}



