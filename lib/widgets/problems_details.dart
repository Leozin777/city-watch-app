import 'package:city_watch/models/problems.dart';
import 'package:flutter/material.dart';

class ProblemsDetails extends StatelessWidget {
  Problems problems;

  ProblemsDetails({Key? key, required this.problems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            problems.foto,
            height: 250,
            width: MediaQuery
                .of(context)
                .size
                .width,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16), // Valor ajustado
          Padding(
            padding: EdgeInsets.only(left: 24),
            child: Text(
              problems.nome,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 60, left: 24),
            child: Text(
              problems.endereco,
            ),
          ),
        ],
      ),
    );
  }
}