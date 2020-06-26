import 'package:flutter/material.dart';
//Classe feita apenas para trocar a cor de fundo
class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}