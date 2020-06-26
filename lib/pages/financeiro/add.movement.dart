import 'package:flutter/material.dart';
import 'package:foca_app/pages/login/login.dart';
import 'estilo/const.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'create.category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
  Esta eh a pagina onde o usuario ira inserir sua nova movimentacao.
  * Se a flag for true, sera uma nova receita. Caso contrario sera uma nova despesa.
  Nele contem um formlario que devera ser preenchido pelo usuario.
  Só ira retornar para a pagina principal apos o formulario ser
  peeenchido corretamemte.
 */

class AddMovementWidget extends StatefulWidget{
    AddMovementWidget (this.categories, this.flag);
    List categories;
    bool flag;
    _AddMovementWidgetState createState() => _AddMovementWidgetState();
}
List<Map> CategoriesFromBD = new List();

class _AddMovementWidgetState extends State<AddMovementWidget>{
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    bool _autovalidate = false;

    // Lista de Categorias
    List<DropdownMenuItem<String>> _categories; 

    Map _data =  new Map();
    String _categorySelected = '1';
    bool effected = true;
    DateTime _date  = new DateTime.now();
    DateTime _dateEffected  = new DateTime.now().add(new Duration(days: 1));


// Funcao que seleciona a data de efetivacao, ela somente fica visivel se
// o valor da variavel effected for false.
  Future<Null> selectDate(BuildContext contex) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dateEffected,
      firstDate: _date,
      lastDate: DateTime(3000),
      builder: (BuildContext context, Widget child) {
        return SingleChildScrollView(
          child: child,
        );
      },
    );
    
      if(picked != null){
        setState((){
          _dateEffected = picked;
          _data['date'] = DateFormat('dd/MM/yyyy').format(picked).toString();;
        });
      }
    
  }

  void setEffected(bool value){
    setState((){
      effected = value;
    });
  }

    // Funcao que cria itens de categorias para o usuario poder selecionar
    List<DropdownMenuItem<String>> _buildCategories() {
      List<DropdownMenuItem<String>> list = new List<DropdownMenuItem<String>>();
      for(int i = 0; i < widget.categories.length; i++){
        list.add(
          DropdownMenuItem(
              value: widget.categories[i]['id'],
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                      Container(
                        width: 24,
                        height: 24,
                        child: widget.categories[i]['icon'],
                      ),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                      ),
                      Text(widget.categories[i]['name']),
                  ],
                )                 
            ),
        );
      }
      return list;
  }

// Funcao inicial do flutter
  void initState(){
    super.initState();
    this._categories = this._buildCategories();

  }
    
    Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: (widget.flag) ? Text(NEW + EARN) : Text(NEW + EXPANSE),
            backgroundColor: (widget.flag) ? GREEN : RED,
        ),

        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: formUI(), 
            ),
        )
        
    );

// Funcao do formulario
    Widget formUI() => ListView(
                    children: <Widget>[
                        TextFormField(
                            maxLength: 30,
                            decoration: InputDecoration(
                                labelText: 'Descrição'
                            ),

                            /* Eh aqui onde ocorrera a validação do valor inserido pelo usuario.
                               Esta validacao ocorre da seguinte forma:
                               1 - Verifica-se se o campo esta vazio. Se ocorrer tudo corretamente 
                               segue para salvar o dado.
                            */
                            validator: (String value){
                                if(value.length == 0){
                                    return 'Este campo não pode ficar vazio';
                                }
                                return null;
                            },

                            onSaved: (String value){
                                _data['name'] = value;
                            },
                        ),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixText: CURRENCY,
                                labelText: 'Valor',
                                hintText: '0.00',
                            ),
                            
                            /* Eh aqui onde ocorrera a validacao do valor inserido pelo usuario.
                               Esta validacao ocorre da seguinte maneira: 
                               1 - Verifico se ha apenas 2 casas decimais apos o ponto
                               2 - Tento converter o valor em um valor de ponto flutuante;
                               3 - Se ocorrer tudo certo, faça o teste de valor negativo ou zero;
                               4 - Se nao passar no teste segue para salvar o valor informado.
                            */
                            validator: (String value){
                              try{
                               
                                if(value[value.length - 3] == '.'){
                                
                                  try{
                                      double v = double.parse(value);
                                      if (v <= 0){
                                          return V_INVALID;
                                      }
                                  }catch (e){
                                      return V_INVALID;
                                  }

                                  return null;
                                } else {
                                  return V_INVALID;
                                }
                              }catch (e){
                                return V_INVALID;
                              }
                            },
                            
                            // Aqui e onde o valor inserido no formulario sera salvo. 
                            onSaved: (String value){
                                _data['moneyValue'] = double.parse(value);
                            },
                        ),

                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                        ),


                        Text(
                          'Categoria', 
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey
                          ),
                        ),

                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 4,
                              child: selectCategory(),
                            ),

                            Flexible(
                              flex: 1,
                              child: FlatButton(
                                  child: Icon(Icons.add, color: BLUE),
                                  onPressed: () async {
                                    var v = await createCategory(context);
                                    print(v);
                                    if(v != null){
                                      // chamo a funcao onde adiciono uma categoria personalizada
                                      updateCategories(_categories, v[0], v[1]);
                                    }
                                  }
                              ),
                            )
                          ]
                        ),

                        // Botao de efetivacao. Se estiver marcado, o valor do effected sera true e consequentemente sera calculado,
                        //caso falso ele nao sera calculado ate que a data de hoje seja igual a da effetivada 
                        CheckboxListTile(
                          value: effected,
                          onChanged: setEffected,
                          title: Text('Efetivada'),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
      
                        // Botao Para Escolher a Data de efetivação caso a variavel effected contenha o valor falso.
                        Visibility(
                          visible: (!effected),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Data de Efetivação',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                              Row(
                                
                                children: <Widget>[

                                  Expanded(
                                    child:  FlatButton(
                                      shape: Border.all(width: 0.5, color: Colors.black),
                                      child: Text(DateFormat('dd/MM/yyyy').format(_dateEffected)),
                                      onPressed: (){
                                        selectDate(context);
                                      },
                                    )
                                  ),
                                 
                                ],
                              )
                              

                            ],
                          ),
                        ),
                        
                        RaisedButton(
                            child: Text(SAVE),
                            onPressed: () { 
                                _validateInputs();
                                if(!_autovalidate){
                                    // Retorna para a pagina principal com o valor obtido
                                    _data['category'] = _categorySelected;
                                    if(_data['date'] == null && effected){
                                       _data['date'] = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
                                    }else if(_data['date'] == null && !effected){
                                       _data['date'] = DateFormat('dd/MM/yyyy').format(DateTime.now().add(new Duration(days: 1))).toString();
                                    }
                                  
                                    _data['time'] = DateFormat('hh:mm').format(DateTime.now()).toString();
                                    _data['effected'] = effected;

                                    Map dataFinished = {
                                      'data': _data,
                                      'categories': widget.categories
                                    };

                                    AddMovementBD(_data);     // Insiro no Firebase                       
                                    Navigator.pop(context, dataFinished);
                                }
                                
                              },
                        )
                    ],
                );


// Funcao que insere a movimentacao no Firebase
  AddMovementBD(Map _data){
    String move = 'Receita';
    if(!widget.flag)
        move = 'Despesa';  
    
    Firestore.instance.collection(move).add({
      'categoria' : _data['category'],
      'check' :_data['effected'],
      'data' : _data['date'],
      'refUser': usuario.uid,
      'descricao': _data['name'],
      'valor': _data['moneyValue'],
      'hora': _data['time'],
    });
  }
    /*
      É a função responsavel por trazer os dados da nova categoria
     */
    Future<List> createCategory(BuildContext context) async{
      return showDialog(
          context: context,
          builder: (BuildContext context) => CreateCategory()
      );


    }

// Função que cria uma seleção de uma categoria em forma de dropdown
 DropdownButton selectCategory() => DropdownButton<String>(
        items: _categories,

        onChanged: (value) {
          setState(() {
            _categorySelected = value;
          });
        },
        value: _categorySelected,
        isExpanded: true,
        elevation: 2,

    );

/*
  Funcao onde verifica se todos os valores foram inseridos
  de forma correta pelo usuario.
*/
    void _validateInputs(){
          if(_formKey.currentState.validate()){
                _formKey.currentState.save();
                _autovalidate = false;
                
          }else{
                setState(() {
                    _autovalidate = true; 
                });
          }
    }

  /*
    Esta funcao cria o item a ser adicionado na lista de categorias e na lista de categorias no firebase
  */
  void updateCategories(List list, String name, var color){
    setState(() {
      print((_categories.length+1).toString());
      //Cria e adiciona o item
      _categories.add( new DropdownMenuItem(
          value: (_categories.length+1).toString(),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
              ),
              Text(name)
            ],
          )
      ));

      // insiro na lista de categorias
      widget.categories.add({
        'id': (_categories.length).toString(),
        'icon': Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ), 
        'name': name,
        });

        // Insiro a categoria no firebase
        Firestore.instance.collection('CategoriaFinancas').add({
          'refUser': usuario.uid,
          'id': (_categories.length).toString(),
          'nome': name,
          'movimentacao': widget.flag,
          'cor': color.value.toString(),
        });
       // Atualiza a lista
      _categories = List.from(list);
      widget.categories = List.from(widget.categories);

    });
  }
}



