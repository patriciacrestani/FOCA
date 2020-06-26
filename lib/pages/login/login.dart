import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foca_app/functions_page/navigation_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:foca_app/notification/firebase_notification_handler.dart';

class Login extends StatefulWidget{
  LoginState createState() => LoginState();

}
FirebaseUser usuario;
class LoginState extends State<Login>{
  // Variáveis para fazer a autennticação
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image(image: AssetImage('assets/icons/logo.png'), width: 200, height: 200,),

            Text('Bem-vinde!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),

            Text('Seu novo jeito de FOCAR no que importa!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: <Widget>[
                RaisedButton(
                  child: ListTile(
                    leading: Image(image: AssetImage('assets/icons/google.png'),
                      width: 25,
                      height: 25,
                      color: Colors.indigoAccent,
                    ),
                    title: Text('Login pelo Google',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.indigoAccent),
                    ),
                  ),
                  onPressed: () async {
                    FirebaseUser user;
                    try{
                      user = await _handleSignIn();
                      FirebaseUser currentUser = await _auth.currentUser();
                      assert(user.uid == currentUser.uid);
                      setState(() {
                        if (user != null) {
                          usuario = user;
                          // Checa se o usuario ja tem uma conta
                         // if(Firestore.instance.collection('usuarios').where('id', isEqualTo: user.uid).getDocuments() == null){
                            //Caso não tenha, adiciona no BD
                              Firestore.instance.collection('usuarios').document(user.uid).setData({'nome': user.displayName, 'id': user.uid, 'email': user.email});
                       //   }
                          print(user);
                          _googleSignIn.signOut();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigationBar()));
                          print(true);
                        } else {
                          print(false);
                        }
                      });
                    }catch(e){
                      print(e);
                    }
                  },
                ),
                Text('Ao fazer login você estará aceitando nosssos Termos e Condições de Uso.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ]
            )
          ],
        ),
      )
    );
  }

  /* Função responsável pela autenticação, código
  * vindo do exemplo do uso do firebase_auth.
  * */
  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return user;
  }

  @override
  void initState() {
    super.initState();
    new FirebaseNotifications().setUpFirebase();
  }
}
