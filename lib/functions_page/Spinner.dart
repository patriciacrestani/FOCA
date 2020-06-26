import 'package:flutter/material.dart';

//Classe responsavel por exibir animacao de carregamento vulgo Spinner

class Spinner extends StatefulWidget {
  @override
  _SpinnerState createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,

              ),
            ],
          )
        ],
      ),

      builder: (BuildContext context, Widget child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * 3.14,
          child: child,
        );
      },
    );
  }
}