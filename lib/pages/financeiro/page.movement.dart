import 'package:flutter/material.dart';
import 'estilo/const.dart';

/*
  Pagina onde mostra com mais detalhes a movimentacao desejada, podendo
  ser receita (se a flag for true) ou despesa (se a flag for false).
*/


class Movement extends StatefulWidget{
  Map movement;
  List category;
  bool flag;
  Movement(this.movement, this.category, this.flag);
  

  _MovementState createState() => _MovementState();  
}

class _MovementState extends State<Movement>{

  void initState(){
    super.initState();
  }

  Widget build(BuildContext context) => Scaffold(
    
    body: Stack(
      children: <Widget>[
        NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
            SliverAppBar(
              backgroundColor: (widget.flag) ? GREEN : RED,
              expandedHeight: 120,
              floating: true,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(CURRENCY + widget.movement['moneyValue'].toStringAsFixed(2), 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: WHITE,
                  fontSize: 20,
                  ),
                ),
              ),

              
            ),
          ],
        
          body: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(widget.movement['name'],
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),

                Text('Data e Hora: '+ widget.movement['date'] + ' às ' + widget.movement['time'],
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                Text('Categoria:'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      child: widget.category[int.parse(widget.movement['category'])-1]['icon']
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                    ),
                    Text(widget.category[int.parse(widget.movement['category'])-1]['name'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ]
                ),
                CheckboxListTile(
                  value: widget.movement['effected'],
                  onChanged: (bool value){},
                  title: Text('Efetivada', style: TextStyle(color: Colors.black)),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
      
              ],
            ),
          )
        ),
        // Botao onde o usuario pode deletar a movimentacao
        Positioned(
            bottom: 10,
            right: 10,
            child: new FloatingActionButton(
              onPressed: () async {
                    bool flag = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => DeleteMovement()
                    );
                    
                    if(flag){
                      Navigator.pop(context, flag);
                    }
              },
              child: new Icon(Icons.delete),
              backgroundColor: (widget.flag) ? GREEN : RED,
            ),
          ),
      ],
    )
  );
}

// Classe auxiliar onde possui um AlertDialog que pede a confimacao do usuario
// se deseja remover esta movimentacao, se sim retorna true, se falso retorna false
class DeleteMovement extends StatefulWidget{

  @override
  _DeleteMovementState createState() => _DeleteMovementState();
    
}

class _DeleteMovementState extends State<DeleteMovement>{

  @override
  Widget build(BuildContext context) => AlertDialog(
      title: Text('Tem certeza que deseja deletar esta movimentação?'),
      content: Text('Esta ação não pode ser desfeita.', style: TextStyle(color: RED),),

      actions: <Widget>[
        FlatButton(
          child: Text('CANCELAR'),
          onPressed: (){
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: Text('OK', style: TextStyle(color: WHITE),),
          color: RED,
          onPressed: (){
            Navigator.pop(context,true);
          },
        )
      ],
    );
}