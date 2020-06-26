import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';
import 'package:foca_app/pages/academico/heading.items.events.dart';

import 'add.event.dart';


class PersonalWidget extends StatefulWidget{
  _PersonalWidgetState createState() => _PersonalWidgetState();
}


class _PersonalWidgetState extends State<PersonalWidget> {

  Color THEME = Colors.blue;
  List<Card> list = new List<Card>();

  // Lista de categorias de eventos pessoais
  List _categories = [
    {'id': 'Aniversário', 'icon': Image(image: AssetImage('assets/icons/pessoal/aniversario.png'), width: 40, height: 40,), 'name': 'Aniversário'},
    {'id': 'Compras', 'icon': Image(image: AssetImage('assets/icons/pessoal/compras.png'), width: 40, height: 40,), 'name': 'Compras'},
    {'id': 'Faxina', 'icon': Image(image: AssetImage('assets/icons/pessoal/faxina.png'), width: 40, height: 40,), 'name': 'Faxina'},
  ];

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(//Cria um botão para adicionar um evento
        onPressed: () async {
          awaitValue(context);
        },
        child: Icon(Icons.add),
        backgroundColor: THEME,
      ),
      body: SafeArea(
        child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        HeadingItemsEvents(),
                        _buildEvents(),
                      ],
                    ),
                  ),
                ]),
              ),
            ]
        ),
      ),
    );
  }

  Widget _buildEvents() {
    return StreamBuilder(
      stream: Firestore.instance.collection('LembretePessoal').where('refUser', isEqualTo: usuario.uid).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) { //Builder: O que fazer com os dados
        if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Container(
              constraints: BoxConstraints.expand(height: 200),
              alignment: Alignment.topCenter,
              child: Image.asset('assets/foquinhas/focavetorizadapessoal.png',//Caso não tenha nenhum evento, aparece uma imagem da foca
                  fit: BoxFit.cover)
          );
        }else{
          return Column(
            children: <Widget>[
              ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data.documents[index]; // Retorna a lista de elementos

                  return AnimatedOpacity(
                    opacity: !doc['check'] ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                                value: doc['check'],
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                                onChanged: (
                                    bool e) { //Exclui o evento caso o checkbox esteja checkado
                                  setState(() {
                                    Firestore.instance.collection(
                                        'LembretePessoal').document(
                                        doc.documentID).updateData(
                                        {'check': true});
                                    updateEvent(doc, context);
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(//Mostra uma mensagem ao concluir a exclusão
                                          content: Text(
                                              'FOCA no lembrete concluído!'),
                                          duration: Duration(seconds: 1),
                                          backgroundColor: Colors.blue,
                                        ));
                                  });
                                }),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(doc['titulo'],
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(' ' + doc['hora'],//imprime a hora do evento
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(doc['data'],//imprime a data do evento
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(doc['descricao'],//imprime a descrição do evento
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.clip,
                                  softWrap: true,
                                ),
                                Text(doc['category'],//imprime a categoria do evento
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ],
          );
        }
      },
    );
  }


  //Chama a função de adicionar um evento. Passando a lista de categorias como parâmetros.
  void awaitValue(BuildContext context) async{
    Map result;
    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEventWidget(_categories)));
  }
}

//Realiza a exclusão do evento
void updateEvent(DocumentSnapshot doc, BuildContext context) async {
  Future.delayed(Duration(milliseconds: 950),(){
    Firestore.instance.collection('LembretePessoal').document(doc.documentID).delete();
  });
}