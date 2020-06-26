import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:foca_app/functions_page/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/grupos/add_grupos.dart';
import 'package:foca_app/pages/grupos/criar_grupos.dart';
import 'package:foca_app/pages/grupos/PaginaGrupo.dart';
import 'package:foca_app/functions_page/spinner.dart';
import 'package:foca_app/pages/login/login.dart';
import 'package:draggable_flutter_list/draggable_flutter_list.dart';

//Esta eh a classe principal dos grupos
//Eh aonde os grupos sao listados

class grupo{
  DocumentSnapshot doc;
  grupo(this.doc);
}

class Groups extends StatefulWidget{
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); //Global key para criacao do alertdialog e snackbar

  DocumentSnapshot document;  //Necessario para o reconhecimento de um grupo especifico pelas funcoes

  Icon _iconDial = Icon(Icons.add);
  Color _backgroundDial = Colors.purple;
  Color _foregroundDial = Colors.white;

  String titulo;
  List<Card> list = new List<Card>();
    final List<Widget> ListaAcoes = [
        //Classes das acoes
        AdicionarGruposWidget(),
        CriarGruposWidget(),
  ];

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerBar(),
      appBar: new AppBar( 
        backgroundColor: Colors.purple,
        title: new Text("Grupos"),
      ),

      floatingActionButton: menuButton(),

      body: StreamBuilder(
        stream: Firestore.instance.collection('Grupos').where('Membros', arrayContains: usuario.uid).snapshots(), //Recupera da colecao GRUPOS os grupos que o usuario esta inserido  
        builder: (context, snapshot){
          if(!snapshot.hasData) return Spinner();  
          if (snapshot.data.documents.length == 0) { //Caso o usuario nao esteja inserido em algum grupo
            return Container(
              constraints: BoxConstraints.expand(height: 200),
              alignment: Alignment.topCenter,
              child: Image.asset('assets/foquinhas/focavetorizadagrupos.png', fit: BoxFit.cover),
            );
          }else {
            return DragAndDropList(
              snapshot.data.documents.length,
              canBeDraggedTo: (one, two) => true,
              dragElevation: 8.0,
              key: new Key("DragAndDropper"),
              itemBuilder: (BuildContext context, index) {
                DocumentSnapshot doc = snapshot.data.documents[index]; //Retorna o contexto de cada documento
                document = doc;
                return Container(
                  color: Colors.white,
                  child: ListTile(
                      leading: Icon(Icons.group),
                      title: Text(doc['nome']), //Exibe o nome do grupo
                      subtitle: Text("Participantes do grupo: " + (doc['participantes'].toString())), //Exibe a quantidade de participantes do grupo
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaGrupo(doc))); //Rota para entrar na pagina do grupo selecionado
                      },
                    trailing: PopupMenuButton( //Opcoes extras dos grupos
                      elevation: 3.2,
                      onSelected: _select,
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Text("Sair do grupo"),
                        ),
                        PopupMenuItem(
                            value: 2,
                            child: Text("Excluir grupo")
                        ),
                        PopupMenuItem(
                          value: 3,
                          child: Text("Código do Grupo"),
                        ),
                      ],
                    ),
                  )
                );
              },
              onDragFinish: (before, after) {
                List<DocumentSnapshot> doc = snapshot.data.documents;
                DocumentSnapshot temp = doc[before];
                doc.removeAt(before);
                doc.insert(after, temp);
                print("Moved item before: $before after: $after ");
              },
            );
          }
        }
      ),
      backgroundColor: Colors.white,
    );
  }


  SpeedDial menuButton(){ //Criacao do menu para adicao ou criacao de grupos

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

      // As Funções onOpen e onClose fazem a animação de cores e ícones do App
      onOpen: (){
        setState(() {
          _backgroundDial = Colors.white;
          _foregroundDial = Colors.purple;
          _iconDial = Icon(Icons.clear);
        });
      },

      onClose: (){
        setState(() {
          _backgroundDial = Colors.purple;
          _foregroundDial = Colors.white;
          _iconDial = Icon(Icons.add);
        });
      },

      // Aqui fica a coleção de opções
      children: [

        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
          label: 'Criar Grupo',

          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => CriarGruposWidget()));
          },
        ),

        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
          label: 'Entrar em Grupo',

          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarGruposWidget()));
          },
        ),
      ],
    );
  }

  void _chamaSnackBar(int op){  //funcao que chama uma snackbar diferentes para cada acao realizada
    switch(op){
      case 1:
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('FOCA no código copiado!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.purple,
            ));
        break;
      case 2:
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('Você parou de FOCAR nesse grupo!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.purple,
            ));
        break;
      case 3:
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('Não dá pra FOCAR nesse grupo mais...'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.purple,
            ));
        break;
      default:
        break;
    }
  }
  void _excluirGrupo() async {  //funcao que exclui o grupo e todas as tarefas a ele atribuidas
    QuerySnapshot tarefasParaDeletar = await Firestore.instance.collection('TarefasGrupo').where('idGrupo', isEqualTo: document.documentID).getDocuments();
    for(int i = 0; i < tarefasParaDeletar.documents.length; i++){
      Firestore.instance.collection('TarefasGrupo').document(tarefasParaDeletar.documents[i].documentID).delete();
    }
    Firestore.instance.collection('Grupos').document(document.documentID).delete();
  }

  void _sairGrupo() async{  //Funcao que remove o usuario atual de um grupo Se o grupo ficar vazio ele eh excluido
    List<String> idUser = [usuario.uid];
    int qtdParticipantes = 0;
    DocumentReference databaseReference = Firestore.instance.collection("Grupos").document(document.documentID);
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("Grupos").document(document.documentID).get();
    print(qtdParticipantes);
    qtdParticipantes = documentSnapshot.data['participantes'];
    print(qtdParticipantes);
    qtdParticipantes -= 1;
    print(qtdParticipantes);
    if(qtdParticipantes != 0){
      await databaseReference.updateData({
        "Membros": FieldValue.arrayRemove(idUser),
        "participantes": qtdParticipantes
      });
    }
    else
      await _excluirGrupo();
  }

  void _sairGrupoOption(){  //AlertDialog para confirmar a saida de um grupo
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deseja mesmo sair do grupo?"),
          content: new Text("Você não terá mais acesso as informações deste grupo."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("SAIR"),
              onPressed: () async{
                await _sairGrupo();
                _chamaSnackBar(2);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _excluirGrupoOption(){ //AlertDialog para confirmar a exclusao de um grupo
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deseja mesmo apagar este grupo?"),
          content: new Text("Esta ação não pode ser desfeita."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("EXCLUIR"),
              onPressed: () async {
                await _excluirGrupo();
                _chamaSnackBar(3);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _exibirCodigo()async{  //AlertDialog que exibe o codigo de um grupo para facil compartilhamento
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("Grupos").document(document.documentID).get();
    String codigo = documentSnapshot.data['idGrupo'];
    showDialog(
        context: _scaffoldKey.currentContext,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text("Código do Grupo"),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.purple,
                    shape: Border.all(width: 0.5, color: Colors.purple),
                    child: Text(codigo),
                    onPressed: (){
                      Clipboard.setData(new ClipboardData(text: codigo));
                      _chamaSnackBar(1);
                      Navigator.pop(context);
                    },
                  ),
                ]
            ),
          );
        }
    );
  }

  void _select(int value){  //Switch para o PopupMenuButton
    switch(value){
      case 1:
        _sairGrupoOption();
        break;
      case 2:
        _excluirGrupoOption();
        break;
      case 3:
        _exibirCodigo();
        break;
      default:
        break;
    }
  }

}