import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foca_app/pages/login/login.dart';
import 'package:flutter/material.dart';
/*
  Pagina que contem algumas funcoes que o financeiro usa
* */

// Funcao que retorna um Map contendo dois valores,
// sendo o primeiro uma lista de receita ou Despesa (determinado pela flag)
// e o outro valor e um ponteiro indicando quantas movimentacoes ainda nao foram efetivadas
 Future<Map> returnMovement(bool flag) async{
      List<Map> list = new List<Map>();
      int index = 0;
      Map data = new Map();
      String movement = 'Receita'; 
      if(!flag) movement = 'Despesa';

      Query colecao = Firestore.instance.collection(movement).where('refUser', isEqualTo: usuario.uid);
      Future<QuerySnapshot> query = colecao.getDocuments();
      await query.then((value){
          for(DocumentSnapshot item in value.documents){
            Map move = new Map();

            item.data.forEach((k, v){
              if (k == "categoria") move['category'] = v;
              if (k == "check") move['effected'] = v;
              if (k == "data") move['date'] = v;
              if (k == "descricao") move['name'] = v;
              if (k == "hora") move['time'] = v;
              if (k == "valor") move['moneyValue'] = v;
              if (k == "refUser") move['refUser'] = v;

            });
            if(move['effected']){
              list.insert(index, move);
            }else{
              list.insert(0,move);
              index += 1;
            }
          }
         
      });
      data['list'] = list;
      data['pointer'] = index;
      return data;
    }

// Funcao que busca as categorias personalizadas de receitas e despesas (determinado pela flag)
    Future<List<Map>> returnCategoriesFromBD(bool flag, List list) async{
      Query colecao = Firestore.instance.collection('CategoriaFinancas').where('refUser', isEqualTo: usuario.uid); 
      Future<QuerySnapshot> query = colecao.getDocuments();
      await query.then((value){
          for(DocumentSnapshot item in value.documents){
            Map cat = new Map();

            item.data.forEach((k, v) { //Converte cada item vindo do BD em um objeto de categoria
              if (k == "cor") cat['icon'] = new Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(int.parse(v)),
                                                    ),
                                                  );
              if (k == "id") cat['id'] = v;
              if (k == "nome") cat['name'] = v;
            });
            list.add(cat);
          }
      });
      return list;
    }


