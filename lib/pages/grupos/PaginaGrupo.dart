import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foca_app/functions_page/Spinner.dart';
import 'package:foca_app/pages/grupos/criar_tarefa_grupo.dart';

class PaginaGrupo extends StatefulWidget{
  DocumentSnapshot doc; //Aqui eh armazenado o documento do grupo que estamos visualizando
  PaginaGrupo(this.doc);
	PaginaGrupoState createState() => PaginaGrupoState();
}

//Pagina para visualizacao das tarefas de um grupo especifico

class PaginaGrupoState extends State<PaginaGrupo> {

	Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
			appBar: AppBar(
				title: Text(widget.doc['nome']), //Exibe nome do grupo no topo da pagina
        backgroundColor: Colors.purple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{ //Navega para a pagina que cria novas tarefas
          await Navigator.push(context, MaterialPageRoute(builder: (context) => CriarTarefaWidget(widget.doc.documentID, widget.doc)));}, 
        child: Icon(Icons.add,),
        backgroundColor: Colors.purple,
       ),
      body:
        StreamBuilder (
          stream:  Firestore.instance.collection('TarefasGrupo').where('idGrupo',isEqualTo: widget.doc.documentID).snapshots(), //Recupera do BD todas as tarefas daquele grupo
          builder: (context, snapshot) {                                //Builder: O que fazer com os dados
            print(snapshot);
            if(!snapshot.hasData) return Spinner(); //Enquanto os dados ainda nao foram recebidos
            if (snapshot.data.documents.length == 0){ //Caso nao haja tarefas
              return Container (
                constraints: BoxConstraints.expand(height: 200),
                alignment: Alignment.topCenter,
                child: Image.asset('assets/foquinhas/focavetorizadagrupos.png', fit: BoxFit.cover),
              );
            }else{
              return Column(
                children: <Widget>[
                  ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data.documents[index]; // Retorna a lista de elementos
                      return AnimatedOpacity( //Funcao que realiza a animacao de Fade out
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
                                    activeColor: Colors.purple,
                                    checkColor: Colors.white,
                                    onChanged: (bool e) { //Verifica se está checado ou não
                                      setState(() {
                                        Firestore.instance.collection('TarefasGrupo').document(doc.documentID).updateData({'check': true}); //Atualiza a tarefa como finalizada
                                     });
                                      if (e) {
                                        updateEvent(doc, context);
                                        Scaffold.of(context).showSnackBar( //Exibe mensagem de sucesso para a conclusao da tarefa
                                          SnackBar(
                                            content: Text('FOCA no lembrete concluído!'),
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Colors.purple,
                                          ));
                                      }
                                    }),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            textBaseline: TextBaseline.alphabetic,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text(doc['tarefa'], 
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
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
        )
  );

  void updateEvent(DocumentSnapshot doc, BuildContext context) async {
    Future.delayed(Duration(milliseconds: 950),(){
      Firestore.instance.collection('TarefasGrupo').document(doc.documentID).delete(); //A tarefa eh excluida quando concluida
    });
  }

}
